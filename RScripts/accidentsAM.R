
am <- read.csv("acc_fr_0610.csv", )

am <- data.frame(lapply(am, as.character), stringsAsFactors=FALSE)

# filtrer sur le département 
am <- am[am$dep == '060',]

vf <- read.csv("villes_france.csv")
vf <- vf[vf$X01 == '06',]

# cast data frame factors type to characters
vf <- data.frame(lapply(vf, as.character), stringsAsFactors=FALSE)

# add column for full adress for google maps (after loop)
am["fulladress"] <- ''

# for every rows in accidents list
for(i in 1:nrow(am)){
  
  # changer le numéro INSEE des communes par leur véritable nom
  comnum <- paste("06", am$com[i], sep="")
  isFound <- (length(vf$OZAN[vf$X01284 == comnum]) > 0)
  if(isFound){
    nomcom <- vf$OZAN[vf$X01284 == comnum]
   # am$com <- as.character(am$com) # cast value to string
    am$com[am$com == am$com[i]] <- nomcom # change value with city name
  }
  
  fulladress <- ""
  # remove useless expressions in libellevoie
  fulladress <- am$libellevoie[i]
  if(fulladress != ''){
    
    fulladress <- sub("\\(DU.*)", replacement="", fulladress)
    fulladress <- sub("DU N.*", replacement="", fulladress)
    fulladress <- sub("\\(JUSQU.*)", replacement="", fulladress)
    fulladress <- sub("JUSQU.*", replacement="", fulladress)
    fulladress <- sub("\\(A PARTIR.*)", replacement="", fulladress)
    fulladress <- sub("A PARTIR.*", replacement="", fulladress)
    fulladress <- sub("-.*-", replacement="", perl=TRUE, fulladress)
    
    # Streets name
    fulladress <- sub("AV[.]", replacement="AVENUE ", fulladress)
    fulladress <- sub("CH[.]", replacement="CHEMIN ", fulladress)
    fulladress <- sub("PL[.]", replacement="CHEMIN ", fulladress)
    fulladress <- sub("R[.]", replacement="RUE ", fulladress)
    fulladress <- sub("BD ", replacement="BOULEVARD ", fulladress)
    
    #remove parentheses
    fulladress <- gsub("\\(", replacement="",  fulladress)
    fulladress <- gsub("\\)", replacement="",  fulladress)
    fulladress <- gsub("N°", replacement="",  fulladress)
    
    
    fulladress <- gsub("é", replacement="e",  fulladress)
    fulladress <- gsub("è", replacement="e",  fulladress)
    fulladress <- gsub("ê", replacement="e",  fulladress)
    fulladress <- gsub("â", replacement="e",  fulladress)
    fulladress <- gsub("à", replacement="e",  fulladress)
    fulladress <- gsub("°", replacement="",  fulladress)
    fulladress <- gsub("'", replacement="",  fulladress)
    
    if(as.character(am$numero[i]) != '0'){
      fulladress <- paste(am$numero[i], fulladress, sep=" ")
    }
    
    fulladress <- paste(fulladress, am$com[i], sep=", ")
    fulladress <- paste(fulladress, "Alpes-Maritimes, France", sep=", ")
    am$fulladress[i] <- fulladress
                        
  }
  else{
    fulladress <- paste(am$com[i], "Alpes-Maritimes, France", sep=", ")
    am$fulladress[i] <- fulladress
  }
}

#backup
write.csv(am, file="accident_departement.csv")

library(ggmap)

#reset lat/long values 
am$lat <- ""
am$long <- ""

############ REPEAT THIS PART IF EXCEEDING LIMITS

i <- 1
adress <- ""
# start geocoding to get lat/long of every incidents
for(i in 1:nrow(am)){
  
  
  # check if lat long not already exist
  if(!is.na(am$lat[i]) && ! is.na(am$long[i]) && am$lat[i] == '' && am$long[i] == ''){
    
    adress <- am$fulladress[i]
    gps <- geocode(location=am$fulladress[i], sensor=FALSE)
    
    gps <- data.frame(lapply(gps, as.character), stringsAsFactors=FALSE)
    
    #insert lat/long for every rows with the same full adress
    am$lat[am$fulladress == am$fulladress[i]] <- gps$lat
    am$long[am$fulladress == am$fulladress[i]] <- gps$lon
    print(i)
    Sys.sleep(2)
  }

}

######## END REPEAT


#backup
write.csv(am, file="accident_departement_tempgeocode_final.csv")



