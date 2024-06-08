from django.contrib import admin
from .models import Herb
# Register your models here.


@admin.register(Herb)
class HerbAdmin(admin.ModelAdmin):
    list_display=['common_name','description']