library(shiny)
library(rmarkdown)
source("mod_report.R")
source("../rmd_helpers.R")
ui <- function(){
  bs4Dash::dashboardPage(
    bs4Dash::dashboardHeader(title = "Report Generator"),
    bs4Dash::dashboardSidebar(
      bs4Dash::sidebarMenu(
        bs4Dash::menuItem("Reports", tabName = "reports", icon = icon("file"))
      )
    ),
    bs4Dash::dashboardBody(
      bs4Dash::tabItems(
        bs4Dash::tabItem(
          tabName = "reports",
          fluidRow(
            bs4Dash::box(
              title = "Generate Report",
              width = 12,
              status = "primary",
              solidHeader = TRUE,
              reportDownloadUI("report1")
            )
          )
        )
      )
    )
  )
}

server <- function(input, output, session) {
  reportDownloadServer("report1")
}

shinyApp(ui, server, options = list(launch.browser = T, port = 8912, host = '0.0.0.0'))
