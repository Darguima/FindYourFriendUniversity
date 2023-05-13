import requests

from bs4 import BeautifulSoup, Tag

from utils.getStudentId import getStudentId

from myTypes import UniversitiesCodes

def getUniversityPlacements(universitiesCodes: UniversitiesCodes, years: int, phases: int, amountOfCourses: int):
  print("\nGetting University Placements:\n")

  accumulator = 0
  for universityCode, university in universitiesCodes.items():
    for course in university['courses']:
      accumulator += 1
      print(f"\tProgress: {round((100 * accumulator) / amountOfCourses)}% ({accumulator}/{amountOfCourses})", end='\r')

      placements = {}

      for year in years:
        placements[year] = {}
        for phase in phases:
          placements[year][phase] = getStudentsApplicationsInfo(universityCode, course['code'], year, phase)
      
      universitiesCodes[universityCode]["placements"][course['code']] = placements

  return universitiesCodes

def getStudentsApplicationsInfo (universityCode: str, courseCode: str, year: int, phase: int):
  page = requests.get(f"http://dges.gov.pt/coloc/{year}/col{phase}listacol.asp",
    data = {
      "CodEstab": universityCode,
      "CodCurso": courseCode,
    }
  )

  soup = BeautifulSoup(page.text, "html.parser")

  tables = soup.find_all("table", {"class": "caixa"})

  if (len(tables) <= 0):
    return []

  table: Tag = tables[-1]

  placementInfo = []

  for studentInfo in table.find_all("tr"):
    
    info = list(
      filter(
        lambda i: i != "",
        map(lambda i: i.text.replace("\n", "").replace("\t", "").replace("\r", "").strip(), studentInfo.find_all("td"))
      )
    )

    if len(info) < 2:
      continue

    placementInfo.append(getStudentId(info[0], info[1]))
  
  return placementInfo
