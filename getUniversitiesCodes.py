import requests
from bs4 import BeautifulSoup

def getUniversitiesCodes ():
  page = requests.get("http://www.dges.gov.pt/guias/indest.asp")
  soup = BeautifulSoup(page.text, "html.parser")

  universities = {}
  courses = {}
  currentUniversity = {}
  
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
        "courses": []
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
  