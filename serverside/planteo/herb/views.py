# import os
# import json
# from .models import Herb,Month
# from django.db import IntegrityError

# file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'data', 'plantdataset3.txt')

# if os.path.exists(file_path):
#     print('Found')
# else:
#     print("File not found")


# def save_herbs_from_file(file_path):
#     if file_path:
#         try:
#             with open(file_path, "r") as file:
#                 herbs_data = json.load(file)
                
#                 for herb_data in herbs_data:
#                     # Check if herb with the same common name already exists
#                     if not Herb.objects.filter(common_name=herb_data['CommonName']).exists():
#                         herb = Herb(
#                             common_name=herb_data['CommonName'],
#                             scientific_name=herb_data['ScientificName'],
#                             optimal_soil_ph_range=herb_data['OptimalSoilPHRange'],
#                             soil_type_preferences=herb_data['SoilTypePreferences'],
#                             light_requirements=herb_data['LightRequirements'],
#                             water_requirements=herb_data['WaterRequirements'],
#                             nutrient_requirements=herb_data['NutrientRequirements'],
#                             temperature_range=herb_data['TemperatureRange'],
#                             humidity_tolerance=herb_data['HumidityTolerance'],
#                             planting_depth_and_spacing=herb_data['PlantingDepthAndSpacing']
#                         )
#                         herb.save()

#                         for month_name in herb_data['SeasonInPakistan']:
#                             month, created = Month.objects.get_or_create(name=month_name)
#                             herb.season_in_pakistan.add(month)
                        
#                         herb.save()
#                     else:
#                         print(f"Herb with common name '{herb_data['CommonName']}' already exists and will not be added again.")

#             print("Herbs saved successfully!")
#         except FileNotFoundError:
#             print(f"File not found at path: {file_path}")
#         except json.JSONDecodeError:
#             print("Error decoding JSON from the file.")
#         except IntegrityError as e:
#             print(f"Integrity error occurred: {e}")
#     else:
#         print("File path is empty.")


# save_herbs_from_file(file_path)


import math
from datetime import datetime
from django.http import JsonResponse
from .models import Location, Herb, Month
from django.db.models import Q
from .serializers import HerbListSerializer

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

    # Filter locations within 5 kilometers
    nearby_locations = [loc for loc in locations if calculate_distance(user_lat, user_lon, loc.latitude, loc.longitude) <= 5]

    # Extract distinct soil pH ranges and texture preferences
    soil_ph_list = set(loc.soil_ph for loc in nearby_locations)
    texture_list = set(loc.texture for loc in nearby_locations)

    # Build Q objects dynamically for filtering
    q_objects = Q()
    for soil_ph in soil_ph_list:
        q_objects |= Q(optimal_soil_ph_range__contains=[soil_ph])

    for texture in texture_list:
        q_objects &= Q(soil_type_preferences__icontains=texture)

    # Query suitable plants based on the extracted values
    suitable_plants = Herb.objects.filter(
        q_objects,
        season_in_pakistan__name__icontains=current_month
    ).distinct()

    # If no suitable plants are found, query based on current month only
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



from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Herb
from .serializers import HerbListSerializer

class HerbListView(APIView):
    def get(self, request, *args, **kwargs):
        try:
            herbs = Herb.objects.all()
            serializer = HerbListSerializer(herbs, many=True)
            return Response({
                'status': 'success',
                'data': serializer.data
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

