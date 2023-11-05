# Mapea las provincias españolas que hayas visitado con esta Shiny App hecha en R
#
library(shiny)
library(leaflet)
library(sf)
library(leaflet.extras)
library(htmlwidgets)

provs <- esp_get_prov_siane(epsg = 3857)
provs2 <- st_transform(provs, crs = st_crs(4326))

ui <- fluidPage(
  selectInput("prov", "Selecciona la/s provincia/s visitada/s", choices = provs2$iso2.prov.name.es, multiple = TRUE),
  leafletOutput("map", width = "100%", height = "600px")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      setView(lng = -4.5, lat = 39.5, zoom = 6) %>%
      addTiles() %>%
      addPolygons(data = provs2, color = "black", 
                  fillColor = ~ifelse(iso2.prov.name.es %in% input$prov, "lightgreen", "lightpink"), 
                  fillOpacity = 0.4, 
                  weight = 1)
  })
  
    }

shinyApp(ui, server)
