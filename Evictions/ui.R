#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Predicting Evictions in Brooklyn, 2010-2016"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Using the following model specifications, one can see how different census tract-level factors affect predicted eviction rates. Rates can be predicted in Brooklyn on average, or in a specific neighborhood",
                        min = 13,
                        max = 50,
                        value = 35)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
)
