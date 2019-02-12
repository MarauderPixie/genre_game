library(dplyr)
library(shiny)
# library(shinyWidgets)
library(shinyjs)

songs <- readRDS("data/songs.rds") %>% 
  mutate(
    title = stringr::str_to_title(title)
  )

smpl <- songs %>% 
  group_by(genre) %>% 
  sample_n(4) %>% 
  ungroup()

smpl <- smpl[sample(nrow(smpl)),]

# Define UI for application ----
ui <- fluidPage(
  useShinyjs(),
  theme = shinythemes::shinytheme("sandstone"),
  
  # Application title
  titlePanel(p("Can you tell the genre of a song by it's name?", align = "center")),
  
  hr(),
  
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
  
  hidden(
    div(
      id = "questionpage",
      align = "center",
      
      p("What's the genre of"),
      div(
        id = "song01",
        # h2(smpl$title[1])
        h2(textOutput("song_number"))
      ),
      p("?"),
      
      actionButton("count", "Country"),
      actionButton("hphp", "Hip-Hop"),
      actionButton("pop", "Pop"),
      actionButton("metal", "Metal"),
      actionButton("rock", "Rock"),
      
      verbatimTextOutput("cnt"),
      verbatimTextOutput("hip"),
      verbatimTextOutput("pop"),
      verbatimTextOutput("mtl"),
      verbatimTextOutput("rck"),
      verbatimTextOutput("i")
    )
  )
  # )
)



# Define server logic
server <- function(input, output, session) {
  # observe({
  #   onclick("start", toggle("qpage", anim = TRUE))
  # })
  
  observeEvent(input$start, {hide("welcome", anim = TRUE)})
  observeEvent(input$start, {show("questionpage", anim = TRUE)})
  observeEvent(input$start, {show("song01", anim = TRUE)})
  
  # observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
  #   if (input$count == 1 | input$hphp == 1 | input$pop == 1 | input$metal == 1 | input$rock == 1){
  #     hide("song01", anim = TRUE)
  #   }
  # })
  # observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
  #   if (input$count == 1 | input$hphp == 1 | input$pop == 1 | input$metal == 1 | input$rock == 1){
  #     show("song02", anim = TRUE)
  #   }
  # })
  
  # for (i in length(smpl$title)){
  #   song_num <- paste0("song0", i)
  #   
  #   observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
  #     if (input$count == i | input$hphp == i | input$pop == i | input$metal == i | input$rock == i){
  #       hide(song_num, anim = TRUE)
  #     }
  #   })
  #   observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
  #     if (input$count == i | input$hphp == i | input$pop == i | input$metal == i | input$rock == i){
  #       show(song_num, anim = TRUE)
  #     }
  #   })
  # }
  
  observeEvent(input$count | input$hphp | input$pop | input$metal | input$rock, {
    i <- input$count + input$hphp + input$pop + input$metal + input$rock + 1
    delay(100, output$song_number <- renderText(smpl$title[i]))
    
    output$i <- renderText(paste("counter i:", i))
    output$cnt <- renderText(paste("Country:", input$count))
    output$hip <- renderText(paste("HipHop: ", input$hphp))
    output$pop <- renderText(paste("Pop:    ", input$pop))
    output$mtl <- renderText(paste("Metal:  ", input$metal))
    output$rck <- renderText(paste("Rock:   ", input$rock))
  })
}


# Run the application 
shinyApp(ui = ui, server = server)