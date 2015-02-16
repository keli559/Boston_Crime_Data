---
title: "Boston Crime Incident Reports (2012-2015)"
author: "Ke Li"
date: "02/15/2015"
output: html_document
---
## Data Pre-processing

The crime indicent reports data is downloaded from [City of Boston](https://data.cityofboston.gov/api/views/7cdf-6fgx/rows.csv?accessType=DOWNLOAD). It contains crime recorded from 2012 to now in the City of Boston. The size of the data is about 47 MB. The detailed description of the data variables can be seen at file [Crime_Indicent_Field_Explanation.xlsx](https://data.cityofboston.gov/api/assets/F443C87A-9722-4032-B0A3-E823BA469DF6?download=true). To make the data for suitable for this analysis, preprocessing is performed, including:
- Taking of unuseful variables;
- Expanding the geolocation into lat and lng variables


```r
#url = 'https://data.cityofboston.gov/api/views/7cdf-6fgx/rows.csv?accessType=DOWNLOAD'
#download.file(url, './Crime_Incident_Reports.csv', method='curl')
#crime = read.csv('Crime_Incident_Reports.csv')
###Taking of unuseful variables;
#crime$COMPNOS =NULL
#crime$NatureCode =NULL
#crime$X =NULL
#crime$Y =NULL
#crime$REPORTINGAREA = NULL
####Expand the geolocation into lat and lng variables
#crime$Location = as.character(crime$Location)
#tmp = strsplit(gsub(".*\\((.*)\\).*", "\\1", crime$Location), ',')
#tmp = matrix(unlist(tmp), ncol = 2, byrow=T)
#crime$lat = as.numeric(tmp[, 1])
#crime$lng = as.numeric(tmp[, 2])
#crime$DOMESTIC = NULL
#crime$Location = NULL
```
- Replacing the date time with R-formatted date string;
- Converting the Year and Month variables from numeric to factor;
- Deriving the time of the day the crime took place from variable 'FROMDATE';
- Deriving whether the crime took place during the day or at night (7:00pm-7:00am);
- Cutting a day into four chuncks of interval with 6 hours each;
- Relevel the order of DAY_WEEK, following 'Sunday', 'Monday',... 'Saturday' sequence.  


```r
##library(lubridate)
#crime$DateFormatted = mdy_hms(crime$FROMDATE, tz='EST')
#crime$FROMDATE= NULL
#### convert to factor
#crime$Year = as.factor(crime$Year)
#crime$Month = as.factor(crime$Month)
#### Derive the hour of the day the crime takes place
#crime$hr = strftime(crime$DateFormatted, format='%H')
#### Derive whether the crime took place during the day or at night
#crime$AtNight=(strftime(crime$DateFormatted, format='%H:%M:%S') > "19:00:00")|
#(strftime(crime$DateFormatted, format='%H:%M:%S') < "07:00:00")
#### Cut a day into Four chuncks with 6 hour each.
#cutpoints = c(0, 6, 12, 18, 24)
#crime$timeDec = cut(as.numeric(crime$hr), cutpoints)
#### relevel days of a week
#print levels(crime$DAY_WEEK)
#crime$DAY_WEEK = factor(crime$DAY_WEEK, levels(crime$DAY_WEEK)[c(4, 2, 6, 7, 5, 1, 3)])
```

- Adjusting the letter case confusion (ex, 'Three' and 'THREE' are same thing.);


```r
## UCRPART was found to have upper/lower case confusion
#crime$UCRPART = as.factor(toupper(crime$UCRPART))
```
- Converting the reported districted code for Boston Police Department into readable Boston district names;

```r
## check the safety at different district
## replace district code with names
#distrName = c(
#A1 = 'Downtown',
#A15= 'Charlestown',
#A7= 'East Boston',
#B2= 'Roxbury',
#B3= 'Mattapan',
#C6= 'South Boston',
#C11= 'Dorchester',
#D4= 'South End',
#D14= 'Brighton',
#E5= 'West Roxbury',
#E13= 'Jamaica Plain',
#E18= 'Hyde Park',
#HTU= 'Human Traffic Unit'
#)
#crime$ReptDistrName = as.factor(distrName[as.character(crime$REPTDISTRICT)])
#crime$REPTDISTRICT = NULL
```
## Variables and Data Structure
First of all, the data has 269849 observations and 18 variables.  

```r
str(crime)
```

```
## 'data.frame':	269849 obs. of  18 variables:
##  $ INCIDENT_TYPE_DESCRIPTION: Factor w/ 69 levels "07RV","32GUN",..: 66 69 54 40 66 44 31 18 18 18 ...
##  $ MAIN_CRIMECODE           : Factor w/ 69 levels "01INV","01xx",..: 69 18 6 50 69 52 42 20 20 20 ...
##  $ WEAPONTYPE               : Factor w/ 4 levels "Firearm","Knife",..: 3 1 3 4 3 4 4 3 3 3 ...
##  $ Shooting                 : Factor w/ 2 levels "No","Yes": 1 1 1 1 1 1 1 1 1 1 ...
##  $ SHIFT                    : Factor w/ 3 levels "Day","First",..: 3 3 3 3 3 3 3 1 1 1 ...
##  $ Year                     : Factor w/ 4 levels "2012","2013",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ Month                    : Factor w/ 12 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ DAY_WEEK                 : Factor w/ 7 levels "Sunday","Monday",..: 5 5 5 5 5 5 5 5 5 5 ...
##  $ UCRPART                  : Factor w/ 4 levels "OTHER","PART ONE",..: 4 4 2 3 4 3 3 4 4 4 ...
##  $ STREETNAME               : Factor w/ 4072 levels "","13TH ST","16TH ST",..: 2433 507 3090 982 3518 2244 3952 1741 3809 3511 ...
##  $ XSTREETNAME              : Factor w/ 3115 levels ""," ","  ","13TH ST",..: 1 1 1 1230 1 1 1 1 1 1 ...
##  $ ReptDistrName            : Factor w/ 13 levels "Brighton","Charlestown",..: 3 3 3 7 11 5 8 12 10 4 ...
##  $ lat                      : num  42.3 42.3 42.3 42.3 42.3 ...
##  $ lng                      : num  -71.1 -71.1 -71.1 -71.1 -71 ...
##  $ DateFormatted            : POSIXct, format: "2012-01-12 06:00:00" "2012-01-12 06:35:00" ...
##  $ hr                       : Factor w/ 24 levels "00","01","02",..: 7 7 7 7 7 8 8 8 8 8 ...
##  $ AtNight                  : logi  TRUE TRUE TRUE TRUE TRUE FALSE ...
##  $ timeDec                  : Factor w/ 4 levels "(0,6]","(6,12]",..: 1 1 1 1 1 2 2 2 2 2 ...
```
The variables given in the data are shown in the following:

```r
names(crime)
```

```
##  [1] "INCIDENT_TYPE_DESCRIPTION" "MAIN_CRIMECODE"           
##  [3] "WEAPONTYPE"                "Shooting"                 
##  [5] "SHIFT"                     "Year"                     
##  [7] "Month"                     "DAY_WEEK"                 
##  [9] "UCRPART"                   "STREETNAME"               
## [11] "XSTREETNAME"               "ReptDistrName"            
## [13] "lat"                       "lng"                      
## [15] "DateFormatted"             "hr"                       
## [17] "AtNight"                   "timeDec"
```
where,
- "INCIDENT_TYPE_DESCRIPTION": Boston Police Department classification;
- "MAIN_CRIMECODE": BRIC classification of the crime code for analysis purposes;
- "UCRPART": Universal Crime Reporting Part number (1,2, 3); 
- "WEAPONTYPE":Detailed info on the weapon type (free form field);
- "Shooting": Whether police shooting is involved (??);
- "SHIFT": What shift (Day, First, Last) the incident took place on;
- "timeDec": the time interval of every 6 hours of a day, the cutting points are (0, 6, 12, 18, 24) as the hours of a day; 
- "Year", "Month", "hr", and "DateFormatted": the time variables when the crime took place; and, 
- "lat" and "lng" are latitude and longitude, where the crime record took place. 
More information is recorded in the file 'Crime_Incident_Field_Explanation.xlsx'.

## Analysis
Couple of exploratory analytical topics are explored to investigate the crime rate distribution in districts, time of day, over the years. 
### Geolocations
Latitude and Longitude are used to plot each record in the data. This roughly depicts the map of Boston, if you are familiar with Boston area. 

```r
library(ggplot2)
# geographically, where are the different districts?
qplot(lng, lat, data=crime, color=ReptDistrName, geom='point')+
theme_bw(base_size=20)+
  geom_point(size = 5)
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 

```r
#dev.copy(png, file='distrLoc.png', height=1100, width= 1100)
#dev.off()
```
To make it clearer. The crime locations depict each district as:
 

```r
library(lattice)
xyplot(lat~lng|ReptDistrName, data=crime)
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) 

