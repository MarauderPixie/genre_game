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
  titlePanel("Can you tell the genre of a song by it's name?"),
  
  hr(),
  
  # mainPanel(
  div(
    id = "qpage",
    
    p("Most people have strong opinions about their favorite or least favorite musical genre or even
         about genres in general. One way or another, music is often a strong identification device."),
    p("But how different are musical genres actually in terms of language? How well are people able
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
      id = "song01",
      align = "center",
      
      p("What's the genre of"),
      h2(smpl$title[1]),
      p("?"),
      
      actionButton("count", "Country"),
      actionButton("hphp", "Hip-Hop"),
      actionButton("pop", "Pop"),
      actionButton("metal", "Metal"),
      actionButton("rock", "Rock")
    )
  )
  # )
)



# Define server logic
server <- function(input, output, session) {
  # observe({
  #   onclick("start", toggle("qpage", anim = TRUE))
  # })
  
  observeEvent(input$start, {hide("qpage", anim = TRUE)})
  observeEvent(input$start, {show("song01", anim = TRUE)})
}


# Run the application 
shinyApp(ui = ui, server = server)