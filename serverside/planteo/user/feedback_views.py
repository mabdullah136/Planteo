from .models import User,Feedback,UserSubmittedImage,Votes
from rest_framework import generics,status
from .serializers import CreateUserQuerySerializer,CreateQuesyFeedbackSerializer,UserQuerySerializer,FeedbackTextSerializer,VotesSerializer
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

class CreateVoteViewSet(generics.CreateAPIView):
    queryset = Votes.objects.all()
    serializer_class = VotesSerializer

    def create(self, request, *args, **kwargs):
        feedback_info_id = request.data.get('feedback_info')
        user = request.user

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
            return Response({'message': 'Vote status toggled successfully'}, status=status.HTTP_200_OK)
        except Votes.DoesNotExist:
            serializer = self.get_serializer(data=request.data)
            if serializer.is_valid():
                vote = serializer.save(user=user, likes=True)
                vote.feedback_info.total_votes += 1
                vote.feedback_info.save()
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)




