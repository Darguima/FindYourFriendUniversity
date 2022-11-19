from typing import TypedDict

class Entity (TypedDict):
  name: str
  code: str

class University (TypedDict):
  name: str
  courses: list[Entity]
  isPolytechnic: bool

UniversitiesCodes = dict[int, University]

class Course (TypedDict):
  name: str
  universities: list[Entity]

CoursesCodes = dict[int, Course]

class Application (TypedDict):
  orderNumber: str
  civilId: str
  name: str
  candidatureGrade: str
  optionNumber: str
  examsGrades: str
  _12grade: str
  _11grade: str
  
  universityName: str
  universityCode: str
  courseName: str
  courseCode: str

  isPolytechnic: bool

Applications = list[Application]
