#Data Visualization::Prototype Mock-ups
#5-12 December 2016
#Diedre Brown

####AIMS####
#Who and what are affected by coastal loss to Brooklyn's CD 6 Carroll Gardens, 
#Cobble Hill, Columbia St., Gowanus, Park Slope, Red Hook
#Looking at what is the extent of loss of coastal area to NYC based on the data from the FEMA maps,
#I’d like to express it as a series of small multiples over maps and/or charts.
#How does the area of the 2050 predictions vary from the 2020 predictions?
#In the city as a whole.
#2020 100 year to 500 year
#2050 100 year to 500 year
#2020 100 year to 2050 100 year
#2050 100 year to 2050 500 year
#For a coastal area heavily affected by Sandy, like Brooklyn's Community District 6, based on these predictions,
#how does the community compare to the rest of the city?
#2020 100 year to 500 year
#2050 100 year to 500 year
#2020 100 year to 2050 100 year
#2050 100 year to 2050 500 year


####Packages, Requires, Sources####
require('ggplot2')
require(lubridate)
library(tidyr)
require(dplyr)
require(hexbin)
library(RColorBrewer)
require('rgdal')
require('maptools')
require('ggmap')
require('rgeos')
source('DBDVFThm.R')

####Hydrologic Conditions of New York City and Brooklyn Community District 6#### 
#Sources: NYC Open Data, FEMA
#By comparing the area of land lost to water within the following criteria (existing borough
#boundaries, 2020 FEMA floodplain maps, sandy inundation zone,and 2050 FEMA floodplain maps)

###Current Conditions####
##All Borough Boundaries####
#Non-map data of NYC Borough Boundaries and Borough Boundaries with Water Areas Included.
boroboundata<-read.csv('nybb.csv')#borough boundaries
boroboundwidata<-read.csv('nybbwi.csv')#borough boundaries wih water
#Find the area of water of each borough
#Combine the two datasets and print the difference in Shape_Area for each borough
#Join with a column identifying dataset
#boroboundata$Coder <- "A"
#boroboundwidata$Coder <-"B"
borojoin <- left_join(boroboundata,boroboundwidata,by=c('BoroCode'='BoroCode')) #join
borojoinord<-borojoin %>%
  mutate(ShapeDiff=Shape_Area.y-Shape_Area.x)#calculate coastline = shape difference
coast<-ggplot(data = borojoinord, aes(x= reorder(BoroName.x, ShapeDiff), y=ShapeDiff))+
    geom_bar(stat = "identity", 
             fill="#ffffff",
              size = 0.25)+
    labs(
      title="Square Miles of Water Area Boundaries Per Borough in New York City",
      caption = "Source: Department of City Planning DCP. 
      https://data.cityofnewyork.us/City-Government/Borough-Boundaries/tqmj-j8zm")+
  DBDVFThm
print(coast)
ggsave("nyccoastline.pdf",coast)
  
#Map data of NYC Borough Boundaries and Borough Boundaries with Water Areas Included.
#borobound<-readOGR(dsn='borobound',layer='geo_export_69abd484-70b1-4925-bf57-94144a6cb72c')#borough boundaries
#bbconvert<-fortify(borobound,region='AFFGEOID')
#Join with borobound data
#bbmap<-left_join(bbconvert,borojoinord,by=c())
#boroboundwi<-readOGR(dsn='boroboundwi',layer='geo_export_ecffb771-4bde-4881-b57b-212ee8124773')#borough boundaries with water
#bbwiconvert<-fortify(boroboundwi,region='AFFGEOID')
##bbmap<-left_join(bbconvert,borojoinord,by=c())
#Mapping
#boroboundmap<-ggplot(bbmap,aes(x=long,y=lat,group=,fill=))+
#geom_polygon(color='#B2B2B2', size=0.2)+ #map with county lines
#coord_map('albers', lat0=39, lat1=45)+
#scale_fill_gradient(low='#ffffff', high = '#CC1E2B')+ #color gradient fix
#theme_nothing(legend = TRUE)+
#labs(
#title="Square Miles of Water Area Boundaries Per Borough in New York City",
#caption = "Source: Department of City Planning DCP. 
#https://data.cityofnewyork.us/City-Government/Borough-Boundaries/tqmj-j8zm")+
#  DBDVFThm
#print(boroboundmap)
#ggsave("boroboundmap.pdf",boroboundmap)


####Brooklyn Community District 6 - Carroll Gardens, Cobble Hill, Columbia St., Gowanus, Park Slope, Red Hook####
#A map and graph to show where Community District fits into all of this. 
#i.e.)If Brooklyn has 746939482 sq miles of water boundary, what portion of that belongs to CD6
#brooklynbound<-borojoinord%>%
#  filter(BoroCode==3)%>% #looking at Brooklyn only
#  select(the_geom.x,BoroCode,BoroName.x,Shape_Area.x,ShapeDiff)%>%#selecting only columns needed
#  rename(ShapeDiff=BkShapeWaterArea)
nyccddbound<-read.csv('nycd.csv') #cd data
nyccdboundfilt<-nycdbound%>%
  filter(BoroCD==306)#filtering for BKLYN CD6
nyccdboundwi<-read.csv('nycdwi.csv')  #cd data with water
nyccdboundwifilt<-nyccboundwi%>%
  filter(BoroCD==306)#filtering for BKLYN CD6
nyccdjoin<-left_join(nyccdboundfilt,nyccdboundwifilt, by=c('BoroCode'='BoroCode'))
cd306bound<-nyccdjoin %>%
  mutate(ShapeDiff=Shape_Area.y-Shape_Area.x)#calculate coastline = shape difference




#Map data of BK CD6
#Community District Land Mass
#nyccdmap<-readOGR(dsn='cddata', layer='geo_export_d0a1d9b7-a8a6-4986-9757-87c06fbc09c8')#adding geo data
#nyccdmapconvert<-fortify(nycdmap, region='AFFGEOID')#converting geodata into a data frame




