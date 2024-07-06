from .models import User,Feedback,UserSubmittedImage,Votes
from rest_framework import generics,status
from .serializers import CreateUserQuerySerializer,CreateQuesyFeedbackSerializer,UserQuerySerializer,FeedbackTextSerializer,VotesSerializer,QueryDetailSerializer,UserShortDetailSerializer
from .permissions import IsOwnerOrAdmin,IsOwnerOrAdmin
from rest_framework.response import Response
from .permissions import IsQueryOwner
from django.shortcuts import get_object_or_404
import firebase_admin
from firebase_admin import messaging, credentials
from django.conf import settings
from django.views.decorators.csrf import csrf_exempt

cred = credentials.Certificate('user/planteo-62da6-firebase-adminsdk-srgbd-4ae3614662.json')
firebase_admin.initialize_app(cred)

def send_notification(user_id, title, body):
    try:
        user = User.objects.get(pk=user_id)
        fcm_token = user.fcm_token
        if not fcm_token:
            raise ValueError("No FCM token for the user")
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body
            ),
            token=fcm_token
        )
        response = messaging.send(message)
        print(f'Successfully sent message: {response}')
        return response

    except User.DoesNotExist:
        print("User does not exist")
        return None
    except ValueError as e:
        print(f'ValueError: {e}')
        return None
    except Exception as e:
        print(f'Error sending message: {e}')
        return None

class UserQueryCreateViewSet(generics.CreateAPIView):
    queryset = UserSubmittedImage.objects.all()
    serializer_class = CreateUserQuerySerializer

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    def post(self, request, *args, **kwargs):
        try:
            user = self.request.user
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            response_data = serializer.data
            response_data['user_id'] = user.id
            print(response_data)
            for key, value in response_data.items():
                if value is None:
                    response_data[key] = ''

            return Response(response_data, status=status.HTTP_201_CREATED, headers=headers)
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


from datetime import datetime
from django.utils import timezone
import pytz

def get_time_diff(upload_date):
    current_date = datetime.now(pytz.utc)
    time_diff = current_date - upload_date

    if time_diff.days == 0:
        hours_diff = time_diff.seconds // 3600
        if hours_diff == 0:
            minutes_diff = time_diff.seconds // 60
            return f"{minutes_diff} minutes ago"
        else:
            return f"{hours_diff} hours ago"
    else:
        return f"{time_diff.days} days ago"


class QueryViewSet(generics.RetrieveAPIView):
    queryset = UserSubmittedImage.objects.all()
    serializer_class = QueryDetailSerializer
    lookup_field = 'query_id'  

    def retrieve(self, request, *args, **kwargs):
        query_id = kwargs.get('query_id')  
        if query_id:
            try:
                query = get_object_or_404(UserSubmittedImage, pk=query_id)
                user = get_object_or_404(User, pk=query.user.id)
                user_serializer = UserShortDetailSerializer(user)
                query_serializer = self.get_serializer(query)
                upload_date_diff = get_time_diff(query.upload_date)
                feedback = Feedback.objects.filter(info_id=query_id).order_by('-total_votes')
                feedback_serializer = FeedbackTextSerializer(feedback, many=True)
                response_data = user_serializer.data
                query_data = query_serializer.data
                query_data['upload_date'] = upload_date_diff
                response_data['query_detail'] = query_data
                response_data['feedback'] = feedback_serializer.data

                return Response(response_data, status=status.HTTP_200_OK)
            except UserSubmittedImage.DoesNotExist:
                return Response({'error': 'Query not found'}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({'error': 'Query ID is required'}, status=status.HTTP_400_BAD_REQUEST)
    


     
class CreateFeedbackViewSet(generics.ListCreateAPIView):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackTextSerializer

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
        feedback_instance = serializer.instance  
        info_id = feedback_instance.info_id  
        user_id=UserSubmittedImage.objects.get(pk=info_id)
        # if(user_id.user.id != )
        send_notification(user_id.user.id, "New Feedback on Your Query", feedback_instance.feedback_text)
        # if feedback_instance.user != user_id:
        #     send_notification(user_id.id, "New Feedback on Your Query", feedback_instance.feedback_text)
        

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            self.perform_create(serializer)
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class CreateVoteViewSet(generics.CreateAPIView):
    queryset = Votes.objects.all()
    serializer_class = VotesSerializer

    def create(self, request, *args, **kwargs):
        feedback_info_id = request.data.get('feedback_info')
        user = request.user
        print(user)
        if not feedback_info_id:
            return Response({'error': 'feedback_info_id is required'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            vote = Votes.objects.get(feedback_info_id=feedback_info_id, user=user)
            if vote.likes:
                vote.likes = False
                vote.feedback_info.total_votes -= 1
            else:
                vote.likes = True
                vote.feedback_info.total_votes += 1
            vote.save()
            vote.feedback_info.save()
            total_votes = vote.feedback_info.total_votes
            return Response({'message': 'Vote status toggled successfully', 'total_votes': total_votes}, status=status.HTTP_200_OK)
        except Votes.DoesNotExist:
            serializer = self.get_serializer(data=request.data)
            if serializer.is_valid():
                vote = serializer.save(user=user, likes=True)
                vote.feedback_info.total_votes += 1
                vote.feedback_info.save()
                total_votes = vote.feedback_info.total_votes
                return Response({'message': 'Vote status toggled successfully', 'total_votes': total_votes}, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

from django.db.models import QuerySet
from rest_framework.status import HTTP_404_NOT_FOUND


class ListOfUserQueryViewSet(generics.ListAPIView):
    serializer_class = UserQuerySerializer
    permission_classes = [IsQueryOwner]

    def get_queryset(self) -> QuerySet:
        search_query: str = self.request.GET.get('search')
        if search_query:
            queryset = UserSubmittedImage.objects.filter(subject__icontains=search_query)
        else:
            queryset = UserSubmittedImage.objects.all()
        return queryset

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({'error': 'No queries found'}, status=HTTP_404_NOT_FOUND)
        return super().list(request, *args, **kwargs)