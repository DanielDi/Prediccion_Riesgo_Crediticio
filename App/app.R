## app.R ##
library(shinydashboard)
library(shiny)
library(scorecard)

load('data/scorecardModelo.RData')
load('data/allScores.RData')

ui <- dashboardPage(
  dashboardHeader(title = "PrediCrédito"),
  dashboardSidebar(sidebarMenu(
      menuItem("Descripción", tabName = "descripcion", icon = icon("info")),
      menuItem("Scorecard", tabName = "scorecard", icon = icon("address-card")),
      menuItem("Recursos", tabName = "recursos", icon = icon("glyphicon glyphicon-link", lib="glyphicon"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "descripcion",
              titlePanel(h1("PrediCrédito")),
        h4("Las empresas dedicadas a las finanzas y, en particular, las prestamistas buscan métricas que les ayuden a evaluar si un cliente es un riesgo potencial para su negocio.
        Estas métricas se pueden resumir en el ScoreCard, la cual presenta rangos de riesgo con base a los criterios críticos de cada empresa.
        Un buen puntaje crediticio es fundamental a la hora de tomar decisiones sobre quiénes son los clientes más aptos para la aprobación de prestamos
        financiamiento u otros recursos por parte de las empresas. Debido a esto, conocerlo y utilizarlo es la mejor decisión para el futuro de la empresa.
           "),
        h4("
           PrediCrédito es la aplicación con la que la que podrás obtener la ScoreCard de tus potenciales clientes de forma rápida, eficiente y efectiva, además de la posibilidad de comparar que tan bueno o malo es el puntaje de cada cliente contra el comportamiento global de los ScoreCards de los prestatarios en nuestra base de datos de más de 450.000 registros, y así poder tomar la mejor decisión ante cada caso. 
      "),
      ),
      tabItem(tabName = "scorecard",
              fluidRow(
                valueBoxOutput('score_box'),
                valueBoxOutput('percentile_score_box'),
                infoBoxOutput('int_rate_box'),
                infoBoxOutput('grade_box'),
                infoBoxOutput('home_ownership_box'),
                infoBoxOutput('annual_inc_box'),
                infoBoxOutput('verification_status_box'),
                infoBoxOutput('purpose_box'),
                infoBoxOutput('dti_box'),
                infoBoxOutput('inq_6m_box'),
#                infoBoxOutput('earliest_crc_box')
                ),
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
                    selectInput("home_ownership_input", label="Tipo de vivienda actual",
                                choices = list("Propia"="OWN",
                                               "Arriendo"="RENT",
                                               "Hipoteca"="MORTGAGE"),
                    ),
                    numericInput("annual_income_input", "Ingresos anuales:", 10000, min = 0, max = 10000000),
                    radioButtons("verification_input", "Verificación de los ingresos",
                                 c("No verificados" = 0,
                                   "Verificados por LC" = 1,
                                   "Fuente verificada" = 2),
                                 inline=T),
                    selectInput("purpose_input", label="¿Cuál es el propósito del préstamo?",
                                choices = list("Boda"="wedding",
                                               "Vacaciones"="vacation",
                                               "Pequeño negocio"="small_business",
                                               "Energías renovables"="renewable_energy",
                                               "Mudanza"="moving",
                                               "Salud"="medical",
                                               "Compra"="major_purchase",
                                               "Pago de la casa"="house",
                                               "Mejorar el hogar"="home_improvement",
                                               "Educación"="educational",
                                               "Pago de deuda"="debt_consolidation",
                                               "Tarjeta de crédito"="credit_card",
                                               "Vehículo"="car"),
                                ),
                    sliderInput("dti_input", "Relación deudas e ingresos:", 10, min = 0, max = 40),
                    sliderInput("inq_6m_input", "Solicitudes en los últimos 6 meses:", 0, min = 0, max = 40),
                    #dateInput("earliest_cr_input", "Mes en el que abrió su primer crédito:", value = Sys.Date(), format = "mm/yy"),
                  )
                
                )
      ),
      tabItem(tabName = "recursos",
              tabPanel("Acerca de Nosotros",
                       fluidPage(
                         titlePanel("Integrantes"),
                         fluidRow(
                           column(4,
                                  wellPanel(
                                    h3("Brayan M. Ortiz Fajardo"),
                                    h4("bortizf@unal.edu.co"),
                                    h5("Ingeniería de Sistemas e Informática")
                                  )
                           ),
                           column(4,
                                  wellPanel(
                                    h3("Daniel Espinal Mosquera"),
                                    h4("despinalm@unal.edu.co"),
                                    h5("Ingeniería de Sistemas e Informática")
                                  )
                           ),
                           
                           column(4,
                                  wellPanel(
                                    h3("Juan Sebastián Falcón"),
                                    h4("jfalcong@unal.edu.co"),
                                    h5("Estadística")
                                  )
                           ),
                         ),
                         fluidRow(
                           column(4,
                                  wellPanel(
                                    h3("Juan F. Peña Tamayo"),
                                    h4("jpenat@unal.edu.co"),
                                    h5("Ingeniería de Sistemas e Informática")
                                  )
                           ),
                           column(4,
                                  wellPanel(
                                    h3("Thalea Marina Hesse"),
                                    h4("thesse@unal.edu.co"),
                                    h5("Ciencia de Datos")
                                  )
                           )
                         ),
                         
                         fluidRow(
                           column(6,
                                  wellPanel(
                                    h3("Github"),
                                    tags$a(
                                      href="https://github.com/DanielDi/Prediccion_Riesgo_Crediticio", 
                                      tags$img(src="github_image.png", 
                                               title="Link al repositorio en github")
                                    ),
                                    h3("RPubs"),
                                    tags$a(
                                      href="https://github.com/DanielDi/Prediccion_Riesgo_Crediticio", 
                                      tags$img(src="rp2.png",height = 100, width = 100, 
                                               title="Link al informe")
                                    ),
                                  )
                           ),
                           column(6,
                                  wellPanel(
                                    h3("Vídeo"),
                                    HTML('<iframe width="350" height="250" src="https://www.youtube.com/embed/B_oZs7OAYV0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                                  )
                           )
                         )
                       )
              )
              
              
              
      )
    )
  )
)

server <- function(input, output) {
  # Calcular scorecard
  resultadoScorecard <- reactive({
    #Calcular días entre fecha actual y fecha de último crédito
    #earliest_cr_days <- Sys.Date() - input$earliest_cr_input
    
    # Datos del usuario
    borrowerData <- data.frame(
      int_rate            = as.numeric(input$int_rate_input), 
      grade               = as.character(input$grade),
      home_ownership      = as.character(input$home_ownership_input),
      annual_inc          = as.numeric(input$annual_income_input),
      verification_status = as.integer(input$verification_input),
      purpose             = as.character(input$purpose_input), 
      dti                 = as.numeric(input$dti_input), 
      inq_last_6mths      = as.numeric(input$inq_6m_input)
      #earliest_cr_line   = as.integer(earliest_cr_days) 
    )
    
    # Scorecard del usuario (dataframe)
    scorecardBorrower <- scorecard_ply(borrowerData, score_card_model, only_total_score = FALSE)
    
    return(scorecardBorrower)
  })
  
  #Box para cada variable con su puntaje
  output$intRateOut <- renderText(resultadoScorecard()$int_rate_points)
  output$int_rate_box <- renderInfoBox({
    infoBox(
      "Tasa de interés", textOutput('intRateOut'), icon = icon("percent"),
      color = "yellow", fill = FALSE
    )
  })
  
  output$gradeOut <- renderText(resultadoScorecard()$grade_points)
  output$grade_box <- renderInfoBox({
    infoBox(
      "Grado", textOutput('gradeOut'), icon = icon("tag"),
      color = "yellow", fill = FALSE
    )
  })
  
  output$homeOwnershipOut <- renderText(resultadoScorecard()$home_ownership_points)
  output$home_ownership_box <- renderInfoBox({
    infoBox(
      "Tipo de vivienda", textOutput('homeOwnershipOut'), icon = icon("home"),
      color = "yellow", fill = FALSE
    )
  })
  
  output$annualIncOut <- renderText(resultadoScorecard()$annual_inc_points)
  output$annual_inc_box <- renderInfoBox({
    infoBox(
      "Ingresos anuales", textOutput('annualIncOut'), icon = icon("glyphicon glyphicon-plus-sign", lib = "glyphicon"),
      color = "yellow", fill = FALSE
    )
  })
  
  output$verificationOut <- renderText(resultadoScorecard()$verification_status_points)
  output$verification_status_box <- renderInfoBox({
    infoBox(
      "Verificacion", textOutput('verificationOut'), icon = icon("glyphicon glyphicon-search", lib = "glyphicon"),
      color = "yellow", fill = FALSE
    )
  })
  
  output$purposeOut <- renderText(resultadoScorecard()$purpose_points)
  output$purpose_box <- renderInfoBox({
    infoBox(
      "Propósito", textOutput('purposeOut'), icon = icon("plane"),
      color = "yellow", fill = FALSE
    )
  })
  
  output$dtiOut <- renderText(resultadoScorecard()$dti_points)
  output$dti_box <- renderInfoBox({
    infoBox(
      "Relación deudas ingresos", textOutput('dtiOut'), icon = icon("divide"),
      color = "yellow", fill = FALSE
    )
  })
  
  output$inq6mOut <- renderText(resultadoScorecard()$inq_last_6mths_points)
  output$inq_6m_box <- renderInfoBox({
    infoBox(
      "Solicitudes en los últimos 6 meses", textOutput('inq6mOut'), icon = icon("question"),
      color = "yellow", fill = FALSE
    )
  })
  
  # output$earliestCrcOut <- renderText(resultadoScorecard()$earliest_cr_line_points)
  # output$earliest_crc_box <- renderInfoBox({
  #   infoBox(
  #     "Tiempo transcurrido desde el primer crédito", textOutput('earliestCrcOut'), icon = icon("calendar"),
  #     color = "yellow", fill = FALSE
  #   )
  # })
  
  # Box para puntaje total
  output$scoreOut <- renderText(resultadoScorecard()$score)
  output$score_box <- renderValueBox({
    valueBox(
      textOutput('scoreOut'), "Puntaje crediticio",icon = icon("star"),
      color = "yellow"
    )
  })
  
  # Cómo se ve contra la población
  resultadoPoblacion <- reactive({
    percentile <- ecdf(allScores$score)
    percentileUser <- percentile(resultadoScorecard()$score)*100
    percentPercentile <- paste(round(percentileUser, digits=2), "%")
    return(percentPercentile)
  })
  
  output$percentileResult <- renderText(resultadoPoblacion())
  output$percentile_score_box <- renderValueBox({
    valueBox(
      textOutput('percentileResult'), "mejor que el resto de la población", icon = icon("star"),
      color = "green"
    )
  })

}

shinyApp(ui, server)