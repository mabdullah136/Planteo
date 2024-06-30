from django.contrib import admin
from .models import Herb,Location

@admin.register(Herb)
class HerbAdmin(admin.ModelAdmin):
    list_display=['common_name','description','image']
    list_editable = ['image'] 

@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display=['latitude']