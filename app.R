library(dplyr)
library(shiny)
# library(shinyWidgets)
library(shinyjs)

songs <- readRDS("data/songs.rds") %>% 
  mutate(
    title = stringr::str_to_title(title)
  )

## function to... generate session data
generate_session <- function(){
  uid <- paste0(c(sample(LETTERS, 3), "_" ,sample(0:9, 9)), collapse = "")
  ptf <- paste0("data/", uid, ".rds")
  
  smpl <- songs %>% 
    group_by(genre) %>% 
    sample_n(4) %>% 
    ungroup() %>% 
    mutate(
      user  = uid,
      guess = NA
    )
  
  smpl <- smpl[sample(nrow(smpl)),]
  
  # saveRDS(smpl, ptf)
  return(smpl)
}


buttons <- c("count", "hphp", "pop", "metal", "rock")

# Define UI for application ----
ui <- fluidPage(
  useShinyjs(),
  theme = shinythemes::shinytheme("sandstone"),
  
  # Application title
  titlePanel(p("Can you tell the genre of a song by it's name?", align = "center")),
  
  hr(),
  
  ### welcome page ----
  # mainPanel(
  div(
    id = "welcome",
    
    p("Most people have strong opinions about their favorite or least favorite musical genre or even
         about genres in general. One way or another, music is often a strong identification device. 
         But how different are musical genres actually in terms of language? How well are people able
         to distinguish between them? Let's find out!"), br(),
    p("On the following pages, you will be presented a title of a song and we ask you to tell us what
         you think which genre that title comes from. There will be a total of 20 songs and afterwards
         you will get your results: on how many have you been correct, on which ones and what genre
         does it actually belong to?"), br(),
    p("No data other than your responses and a unique number will be stored. In no way will it be
         possible to identify you at any point during or after the session. You're participation is 
         completely voluntary."), br(),
    p("Thanks for your help and have fun!"), br(),
    
    actionButton("start", "Let's do it!"),
    
    align = "center"
  ),
  
  ## questioning page ----
  hidden(
    div(
      id = "questionpage",
      align = "center",
      
      # I'll leave div-id "song01" in for now, in case I come up with a
      # shinier version to display the title
      p("What's the genre of"),
      div(
        id = "song01",
        h2(textOutput("song_number"))
      ),
      p("?"),
      
      actionButton("count", "Country"),
      actionButton("hphp", "Hip-Hop"),
      actionButton("pop", "Pop"),
      actionButton("metal", "Metal"),
      actionButton("rock", "Rock"),
      
      # verbatimTextOutput("clicks"),
      verbatimTextOutput("i")
      # tableOutput("tbl"),
      # verbatimTextOutput("guess")
    )
  ),
  
  ## results page ----
  hidden(
    div(
      id = "results",
      align = "center",
      
      h2("You're done. Here are your results:"),
      
      h3("You were correct on X% of the titles."),
      
      p("here's a detailed table for you."),
      p("Feel free to close the browser window anytime now.")
    )
  )
  # )
)



# Define server logic ----
server <- function(input, output, session) {
  
  smpl <- reactive({
    input$start
    generate_session()
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
  
  
  i <- reactive({
    input$count + input$hphp + input$pop + input$metal + input$rock + 1
  })
  
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
        paste(smpl()$user[i()-1], ',"',
              smpl()$title[i()-1], '",',
              smpl()$genre[i()-1], ",",
              guess(), sep = ""),
        
        file = paste0("data/", smpl()$user[i()-1], ".log"),
        sep = "\n",
        append = TRUE
      )
    }
    
    # show results after 20 guesses
    if (i() > 20){
      observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
        hide("questionpage", anim = TRUE)
      })
      
      observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
        hide("song01", anim = TRUE)
      })
      
      observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
        show("results", anim = TRUE)
      })
    }
  })
}


# Run the application 
shinyApp(ui = ui, server = server)