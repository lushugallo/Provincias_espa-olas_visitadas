library(tmap)
library(ggplot2)
library(sf)
library(mapSpain)
library(leaflet)
library(shiny)
library(leaflet.extras)


#Provincias
provs <- esp_get_prov_siane(epsg = 3857)

#Leemos los nombres de las provincias
unique(provs$iso2.prov.name.es)

#Ploteamos el mapa completo de España
ggplot(provs) +
  geom_sf(aes(fill = iso2.prov.name.es), color = "white", show.legend = FALSE) 
  
#Indicamos los nombres de las provincias visitadas
provs$highlighted <- ifelse(provs$iso2.prov.name.es %in% c("Cádiz", "Granada", "Málaga", "Barcelona", "Madrid", "Toledo", "Sevilla", "Zaragoza","Tarragona", "Gerona"), "highlighted", "normal")

ggplot(provs) +
  geom_sf(aes(fill = highlighted), color = "white", show.legend = FALSE) +
  theme_minimal() +
  coord_sf(datum = NA) +
  labs(title="Provincias españolas visitadas",
       caption = "Fuente: elaboración propia con librería mapSpain")

espana_coords <- c(40, -4)  

# Crear el mapa de Leaflet
leaflet() %>%
  setView(lng = espana_coords[2], lat = espana_coords[1], zoom = 6) %>%
  addTiles() 


provs2 <- st_transform(provs, crs = st_crs(4326))

provs_visitadas <- provs2[provs2$highlighted == "highlighted", ]
provs_no_visita <- provs2[provs2$highlighted == "normal", ]

# Crear un mapa de Leaflet
mapa_provs <- leaflet(data = provs2) %>%
  addTiles() %>%  
  addPolygons(data = provs_visitadas, color = "black", fillColor = "lightgreen", fillOpacity = 0.4, weight = 1) %>%
  addPolygons(data = provs_no_visita, color = "black", fillColor = "lightpink", fillOpacity = 0.4, weight = 1) %>%
  setView(lng = -4, lat = 40, zoom = 6)  

mapa_provs


leaflet(data = provs2) %>%
  setView(lng = espana_coords[2], lat = espana_coords[1], zoom = 6) %>%
  addTiles() %>%  
  addPolygons(color = "black", 
              fillColor = ~ifelse(highlighted == "highlighted", "lightgreen", "lightpink"), 
              fillOpacity = 0.4, 
              weight = 1) %>%
  setView(lng = -4, lat = 40, zoom = 6)


