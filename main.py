import json

from getUniversitiesCodes import getUniversitiesCodes
from getStudentsInfo import getStudentsInfo

universities, courses = getUniversitiesCodes()
students = getStudentsInfo(universities)

with open("students.json", "w") as outfile:
    outfile.write(json.dumps(students, indent=4, ensure_ascii=False))
