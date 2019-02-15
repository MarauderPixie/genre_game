# Global functions and variables ----

library(dplyr)
library(shiny)
library(shinyjs)

songs <- readRDS("data/songs.rds") %>% 
  mutate(
    title = stringr::str_to_title(title)
  )

## function to generate session data
generate_session <- function() {
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


# buttons <- c("count", "hphp", "pop", "metal", "rock")

