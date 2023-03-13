library(shiny)
library(ggplot2)


# Define UI
ui <- fluidPage(
  titlePanel("Pharmaceutical Intervention App"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("effect_size", "Effect Size", min = 0, max = 2, value = 1, step = 0.1),
      selectInput("drug_type", "Drug Type", choices = c("Drug A", "Drug B")),
      numericInput("dose", "Dose", value = 50, min = 0, max = 1000),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server
server <- function(input, output, session) {
  
  # Define reactive values for drug data
  drug_data <- reactiveValues()
  
  # Define function to simulate drug data
  simulate_drug_data <- function(effect_size, drug_type, dose) {
    x <- rnorm(1000)
    if (drug_type == "Drug A") {
      y <- effect_size*x + rnorm(1000, mean = 0, sd = 0.5)
    } else {
      y <- effect_size*x^2 + rnorm(1000, mean = 0, sd = 0.5)
    }
    y <- y + dose
    data.frame(x = x, y = y)
  }
  
  # Observe submit button and update drug data
  observeEvent(input$submit, {
    drug_data$data <- simulate_drug_data(input$effect_size, input$drug_type, input$dose)
  })
  
  # Generate plot based on drug data
  output$plot <- renderPlot({
    ggplot(drug_data$data, aes(x = x, y = y)) +
      geom_point() +
      geom_smooth(method = "lm", se = FALSE) +
      labs(x = "Baseline Value", y = "Outcome Value", title = "Effect of Pharmaceutical Intervention")
  })
}

# Run app
shinyApp(ui, server)
