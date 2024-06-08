import os
import json
from .models import Herb,Month
from django.db import IntegrityError

file_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'data', 'plantdataset2.txt')

if os.path.exists(file_path):
    print('Found')
else:
    print("File not found")


def save_herbs_from_file(file_path):
    if file_path:
        try:
            with open(file_path, "r") as file:
                herbs_data = json.load(file)
                
                for herb_data in herbs_data:
                    # Check if herb with the same common name already exists
                    if not Herb.objects.filter(common_name=herb_data['CommonName']).exists():
                        herb = Herb(
                            common_name=herb_data['CommonName'],
                            scientific_name=herb_data['ScientificName'],
                            optimal_soil_ph_range=herb_data['OptimalSoilPHRange'],
                            soil_type_preferences=herb_data['SoilTypePreferences'],
                            light_requirements=herb_data['LightRequirements'],
                            water_requirements=herb_data['WaterRequirements'],
                            nutrient_requirements=herb_data['NutrientRequirements'],
                            temperature_range=herb_data['TemperatureRange'],
                            humidity_tolerance=herb_data['HumidityTolerance'],
                            planting_depth_and_spacing=herb_data['PlantingDepthAndSpacing']
                        )
                        herb.save()

                        for month_name in herb_data['SeasonInPakistan']:
                            month, created = Month.objects.get_or_create(name=month_name)
                            herb.season_in_pakistan.add(month)
                        
                        herb.save()
                    else:
                        print(f"Herb with common name '{herb_data['CommonName']}' already exists and will not be added again.")

            print("Herbs saved successfully!")
        except FileNotFoundError:
            print(f"File not found at path: {file_path}")
        except json.JSONDecodeError:
            print("Error decoding JSON from the file.")
        except IntegrityError as e:
            print(f"Integrity error occurred: {e}")
    else:
        print("File path is empty.")


save_herbs_from_file(file_path)

# def update_herb_descriptions(file_path):
#     file_path = os.path.abspath(file_path)
#     if os.path.exists(file_path):
#         with open(file_path, "r") as file:
#             descriptions_data = json.load(file)
#             for item in descriptions_data:
#                 common_name = item["CommonName"]
#                 description = item["Description"]
#                 herbs = Herb.objects.filter(common_name=common_name)
#                 if herbs.exists():
#                     for herb in herbs:
#                         herb.description = description
#                         herb.save()
#                     print(f"Updated {common_name} with description.")
#                 else:
#                     print(f"Herb with common name {common_name} not found.")
#     else:
#         print(f"File not found at path: {file_path}")

# update_herb_descriptions(file_path)



# import os
# import random
# import django


# from herb.models import Location

# def generate_location_dataset(num_locations):
#     names = [
#         "Mall Road", "Gulberg", "Model Town", "Defence Housing Authority (DHA)", "Johar Town",
#         "Faisal Town", "Garden Town", "Township", "Shadman", "Allama Iqbal Town", "Gulshan-e-Ravi",
#         "Samanabad", "Iqbal Town", "Sabzazar", "Wapda Town", "Cantt", "Raiwind Road", "Bahria Town",
#         "PIA Housing Scheme", "Gulshan-e-Lahore", "Chungi Amar Sadhu", "Wahdat Colony", "Ichhra",
#         "Harbanspura", "Barkat Market", "Jallo Mor", "Canal View", "Shah Jamal", "Model Housing Society",
#         "Johar Town Phase 2", "Township Sector B", "Thokar Niaz Baig", "Muslim Town", "Mozang",
#         "Qaddafi Stadium", "Model Town Link Road", "Eden Avenue Extension", "Shalimar Link Road", 
#         "Shahdara", "Lahore Cantt", "Ferozepur Road", "Garhi Shahu", "Green Town", "Gulberg 3", 
#         "Gulberg 2", "Iqbal Avenue", "Makkah Colony", "Township Sector A", "Punjab Coop Housing Society", 
#         "Akbari Gate", "Shahdra Town", "Lakshmi Chowk", "Ravi Road", "Badami Bagh", "Chauburji", 
#         "Data Darbar", "Gulshan-e-Iqbal", "Gulshan Ravi", "Mohni Road", "Neela Gumbad", "Shah Alam Market",
#         "Lohari Gate", "Anarkali", "Rang Mahal", "Shish Mahal", "Badshahi Masjid", "Shahi Qila",
#         "Shalimar Gardens", "Hazuri Bagh", "Jinnah Hospital", "Sir Ganga Ram Hospital", "Services Hospital",
#         "Mayo Hospital", "Punjab University", "Government College University", "Lahore Zoo", "Jilani Park",
#         "Lahore Museum", "Al-Hamra Arts Council", "Royal Palm Golf & Country Club", "Lahore Gymkhana Club",
#         "Punjab Club", "Aitchison College", "National College of Arts", "Government College of Science",
#         "Forman Christian College", "Kinnaird College for Women", "Lahore School of Economics",
#         "Lahore University of Management Sciences (LUMS)", "Beaconhouse National University (BNU)"
#     ]

    
#     locations = []
#     for i in range(num_locations):
#         name = random.choice(names) + f" {i}"
#         lat = random.uniform(31.4, 31.7)
#         lon = random.uniform(74.1, 74.4)
#         soil_ph = round(random.uniform(5.5, 8.0), 1)
#         nutrient_level = random.choice(["High", "Medium", "Low"])
#         texture = random.choice(["Loamy", "Sandy", "Clay"])
#         organic_matter_content = random.choice(["High", "Medium", "Low"])

#         location = Location(
#             name=name,
#             latitude=lat,
#             longitude=lon,
#             soil_ph=soil_ph,
#             nutrient_level=nutrient_level,
#             texture=texture,
#             organic_matter_content=organic_matter_content
#         )
#         locations.append(location)

#     Location.objects.bulk_create(locations)
#     print(f"Created {num_locations} locations.")


# generate_location_dataset(100)

# herb/views.py