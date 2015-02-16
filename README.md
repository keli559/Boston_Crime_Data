# Boston_Crime_Data
Boston crime data by itself is downloaded from http://data.cityofboston.gov. The data is 47M large, CSV format. The data shows the crime incidents recorded by Boston Police Department since 2012. It has 269849 records with 20 variables

Wihtin the original data:

- COMPNOS: Internal BPD report number
- NatureCode: 
- INCIDENT_TYPE_DESCRIPTION: Boston Police Department (BPD) incident classification
- MAIN_CRIMECODE: BRIC classification of the crime code for analysis purposes
- REPTDISTRICT: What district the crime was reported in
- REPORTINGAREA: RA number associated with the where the crime was reported from.
- FROMDATE: Earliest date and time the incident could have taken place
- WEAPSONTYPE: Detailed info on the weapon type (free form field)
- Shooting: 
- DOMETIC: Was the suspect a family member or intimate partner of the victim
- SHIFT: What shift (Day, First, Last) the incident took place on
- Year: 
- Month: 
- DAY_WEEK: What day of the week the incident took place
- UCRPART: Universal Crime Reporting Part number (1,2, 3)
- X: X coordinate (state plane, feet) of the geocoded address location (obscured to the street segment centroid for privacy).
- Y: Y coordinate (state plane, feet) of the geocoded address location(obscured to the street segment centroid for privacy).
- STREETNAME: Street name the incident took place
- XSTREETNAME: optional - Cross street the incident took place
- Location: geolocation (latitude, longitude) of the crime


##Files:

- crime_markdown.md: the writeup of all the code and analysis with plots
- Crime_Incident_Field_Explanation.xlsx: the explanation of variables, downloaded from data.cityofboston.gov
- crime_program.r: the source code of the analysis written in R
- "png" files: plots included in the analysis, saved as backs-up




