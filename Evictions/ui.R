library(shiny)
library(ggplot2)

# Define UI
ui <- fluidPage(
  
  # Page title
  titlePanel("Data Plotter"),
  
  # Sidebar layout
  sidebarLayout(
    
    # Sidebar panel
    sidebarPanel(
      
      # File input for uploading CSV
      fileInput(inputId = "file",
                label = "Choose CSV File",
                accept = ".csv"),
      
      # Checkbox for skipping first row
      checkboxInput(inputId = "header",
                    label = "File has header?",
                    value = TRUE),
      
      # Dropdown menus for selecting columns
      selectInput(inputId = "x_var",
                  label = "X-axis Variable:",
                  choices = NULL),
      
      selectInput(inputId = "y_var",
                  label = "Y-axis Variable:",
                  choices = NULL),
      
      # Slider input for alpha
      sliderInput(inputId = "alpha",
                  label = "Transparency:",
                  min = 0, max = 1, value = 0.5, step = 0.1),
      
      # Checkbox for jitter
      checkboxInput(inputId = "jitter",
                    label = "Add Jitter?",
                    value = FALSE),
      
      # Checkbox for loess smoothing
      checkboxInput(inputId = "smooth",
                    label = "Add Smoothing?",
                    value = FALSE),
      
      # Numeric input for loess span
      numericInput(inputId = "span",
                   label = "Smoothing Span:",
                   value = 0.75)
      
    ),
    
    # Main panel
    mainPanel(
      
      # Plot output
      plotOutput(outputId = "plot")
      
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Load data from file
  data <- reactive({
    file <- input$file
    if (is.null(file)) {
      return(NULL)
    }
    df <- read.csv(file$datapath, header = input$header)
    return(df)
  })
  
  # Update column choices based on data
  observe({
    df <- data()
    if (!is.null(df)) {
      updateSelectInput(session, "x_var", choices = colnames(df))
      updateSelectInput(session, "y_var", choices = colnames(df))
    }
  })
  
  # Create plot based on user inputs
  output$plot <- renderPlot({
    
    # Get selected variables from data
    df <- data()
    if (is.null(df)) {
      return(NULL)
    }
    x_var <- df[[input$x_var]]
    y_var <- df[[input$y_var]]
    
    # Create plot
    p <- ggplot(df, aes(x = x_var, y = y_var)) +
      geom_point(alpha = input$alpha, position = if (input$jitter) "jitter" else "identity") +
      labs(x = input$x_var, y = input$y_var)
    
    # Add smoothing if requested
    if (input$smooth) {
      p <- p + geom_smooth(method = "loess", span = input$span)
    }
    
    # Return plot
    return(p)
  })
}

# Run the app
shinyApp(ui, server)
