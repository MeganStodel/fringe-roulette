fluidPage(

  title = "Fringe Roulette",
  
  headerPanel(h1("Fringe Roulette", align = "center")),
  br(),
  
  fluidRow(column(12, align = "center",
                  materialSwitch(
                    inputId = "show_options"
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
                       start = "2019-08-02", 
                       end = "2019-08-26", 
                       min = "2019-08-02", 
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
    column(12, align = "center",
    htmlOutput("roulette_result")
  )
  )
  
)
