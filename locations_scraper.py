import requests
from bs4 import BeautifulSoup
import urllib.parse
import json

HEADERS = {
  "Content-Type": "application/x-www-form-urlencoded"
}

def scraper():
  country_page = requests.get("https://ddn.dgrdn.gov.pt/ddn_editaisfreg.aspx", headers=HEADERS)
  country_soup = BeautifulSoup(country_page.text, "html.parser")

  district_viewstate = country_soup.find(attrs={"name" : "__VIEWSTATE"})["value"]
  district_event_validation = country_soup.find(attrs={"name" : "__EVENTVALIDATION"})["value"]

  select_district = country_soup.find("select", {"id": "ctl00_ctl00_cPage_cPage_selDist"})
  select_district_options = select_district.find_all("option")

  for district_option in select_district_options:
    # Ignore void and "Estrangeiro" (Foreign) options
    if district_option["value"] != "-1" and district_option["value"] != "0":
      district_scraper(district_option.text, district_option["value"], district_viewstate, district_event_validation)
  
def district_scraper(district_name, district_id, viewstate, event_validation):
  print("District: " + district_name + " - ID: " + district_id)
  persons_location.append({
    "name": district_name,
    "district_code": district_id,
    "counties": []
  })

  raw_data = \
      "__VIEWSTATE=" + urllib.parse.quote_plus(viewstate) \
      + "&__EVENTVALIDATION=" + urllib.parse.quote_plus(event_validation) \
      + "&ctl00%24ctl00%24cPage%24cPage%24selDist=" + district_id

  district_page = requests.post(
    "https://ddn.dgrdn.gov.pt/ddn_editaisfreg.aspx",
    headers=HEADERS,
    data=raw_data
  )

  district_soup = BeautifulSoup(district_page.text, "html.parser")

  county_viewstate = district_soup.find(attrs={"name" : "__VIEWSTATE"})["value"]
  county_event_validation = district_soup.find(attrs={"name" : "__EVENTVALIDATION"})["value"]

  select_county = district_soup.find("select", {"id": "ctl00_ctl00_cPage_cPage_selConc"})
  select_county_options = select_county.find_all("option")

  for county_option in select_county_options:
    if county_option["value"] != "-1":
      county_scraper(county_option.text, county_option["value"], district_name, district_id, county_viewstate, county_event_validation)
      # break

def county_scraper(county_name, county_id, district_name, district_id, viewstate, event_validation):
  print("\tCounty: " + county_name + " - ID: " + county_id)
  persons_location[-1]["counties"].append({
    "name": county_name,
    "county_code": county_id,
    "parishes": []
  })
  
  raw_data = \
      "__VIEWSTATE=" + urllib.parse.quote_plus(viewstate) \
      + "&__EVENTVALIDATION=" + urllib.parse.quote_plus(event_validation) \
      + "&ctl00%24ctl00%24cPage%24cPage%24selDist=" + district_id \
      + "&ctl00%24ctl00%24cPage%24cPage%24selConc=" + county_id

  county_page = requests.post(
    "https://ddn.dgrdn.gov.pt/ddn_editaisfreg.aspx",
    headers=HEADERS,
    data=raw_data
  )

  county_soup = BeautifulSoup(county_page.text, "html.parser")

  parish_viewstate = county_soup.find(attrs={"name" : "__VIEWSTATE"})["value"]
  parish_event_validation = county_soup.find(attrs={"name" : "__EVENTVALIDATION"})["value"]

  select_parish = county_soup.find("select", {"id": "ctl00_ctl00_cPage_cPage_selFreg"})
  
  select_parish_options = select_parish.find_all("option")

  for parish_option in select_parish_options:
    if parish_option["value"] != "-1":
      parish_scraper(parish_option.text, parish_option["value"], county_name, county_id, district_name, district_id, parish_viewstate, parish_event_validation)
      # break
  
def parish_scraper(parish_name, parish_id, county_name, county_id, district_name, district_id, viewstate, event_validation, page="1"):
  print("\t\tParish: " + parish_name + " - ID: " + parish_id + " - Page: " + page)
  if (page == "1"):
    persons_location[-1]["counties"][-1]["parishes"].append({
    "name": parish_name,
    "parish_code": parish_id,
    "people": []
  })

  raw_data = \
      "__VIEWSTATE=" + urllib.parse.quote_plus(viewstate) \
      + "&__EVENTVALIDATION=" + urllib.parse.quote_plus(event_validation) \
      + "&ctl00%24ctl00%24cPage%24cPage%24selDist=" + district_id \
      + "&ctl00%24ctl00%24cPage%24cPage%24selConc=" + county_id \
      + "&ctl00%24ctl00%24cPage%24cPage%24selFreg=" + parish_id

  if (page != "1"):
    raw_data += "&__EVENTTARGET=ctl00%24ctl00%24cPage%24cPage%24tabListConv&__EVENTARGUMENT=Page%24" + page

  parish_page = requests.post(
    "https://ddn.dgrdn.gov.pt/ddn_editaisfreg.aspx",
    headers=HEADERS,
    data=raw_data
  )

  parish_soup = BeautifulSoup(parish_page.text, "html.parser")
  table_rows = parish_soup.findAll("tr")

  if (len(table_rows) <= 1):
    return
  else:
    table_rows = table_rows[1:]

  next_page_viewstate = parish_soup.find(attrs={"name" : "__VIEWSTATE"})["value"]
  next_page_event_validation = parish_soup.find(attrs={"name" : "__EVENTVALIDATION"})["value"]

  next_page = None
  # Will run if exists a pagination on the table bottom
  if (table_rows[-1].find("span") != None):
    current_page = table_rows[-1].find("span")

    next_page_element = current_page.find_next("a")
    possible_next_page = str(int(current_page.text) + 1)

    exists_next_page = next_page_element != None and (next_page_element.text == possible_next_page or next_page_element.text == "...")

    if (exists_next_page):
      next_page = possible_next_page
    else:
      next_page = None

  # Remove all the pagination rows
  table_rows = list(filter(lambda row: row.find("span") == None, table_rows))

  for person_row in table_rows:
    person_cells = person_row.findAll("td")
    name = person_cells[0].text
    civil_id = person_cells[1].text

    persons_location[-1]["counties"][-1]["parishes"][-1]["people"].append({
      "name": name,
      "civil_id": civil_id
    })

  if (next_page != None):
    parish_scraper(parish_name, parish_id, county_name, county_id, district_name, district_id, next_page_viewstate, next_page_event_validation, next_page)
  
persons_location = []

scraper()

print(f"\n\nDone!!! Locations stored at `\033[1mlocations.json\033[0m`.")

with open("locations.json", "w") as file:
    json.dump(persons_location, file, indent=4, ensure_ascii=False)

