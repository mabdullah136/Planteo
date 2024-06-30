import pickle
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import pandas as pd
import numpy as np
from .models import Location,Herb
import requests

import os
print("Current Working Directory:", os.getcwd())

# Load the model when the server starts
NB_pkl_filename = os.path.join(os.path.dirname(__file__), 'function/NBClassifier.pkl')
print("Constructed Path:", NB_pkl_filename)

if os.path.exists(NB_pkl_filename):
    print("File found, proceeding to load")
    with open(NB_pkl_filename, 'rb') as file:
        NaiveBayes = pickle.load(file)
else:
    raise FileNotFoundError(f"File not found: {NB_pkl_filename}")

# env_data = {
#         'N': 26,
#         'P': 9,
#         'K': 15,
#         'temperature': 23,
#         'humidity': 65,
#         'ph': 6.6,
#         'rainfall': 150,
#     }

# sample_data = pd.DataFrame([env_data])
# probs = NaiveBayes.predict_proba(sample_data)
# class_labels = NaiveBayes.classes_
# top_indices = np.argsort(probs[0])[-10:][::-1]
# top_10_plants = class_labels[top_indices]
# print(top_10_plants)

api_key = 'b4c789a96343fade85ef367b0aa5ad01'
url = f'https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={api_key}'

import math

def haversine(lat1, lon1, lat2, lon2):
    R = 6371  # Radius of the Earth in km
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat / 2) * math.sin(dlat / 2) +
         math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) *
         math.sin(dlon / 2) * math.sin(dlon / 2))
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    distance = R * c
    return distance


class PlantSuggestionAPIView(APIView):

    def post(self, request, *args, **kwargs):
        data = request.data
        latitude = float(data.get('latitude'))
        longitude = float(data.get('longitude'))
        print(latitude)
        print(longitude)
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            humidity = data['main']['humidity']
            temp_min_k = data['main']['temp_min']
            temp_max_k = data['main']['temp_max']
            temp_min_c = round(temp_min_k - 273.15, 1)
            temp_max_c = round(temp_max_k - 273.15, 1)
            avg_temp_c = round((temp_min_c + temp_max_c) / 2, 1)

        try:
            # Calculate distances to all locations
            locations = Location.objects.all()
            nearest_location = None
            min_distance = float('inf')
            for location in locations:
                distance = haversine(latitude, longitude, location.latitude, location.longitude)
                if distance <= 4.0 and distance < min_distance:  # 4 km radius
                    nearest_location = location
                    min_distance = distance
            
            if nearest_location is None:
                return Response({'error': 'Location not found'}, status=status.HTTP_404_NOT_FOUND)
            
            env_data = {
                'N': nearest_location.nitrogen,
                'P': nearest_location.phosphorus,
                'K': nearest_location.potassium,
                'temperature': avg_temp_c,
                'humidity': humidity,
                'ph': nearest_location.soil_ph,
                'rainfall': 150,
            }
            sample_data = pd.DataFrame([env_data])
            probs = NaiveBayes.predict_proba(sample_data)
            class_labels = NaiveBayes.classes_
            top_indices = np.argsort(probs[0])[-10:][::-1]
            top_10_plants = class_labels[top_indices]
            print(top_10_plants)
            plant_details = []
            for plant in top_10_plants:
                try:
                    herb = Herb.objects.get(common_name=plant.capitalize())
                    plant_details.append({
                        'id': herb.id,
                        'common_name': herb.common_name,
                        'description': herb.description,
                        'img': f'/media/{herb.image}',
                    })
                except Herb.DoesNotExist:
                    continue
            return Response({'status': 'success', 'data': plant_details}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
