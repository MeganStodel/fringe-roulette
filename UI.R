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
                     column(6, align = "right",
                     pickerInput(
                       inputId = "category_select",
                       label = "Category",
                       choices = categories,
                       options = list(
                         `actions-box` = TRUE), 
                       multiple = TRUE, 
                       selected = categories
                     )),
                     column(6, align = "left", 
                            dateRangeInput(
                       inputId = "date_select", 
                       label = "Date range", 
                       start = "2019-07-31", 
                       end = "2019-08-26", 
                       min = "2019-07-31", 
                       max = "2019-08-26"
                     ))
                     ),
                   fluidRow(
                     column(6, align = "right",
                     pickerInput(
                       inputId = "start_hour",
                       label = "Start of time range", 
                       choices = hour_seq
                   ),
                   pickerInput(
                     inputId = "start_min",
                     choices = min_seq
                   )),
                   column(6, align = "left",
                   pickerInput(
                     inputId = "end_hour",
                     label = "End of time range", 
                     choices = hour_seq, 
                     selected = "23"
                   ),
                   pickerInput(
                     inputId = "end_min",
                     choices = min_seq, 
                     selected = "55"
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
