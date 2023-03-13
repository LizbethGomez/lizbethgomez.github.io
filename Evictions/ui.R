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
      plotOutput(outputId = "plot"), 
      
     p("This shiny app is a data plotter that allows the user to upload a CSV 
       file and select the X and Y variables for plotting. It includes options 
       for customizing the plot, such as adjusting transparency, adding jitter,
       and adding smoothing. The app is built using the Shiny package in R and 
       the ggplot2 package for creating the plots. The app has a sidebar layout 
       with several input widgets, including a file input for uploading the CSV
       file, dropdown menus for selecting columns, a slider input for transparency, 
       and checkboxes for adding jitter and smoothing. The app also has a main panel 
       that displays the plot based on the user's selections. The app loads the
       data from the uploaded CSV file and updates the column choices in the 
       dropdown menus based on the data. Overall, this app is useful for 
       quickly exploring and visualizing data.")
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
