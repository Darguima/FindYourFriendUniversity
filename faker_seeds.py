import random
import json

COURSES_PER_UNIVERSITY = 3
APPLICATIONS_PER_PHASE = 2

students = [
    {
        "name": "Ana Carolina Santos",
        "civil_id": "12345678",
        "_12grade": "155",
        "_11grade": "185",
        "exams_grades": "168,0",
        "candidature_grade": "192,3",
    },
    {
        "name": "Miguel Pedroso Fernandes",
        "civil_id": "87654321",
        "_12grade": "178",
        "_11grade": "195",
        "exams_grades": "187,0",
        "candidature_grade": "170,8",
    },
    {
        "name": "Beatriz Inês Sousa",
        "civil_id": "45612378",
        "_12grade": "143",
        "_11grade": "175",
        "exams_grades": "159,0",
        "candidature_grade": "184,7",
    },
    {
        "name": "Gustavo David Santos",
        "civil_id": "78945612",
        "_12grade": "162",
        "_11grade": "169",
        "exams_grades": "179,0",
        "candidature_grade": "156,2",
    },
    {
        "name": "Rita Lara Costa",
        "civil_id": "23478961",
        "_12grade": "191",
        "_11grade": "158",
        "exams_grades": "174,0",
        "candidature_grade": "199,5",
    },
    {
        "name": "Tiago Eduardo Fernandes",
        "civil_id": "56789123",
        "_12grade": "195",
        "_11grade": "174",
        "exams_grades": "182,0",
        "candidature_grade": "185,9",
    },
    {
        "name": "Carolina Inês Sousa",
        "civil_id": "89012345",
        "_12grade": "173",
        "_11grade": "165",
        "exams_grades": "168,0",
        "candidature_grade": "178,4",
    },
    {
        "name": "Pedro João Santos",
        "civil_id": "67834512",
        "_12grade": "147",
        "_11grade": "174",
        "exams_grades": "166,0",
        "candidature_grade": "155,1",
    },
    {
        "name": "Vera Natália Costa",
        "civil_id": "45698723",
        "_12grade": "181",
        "_11grade": "197",
        "exams_grades": "193,0",
        "candidature_grade": "189,2",
    },
    {
        "name": "Lara Miguel Sousa",
        "civil_id": "78923456",
        "_12grade": "168",
        "_11grade": "151",
        "exams_grades": "163,0",
        "candidature_grade": "171,6",
    }
]

universities = [
  {
    "name": "ISCTE - Instituto Universitário de Lisboa",
    "id": "6800",
    "is_polytechnic": False
  },
  {
    "name": "Universidade da Beira Interior",
    "id": "0400",
    "is_polytechnic": False
  },
  {
    "name": "Instituto Politécnico de Coimbra - Instituto Superior de Engenharia de Coimbra",
    "id": "3064",
    "is_polytechnic": True
  }
]

courses = [
  {
    "id": "9448",
    "name": "Antropologia"
  },
  {
    "id": "9257",
    "name": "Arquitetura"
  },
  {
    "id": "9540",
    "name": "Bioengenharia"
  },
  {
    "id": "9089",
    "name": "Engenharia Civil"
  }
]

locations = [
    {
        "name": "Aveiro",
        "district_code": "1",
        "counties": [
            {
                "name": "Águeda",
                "county_code": "1",
                "parishes": [
                    {
                        "name": "Agadão",
                        "parish_code": "1",
                        "people": []
                    },
                    {
                        "name": "Aguada de Cima",
                        "parish_code": "3",
                        "people": []
                    }
                ]
            }
        ]
    },
    {
        "name": "Beja",
        "district_code": "2",
        "counties": [
            {
                "name": "Aljustrel",
                "county_code": "218",
                "parishes": [
                    {
                        "name": "Ervidel",
                        "parish_code": "2821",
                        "people": []
                    }
                ]
            }
        ]
    },
    {
        "name": "Braga",
        "district_code": "3",
        "counties": [
            {
                "name": "Amares",
                "county_code": "176",
                "parishes": [
                    {
                        "name": "Barreiros",
                        "parish_code": "1917",
                        "people": []
                    }
                ]
            }
        ]
    }
]

# ====== Applications Seeds ========

seeds = universities.copy()

for university in seeds:
    university["courses"] = []
    chosen_courses = random.sample(courses, COURSES_PER_UNIVERSITY)

    for course_i in range(0, COURSES_PER_UNIVERSITY):
      university["courses"].append(chosen_courses[course_i].copy())
      course = university["courses"][course_i]

      course["applications"] = {}

      for year in (2018, 2019, 2020, 2021, 2022, 2023):
        course["applications"][year] = {}
        for phase in (1, 2, 3):
          course["applications"][year][phase] = []
          applications = course["applications"][year][phase]

          chosen_applications = random.sample(students, APPLICATIONS_PER_PHASE)

          for (student_index, application) in enumerate(chosen_applications):
            applications.append(application.copy())
            application = applications[student_index]

            original_civil_id = application["civil_id"]
            application["civil_id"] = f"{original_civil_id[:3]}(...){original_civil_id[-2:]}"

            application["course_order_num"] = str(student_index + 1)

            for student_option_number in (1, 2, 3, 4, 5, 6):
              application_id = application["civil_id"] + application["name"] + str(year) + str(phase) + str(student_option_number)

            if student_option_number > 6:
              raise "Your bad luck + My Skill Issue :) Just try again bro"
            
            application["student_option_number"] = str(student_option_number)

# print(json.dumps(seeds, ensure_ascii=False, indent=2))

with open("seeds/applications_faked.json", "w") as file:
    json.dump(seeds, file, indent=4, ensure_ascii=False)

print(f"\nApplications stored at `seeds/\033[1mapplications_fakeds.json\033[0m`.")

# ====== Locations Seeds ========

students_to_add = random.sample(students, int(len(students) * 0.75)) 

# Collect all parishes from all locations
all_parishes = []
for location in locations:
    for county in location["counties"]:
        for parish in county["parishes"]:
            all_parishes.append(parish)

for student in students_to_add:
    name_parts = student["name"].split()
    first_name = name_parts[0].upper()
    last_name = name_parts[-1].upper()
    formatted_name = f"{first_name} *** {last_name}"
    
    formatted_civil_id = f"****{student['civil_id'][-4:]}"

    # Choose random county
    district_index = random.randint(0, len(locations) - 1)
    county_index = random.randint(0, len(locations[district_index]["counties"]) - 1)
    parish_index = random.randint(0, len(locations[district_index]["counties"][county_index]["parishes"]) - 1)

    locations[district_index]["counties"][county_index]["parishes"][parish_index]["people"].append({
        "name": formatted_name,
        "civil_id": formatted_civil_id
    })

dated_locations = {
   "2025": locations
}

with open("seeds/locations_faked.json", "w") as file:
    json.dump(dated_locations, file, indent=4, ensure_ascii=False)

print(f"Locations with students stored at `seeds/\033[1mlocations_faked.json\033[0m`.")
