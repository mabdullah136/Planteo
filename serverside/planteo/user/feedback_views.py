from .models import User,Feedback,UserSubmittedImage,Like
from rest_framework import generics,status
from .serializers import CreateUserQuerySerializer,CreateQuesyFeedbackSerializer,UserQuerySerializer,FeedbackTextSerializer,FeedbackLikeSerializer
from .permissions import IsOwnerOrAdmin,IsOwnerOrAdmin
from rest_framework.response import Response
from .permissions import IsQueryOwner

class UserQueryCreateViewSet(generics.CreateAPIView):
    queryset = UserSubmittedImage.objects.all()
    serializer_class = CreateUserQuerySerializer
    def post(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response({'status': 'User query created successfully'}, status=status.HTTP_201_CREATED, headers=headers)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class UserQueryDeleteViewSet(generics.DestroyAPIView):
    queryset = UserSubmittedImage.objects.all()
    serializer_class = UserQuerySerializer
    permission_classes = [IsQueryOwner]

    def delete(self, request, *args, **kwargs):
            try:
                query_id = self.kwargs['pk']
                instance = self.get_object()
                self.perform_destroy(instance)
                return Response({'status': f'User query with ID {query_id} deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
            except Exception as e:
                return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
class ListOfUserQueryViewSet(generics.ListAPIView):
    serializer_class = UserQuerySerializer
    permission_classes = [IsQueryOwner]

    def get_queryset(self):
        search = self.request.GET.get('search')
        if search:
            queryset = UserSubmittedImage.objects.filter(user_id=search)
        else:
            queryset = UserSubmittedImage.objects.all()
        return queryset

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({'message': 'No queries found.'}, status=status.HTTP_204_NO_CONTENT)
        return super().list(request, *args, **kwargs)

class CreateFeedbackViewSet(generics.ListCreateAPIView):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackTextSerializer

    def create(self, request, *args, **kwargs):
        mutable_request_data = request.data.copy() 
        mutable_request_data['user'] = request.user.pk 
        serializer = self.get_serializer(data=mutable_request_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
     
class CreateFeedbackViewSet(generics.ListCreateAPIView):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackTextSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CreateLikeViewSet(generics.CreateAPIView):
    queryset = Like.objects.all()
    serializer_class = FeedbackLikeSerializer

    def create(self, request, *args, **kwargs):
        feedback_info_id = request.data.get('feedback_info_id')  # Use the correct field name
        user = request.user

        try:
            like = Like.objects.get(feedback_info_id=feedback_info_id, user=user)
            like.likes = not like.likes  # Toggle the likes field
            like.save()
            return Response({'message': 'Like status toggled successfully'}, status=status.HTTP_200_OK)
        except Like.DoesNotExist:
            serializer = self.get_serializer(data=request.data)
            if serializer.is_valid():
                serializer.save(user=user, likes=True)  # Set likes to True for new like
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)





