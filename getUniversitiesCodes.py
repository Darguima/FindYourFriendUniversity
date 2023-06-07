import requests
from bs4 import BeautifulSoup

from myTypes import UniversitiesCodes, CoursesCodes, Entity

def getUniversitiesCodes ():
  allUniversities: UniversitiesCodes = {}
  allCourses: CoursesCodes = {}

  # Scraping Universities
  universities, uniCourses = scrapSite("http://www.dges.gov.pt/guias/indest.asp?reg=11", False)
  allUniversities.update(universities)
  allCourses.update(uniCourses)

  # Scraping polytechnics
  polytechnic, polyCourses = scrapSite("http://www.dges.gov.pt/guias/indest.asp?reg=12", True)
  allUniversities.update(polytechnic)
  allCourses.update(polyCourses)

  return allUniversities, allCourses

def scrapSite(url: str, isPolytechnic: bool):
  page = requests.get(url)
  soup = BeautifulSoup(page.text, "html.parser")

  universities: UniversitiesCodes = {}
  courses: CoursesCodes = {}
  currentUniversity: Entity = {}
  
  elem = soup.find("div", {"class": "box9"})

  while elem != None:
    code = elem.findChild("div", {"class": ["lin-area-c1", "lin-ce-c2"]}).contents[0].text
    name = elem.findChild("div", {"class": ["lin-area-d2", "lin-ce-c3"]}).contents[0].text

    if elem['class'][0] == "box9": # University
      currentUniversity = {
        "code": code,
        "name": name,
      }

      universities[code] = {
        "name": name,
        "courses": [],
        "isPolytechnic": isPolytechnic
      }

    # Course
    elif elem['class'][0] == "lin-ce":

      if code in courses:
        courses[code]["universities"].append(currentUniversity)

      else:
        courses[code] = {
          "name": name,
          "universities": [currentUniversity]
        }

      universities[currentUniversity["code"]]["courses"].append({ "code": code, "name": name})

    elem = elem.find_next("div", {"class": ["box9", "lin-ce"]})

  return universities, courses
  