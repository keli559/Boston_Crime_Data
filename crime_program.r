## #url = 'https://data.cityofboston.gov/api/views/7cdf-6fgx/rows.csv?accessType=DOWNLOAD'
## #download.file(url, 'Crime_Incident_Reports.csv', method='curl')
## crime = read.csv('Crime_Incident_Reports.csv')
## crime$COMPNOS =NULL
## crime$NatureCode =NULL
## crime$X =NULL
## crime$Y =NULL
## crime$Location = as.character(crime$Location)
## tmp = strsplit(gsub(".*\\((.*)\\).*", "\\1", crime$Location), ',')
## tmp = matrix(unlist(tmp), ncol = 2, byrow=T)
## crime$lat = as.numeric(tmp[, 1])
## crime$lng = as.numeric(tmp[, 2])
## library(lubridate)
## crime$DateFormatted = mdy_hms(crime$FROMDATE, tz='EST')
## crime$FROMDATE= NULL
## crime$REPORTINGAREA = NULL
## crime$DOMESTIC = NULL
## crime$Location = NULL
## crime$Year = as.factor(crime$Year)
## crime$Month = as.factor(crime$Month)
## crime$hr = strftime(crime$DateFormatted, format='%H')
## crime$AtNight=(strftime(crime$DateFormatted, format='%H:%M:%S') > "19:00:00")|
## (strftime(crime$DateFormatted, format='%H:%M:%S') < "07:00:00")
## cutpoints = c(0, 6, 12, 18, 24)
## crime$timeDec = cut(as.numeric(crime$hr), cutpoints)
## # UCRPART was found to have upper/lower case confusion
## crime$UCRPART = as.factor(toupper(crime$UCRPART))

# check the safety at different district
# replace district code with names
distrName = c(
A1 = 'Downtown',
A15= 'Charlestown',
A7= 'East Boston',
B2= 'Roxbury',
B3= 'Mattapan',
C6= 'South Boston',
C11= 'Dorchester',
D4= 'South End',
D14= 'Brighton',
E5= 'West Roxbury',
E13= 'Jamaica Plain',
E18= 'Hyde Park',
HTU= 'Human Traffic Unit'
)
crime$ReptDistrName = as.factor(distrName[as.character(crime$REPTDISTRICT)])
crime$REPTDISTRICT = NULL


#quickly plot the lat and lon to see the map of Boston
with(head(crime, 2000), plot(lng, lat))
dev.copy(png, file='geoloc.png')
dev.off()
# find out Boston Bombing records
bostonBomb = crime[which((crime$DateFormatted<"2013-04-15 16:00:00 EST"
&crime$DateFormatted>"2013-04-15 10:00:00 EST")
&crime$STREETNAME=='BOYLSTON ST'),]
print(bostonBomb)
#--------------------------
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
dev.copy(png, file='wordcloud_crime.png')
dev.off()
#--------------------------

# weapontype distribution across a day24 hours.
library(lattice)
crime$hr = as.factor(crime$hr)
histogram(~hr|WEAPONTYPE, data=crime)
dev.copy(png, file='hist_hr_weapontype.png')
dev.off()
# weapontype distrubtion in geolocation
xyplot(lat~lng|WEAPONTYPE, data=crime)
dev.copy(png, file='hist_geoloc_weapontype.png')
dev.off()

histogram(~ReptDistrName, data=crime)
dev.copy(png, file='hist_districts.png')
dev.off()
#
# where did shooting take place
library(lattice)
xyplot(lat~lng, data=subset(crime, Shooting=='Yes'))
dev.copy(png, file='geo_shooting.png')
dev.off()
with(subset(crime, Shooting=='Yes'), table(ReptDistrName))
#
histogram(~ReptDistrName, data=subset(crime, Shooting=='Yes'))
dev.copy(png, file='hist_district_shooting.png')
dev.off()
#
#plot the shooting cases histograms in districts from 2012 to 2015
histogram(~ReptDistrName|Year, data=subset(crime, Shooting=='Yes'))
dev.copy(png, file='hist_years_shooting.png')
dev.off()
#

# check days of a week crime rate
histogram(~DAY_WEEK, data=crime)


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
dev.copy(png, file='top3streets.png', height=1100, width= 600)
dev.off()

# geographically, where are the different districts?
qplot(lng, lat, data=crime, color=ReptDistrName, geom='point')+
theme_bw(base_size=20)+
  geom_point(size = 5)
dev.copy(png, file='distrLoc.png', height=1100, width= 1100)
dev.off()
#xyplot(lat~lng|ReptDistrName, data=crime)
#dev.copy(png, file='distrLoc_1.png', height=1100, width= 1100)
#dev.off()

