#Data Visualization
#19 December 2016
#Diedre Brown


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
  

####Brooklyn Community District 6 - Carroll Gardens, Cobble Hill, Columbia St., Gowanus, Park Slope, Red Hook####
#A map and graph to show where Community District fits into all of this. 
#i.e.)If Brooklyn has 746939482 sq miles of water boundary, what portion of that belongs to CD6
#brooklynbound<-borojoinord%>%
#  filter(BoroCode==3)%>% #looking at Brooklyn only
#  select(the_geom.x,BoroCode,BoroName.x,Shape_Area.x,ShapeDiff)%>%#selecting only columns needed
#  rename(ShapeDiff=BkShapeWaterArea)
nyccddbound<-read.csv('nycd.csv') #cd data
nyccdboundwi<-read.csv('nycdwi.csv')  #cd data with water
nyccdboundjoin<-left_join(nyccddbound,nyccdboundwi, by=c('BoroCD'='BoroCD'))
nyccdboundjoinordered<-nyccdboundjoin%>%
  arrange(BoroCD)%>%
  select(BoroCD,Shape_Area.x,Shape_Area.y)%>%
  mutate(cdShapeDiff=Shape_Area.y-Shape_Area.x)%>%
  mutate(cdwaterper=Shape_Area.y/cdShapeDiff * 100)
bkcdfilt<-slice(nyccdboundjoinordered, 29:46)
bkcdchart<-ggplot(data = bkcdfilt, aes(x=reorder(BoroCD,cdShapeDiff),y=cdShapeDiff))+
  geom_bar(stat = "identity", 
           fill="#ffffff",
           size = 0.25)+
  labs(
    title="Square Miles of Water Area Boundaries Per Brooklyn Community District",
    caption = "Source: Department of City Planning DCP. 
    https://data.cityofnewyork.us/City-Government/Borough-Boundaries/tqmj-j8zm")+
  DBDVFThm
print(bkcdchart)
ggsave("bkcdwaterchart.pdf",bkcdchart)

#all the community districts
nyccdchart<-ggplot(nyccdboundjoinordered, aes(x=BoroCD,y=cdShapeDiff, size=cdwaterper, color=BoroCD))+
  geom_point(
    alpha=0.3)+
  geom_text(aes(label=ifelse(BoroCD==306,as.character(BoroCD),'')), hjust=0,vjust=0)+
  labs(
    title="Percentage of Square Miles of Coast Per Community District",
    caption = "Source: Department of City Planning DCP. 
    https://data.cityofnewyork.us/City-Government/Borough-Boundaries/tqmj-j8zm")+
  DBDVFThm
print(nyccdchart)
ggsave("NYCcdwaterchart.pdf",nyccdchart)
  
