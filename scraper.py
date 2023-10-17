import requests
from bs4 import BeautifulSoup, Tag
import json


def scrape_courses_by_university(is_polytechnic, courses_by_university=[]):
    type_code = 11 if not is_polytechnic else 12
    page = requests.get(
        f"http://www.dges.gov.pt/guias/indest.asp?reg={type_code}")
    soup = BeautifulSoup(page.text, "html.parser")

    elem = soup.find("div", {"class": "box9"})

    current_university = {}
    universities_qnt = 0
    courses_qnt = 0

    while elem != None:
        id = elem.findChild(
            "div", {"class": ["lin-area-c1", "lin-ce-c2"]}).contents[0].text
        name = elem.findChild(
            "div", {"class": ["lin-area-d2", "lin-ce-c3"]}).contents[0].text

        if elem['class'][0] == "box9":  # University
            if current_university != {}:
                courses_by_university.append(current_university.copy())
                universities_qnt += 1

            current_university["name"] = name
            current_university["id"] = id
            current_university["is_polytechnic"] = is_polytechnic
            current_university["courses"] = []

        elif elem['class'][0] == "lin-ce":  # Course
            current_university["courses"].append({"id": id, "name": name})
            courses_qnt += 1
            # Just one course and institute per institute type
            # break

        elem = elem.find_next("div", {"class": ["box9", "lin-ce"]})

    courses_by_university.append(current_university.copy())
    universities_qnt += 1

    return (courses_by_university, universities_qnt, courses_qnt)


def scrape_applications_for_courses(courses_by_university, years, phases):
    courses_counter = 0
    for uni_i, uni in enumerate(courses_by_university):
        for course in uni["courses"]:
            courses_counter += 1
            course["applications"] = {}
            for year in years:
                course["applications"][year] = {}
                for phase in phases:
                    course["applications"][year][phase] = getStudentsCourseInfo(
                        uni["id"],
                        course["id"],
                        year,
                        phase
                    )
                    print(f"Progress {round((100 * (courses_counter - 1)) / courses_qnt)}% \t\t \033[1m{uni_i + 1} / {institutes_qnt}\033[0m Universities ({uni['id']}) \t\t \033[1m{courses_counter} / {courses_qnt}\033[0m\033[0m Courses ({course['id']}) \t\t {year} phase {phase}", end="\r")

        #         # Just first year and phase
        #             break
        #         break
        # # Just first course and university
        #     break
        # break

    return courses_by_university


def getStudentsCourseInfo(university_id, course_id, year, phase, first_student=1, last_student=10000):
    page = requests.get(
        f"http://dges.gov.pt/coloc/{year}/col{phase}listaser.asp?CodEstab={university_id}&CodCurso={course_id}&ids={first_student}&ide={last_student}&Mx={last_student}")
    soup = BeautifulSoup(page.text, "html.parser")

    tables = soup.find_all("table", {"class": "caixa"})

    if (len(tables) == 0):
        return []

    applications = []
    table: Tag = tables[-1]

    for application in table.find_all("tr"):
        application = application \
            .getText() \
            .replace("\t", "") \
            .replace("\r", "") \
            .split("\n")

        application = list(filter(lambda s: s != '', application))

        if (len(application) != 8):
            continue

        applications.append({
            "course_order_num": application[0],
            "civil_id": application[1],
            "name": application[2],
            "candidature_grade": application[3],
            "student_option_number": application[4],
            "exams_grades": application[5],
            "_12grade": application[6],
            "_11grade": application[7],
        })

    return applications

def scrape_placements_for_applications(applications):
    courses_counter = 0
    for uni_i, uni in enumerate(applications):
        type_code = 11 if not uni["is_polytechnic"] else 12
        for course in uni["courses"]:
            courses_counter += 1
            if "applications" not in course:
                continue

            for year in course["applications"]:
                for phase in course["applications"][year]:
                    page = requests.get(f"http://dges.gov.pt/coloc/{year}/col{phase}listacol.asp",
                        data = {
                        "CodEstab": uni['id'],
                        "CodCurso": course['id'],
                        "CodR": type_code,
                        "search": "Continuar"
                        }
                    )
                    soup = BeautifulSoup(page.text, "html.parser")

                    tables = soup.find_all("table", {"class": "caixa"})

                    if (len(tables) == 0):
                        continue

                    table: Tag = tables[-1]

                    placements = []

                    for placement in table.find_all("tr"):
                        placement = placement \
                            .getText() \
                            .replace("\t", "") \
                            .replace("\r", "") \
                            .split("\n")

                        placement = list(filter(lambda s: s != '', placement))

                        if (len(placement) != 2):
                            continue
                        
                        civil_id = placement[0].strip()
                        name = placement[1].strip().replace(" ", "").lower()

                        placements.append(civil_id + name)
                    
                    for student_i, student in enumerate(course["applications"][year][phase]):
                        id = student["civil_id"].strip() + student["name"].strip().replace(" ", "").lower()
                        course["applications"][year][phase][student_i]["placed"] = id in placements
                    
                    print(f"Progress {round((100 * (courses_counter - 1)) / courses_qnt)}% \t\t \033[1m{uni_i + 1} / {institutes_qnt}\033[0m Universities ({uni['id']}) \t\t \033[1m{courses_counter} / {courses_qnt}\033[0m\033[0m Courses ({course['id']}) \t\t {year} phase {phase}", end="\r")


    return applications

print("Welcome to FindYourFriendUniversity Scraper!")
print("\nScraping Universities and Courses ...")

(courses_by_university, universities_qnt, courses_uni_qnt) \
    = scrape_courses_by_university(is_polytechnic=False)

(courses_by_university, polytechnics_qnt, courses_poli_qnt) \
    = scrape_courses_by_university(is_polytechnic=True, courses_by_university=courses_by_university)

courses_qnt = courses_uni_qnt + courses_poli_qnt
institutes_qnt = universities_qnt + polytechnics_qnt

# print("Courses by Universities:\n" +
#       json.dumps(courses_by_university, indent=4, ensure_ascii=False))

print(f"""
{institutes_qnt} institutes with {courses_qnt} courses:
    {universities_qnt} universities with {courses_uni_qnt} courses
    {polytechnics_qnt} polytechnics with {courses_poli_qnt} courses
""")

applications = scrape_applications_for_courses(
    courses_by_university, [2018, 2019, 2020, 2021, 2022, 2023], [1, 2, 3])

print(f"\n\nScraped Applications. Starting scrape placements.\n\n")

applications_with_placements = scrape_placements_for_applications(applications)

print(f"\n\nDone!!! Applications stored at `\033[1mapplications.json\033[0m`.")

with open("applications.json", "w") as file:
    json.dump(applications_with_placements, file, indent=4, ensure_ascii=False)

# print("Applications:\n" +
#       json.dumps(applications, indent=4, ensure_ascii=False))