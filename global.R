# Global functions and variables ----

library(dplyr)
library(shiny)
library(shinyjs)
library(kableExtra)
if (!("ulid" %in% installed.packages())) remotes::install_github("hrbrmstr/ulid")
library(ulid)

songs <- readRDS("data/songs.rds") %>% 
  mutate(
    title = stringr::str_to_title(title)
  )

## function to generate session data
generate_session <- function() {
  uid <- ulid_generate(1)
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

