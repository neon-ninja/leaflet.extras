library(leaflet.extras)
library(shiny)
library(RColorBrewer)

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(
    top = 10,
    right = 10,
    selectInput("colors", "Color Scheme",
                rownames(subset(
                  brewer.pal.info, category %in% c("seq", "div")
                )))
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(-75.14, 40, zoom = 11) %>%
      addGeoJSONChoropleth(
        "https://rawgit.com/TrantorM/leaflet-choropleth/gh-pages/examples/basic_topo/crimes_by_district.topojson",
        valueProperty = "incidents",
        scale = input$colors,
        mode = "q",
        steps = seq(0,5e4,1e4),
        color = "#ffffff",
        weight = 1,
        fillOpacity = 0.5,
        highlightOptions =
          highlightOptions(
            fillOpacity = 1,
            weight = 2,
            opacity = 1,
            color = "#000000",
            bringToFront = TRUE,
            sendToBack = TRUE
          ),
        legendOptions =
          legendOptions(title = "Crimes", position = "bottomright"),
      )
  })
}

shinyApp(ui, server)

