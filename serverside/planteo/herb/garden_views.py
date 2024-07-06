from django.http import JsonResponse
from .models import GardenDetail,Garden,Herb,Notification
from .serializers import GardenDetail,GardenDetailSerializer,UpdateGardenSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound
from rest_framework import generics,status
from .serializers import GardenSerializer,GardenDetailSerializer,NotificationSerializer,GetGardenDetailSerializer
from rest_framework import serializers
from rest_framework.permissions import IsAuthenticated
from rest_framework.status import HTTP_404_NOT_FOUND
from rest_framework.exceptions import ValidationError
from rest_framework.decorators import api_view
from .cron import send_notification
from django.utils import timezone
from datetime import timedelta

class GardenCreateViewSet(generics.CreateAPIView):
    queryset = Garden.objects.all()
    serializer_class = GardenSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        garden = serializer.save(user=self.request.user)
        current_date = timezone.now().date()
        notification_date = current_date + timedelta(days=3)
        notification_time = timezone.datetime.strptime('11:00:00', '%H:%M:%S').time()
        Notification.objects.create(
            user=self.request.user,
            date=notification_date,
            time=notification_time,
            garden_name=garden.name
        )
    def post(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            return Response({'status': 'Garden created successfully and notification logged'}, status=status.HTTP_201_CREATED)
        except serializers.ValidationError as e:
            return Response({'error': 'Invalid request data', 'details': e.detail}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error': 'Internal Server Error', 'details': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



class GardenDeleteViewSet(generics.DestroyAPIView):  
    queryset = Garden.objects.all()  
    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance.user != request.user:
            return Response({'error': 'You do not have permission to delete this garden'}, status=status.HTTP_403_FORBIDDEN)
        self.perform_destroy(instance)
        return Response({'status': 'Garden deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
    
class GardenListView(generics.ListAPIView):
    serializer_class = GardenSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return Garden.objects.filter(user=user)

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            if not queryset:
                return Response({'error': 'No gardens found'}, status=HTTP_404_NOT_FOUND)
            serializer = self.get_serializer(queryset, many=True)
            return Response(serializer.data)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class UpdateGardenNameViewSet(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request, pk):
        try:
            garden = Garden.objects.get(pk=pk, user=request.user)
        except Garden.DoesNotExist:
            return Response({'error': 'Garden not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = UpdateGardenSerializer(garden, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class CreateGardenDetailViewSet(generics.CreateAPIView):
    queryset = GardenDetail.objects.all()
    serializer_class = GardenDetailSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def post(self, request, *args, **kwargs):
        try:
            plant_id = request.data.get('herb')
            print(plant_id)
            herb = Herb.objects.get(pk=plant_id)
            print(herb.icons)
            mutable_data = request.data.copy()
            mutable_data['plant_name'] = herb.common_name
            mutable_data['icons'] = herb.icons 
            print(f"Icons path: {mutable_data['icons']}")
            serializer = self.get_serializer(data=mutable_data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            return Response({'status': 'Plant added successfully'}, status=status.HTTP_201_CREATED)
        except Herb.DoesNotExist:
            return Response({'error': 'Herb with the provided ID does not exist'}, status=status.HTTP_400_BAD_REQUEST)
        except ValidationError as e:
            return Response({'error': 'Invalid request data', 'details': e.detail}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class GardenDetailView(generics.ListAPIView):
    serializer_class = GetGardenDetailSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        garden_id = self.kwargs.get('garden_id')
        user = self.request.user
        try:
            garden = Garden.objects.get(id=garden_id, user=user)
            return GardenDetail.objects.filter(garden=garden)
        except Garden.DoesNotExist:
            raise NotFound('Garden not found for the current user')

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            serializer = self.get_serializer(queryset, many=True)
            return Response(serializer.data)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class GardenPlantDeleteViewSet(generics.DestroyAPIView):
    queryset = GardenDetail.objects.all()
    serializer_class = GardenDetailSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        # garden_id = self.kwargs.get('garden_id')
        user = self.request.user
        pk = self.kwargs.get('pk')
        print(pk)
        try:
            return GardenDetail.objects.get(pk=pk)
        except Garden.DoesNotExist:
            raise NotFound('Garden not found for the current user')
        except GardenDetail.DoesNotExist:
            raise NotFound('GardenDetail not found')

    def delete(self, request, *args, **kwargs):
        try:
            instance = self.get_object()
            self.perform_destroy(instance)
            return Response({'status': 'Plant deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

class NotificationCreateAPIView(generics.CreateAPIView):
    serializer_class = NotificationSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user, is_active=True)

    def post(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except serializers.ValidationError as e:
            return Response({'error': 'Invalid input', 'details': e.detail}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error': 'Failed to create notification', 'details': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
@api_view(['GET'])
def trigger_send_notification(request):
    try:
        send_notification()
        return Response({'message': 'Notifications sent successfully.'}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)