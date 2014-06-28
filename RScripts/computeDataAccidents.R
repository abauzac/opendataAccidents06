
library(maptools)


am <- read.csv("accident_departement_tempgeocode_final.csv")

# map of every accidents in the list
png(file="map_accidents_all.png",width=2048,height=1024)
plot(gor)
points(am$long, am$lat, pch=19, col="red", cex=0.5)
dev.off()

#info http://statacumen.com/teach/SC1/SC1_16_Maps.pdf

#nice lat min-max : 43.66 - 43.74
#nice lon min-max : 7.175 - 7.30
# mapimage <- get_map(location= c(lon = 7.2368525, lat = 43.7030664)
#                     , color="color"
#                     , source="google"
#                     , maptype="roadmap"
#                     , zoom=13)
# acc_nice <- subset(am, libellevoie != ""&  !is.na(numero) & (com == "NICE"))
# p <- ggmap(mapimage)
# p <- p + geom_point(data= acc_nice, aes(x=long, y=lat, size=grav, colour=grav))
# p