```r
#dev.copy(png, file='distrLoc_1.png', height=1100, width= 1100)
#dev.off()
```
With each district, Roxbury, South End, and Dorchester have the highest crime rates over all. Charlestown, West Roxbury, and East Boston are the safest area. East Boston contains Logan airport. 

```r
histogram(~ReptDistrName, data=crime, scales=list(x=list(rot=45)))
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

```r
#dev.copy(png, file='hist_districts.png')
#dev.off()
```
### Streets of Crime
What is the street that has the highest crime rate? To answer this question, a word cloud is used to showcase the distribution of crime rate on each street. Colors in the word cloud is randomly distributed, doesn't bear any analytical meaning. Washington street has the highest crime rate. Boylston St, Blue Hill Ave, and Mass Ave etc are listed to have high crime rate too. Boylston street is the street where the Boston Marathon Bombings took place on April 15 2013. When looking at map of Boston, Washington St is the longest street in Boston, meandering from Downtown Boston, extending southwestward to Massachussetts-Rhode Island border. It may be quite unfair to address that Washington Street is the most dangerous street in Boston, considering its length. 

```r
# collect streets names, find a display of streets with most crime
street = data.frame(table(crime$STREETNAME))
colnames(street)=c('Name', 'Freq')
street$Name = as.character(street$Name)
# remove street names that are blank
street = street[-which(nchar(street$Name)==0), ]
# make a word cloud of street with highest crime rate since 2012
library(wordcloud)
wordcloud(street$Name, street$Freq, min.freq = 200, random.order=F, 
random.color=T, colors=c('black', 'red', 'steelblue'))
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-1.png) 

