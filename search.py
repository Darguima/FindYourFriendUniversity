import json

from myTypes import StudentsInfo

students: StudentsInfo = json.load(open("students.json", "r") )

def searchByName(searchName: str):
  searchName = searchName.upper()
  searchNames = searchName.split(" ")


  # If search "João Antonio Miguel", only founds "João Antonio Miguel"
  perfectMatch = []
  # If search "João Antonio Miguel", founds names with "João", "Antonio" and "Miguel", for example "João Barroso Antonio Miguel"
  sameNames = []
  # If search "João Antonio Miguel", founds names with "João", "Antonio" or "Miguel", for example "João Barroso" or "Miguel Antunes"
  someNameEqual = []

  namesList = list(dict.fromkeys(
      map(lambda x: x["name"], students)
  ))

  for currentStudent in namesList:
    currentStudentNames = currentStudent.split(" ")

    if currentStudent == searchName:
      perfectMatch.append(currentStudent)

    elif all(subName in currentStudentNames for subName in searchNames):
      sameNames.append(currentStudent)

    elif any(subName in currentStudentNames for subName in searchNames):
      someNameEqual.append(currentStudent)
  
  print("\n======================================================================")
  
  print(f"\nSome Name Equal -{json.dumps(someNameEqual, indent=4, ensure_ascii=False)}")
  print(f"\nSame Names -{json.dumps(sameNames, indent=4, ensure_ascii=False)}")
  print(f"\nPerfect Match -{json.dumps(perfectMatch, indent=4, ensure_ascii=False)}")

searchByName(input("Name: "))
