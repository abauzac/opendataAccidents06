#carte pour la ville de Nice

library(maptools)
library(ggmap)

am <- read.csv("../csv/accident_departement_full.csv")

#nice lat min-max : 43.66 - 43.74
#nice lon min-max : 7.175 - 7.30
# get google map image of Nice

mapimage <- get_map(location= c(lon = 7.2368525, lat = 43.7030664)
                    , color="color"
                    , source="google"
                    , maptype="roadmap"
                    , zoom=13)
ggmapimg <- ggmap(mapimage)


#first map with 
acc_nice <- subset(am, libellevoie != ""  &  !is.na(numero) & (com == "NICE"))

p <- ggmapimg + geom_point(data= acc_nice, aes(x=long, y=lat, size=grav, colour=grav ))

png(file="../images/map_accidents_nice.png",width=1024,height=1024)
plot(p)
dev.off()

#second map : densities
# densite filtre sur les accidents avec un lieu précis (rue + numéro)
acc_nice <- subset(am, libellevoie != ""  
                   & numero != 0 
                   & !is.na(numero) 
                   & (com == "NICE"))


pdensityplot <- ggmapimg + stat_density2d(
  aes(x = long, 
      y = lat, 
      fill= ..level..,
      alpha = ..level..)
  , size = 4
  , data = acc_nice
  , geom = 'polygon') 
scale_fill_gradient(low='#FF0000', high="#0000FF") +
  scale_alpha_continuous(range=c(0.03, 0.80)) +
  guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10))

png(file="../images/map_accidents_nice_density_filtre.png",width=1024,height=1024)
plot(pdensityplot)
dev.off()


# densite filtre sur les accidents avec moins de précision (rue)
acc_nice <- subset(am, libellevoie != ""  
                   & (com == "NICE"))


pdensityplot <- ggmapimg + stat_density2d(
  aes(x = long, 
      y = lat, 
      fill= ..level..,
      alpha = ..level..)
  , size = 4
  , data = acc_nice
  , geom = 'polygon') 
scale_fill_gradient(low='#FF0000', high="#0000FF") +
  scale_alpha_continuous(range=c(0.03, 0.80)) +
  guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10))

png(file="../images/map_accidents_nice_density_nofiltre.png",width=1024,height=1024)
plot(pdensityplot)
dev.off()
