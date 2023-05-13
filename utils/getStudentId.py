def getStudentId(civilId: str, name: str):
  return f"{civilId}_{name}".replace(" ", "_").replace("(...)", "_")
  