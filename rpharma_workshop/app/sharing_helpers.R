storage_path <- "reporting_pool"
report_board <- pins::board_folder(path = storage_path )

final_rmd <- "app/rpharma_report_by_heddlr.Rmd"

rmd_skeleton <- heddlr::import_draft(final_rmd)

# save my rmd skeleton as a pin object
report_board%>%
  pins::pin_write(board = . , x = rmd_skeleton, force_identical_write = TRUE,metadata = list(author = "farid"),name = "my_report", type = "rds")
report_meta <- pins::pin_meta(report_board, name = "my_report")


#

rmd_skeleton2 <- report_board%>%
  pins::pin_read(name = "my_report")

#

rmd_table <- lightparser::split_to_tbl(final_rmd)

rmd_skeleton3 <- rmd_table%>%lightparser::combine_tbl_to_file()

rmd_skeleton3%>%
  heddlr::export_template("app/rmd_lightparser.Rmd")
