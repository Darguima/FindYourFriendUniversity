from myTypes import UniversitiesCodes, Applications

def universitiesStats(universities: UniversitiesCodes, printOutput = False):
  count = {
    "institutionsTotal": 0,
    "coursesTotal": 0,
    "universities": 0,
    "universitiesCourses": 0,
    "polytechnics": 0,
    "polytechnicsCourses": 0,
  }

  for university in universities.values():
    count["institutionsTotal"] += 1
    count["coursesTotal"] += len(university["courses"])

    if not university["isPolytechnic"]: # university
      count["universities"] += 1
      count["universitiesCourses"] += len(university["courses"])
    else: # polytechnic
      count["polytechnics"] += 1
      count["polytechnicsCourses"] += len(university["courses"])

  if printOutput:
    print(f"Exists {count['coursesTotal']} courses in {count['institutionsTotal']} universities.")
    print(f"\t{count['universitiesCourses']} courses in {count['universities']} universities.")
    print(f"\t{count['polytechnicsCourses']} courses in {count['polytechnics']} polytechnics.\n")

  return count


def applicationsStats(applications: Applications, printOutput = False):
  universityStudents = {}
  polytechnicStudents = {}

  for application in applications:
    if not application["isPolytechnic"]: # university
      universityStudents[application["civilId"] + application["name"]] = None
    else: # polytechnic
      polytechnicStudents[application["civilId"] + application["name"]] = None
    
  count = {
    "applicationsTotal": len(applications),
    "studentsTotal": len(universityStudents) + len(polytechnicStudents),
    "universitiesApplications": 0,
    "universitiesStudents": len(universityStudents),
    "polytechnicsApplications": 0,
    "polytechnicsStudents": len(polytechnicStudents)
  }

  for application in applications:
    if not application["isPolytechnic"]: # university
      count["universitiesApplications"] += 1
    else: # polytechnic
      count["polytechnicsApplications"] += len(application["courses"])

  if printOutput:
    print(f"Exists {count['applicationsTotal']} applications from {count['studentsTotal']} different students.")
    print(f"\t{count['universitiesApplications']} applications on universities from {count['universitiesStudents']} different students.")
    print(f"\t{count['polytechnicsApplications']} applications on polytechnics from {count['polytechnicsStudents']} different students.\n")

  return count