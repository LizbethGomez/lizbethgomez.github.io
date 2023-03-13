library(shiny)
library(ggplot2)

# Define UI
ui <- fluidPage(
  titlePanel("Pharmaceutical Intervention Simulation"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("baseline", "Baseline value", min = 0, max = 100, value = 50),
      sliderInput("intervention", "Intervention value", min = 0, max = 100, value = 80),
      sliderInput("duration", "Duration of intervention (months)", min = 1, max = 24, value = 6)
    ),
    mainPanel(
      plotOutput("plot"),
      
      p("This app allows users to simulate the effects of a pharmaceutical intervention 
        on an outcome of interest. The app includes three sliders that allow the user to 
        adjust the baseline value, intervention value, and duration of the intervention. 
        The app then generates a plot showing the simulated outcome over time for the 
        baseline and intervention periods.",
        style = "font-size:25px")
    )
  )
)

# Define server
server <- function(input, output) {
  output$plot <- renderPlot({
    # Generate data for baseline and intervention periods
    baseline_data <- data.frame(x = 1:input$duration, y = rnorm(input$duration, mean = input$baseline, sd = 5))
    intervention_data <- data.frame(x = 1:input$duration, y = rnorm(input$duration, mean = input$intervention, sd = 5))
    
    # Combine data into a single data frame
    data <- rbind(baseline_data, intervention_data)
    
    # Add a column to indicate baseline vs intervention period
    data$period <- rep(c("baseline", "intervention"), each = input$duration)
    
    # Generate plot
    ggplot(data, aes(x = x, y = y, color = period)) +
      geom_line() +
      labs(x = "Time (months)", y = "Outcome", color = "Period") +
      theme_minimal()
  })
}

# Run app
shinyApp(ui, server)
