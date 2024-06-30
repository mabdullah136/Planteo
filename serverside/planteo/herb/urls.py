# herb/urls.py

from django.urls import path
from . import views,model_view,populatedatabse


urlpatterns = [
    # path('save-herbs/', populatedatabse.save_herbs_from_file, name='save_herbs'),
    # path('save-location/', views.generate_location_dataset, name='save_herbs'),
    path('recommend_plants/', views.plant_recommendation_view, name='recommend_plants'),
    path('list/', views.HerbListView.as_view(), name='herb-list'),
    path('detail/', views.HerbDetailView.as_view(), name='herb-list'),
    path('locations/create/', views.LocationCreateViewSet.as_view(), name='location-create'),
    path('suggest_plants/', model_view.PlantSuggestionAPIView.as_view(), name='suggest_plants'),
]
