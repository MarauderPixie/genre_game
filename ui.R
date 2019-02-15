# UI definition ----

shinyUI(
  fluidPage(
    useShinyjs(),
    theme = shinythemes::shinytheme("sandstone"),
    
    # Application title
    h1("Can you tell the genre of a song by it's name?", align = "center"),
    hr(),
    
    ### welcome page ----
    fluidRow(id = "welcome", align = "center",
             column(width = 10, offset = 1,
                    p("Most people have strong opinions about their favorite or least favorite musical genre or even
           about genres in general. One way or another, music is often a strong identification device. 
           But how different are musical genres actually in terms of language? How well are people able
           to distinguish between them? Let's find out!"), 
                    br(),
                    p("On the following pages, you will be presented a title of a song and we ask you to tell us what
           you think which genre that title comes from. There will be a total of 20 songs and afterwards
           you will get your results: on how many have you been correct, on which ones and what genre
           does it actually belong to?"), 
                    br(),
                    p("No data other than your responses and a unique number will be stored. In no way will it be
           possible to identify you at any point during or after the session. You're participation is 
           completely voluntary."), 
                    br(),
                    p("Thanks for your help and have fun!"), 
                    br(),
                    actionButton("start", "Let's do it!")
             )
    ),
    
    ## questioning page ----
    hidden(
      fluidRow(id = "questionpage", align = "center",
               column(10, offset = 1,
                      
                      # I'll leave div-id "song01" in for now, in case I come up with a
                      # shinier version to display the title
                      p("What's the genre of"),
                      h2(id = "song01", textOutput("song_number")),
                      p("?"),
                      
                      actionButton("count", "Country"),
                      actionButton("hphp", "Hip-Hop"),
                      actionButton("pop", "Pop"),
                      actionButton("metal", "Metal"),
                      actionButton("rock", "Rock")
               )
      )
    ),
    
    ## results page ----
    hidden(
      fluidRow(id = "results", align = "center",
               column(width = 10, offset = 1,
                      
                      h2("You're done. Here are your results:"),
                      
                      h3(textOutput("perc")),
                      
                      p("here's a detailed table for you."),
                      
                      tableOutput("result_table"),
                      
                      p("Feel free to close the browser window anytime now.")
               )
      )
    )
  )
)