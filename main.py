import json

from getUniversitiesCodes import getUniversitiesCodes
from getUniversityApplications import getUniversityApplications

from utils.statistics import universitiesStats, applicationsStats

print("\nHi, welcome to Find Your Friend University!!!\n")

universities, courses = getUniversitiesCodes()
uniStats = universitiesStats(universities, printOutput=True)

years = [2018, 2019, 2020, 2021, 2022]
phase = [1, 2, 3]

applications = getUniversityApplications(universities, years, phase, uniStats["coursesTotal"])
applyStats = applicationsStats(applications, printOutput=True)

applicationsFile = "applications.json"
with open(applicationsFile, "w") as outfile:
    outfile.write(json.dumps(applications, indent=4, ensure_ascii=False))

print(f"Students applications stored in '{applicationsFile}' file.\n")
