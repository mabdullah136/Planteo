from django.db import models

class Month(models.Model):
    name = models.CharField(max_length=20)

    def __str__(self):
        return self.name

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
    def __str__(self):
        return f"{self.common_name} ({self.scientific_name})"
    
class Location(models.Model):
    name = models.CharField(max_length=100)
    latitude = models.FloatField()
    longitude = models.FloatField()
    soil_ph = models.FloatField()
    nutrient_level = models.CharField(max_length=100)  
    texture = models.CharField(max_length=100)        
    organic_matter_content = models.CharField(max_length=100)  

    def __str__(self):
        return self.name
