from rest_framework import serializers
from .models import Herb,Location,Garden,GardenDetail,Notification

class HerbListSerializer(serializers.ModelSerializer):
    class Meta:
        model=Herb
        fields=['id','common_name','description','image','icons']


class GardenSerializer(serializers.ModelSerializer):
    class Meta:
        model=Garden
        fields=['id','name','length','width']

class UpdateGardenSerializer(serializers.ModelSerializer):
    class Meta:
        model=Garden
        fields=['name']


class GardenDetailSerializer(serializers.ModelSerializer):
    # icons = serializers.SerializerMethodField()
    class Meta:
        model=GardenDetail
        fields=['id','row_no','column_no','plant_name','icons','garden','herb']

    # def get_icons(self, obj):
    #     if obj.icons:
    #         return obj.icons.url  
    #     return None 

class GetGardenDetailSerializer(serializers.ModelSerializer):
    icons = serializers.SerializerMethodField()
    class Meta:
        model=GardenDetail
        fields=['id','row_no','column_no','plant_name','icons','garden','herb']

    def get_icons(self, obj):
        if obj.icons:
            return obj.icons.url  
        return None 


class HerbDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model=Herb
        fields=['id','common_name','description','scientific_name','optimal_soil_ph_range','soil_type_preferences','light_requirements','water_requirements',
                'nutrient_requirements','temperature_range','humidity_tolerance','planting_depth_and_spacing' ,'image']

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model=Location
        fields=['latitude','longitude','soil_ph','phosphorus','potassium','nitrogen']


class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = ['id','date', 'time']