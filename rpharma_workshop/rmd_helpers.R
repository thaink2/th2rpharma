create_dynamic_rmd_report <- function(different_groups = NULL, input_data_file = "../dev_data/patient_risk_profiles.csv", output_file = NULL, report_type = "html_output"){
  
  # rmd template mport
  introduction_template <- heddlr::import_draft("../content/introduction_template.Rmd")
  section_template <- heddlr::import_draft("../content/analysis_section_template.Rmd")
  single_chunk_template <- heddlr::import_draft("../content/single_group_analysis_template.Rmd")
  summary_template <- heddlr::import_draft("../content/summary_template.Rmd")
  # replace with the right pattern within the age group analysis chunk
  different_groups_chunks  <- different_groups%>%purrr::map(~ {
    single_chunk_template%>%
      heddlr::heddle(data = .x , . , "TARGET_AGE_GROUP")
  })
    
  
  # create a header (dynamically)
  my_report_header <- heddlr::create_yaml_header(
    list(title = "Rpharma workshop Demo",
         subtitle = "Reproducible and scalable reporting using rmarkdown & heddlr",
         author = "Farid",
         date = "`r Sys.Date()`",
         params = list(author = "", 
                       input_data_file = input_data_file),
         output = list("flexdashboard::flex_dashboard" = list(orientation = "rows")))
  )
  
  # render the rmd and create and html file
  
  ## create a an rmd file based on chunks/templates
  rmd_file_heddlr <- heddlr::make_template(my_report_header, 
                                           introduction_template, 
                                           section_template,
                                           different_groups_chunks,
                                           summary_template)
  
  ## export the rmd content into a file
  rmd_file_heddlr%>%
    heddlr::export_template(filename = "./rpharma_report_by_heddlr.Rmd")
  
  report_params <- list(author = "rpharma", input_data_file = input_data_file)
  ## render and create the final result
  rmarkdown::render(input = "rpharma_report_by_heddlr.Rmd",
                    output_file = output_file,
                    output_format = report_type,
                    params = report_params)
  
}

# patient_risk_profiles <- readr::read_csv("dev_data/patient_risk_profiles.csv")%>%
#   janitor::clean_names()
# 
# different_groups <- patient_risk_profiles%>%dplyr::select(dplyr::starts_with("age_group"))%>%
#   colnames()

# create_dynamic_rmd_report(different_groups = different_groups)
