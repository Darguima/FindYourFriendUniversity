import requests
from bs4 import BeautifulSoup, Tag

from utils.getStudentId import getStudentId

from myTypes import UniversitiesCodes, Applications, UniversityPlacements

def getUniversityApplications (universitiesCodes: UniversitiesCodes, years: int, phases: int, amountOfCourses: int):
  applications: Applications = []

  print("\n\nGetting University Applications:")

  accumulator = 0
  for universityCode, university in universitiesCodes.items():
    for course in university['courses']:
      courseCode = course['code']
      accumulator += 1
      print(f"\tProgress: {round((100 * accumulator) / amountOfCourses)}% ({accumulator}/{amountOfCourses})", end='\r')

      for year in years:
        for phase in phases:
          applications += getStudentsApplicationsInfo(universityCode, university["name"], courseCode, course["name"], year, phase, university["isPolytechnic"], university["placements"][courseCode][year][phase])

  return applications

def getStudentsApplicationsInfo (universityCode: str, universityName: str, courseCode: str, courseName: str, year: int, phase: int, isPolytechnic: bool, placements: UniversityPlacements, firstStudent=1, lastStudent=10000):
  page = requests.get(f"http://dges.gov.pt/coloc/{year}/col{phase}listaser.asp",
    data = {
      "CodEstab": universityCode,
      "CodCurso": courseCode,

      "ids": firstStudent,
      "ide": lastStudent,
      "Mx": lastStudent,
    }
  )
  soup = BeautifulSoup(page.text, "html.parser")

  tables = soup.find_all("table", {"class": "caixa"})

  if (len(tables) <= 0):
    return []

  table: Tag = tables[-1]

  applicationsInfo: Applications = []

  for studentInfo in table.find_all("tr"):
    
    info = list(
      filter(
        lambda i: i != "", 
        map(lambda i: i.text.replace("\n", "").replace("\t", "").replace("\r", "").strip(), studentInfo.find_all("td"))
      )
    )

    if len(info) < 8:
      continue

    studentId = getStudentId(info[1], info[2])
    wasColocated = studentId in placements

    applicationsInfo.append({
      "studentId": studentId,

      "orderNumber": info[0],
      "civilId": info[1],
      "name": info[2],
      "candidatureGrade": info[3],
      "optionNumber": info[4],
      "examsGrades": info[5],
      "_12grade": info[6],
      "_11grade": info[7],

      "colocated": wasColocated,

      "universityName": universityName,
      "universityCode": universityCode,
      "courseName": courseName,
      "courseCode": courseCode,

      "isPolytechnic": isPolytechnic,
      "year": year,
      "phase": phase,
    })
  
  return applicationsInfo