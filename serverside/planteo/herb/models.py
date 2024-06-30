from django.db import models
import os

class Month(models.Model):
    name = models.CharField(max_length=20)

    def __str__(self):
        return self.name
    

def plant_image_path(instance, filename):
    user_id = instance.id
    _, file_extension = os.path.splitext(filename)
    new_filename = f"{user_id}plant{file_extension}"
    return os.path.join('store/plants/images', new_filename)

class Herb(models.Model):
    common_name = models.CharField(max_length=255)
    scientific_name = models.CharField(max_length=255)
    optimal_soil_ph_range = models.CharField(max_length=20)
    soil_type_preferences = models.CharField(max_length=255)
    light_requirements = models.CharField(max_length=255)
    water_requirements = models.CharField(max_length=50)
    nutrient_requirements = models.CharField(max_length=50)
    temperature_range = models.CharField(max_length=50)
    humidity_tolerance = models.CharField(max_length=50)
    planting_depth_and_spacing = models.CharField(max_length=50)
    season_in_pakistan = models.ManyToManyField(Month)
    description=models.TextField(blank=True, null=True)
    image=models.ImageField(upload_to=plant_image_path,blank=True, null=True)

    def __str__(self):
        return f"{self.common_name} ({self.scientific_name})"
    
class Location(models.Model):
    latitude = models.FloatField(blank=True, null=True)
    longitude = models.FloatField(blank=True, null=True)
    soil_ph = models.FloatField(blank=True, null=True)
    nitrogen = models.FloatField(blank=True, null=True)
    phosphorus = models.FloatField(blank=True, null=True)
    potassium = models.FloatField(blank=True, null=True)

