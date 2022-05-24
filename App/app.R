## app.R ##
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "PrediCrédito"),
  dashboardSidebar(sidebarMenu(
      menuItem("Descripción", tabName = "descripcion", icon = icon("info")),
      menuItem("Scorecard", tabName = "scorecard", icon = icon("address-card"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "scorecard",
              fluidRow(

                box(
                  title = "Ingrese los siguientes datos:",
                  sliderInput("int_rate_input", "Tasa de interés:", 5.5, 26, 10),
                  radioButtons("grade", "Grado",
                               c("A" = "A",
                                 "B" = "B",
                                 "C" = "C",
                                 "D" = "D",
                                 "E" = "E",
                                 "F" = "F",
                                 "G" = "G"),
                               inline=T),
                  numericInput("annual_income_input", "Ingresos anuales:", 10000, min = 0, max = 10000000),
                  selectInput("purpose_input", label="¿Cuál es el propósito del préstamo?",
                              choices = list("Boda"="wedding",
                                             "Vacaciones"="vacation",
                                             "Pequeño negocio"="small_business",
                                             "Energías renovables"="renewable_energy",
                                             "Mudanza"="moving",
                                             "Salud"="medical",
                                             "Compra"="purchase",
                                             "Hogar"="house",
                                             "Mejoramiento"="improvement",
                                             "Educación"="educational",
                                             "Pago de deuda"="debt_consolidation",
                                             "Tarjeta de crédito"="credit_card",
                                             "Vehículo"="car"),
                              ),
                  sliderInput("dti_input", "Relación deudas e ingresos:", 0, 10, 5),
                  dateInput("earliest_cr_input", "Mes en el que abrió su primer crédito:", value = Sys.Date(), format = "mm/yy"),
                  numericInput("inq_6m_input", "Solicitudes en los últimos 6 meses:", 0, min = 0, max = 30),
                ),
                
                box(plotOutput("plot1", height = 250))
              )
      ),
      
      tabItem(tabName = "descripcion",
              h2("Colocar descripción acá")
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$int_rate_input)]
    hist(data)
  })
}

shinyApp(ui, server)