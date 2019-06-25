fluidPage(
  theme = "fringe_style.css", 
  
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Alegreya');
                    @import url('//fonts.googleapis.com/css?family=Montserrat');
                    @import url('//fonts.googleapis.com/css?family=Righteous');
                    
                    "))
    ),

  title = "Fringe Roulette",
  
  headerPanel(h1("Fringe Roulette", align = "center")),
  br(),
  
  fluidRow(column(12, align = "center", 
                  prettySwitch(
                    inputId = "show_options",
                    label = "", 
                    width = "80%"
                  )
  )
  ),
  
  conditionalPanel(condition = "input.show_options == true",
                   fluidRow(
                     column(12, align = "center",
                     pickerInput(
                       inputId = "category_select",
                       choices = categories,
                       options = list(
                         title = "Category selection", 
                         `actions-box` = TRUE), 
                       multiple = TRUE
                     ),
                     dateRangeInput(
                       inputId = "date_select", 
                       label = "Date range", 
                       start = "2019-07-31", 
                       end = "2019-08-26", 
                       min = "2019-07-31", 
                       max = "2019-08-26"
                     )
                   )
                   )
                   
    
  ),

  fluidRow(column(12, align = "center",
                  actionBttn(
                    inputId = "random_show",
                    label = "Show Me",
                    style = "jelly", 
                    color = "danger"
                  )
  )
  ), 
  br(),
  br(),
  
  fluidRow(
    column(1), 
    column(10, align = "center",
    withSpinner(htmlOutput("roulette_result"), type = 5, 
                proxy.height = "200px")
  ), 
  column(1)
  )
  
)