```r
#dev.copy(png, file='wordcloud_crime.png')
#dev.off()
```
Therefore, two more analyses are made to followup with the word cloud observation: Boston Marathon Bombings and Street of Crime in each district.
### Boston Marathon Bombings

Location, BOYLSTON ST; Time, April 15 2013, around 14:00-15:00 EST. Most of the records during Boston Marathon Bombings appear to be "Property Lost" and "Property Found", as in any other big events. Thus, records with "Property Lost" or "Property Found" filtered are listed. The incident type descriptions are "aggravated assault", "medical assistance", and "death investigation", which reflect the bombing scene to some extent.  

```r
options(width = 2000)
# find out Boston Bombing records
bostonBomb = crime[which((crime$DateFormatted<"2013-04-15 16:00:00 EST"
&crime$DateFormatted>"2013-04-15 10:00:00 EST")
&crime$INCIDENT_TYPE_DESCRIPTION != 'PropLost'
&crime$INCIDENT_TYPE_DESCRIPTION != 'PropFound'
&crime$STREETNAME=='BOYLSTON ST'),]
print(bostonBomb[ , c('INCIDENT_TYPE_DESCRIPTION', 'STREETNAME', 'ReptDistrName', 'DateFormatted')])
```

```
##        INCIDENT_TYPE_DESCRIPTION  STREETNAME ReptDistrName       DateFormatted
## 109392                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109422                   InvProp BOYLSTON ST     South End 2013-04-15 14:50:00
## 109430                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109464                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109466        AGGRAVATED ASSAULT BOYLSTON ST     South End 2013-04-15 14:50:00
## 109467                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109469                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109470                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109471        AGGRAVATED ASSAULT BOYLSTON ST     South End 2013-04-15 14:50:00
## 109472       DEATH INVESTIGATION BOYLSTON ST     South End 2013-04-15 14:50:00
## 109473       DEATH INVESTIGATION BOYLSTON ST     South End 2013-04-15 14:50:00
## 109474        AGGRAVATED ASSAULT BOYLSTON ST     South End 2013-04-15 14:50:00
## 109475                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109476       DEATH INVESTIGATION BOYLSTON ST     South End 2013-04-15 14:50:00
## 109477                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109481                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109483                 MedAssist BOYLSTON ST     South End 2013-04-15 14:50:00
## 109486                   InvProp BOYLSTON ST     South End 2013-04-15 14:50:00
## 109488                 MedAssist BOYLSTON ST     South End 2013-04-15 14:51:00
```
###Street of Crime of Each District
In each district, the streets with top 3 crime rate is listed out.


