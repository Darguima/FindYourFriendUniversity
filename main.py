import json

from getUniversitiesCodes import getUniversitiesCodes
from getUniversityApplications import getUniversityApplications

from utils.statistics import universitiesStats, applicationsStats

print("\nHi, welcome to Find Your Friend University!!!\n")

universities, courses = getUniversitiesCodes()
uniStats = universitiesStats(universities, printOutput=True)

applications = getUniversityApplications(universities, uniStats["coursesTotal"])
applyStats = applicationsStats(applications, printOutput=True)

with open("applications.json", "w") as outfile:
    outfile.write(json.dumps(applications, indent=4, ensure_ascii=False))
