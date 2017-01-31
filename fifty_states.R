
library(twitteR)
library(ggplot2)
library(ROAuth)
library(httr)
library(xml2)
library(base64enc)
library(dismo)
library(rgdal)
dat= dat = read.table("~/Desktop/GPS_by_county.csv",sep = ",",header = T)
gps_coord = dat[,c(4,2,13,14)]
consumer_key = "yTx0L4rOTRcNhYVp4tNWAEQnG"
consumer_secret = "GFK0TiND9d9HnSPvm16HaOGmXN0KHDNu9pZXfsWvhuKCuNqe7p"
access_token = "99661008-tNkqwsS4cKWiK4ov2VOzuB1h9NIPPfEjB9qn0fqRa"
access_token_secret = "GHjsDvBE0qLAYA38sEC2FJU8mQfyVwOnxJn5OeKTSxdWT"

setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_token_secret)

clean_gps = function(x)
{
  x = unlist(strsplit(as.character(x),""))[-c(1,length(unlist(strsplit(as.character(x),""))))]
  return(paste(x,collapse = ""))
}

test[,3] = sapply(test[,3],clean_gps)
test[,4] = sapply(test[,4],clean_gps)

for(i in 1:dim(test)[1])
{
  gps = paste(c(test[i,c(3,4)],"20mi"),collapse = ",")
 temp = searchTwitter("USA", n = 10,geocode =gps )
}



temp = gps_coord[which(gps_coord$County == "San Diego"),]
gps = paste(c(clean_gps(temp[1,3]),clean_gps(temp[1,4]),"10mi"),collapse = ",")


x = twListToDF(searchTwitter("Hillary",n = 2000))
userinfo = lookupUsers(x$screenName)
userinfo = twListToDF(userinfo)
locatedusers = !is.na(userinfo$location)
index = which(!is.na(userinfo$location))
usertext = x$text[index]
loc = geocode(userinfo$location[locatedusers])
loc = loc[!is.na(loc),]
loc = subset(loc, (lon >= -125) & (lon <= -75) & (lat >=25) & (lat <50))
p = ggplot() +
  geom_polygon(data = map_data("state"),aes(x = long,y = lat,group = group),color = "white",fill = "blue") +
  geom_point(data = loc,aes(x = lon,y = lat),size = 1,color = "red") 
p


ggplot() + 
  geom_polygon(data = map_data("state"),aes(x = long,y = lat,group = group),color = "white",fill = "grey")




# 

s = readOGR(dsn = path.expand("~/Desktop/data\ files"),layer = "cb_2015_us_state_500k")



Sys.setenv(SPARK_HOME = "~/spark-2.0.1-bin-hadoop2.7/")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))


.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)