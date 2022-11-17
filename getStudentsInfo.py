import requests
from bs4 import BeautifulSoup, Tag

from myTypes import UniversitiesCodes, StudentsInfo

def getStudentsInfo (universitiesCodes: UniversitiesCodes):
  students: StudentsInfo = []
  counter = 0

  for universityCode, university in universitiesCodes.items():
    for course in university['courses']:
      counter += 1
      print(f"Counter: {counter}")

      students += getStudentsCourseInfo(universityCode, university["name"], course['code'], course["name"])

  return students

def getStudentsCourseInfo (universityCode: str, universityName: str, courseCode: str, courseName: str, firstStudent=1, lastStudent=10000):
  page = requests.get(f"http://dges.gov.pt/coloc/2022/col1listaser.asp?CodEstab={universityCode}&CodCurso={courseCode}&ids={firstStudent}&ide={lastStudent}&Mx={lastStudent}")
  soup = BeautifulSoup(page.text, "html.parser")

  tables = soup.find_all("table", {"class": "caixa"})

  if (len(tables) <= 0):
    print(f"Without Students: {universityName} - {courseName}")
    return []

  table: Tag = tables[-1]

  students: StudentsInfo = []

  for studentInfo in table.find_all("tr"):
    
    info = list(
      filter(
        lambda i: i != "", 
        map(lambda i: i.text.replace("\n", "").replace("\t", "").replace("\r", ""), studentInfo.find_all("td"))
      )
    )

    students.append({
      "orderNumber": info[0],
      "civilId": info[1],
      "name": info[2],
      "candidatureGrade": info[3],
      "optionNumber": info[4],
      "examsGrades": info[5],
      "_12grade": info[6],
      "_11grade": info[7],

      "universityName": universityName,
      "universityCode": universityCode,
      "courseName": courseName,
      "courseCode": courseCode
    })
  
  return students