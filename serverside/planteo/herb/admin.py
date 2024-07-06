from django.contrib import admin
from .models import Herb,Location,GardenDetail,Garden,Notification

@admin.register(Herb)
class HerbAdmin(admin.ModelAdmin):
    list_display=['common_name','description','image','icons']
    list_editable = ['image','icons'] 

@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display=['latitude','longitude','soil_ph','nitrogen','phosphorus','potassium']
    # list_editable=['latitude','longitude','soil_ph','nitrogen','phosphorus','potassium']

@admin.register(GardenDetail)
class GardenDetailAdmin(admin.ModelAdmin):
    list_display=['plant_name','row_no','column_no','icons']
    # list_editable = ['plant_name','rown_no'] 

@admin.register(Garden)
class GardenDetailAdmin(admin.ModelAdmin):
    list_display=['name','length','width']


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display=['date','time']
