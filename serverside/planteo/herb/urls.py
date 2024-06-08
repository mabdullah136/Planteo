# herb/urls.py

from django.urls import path
from . import views

urlpatterns = [
    # path('save-herbs/', views.update_herb_descriptions, name='save_herbs'),
    # path('save-location/', views.generate_location_dataset, name='save_herbs'),
    path('recommend_plants/', views.plant_recommendation_view, name='recommend_plants'),
    path('list/', views.HerbListView.as_view(), name='herb-list'),
]
