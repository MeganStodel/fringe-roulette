function(input, output, session) {
  
  show_result <- eventReactive(input$random_show, {
    show_result <- fringe_shows[sample(nrow(fringe_shows), 1)]
    return(show_result)
  })
  
  output$roulette_result <- renderUI({
    outcome_text <- HTML(paste0(
      show_result()[, Title]
    ))
    return(outcome_text)
  })
  
}