from typing import TypedDict

class Entity(TypedDict):
  name: str
  code: str

class University(TypedDict):
  name: str
  courses: list[Entity]

UniversitiesCodes = dict[int, University]

class Course(TypedDict):
  name: str
  universities: list[Entity]

CoursesCodes = dict[int, Course]