```r
# each district, what is the most dangerous street, top3? How dangeous are they?
DataStreetDistr = data.frame(with(crime, table(STREETNAME, ReptDistrName)))
topstreet = data.frame()
for (distrName in unique(DataStreetDistr$ReptDistrName)) {
  subDataStreetDistr = subset(DataStreetDistr, ReptDistrName==distrName)
  tmp = subDataStreetDistr[with(subDataStreetDistr, order(Freq, decreasing=T))[1:3], ] 
  topstreet = rbind(topstreet, tmp)
}
topstreet$STREETNAME = as.factor(topstreet$STREETNAME)
topstreet$Rank = rep(1:3, 13)
library(ggplot2)
ggplot(topstreet, aes(x= Rank, y = Freq, label=STREETNAME))+
  ylim(0, 5000)+
theme_bw(base_size=20)+
geom_bar(stat='identity')+
geom_text(size=4, hjust=0, vjust=0)+
facet_wrap(~ReptDistrName, nrow=13)+
coord_flip()
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png) 

```r
#dev.copy(png, file='top3streets.png', height=1100, width= 600)
#dev.off()
```

### Crime rate over a week
The histogram shows that Sunday has the lowest crime rate since 2012, and Friday has the highest. This observation fits well with the common sense of Friay being the day of partying and Sunday being the hang-over day or church day. The meancrime rate for each day is roughly 38549.9 since 2012, with standard deviation of 2394.2. This shows that on average there are roughly 50.7 crimes happening each day in Boston with 6.3 crimes more or less between Fridays and Sundays. 

```r
# check days of a week crime rate
histogram(~DAY_WEEK, data=crime)
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13-1.png) 

```r
# Average crime rate of a day is
mean(table(crime$DAY_WEEK))
```

```
## [1] 38549.86
```

```r
sd(table(crime$DAY_WEEK))
```

```
## [1] 2394.237
```

### Weapon Distribution
Throughout a day, the weapon usage for crime is plotted. Over all four panels, the crime rate drop to minimum at 7:00am of a day and reach the highest around mid night. 

Interestingly, Firearms and knife appear to stay high in level or even increase in the late night of a day. Unarmed and Other drop in crime rate after sunset. It raises a good hypotheses behind the criminal behavior, choosing weapons to act crime. It is hypothesized that early before dawn, people tend to be asleep, while after sunset, people tend to attend bars and get drunk, and behave outrageously. 

```r
# weapontype distribution across a day24 hours.
library(lattice)
crime$hr = as.factor(crime$hr)
histogram(~hr|WEAPONTYPE, data=crime)
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14-1.png) 

```r
#dev.copy(png, file='hist_hr_weapontype.png')
#dev.off()
```

### Police Shooting
A histogram of Police Shooting is plotted in each town in Boston. Roxbury, Dorchester, and Mattapan rank the highest. Over the years since 2012, Roxbury and Dorchester, Mattapan stay high in police shooting, while in 2015, Jamaica Pain catches up. 


```r
with(subset(crime, Shooting=='Yes'), table(ReptDistrName))
```

```
## ReptDistrName
##           Brighton        Charlestown         Dorchester           Downtown        East Boston Human Traffic Unit          Hyde Park      Jamaica Plain           Mattapan            Roxbury       South Boston          South End       West Roxbury 
##                  5                  6                158                 18                 17                  0                 24                 44                132                224                 16                 49                  6
```

```r
#
histogram(~ReptDistrName, data=subset(crime, Shooting=='Yes'),scales=list(x=list(rot=45)))
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15-1.png) 

