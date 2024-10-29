import_data <- function(input_file = NULL){
  input_file%>%
    readr::read_csv()%>%
    janitor::clean_names()
}
# Module UI function
reportDownloadUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(width = 3, uiOutput(ns("import_data"))),
      column(width = 3, uiOutput(ns("target_groups"))),
      column(width = 3, uiOutput(ns("report_title"))),
      column(width = 3, uiOutput(ns("report_type"))),
      column(width = 3, uiOutput(ns("download_report_item")))
    )
  )
}

# Module server function
reportDownloadServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$import_data <- renderUI({
      actionButton(inputId = ns("import_data"),
                   label = "Import data",
                   icon = icon("upload"),
                   class = "btn-info")
    })
    input_data <- eventReactive(input$import_data,{
      import_data(input_file = "../dev_data/patient_risk_profiles.csv")
    })
    
    output$report_title <- renderUI({
      req(input_data())
      textInput(inputId = ns("report_title"),
                label = "Title",
                placeholder = "rpharma apac report")
    })
    output$report_type <- renderUI({
      req(input_data())
      report_types <- c(pretty_doc = "prettydoc::html_pretty", dashboard = "flexdashboard::flex_dashboard")
      selectInput(inputId = ns("report_type"), label = "Report type", choices = report_types, selected = "prettydoc::html_pretty")
    })
    output$download_report_item <- renderUI({
      req(input$target_groups)
      req(input$report_title)
      downloadButton(ns("download_report"), "Generate Report")
    })
    output$target_groups <- renderUI({
      req(input_data())
      groups_choices <- colnames(input_data())[grepl("age_group",colnames(input_data()))]
      selectInput(ns("target_groups"),
                  label = "Target Groups",
                  choices = groups_choices,
                  selected = NULL,
                  multiple = TRUE)
    })
    output$download_report <- downloadHandler(
      filename = function() {
        paste0("thaink2_report_", Sys.Date(), ".html")
      },
      content = function(file) {
        # Create a dynamic report content based on selected groups
        create_dynamic_rmd_report(different_groups = input$target_groups, output_file = file, report_type = input$report_type)
      }
    )
  })
}
