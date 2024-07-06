from django.urls import path
from . import views,model_view,populatedatabse,garden_views


urlpatterns = [
    path('recommend_plants/', views.plant_recommendation_view, name='recommend_plants'),
    path('list/', views.HerbListView.as_view(), name='herb-list'),
    path('detail/', views.HerbDetailView.as_view(), name='herb-list'),
    path('locations/create/', views.LocationCreateViewSet.as_view(), name='location-create'),
    path('suggest_plants/', model_view.PlantSuggestionAPIView.as_view(), name='suggest_plants'),
    path('create/garden/',garden_views.GardenCreateViewSet.as_view(), name='create_garden'),
    path('delete/garden/<int:pk>/',garden_views.GardenDeleteViewSet.as_view(), name='garden-delete'),
    path('list/garden/',garden_views.GardenListView.as_view(), name='garden-list'),
    path('update/garden/<int:pk>/',garden_views.UpdateGardenNameViewSet.as_view(), name='update-garden-name'),
    path('add/',garden_views.CreateGardenDetailViewSet.as_view(), name='update-garden'),
    path('gardens/<int:garden_id>/details/', garden_views.GardenDetailView.as_view(), name='garden-detail-list'),
    path('gardens/plant/<int:pk>/delete/', garden_views.GardenPlantDeleteViewSet.as_view(), name='garden-detail-delete'),
    path('notifications/create/', garden_views.NotificationCreateAPIView.as_view(), name='notification-create'),
    path('send_notifications/', garden_views.trigger_send_notification, name='send_notifications'),
]
