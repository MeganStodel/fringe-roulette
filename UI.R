fluidPage(
  useSweetAlert(),
  theme = "fringe_style.css", 
  
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Alegreya');
                    @import url('//fonts.googleapis.com/css?family=Montserrat');
                    @import url('//fonts.googleapis.com/css?family=Righteous');
                    
                    "))
    ),

  title = "Fringe Roulette",
  br(),
  headerPanel(h1("Fringe Roulette", align = "center")),
  div(style = "position:absolute;right:1em;top:1em",
      actionBttn(
        inputId = "rules",
        label = "Read the rules",
        style = "jelly",
        color = "danger",
        size = "xs"
      )
      ),
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
                     column(3),
                     column(3, align = "center",
                     pickerInput(
                       inputId = "category_select",
                       label = "Category",
                       choices = categories,
                       options = list(
                         `actions-box` = TRUE), 
                       multiple = TRUE, 
                       selected = categories
                     )),
                     column(3, align = "center", 
                            dateRangeInput(
                       inputId = "date_select", 
                       label = "Date range", 
                       start = "2019-07-29", 
                       end = "2019-08-26", 
                       min = "2019-07-29", 
                       max = "2019-08-26"
                     )),
                     column(3)
                     ),
                   fluidRow(
                     column(3),
                     column(2, align = "center",
                     pickerInput(
                       inputId = "start_hour",
                       label = "Start of time range", 
                       choices = hour_seq
                   ),
                   pickerInput(
                     inputId = "start_min",
                     choices = min_seq
                   )),
                   column(2),
                   column(2, align = "center",
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
                   ), 
                   column(3)
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
  ),
  br(),
  br()
  
)
