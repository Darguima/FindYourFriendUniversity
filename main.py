import json

from getUniversitiesCodes import getUniversitiesCodes

universities, courses = getUniversitiesCodes()

print(json.dumps(universities, indent=4, ensure_ascii=False))
print(json.dumps(courses, indent=4, ensure_ascii=False))
