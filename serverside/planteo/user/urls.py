from django.urls import path,include
from user import user_views,feedback_views

urlpatterns=[
    path('create/',user_views.UserCreateViewSet.as_view(),name='user-creation'),
    path('login/',user_views.login_view,name='login'),
    path('cpassword/',user_views.ChangePasswordViewSet.as_view(),name='change_password'),
    path('send-otp/', user_views.SendOtpToUser.as_view(), name='send_otp'),
    path('forget-password/', user_views.ForgetPassword.as_view(), name='forget-password'),
    path('verify-otp/', user_views.VerifyOTP.as_view(), name='verify-otp'),
    path('update/', user_views.update_user, name='update_user'),

    path('createquery/',feedback_views.UserQueryCreateViewSet.as_view(),name='user_query'),
    path('deletequery/<int:pk>/', feedback_views.UserQueryDeleteViewSet.as_view(), name='delete_query'),
    path('listofequery/', feedback_views.ListOfUserQueryViewSet.as_view(), name='query_list'),
    path('createfeedback/',feedback_views.CreateFeedbackViewSet.as_view(),name='create_query_feedback'),
    path('feedback/like/',feedback_views.CreateLikeViewSet.as_view(),name='like_query_feedback')
]
