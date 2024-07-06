import math
from datetime import datetime
from django.http import JsonResponse
from .models import Location, Herb, Month
from django.db.models import Q
from .serializers import HerbListSerializer,HerbDetailSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Herb,Location
from .serializers import HerbListSerializer,LocationSerializer
from rest_framework.exceptions import NotFound
from rest_framework import generics,status
from django.core.cache import cache
from rest_framework.pagination import PageNumberPagination

def calculate_distance(lat1, lon1, lat2, lon2):
    lat1_rad = math.radians(lat1)
    lon1_rad = math.radians(lon1)
    lat2_rad = math.radians(lat2)
    lon2_rad = math.radians(lon2)
    dlon = lon2_rad - lon1_rad
    dlat = lat2_rad - lat1_rad
    a = math.sin(dlat / 2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    R = 6371.0
    distance = R * c
    return distance

def get_current_month():
    now = datetime.now()
    return now.strftime("%B")

def recommend_plants(user_lat, user_lon, current_month):
    locations = Location.objects.all()

    nearby_locations = [loc for loc in locations if calculate_distance(user_lat, user_lon, loc.latitude, loc.longitude) <= 5]
    soil_ph_list = set(loc.soil_ph for loc in nearby_locations)
    texture_list = set(loc.texture for loc in nearby_locations)

    q_objects = Q()
    for soil_ph in soil_ph_list:
        q_objects |= Q(optimal_soil_ph_range__contains=[soil_ph])

    for texture in texture_list:
        q_objects &= Q(soil_type_preferences__icontains=texture)

    suitable_plants = Herb.objects.filter(
        q_objects,
        season_in_pakistan__name__icontains=current_month
    ).distinct()

    if not suitable_plants:
        suitable_plants = Herb.objects.filter(
            season_in_pakistan__name__icontains=current_month
        ).distinct()

    plant_names = [plant.common_name for plant in suitable_plants]
    return plant_names

def plant_recommendation_view(request):
    if request.method == 'GET':
        lat_str = request.GET.get('lat')
        lon_str = request.GET.get('lon')

        if not lat_str or not lon_str:
            return JsonResponse({"error": "Latitude or longitude is missing."}, status=400)

        try:
            user_lat = float(lat_str)
            user_lon = float(lon_str)
        except ValueError:
            return JsonResponse({"error": "Invalid latitude or longitude format."}, status=400)

        current_month = 'April'
        recommended_plants = recommend_plants(user_lat, user_lon, current_month)
        return JsonResponse({"recommended_plants": recommended_plants})

    return JsonResponse({"error": "Unsupported method."}, status=405)

class HerbListView(APIView):
    def get(self, request, *args, **kwargs):
        try:
            herbs = Herb.objects.all()
            serializer = HerbListSerializer(herbs, many=True)
            data_with_img = []

            for herb in serializer.data:
                data_with_img.append(herb)

            return Response({
                'status': 'success',
                'data': data_with_img
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# class HerbListView(APIView):
#     def get(self, request, *args, **kwargs):
#         try:
#             page = request.query_params.get('page', 1)
#             cache_key = f'herb_list_page_{page}'
#             herbs_data = cache.get(cache_key)
#             if herbs_data:
#                 print("Data loaded from cache")
#                 return Response(herbs_data, status=status.HTTP_200_OK)
#             herbs = Herb.objects.order_by('id')  
#             paginator = PageNumberPagination()
#             paginated_herbs = paginator.paginate_queryset(herbs, request)
#             serializer = HerbListSerializer(paginated_herbs, many=True)
#             herbs_data = paginator.get_paginated_response(serializer.data).data
#             cache.set(cache_key, herbs_data, timeout=60*60*24)
#             return Response(herbs_data, status=status.HTTP_200_OK)
#         except Exception as e:
#             return Response({
#                 'status': 'error',
#                 'message': str(e)
#             }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
        
class HerbDetailView(APIView):
    def post(self, request, *args, **kwargs):
        try:
            herb_id = request.data.get('id')
            if not herb_id:
                return Response({
                    'status': 'error',
                    'message': 'Herb ID is required'
                }, status=status.HTTP_400_BAD_REQUEST)
            try:
                herb = Herb.objects.get(id=herb_id)
            except Herb.DoesNotExist:
                raise NotFound('Herb not found')
            serializer = HerbDetailSerializer(herb)
            herb_data = serializer.data

            return Response({
                'status': 'success',
                'data': herb_data
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        


class LocationCreateViewSet(generics.CreateAPIView):
    queryset = Location.objects.all()
    serializer_class = LocationSerializer

    def create(self, request, *args, **kwargs):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response({'status': 'Location created successfully'}, status=status.HTTP_201_CREATED, headers=headers)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def perform_create(self, serializer):
        serializer.save()


