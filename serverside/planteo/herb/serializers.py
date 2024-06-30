from rest_framework import serializers
from .models import Herb,Location

class HerbListSerializer(serializers.ModelSerializer):
    class Meta:
        model=Herb
        fields=['id','common_name','description','image']

class HerbDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model=Herb
        fields=['id','common_name','description','scientific_name','optimal_soil_ph_range','soil_type_preferences','light_requirements','water_requirements',
                'nutrient_requirements','temperature_range','humidity_tolerance','planting_depth_and_spacing' ,'image']

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model=Location
        fields=['latitude','longitude','soil_ph','phosphorus','potassium','nitrogen']