# 0.  PREPARE ENVIRONMENT -------------------------------------------------
    
    # 0.1 Clear global environment ----
    rm(list = ls()) # Clears global environment
    gc() # Clears memory
    cat("\014") # Clear console

    # 0.2 Load libraries ----
    library(tidyverse) # Hadley Wickham's best libraries
    library(here) # File system navigation
    library(formattable) # Nicely formatted tables

    # 0.3 Name our colour palette ----
    customGreen0 = "#DeF7E9"
    customGreen = "#71CA97"
    customRed = "#ff7f7f"
    
# 1.  GET DATA ------------------------------------------------------------

    # Note: Synthetic cancer data comes from
    # https://simulacrum.healthdatainsight.org.uk/
    
    # Download data if it's not on disk
    if (!dir.exists(here::here("data",
                               "simulacrum_release_v1.2.0.2017"
                               )
                    )
        ) {
        url <- paste0(
            "https://simulacrumhdi.s3.eu-west-2.amazonaws.com/",
            "simulacrum_release_v1.2.0.2017.zip"
        )
        temp_zipped <- tempfile()        
        temp_unzipped <- tempfile()
        download.file(url = url, 
                      destfile = temp_zipped,
                      timeout = max(120, getOption("timeout"))
        )
        # unzip(zipfile = temp_zipped, exdir = temp_unzipped)
        unzip(zipfile = temp_zipped, exdir = here::here("data"))
        unlink(c(temp_zipped, temp_unzipped))
    } 
    
    # Read from disk
    patient_df_raw <- read_csv(here::here(
        "data",
        "simulacrum_release_v1.2.0.2017",
        "data",
        "sim_av_patient.csv"
    ))
    tumour_df_raw <- read.csv(here::here(
        "data",
        "simulacrum_release_v1.2.0.2017",
        "data",
        "sim_av_tumour.csv"
    ))
    vital_status_lookup <- read.csv(here::here(
        "data",
        "simulacrum_release_v1.2.0.2017",
        "data_dictionary_files",
        "zvitalstatus_lookup.csv"
    ))
    sex_lookup <- read.csv(here::here(
        "data",
        "simulacrum_release_v1.2.0.2017",
        "data_dictionary_files",
        "zsex_lookup.csv"
    )) 
    type_lookup <- read.csv(here::here(
        "data",
        "simulacrum_release_v1.2.0.2017",
        "data_dictionary_files",
        "zicd_lookup.csv"
    ))

        
# 2) CLEAN DATA  --------------------------------------------
    # Note: Lung Cancer patients are: SITE_ICD10_O2_3CHAR= C34
    
    
    # Let's see what the tables are
    glimpse(tumour_df_raw)
    skimr::skim(tumour_df_raw)
    length(unique(tumour_df_raw$PATIENTID))
    
    # The tumour dataset contains
    #   * 2.371,281 rows
    #   * 2,200,626 unique patients
    
    glimpse(patient_df_raw)
    length(unique(patient_df_raw$PATIENTID))
    
    # The patient dataset contains
    #   * 2,200,626 rows
    #   * 2,200,626 unique patients
    


# Q1 --------------------------------------------------------------

    # Q1 a) What is the sex distribution of the patients? ----
    # There are 
    patient_df_raw %>%
        inner_join(sex_lookup %>% select(ZSEXID, SHORTDESC), by = c("SEX" = "ZSEXID")) %>%
        select(Sex = SHORTDESC) %>%
        group_by(Sex) %>%
        count() %>%
        formattable()
    
    
        
        knitr::kable(digits=2)

    #%>%
        group_by(SEX) %>%
        count()
    
    
    glimpse(patient_df_raw)
    glimpse(vital_status_lookup)
    glimpse(sex_lookup)
    glimpse(type_lookup)
    type_lookup %>% filter(EXPORTID == "C34")
    table(type_lookup$EXPORTID)
    # It seems that tumour_df_raw is a list of diagnoses, and patient_df_raw is 
    # a list of patients. 
    # The data dictionary tells us that patient_df_raw$NEWVITALSTATUS will tell
    # us the condition of the patient, but there are 
    skimr::skim(tumour_df_raw)
    skimr::skim(patient_df_raw)
    table(patient_df_raw$DEATHCAUSECODE_UNDERLYING)
    patient_df_raw %>% filter(DEATHCAUSECODE_UNDERLYING == "C34")
    patient_df_raw %>% filter(DEATHCAUSECODE_1A == "C34")
    patient_df_raw %>% filter(DEATHCAUSECODE_1B == "C34")
    patient_df_raw %>% filter(DEATHCAUSECODE_1C == "C34")
    patient_df_raw %>% filter(DEATHCAUSECODE_2 == "C34")
    patient_df_raw %>% filter(DEATHCAUSECODE_UNDERLYING == "C34")
    
    glimpse(patient_df_raw)

    skimr::skim(tumour_df_raw)
    