from rest_framework import serializers
from .models import Herb

class HerbListSerializer(serializers.ModelSerializer):
    class Meta:
        model=Herb
        fields=['id','common_name','description']