```r
#dev.copy(png, file='hist_district_shooting.png')
#dev.off()
#
#plot the shooting cases histograms in districts from 2012 to 2015
histogram(~ReptDistrName|Year, data=subset(crime, Shooting=='Yes'),scales=list(x=list(rot=45)))
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15-2.png) 

```r
#dev.copy(png, file='hist_years_shooting.png')
#dev.off()
```

### Crime Types


```r
sort(with(crime, table(INCIDENT_TYPE_DESCRIPTION)), decreasing=T)
```

```
## INCIDENT_TYPE_DESCRIPTION
##                        VAL              OTHER LARCENY             SIMPLE ASSAULT                  MedAssist                      MVAcc                  VANDALISM                     InvPer LARCENY FROM MOTOR VEHICLE               DRUG CHARGES                      FRAUD                   PropLost                      TOWED       RESIDENTIAL BURGLARY                    InvProp         AGGRAVATED ASSAULT                    Service                    ROBBERY                    PersLoc                 AUTO THEFT                  PropFound                      Argue                      OTHER                     Arrest                 DISORDERLY                       FIRE        COMMERCIAL BURGLARY                 PhoneCalls                    LICViol                   BENoProp                   PersMiss                    FORGERY                   PubDrink             WEAPONS CHARGE                   TRESPASS                   Landlord                     Gather        DEATH INVESTIGATION                      32GUN                    Ballist                     SexReg    STOLEN PROPERTY CHARGES                 SearchWarr  OPERATING UNDER INFLUENCE                   Restrain                    PropDam                  Hazardous                       07RV    CRIMES AGAINST CHILDREN   VIOLATION OF LIQUOR LAWS                   SkipFare                     Harass                     Plates       PROSTITUTION CHARGES                     Harbor               EMBEZELLMENT                     PRISON                       Bomb                   HOMICIDE                  BurgTools                     InvVeh                     Explos                      ARSON                   HateCrim                    Runaway                   Aircraft           GAMBLING OFFENSE                      Labor                   Manslaug                  BioThreat 
##                      27940                      25457                      18473                      17511                      14727                      14075                      13868                      13721                      13070                       9188                       8931                       8124                       7308                       7064                       5977                       5673                       5306                       4980                       4905                       4583                       2821                       2373                       2143                       1980                       1976                       1632                       1615                       1544                       1473                       1324                       1282                       1278                       1204                       1125                       1044                       1017                        967                        894                        883                        860                        854                        802                        789                        761                        715                        670                        643                        613                        574                        468                        444                        444                        402                        288                        220                        192                        174                        150                         56                         54                         46                         39                         38                         34                         25                         16                         10                          8                          4
```

```r
# each district, what is the top 3 crime types
DataCrimeDistr = data.frame(with(crime, table(INCIDENT_TYPE_DESCRIPTION, ReptDistrName)))
topcrime = data.frame()
for (distrName in unique(DataCrimeDistr$ReptDistrName)) {
  subDataCrimeDistr = subset(DataCrimeDistr, ReptDistrName==distrName)
  tmp = subDataCrimeDistr[with(subDataCrimeDistr, order(Freq, decreasing=T))[1:3], ] 
  topcrime = rbind(topcrime, tmp)
}
topcrime$INCIDENT_TYPE_DESCRIPTION = as.factor(topcrime$INCIDENT_TYPE_DESCRIPTION)
topcrime$Rank = rep(1:3, 13)
library(ggplot2)
ggplot(topcrime, aes(x= Rank, y = Freq, label=INCIDENT_TYPE_DESCRIPTION))+
  ylim(0, 5000)+
theme_bw(base_size=20)+
geom_bar(stat='identity')+
geom_text(size=4, hjust=0, vjust=0)+
facet_wrap(~ReptDistrName, nrow=13)+
coord_flip()
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17-1.png) 

```r
#dev.copy(png, file='top3crimes.png', height=1100, width= 600)
#dev.off()
```



