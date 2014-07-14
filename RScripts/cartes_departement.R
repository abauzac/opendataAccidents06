
library(maptools)
library(ggmap)

am <- read.csv("../csv/accident_departement_full.csv")

# map of every accidents in the list
gor <- readShapeSpatial("../images/06-Alpes-Maritimes.shp")
png(file="../images/map_accidents_dep.png",width=2048,height=1024)
plot(gor)
points(am$long, am$lat, pch=19, col="red", cex=0.5)
dev.off()

#info http://statacumen.com/teach/SC1/SC1_16_Maps.pdf

mapimage <- get_map(location= c(lon = 7.1368525, lat = 43.8230664)
                    , color="color"
                    , source="google"
                    , maptype="roadmap"
                    , zoom=10)
ggmapimg <- ggmap(mapimage)

# densité accidents départements aucun filtre 

pdensityplot <- ggmapimg + stat_density2d(
  aes(x = long, 
      y = lat, 
      fill= ..level..,
      alpha = ..level..)
  , size = 4
  , data = am
  , geom = 'polygon') 
scale_fill_gradient(low='#FF0000', high="#0000FF") +
  scale_alpha_continuous(range=c(.03, 1)) +
  guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10))

png(file="../images/map_accidents_am_density_nofiltre.png",width=1024,height=1024)
plot(pdensityplot)
dev.off()

# densite accidents filtre grosses villes

pdensityplot <- ggmapimg + stat_density2d(
  aes(x = long, 
      y = lat, 
      fill= ..level..,
      alpha = ..level..)
  , size = 4
  , data = subset(am, com != "NICE" 
                  & com != "ANTIBES" 
                  & com != "GRASSE"
                  & com != "CANNES"
                  & com != "CAGNES-SUR-MER"
                  & com != "SAINT-LAURENT-DU-VAR"
                  & com != "LE CANNET"
                  & com != "MENTON"
                  & com != "ROQUEBRUNE-CAP-MARTIN"
                  & com != "VILLEFRANCHE-SUR-MER"
                  & com != "VILLENEUVE-LOUBET")
  , geom = 'polygon') 
scale_fill_gradient(low='#FF0000', high="#0000FF") +
  scale_alpha_continuous(range=c(.03, 1)) +
  guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10))

png(file="../images/map_accidents_am_density_filtre_grossevilles.png",width=1024,height=1024)
plot(pdensityplot)
dev.off()

#barplot des 1ere villes

png(file="../images/barplot_accidents_top10_villes.png",width=1024,height=512)
par(mar=c(10,4,4,2))
t <- table(am$com)
t <- sort(t, decreasing=TRUE)
x <- barplot(head(t, 10), xlab=NULL, space=1, main="", ylab="", xaxt="n")
text(labels= names(head(t, 10)), srt=25, cex=0.8, x=x, y=-1000, xpd=TRUE, adj=1)
dev.off()


png(file="../images/grid_accidents_top20_villes.png")
topCity20 <- head(t, 20)
grid.table(data.frame(topCity20), cols=NULL)
dev.off()

