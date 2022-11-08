from bs4 import BeautifulSoup
import requests

def getStudentInfo (tableRow):
  studentDataArray = list(
    filter(
      lambda info: info != "",
      map(
        lambda info: info.text.replace("\t", "").replace("\n", "").replace("\r", ""),
        tableRow
      )
    )
  )

  return {
    "orderNumber": studentDataArray[0],
    "citizenCardId": studentDataArray[1],
    "name": studentDataArray[2],
    "gradeCandidature": studentDataArray[3],
    "optionNum": studentDataArray[4],
    "gradeExam": studentDataArray[5],
    "grade12": studentDataArray[6],
    "grade11": studentDataArray[7],
  }

def getUniversityCourseData (universityCode, courseCode, firstStudent=1, lastStudent=10000):
  page = requests.get(f"http://dges.gov.pt/coloc/2022/col1listaser.asp?CodEstab={universityCode}&CodCurso={courseCode}&ids={firstStudent}&ide={lastStudent}&Mx=1310")
  soup = BeautifulSoup(page.text, "html.parser")

  tableRows = soup.find_all("table", {"class": "caixa"})[2].find_all("tr")
  return list(map(getStudentInfo, tableRows))

def searchName (name, courseInfo):
  for student in courseInfo:
    if (name in student["name"]):
      print(student)
      print("\n")
    
courseTest = getUniversityCourseData(1000, 9119)
    
searchName(input("Search Name: ").upper(), courseTest)