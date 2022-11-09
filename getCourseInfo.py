from myTypes import UniversitiesCodes, CoursesCodes

def getCourseInfo (universitiesCodes: UniversitiesCodes, coursesCodes: CoursesCodes):
  for universityCode, university in universitiesCodes.items():

    for course in university['courses']:
      print(course['name'])