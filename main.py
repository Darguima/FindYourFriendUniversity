import json

from getUniversitiesCodes import getUniversitiesCodes
from getCourseInfo import getCourseInfo

universities, courses = getUniversitiesCodes()
getCourseInfo(universities, courses)

# print(json.dumps(universities, indent=4, ensure_ascii=False))
# print(json.dumps(courses, indent=4, ensure_ascii=False))
