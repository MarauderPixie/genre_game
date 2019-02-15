# Server definition ----

shinyServer(function(input, output, session) {
  
  smpl <- reactive({
    input$start
    generate_session()
  })
  
  
  i <- reactive({
    input$count + input$hphp + input$pop + input$metal + input$rock + 1
  })
  
  
  nick <- reactive({
    input$start
    ifelse(input$nickname == "", 
           paste0("Anonymous_Art_Smarty_", 
                  length(list.files("data/"))-1), 
           input$nickname)
  })
  
  cnt <- reactive({
    input$count
    if (input$count == 0) return(data.frame())
    data.frame(genre = "Country", timestamp = Sys.time())
  })
  hip <- reactive({
    input$hphp
    if (input$hphp == 0) return(data.frame())
    data.frame(genre = "Hip-Hop", timestamp = Sys.time())
  })
  pop <- reactive({
    input$pop
    if (input$pop == 0) return(data.frame())
    data.frame(genre = "Pop", timestamp = Sys.time())
  })
  mtl <- reactive({
    input$metal
    if (input$metal == 0) return(data.frame())
    data.frame(genre = "Metal", timestamp = Sys.time())
  })
  rck <- reactive({
    input$rock
    if (input$rock == 0) return(data.frame())
    data.frame(genre = "Rock", timestamp = Sys.time())
  })
  
  
  observeEvent(input$start, {hide("welcome", anim = TRUE)})
  observeEvent(input$start, {show("questionpage", anim = TRUE)})
  observeEvent(input$start, {show("song01", anim = TRUE)})
  
  
  guess <- reactive({
    guesses <- rbind(cnt(), hip(), pop(), mtl(), rck())
    guesses[guesses$timestamp == max(guesses$timestamp), "genre"]
  })
  
  
  
  # count button clicks, switch song and eventually pages
  observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
    output$song_number <- renderText(smpl()$title[i()])
    
    # for debugging purposes
    # output$i <- renderText(paste("counter i:", i()))
    # output$clicks <- renderText(paste("Country:", input$count, "\n",
    #                                   "HipHop: ", input$hphp, "\n",
    #                                   "Pop:    ", input$pop, "\n",
    #                                   "Metal:  ", input$metal, "\n",
    #                                   "Rock:   ", input$rock))
    
    if (i() > 1 & i() <= 21) {
      cat(
        paste(smpl()$user[1], ',"',
              nick(), '","',
              smpl()$title[i() - 1], '",',
              smpl()$genre[i() - 1], ",",
              guess(), sep = ""),
        
        file = paste0("data/", smpl()$user[i() - 1], ".log"),
        sep = "\n",
        append = TRUE
      )
    }
    
    # show results after 20 guesses
    if (i() > 20) {
      results <- reactive({
        logpath <- paste0("data/", smpl()$user[1],".log")
        
        read.csv(logpath, header = FALSE, 
                 col.names = c("UID", "Title", "Genre", "Guess"),
                 stringsAsFactors = FALSE)
      })
      
      perc <- reactive({
        mean(results()$Genre == results()$Guess) * 100
      })
      
      output$perc <- renderText(
        paste0("You were correct on ", perc(), "% of the titles.")
      )
      
      output$result_table <- function() {
        results() %>% 
          select(-UID) %>% 
          mutate(
            Guess = cell_spec(Guess, color = "white", bold = TRUE,
                              background = ifelse(Genre == Guess,
                                                  "green",
                                                  "red")),
            Genre = cell_spec(Genre, color = "white", background = "#666666", bold = TRUE)
          ) %>%
          knitr::kable(escape = FALSE) %>% 
          kable_styling("striped", full_width = FALSE)
      }
      
      observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
        hide("questionpage")
      })
      
      observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
        hide("song01")
      })
      
      observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
        show("results", anim = TRUE)
      })
    }
  })
})