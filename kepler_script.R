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
          
      #### now pull the tracts that have headstarts located in them ####
          
          hawkins_hs_GEOID <- c(47073050501, 47073050301, 47073050700, 47073050400, 47073050800)
          
          hawkins_hs_tracts <- Hawkins_data_profile %>%
            filter(GEOID %in% hawkins_hs_GEOID)
          
      # add the school names to the location data frame #
          
          cv <- hawkins_hs_tracts %>%
            filter(GEOID == 47073050501)
        
          school <- rep("Carters Valley", length(cv$GEOID))  
          
          cv_2 <- cbind(school, cv)
          
          fh <- hawkins_hs_tracts %>%
            filter(GEOID == 47073050301)
          
          school <- rep("Fugate Hill", length(fh$GEOID))
          
          fh_2 <- cbind(school, fh)  
          
          mb <- hawkins_hs_tracts %>%
            filter(GEOID == 47073050700)
          
          school <- rep("McPheeters Bend", length(mb$GEOID))
          
          mb_2 <- cbind(school, mb)
          
          sg <- hawkins_hs_tracts %>%
            filter(GEOID == 47073050400)
          
          school <- rep("Surgoinsville", length(sg$GEOID))
          
          sg_2 <- cbind(school, sg)
          
          kp <- hawkins_hs_tracts %>%
            filter(GEOID == 47073050800)
          
          school <- rep("Kepler", length(kp$GEOID))
          
          kp_2 <- cbind(school, kp)
          
          pretty_tracts <- rbind(cv_2, fh_2, mb_2, sg_2, kp_2)
          
          ####pull out the variables we need ####
          
          hs_vars <- c("DP02_0045", "DP02_0046", "DP02_0047", "DP02_0053", "DP02_0071", "DP02_0112", "DP02_0151", "DP02_0152", "DP03_0009", "DP03_0062", "DP03_0073", "DP03_0074", "DP03_0119", "DP03_0121",
                       "DP05_0005", "DP05_0064")
          
          hs_per_vars <- c("DP02_0045P", "DP02_0046P", "DP02_0047P", "DP02_0053P", "DP02_0071P", "DP02_0112P", "DP02_0151P", "DP02_0152P", "DP03_0009P", "DP03_0062P", "DP03_0073P", "DP03_0074P", "DP03_0119P", "DP03_0121P",
                           "DP05_0005P", "DP05_0064P")
          
          hs_vars_names <- c("Grandparent living in household and responsible for children under 1", "Grandparent living in household and responsible for children 1-2 years old", "Grandparent living in household and responsible for children 3-4 years olds",
                             "Children enrolled in preschool or nursery school", "Citizens with a Disability", "Population ESL", "Households with a Computer", "Households with Broadband internet", "Unemployment Rate", "Median Income",
                             "Total Households with Cash Public Assistance", "Total Households with SNAP", "Percentage of all families below poverty line", "Percentage of all families below poverty line with children under 5",
                             "Population Age under 5", "Population Racially White")
         
          
          #### quickly look at percent poverty under 5 and children under 5 
          
          df_tracts <- pretty_tracts %>%
            filter(variable %in% hs_vars)
          
          df_per_tracts <- pretty_tracts %>%
            filter(variable %in% hs_per_vars)
          
          df_combined <- cbind(hs_vars_names, df_tracts, df_per_tracts)
          
          trimmed_df <- df_combined[,c(1,2,4,6,7,14,15)]
          
          ###get rid of location for tables 
          
          no_location_trimmed_df <- st_set_geometry(trimmed_df, NULL)
          
          ###make new names for table 
          
          hs_table_names <- c("Measure", "Head Start Location", "Census Tract", "Count", "Margin of Error", "Percent", "Percent Margin of Error")
          
          names(no_location_trimmed_df) <- hs_table_names
          
          hawkins_hs_datatable <- datatable(no_location_trimmed_df, caption = "Various Metrics for Hawkins County Census Tracts Containing a Head Start")
          
          hawkins_hs_datatable
          
          ### test for significance 