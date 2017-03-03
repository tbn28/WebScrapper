
# install.packages(c(
#   "shinythemes",
#   "ggplot2",
#   "shiny",
#   "leaflet",
#   "RColorBrewer",
#   "knitr",
#   "maps",
#   "rvest",
#   "stringr",
#   "stringi"
# ))

library(shiny)
library(shinythemes)
library(leaflet)
library(RColorBrewer)
library(knitr)
library(ggplot2)
library(ggmap)
library(maps)
library(rvest)
library(stringr)
library(stringi)
library(DT)

dane <- read.csv(file = "Plik_CSV1.csv", sep = ",")

ui <- fluidPage(
  
  theme = shinytheme("sandstone"),
  
  h1(
    "Zaleznosci zarobkowe i zawodowe na podstawie informacji ofert pracy znalezionych na stronie pracuj.pl",
     align = "center", style = "margin: 40px 10px"
  ),
  
  sidebarLayout(
    sidebarPanel(
      p(strong("Aktualny czas"), align = "center"),
      p(textOutput("currentTime", inline = TRUE), align = "center"),
      br()
    ),
    mainPanel(
     tabsetPanel(
       tabPanel("Dane", DT::dataTableOutput("dane")),
       
       tabPanel("Histogram", plotOutput("histogram", width = 850, height = 500)),
       
       tabPanel("BoxPlot", plotOutput("box", width = 850, height = 500)),
       
       tabPanel("Raport", uiOutput('markdown'))
       
       #tabPanel("Mapa", leafletOutput('mapa', width = 850, height = 500))
     )
    )
  )
)

server <- function(input, output, session)
{
  showModal(modalDialog(
    title = "Witaj w Shiny Web Application!",
    h3("Aplikacja sluzy przedstawieniu ciekawych danych."),
    h3("Zamknij, aby kontynuowac."),
    footer = modalButton("Jasne"),
    easyClose = TRUE
  ))
  
  datasetInput <- reactive({
    dane
    # if (input$check == TRUE) { 
    #   dane[input$slider,]
    # } else {
    #   dane
    # }
  })
  
  output$dane <- DT::renderDataTable(datasetInput(), style="bootstrap")
  
  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("", Sys.time())
  })
  
  Legenda <- dane[,3]
  
  h <- ggplot(
    data = dane, 
    aes(x = dane[,4])
  )
  
  h2 <- h + geom_histogram(
    binwidth = 300, 
    aes(fill = Legenda), 
    colour = "black"
  ) + xlab(colnames(dane)[4]) + ylab("Ilosc")
  
  output$histogram <- renderPlot(h2)
  
  m <- ggplot(
    data = dane, 
    aes(
      x = dane[,3], 
      y = dane[,4], 
      size = dane[,4], 
      colour = dane[,3]
    )
  )
  
  m2 <- m + geom_boxplot(
    aes(fill = Legenda), 
    colour = "blue"
  ) + xlab(colnames(dane)[3]) + ylab(colnames(dane)[4]) + scale_color_gradient(low = "white", high = "black")
  
  output$box <- renderPlot(m2)
  
  output$markdown <- renderUI({HTML(paste(readLines("MeScrapper.html"), collapse="\n"))})
  

}

shinyApp(ui, server)
