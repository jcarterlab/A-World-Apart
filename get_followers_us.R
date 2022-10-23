library(dplyr)
library(tidyverse)
library(jsonlite)
library(writexl)
library(rtweet)

# target accounts. 
dems <- "@TheDemocrats"
rep <- "@GOP"

# creates an object for the parties.
parties <- c(dems, rep)

# retrieves the target account's followers.
get_followers <- function(target_account) {
  followers <- rtweet::get_followers(user = target_account,
                                     n = 300000,
                                     retryonratelimit = TRUE) %>%
    mutate(account = target_account)
  
  return(followers)
}

# retrieves a data frame of multiple account's followers. 
get_multiple_followers <- function(target_accounts) {
  list <- list()
  for(i in 1:length(target_accounts)) {
    list[[i]] <- get_followers(target_accounts[i])
  }
  return(rbind_pages(list))
}

# calculates roughly how long it will take to download all of the data.
total_followers <- 300000*2
rate_limit <- 75*10^3
wait_time <- 15
print(paste0("It will take roughly ", 
             round(((total_followers/rate_limit)*wait_time)/60, 1), 
             " hours to download all the data."))

# binds the results to a single data frame. 
df <- get_multiple_followers(parties)

# saves as a csv file.
write_xlsx(df, "C:/Users/HUAWEI/Desktop/Projects/A-World-Apart/Data/party_followers_us.xlsx")
