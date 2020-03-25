#### Kepler Head Start Investigation ####

    #### load packages ####  

      packages <- c("acs", "tidyverse", "tidycensus", "tigris", "leaflet", "mapview", "tmap", "DT", "sf", "gganimate", "report", "ipumsr", "xtable")

      lapply(packages, library, character.only = TRUE)

    #### get data for the hawkins school system, kepler elementary school, mcpheters bend, fugate hill classrooms ####
      
      #### load the variable names ####
      
          dp_table_variables_18 <- load_variables(2018, "acs5/profile", cache = TRUE)
      
          new_names_18 <- c("variable", "label", "concept")
      
          names(dp_table_variables_18) <- new_names_18   
      
      #### hawkins school system ####
            
          tnss_dp02_2018 <- get_acs(geography = "school district (unified)", state = "TN", table = "DP02", year = 2018, cache = TRUE)
          
          tnss_dp03_2018 <- get_acs(geography = "school district (unified)", state = "TN", table = "DP03", year = 2018, cache = TRUE)
          
          tnss_dp04_2018 <- get_acs(geography = "school district (unified)", state = "TN", table = "DP04", year = 2018, cache = TRUE)
          
          tnss_dp05_2018 <- get_acs(geography = "school district (unified)", state = "TN", table = "DP05", year = 2018, cache = TRUE)
          
          tnss_dp02_18 <- inner_join(tnss_dp02_2018, dp_table_variables_18, by = "variable")
          
          tnss_dp03_18 <- inner_join(tnss_dp03_2018, dp_table_variables_18, by = "variable")
          
          tnss_dp04_18 <- inner_join(tnss_dp04_2018, dp_table_variables_18, by = "variable")
          
          tnss_dp05_18 <- inner_join(tnss_dp05_2018, dp_table_variables_18, by = "variable")
          
          tn_data_profile_18 <- rbind(tnss_dp02_18, tnss_dp03_18, tnss_dp04_18, tnss_dp05_18)
          
          districts <- school_districts(state = "TN", type = "unified", refresh = TRUE)
          
          districts <- st_as_sf(districts)
          
          hawkins_18 <- districts %>%
            filter(NAME == "Hawkins County School District")
          
          hss_dp_18 <- tn_data_profile_18 %>%
            filter(NAME == "Hawkins County School District, Tennessee")
          
      #### elementary schools only ####
          
          elementaryschools_dp02_2018 <- get_acs(geography = "school district (elementary)", state = "TN", table = "DP02", year = 2018, cache = TRUE)
          
          elementaryschools_dp03_2018 <- get_acs(geography = "school district (elementary)", state = "TN", table = "DP03", year = 2018, cache = TRUE)
          
          elementaryschools_dp04_2018 <- get_acs(geography = "school district (elementary)", state = "TN", table = "DP04", year = 2018, cache = TRUE)
          
          elementaryschools_dp05_2018 <- get_acs(geography = "school district (elementary)", state = "TN", table = "DP05", year = 2018, cache = TRUE)
          
          es_dp02_18 <- inner_join(elementaryschools_dp02_2018, dp_table_variables_18, by = "variable")
          
          es_dp03_18 <- inner_join(elementaryschools_dp03_2018, dp_table_variables_18, by = "variable")
          
          es_dp04_18 <- inner_join(elementaryschools_dp04_2018, dp_table_variables_18, by = "variable")
          
          es_dp05_18 <- inner_join(elementaryschools_dp05_2018, dp_table_variables_18, by = "variable")
          
          tnes_dp_18 <- rbind(es_dp02_18, es_dp03_18, es_dp04_18, es_dp05_18)
          
          ###this was worthless, only shows the school systems that are elementary school only, so we need to use the headstart locations and census tract data that way####
          
          
      #### pull hakwins census tract data ####
          
          Hawkins_dp02_2018 <- get_acs(geography = "tract", county = "Hawkins", state = "TN", table = "DP02", year = 2018, geometry = TRUE, cache = TRUE)
          
          Hawkins_dp03_2018 <- get_acs(geography = "tract", county = "Hawkins", state = "TN", table = "DP03", year = 2018, geometry = TRUE, cache = TRUE)
          
          Hawkins_dp04_2018 <- get_acs(geography = "tract", county = "Hawkins", state = "TN", table = "DP04", year = 2018, geometry = TRUE, cache = TRUE)
          
          Hawkins_dp05_2018 <- get_acs(geography = "tract", county = "Hawkins", state = "TN", table = "DP05", year = 2018, geometry = TRUE, cache = TRUE)    
          
          Hawkins_dp02_18 <- inner_join(Hawkins_dp02_2018, dp_table_variables_18, by = "variable")
          
          Hawkins_dp03_18 <- inner_join(Hawkins_dp03_2018, dp_table_variables_18, by = "variable")
          
          Hawkins_dp04_18 <- inner_join(Hawkins_dp04_2018, dp_table_variables_18, by = "variable")
          
          Hawkins_dp05_18 <- inner_join(Hawkins_dp05_2018, dp_table_variables_18, by = "variable")
          
          Hawkins_data_profile <- rbind(Hawkins_dp02_18, Hawkins_dp03_18, Hawkins_dp04_18, Hawkins_dp05_18)
          
          View(Hawkins_data_profile)
          
      ### need a data frame with headstart location names and census tract numbers ###    