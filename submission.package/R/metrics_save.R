
#' Save performance metrics to CSV or HTML
#'
#' @param results_df A data.frame created by format_performance_output()
#' @param format Output format: "csv" or "html"
#' @param outdir Output directory (default: "results")
#' @param filename Optional filename (auto-named if NULL)
#'
#' @importFrom htmlTable htmlTable
#' @importFrom utils write.csv
#'
#' @return The file path where the report was saved
#' @export
save_performance_report=function(results_df,
                                format="csv",
                                outdir="results",
                                filename=NULL){
  if(!dir.exists(outdir))
    dir.create(outdir,recursive=TRUE)

  timestamp=format(Sys.time(),"%Y%m%d_%H%M")
  if(is.null(filename)){
    filename=paste0("performance_",timestamp,".",format)

  }
  filepath=file.path(outdir,filename)

  if(format=="csv"){
    utils::write.csv(results_df,filepath,row.names=FALSE)
  }
  else if(format=="html"){
    if(!requireNamespace("htmlTable",quietly=TRUE)){
      stop("Please install the 'htmlTable' package to use HTML output.")
    }
    html=htmlTable::htmlTable(results_df)
    cat(html,file=filepath)
  }
  else{
    stop("\uc9c0\uc6d0\ub418\uc9c0 \uc54a\ub294 \ud615\uc2dd\uc785\ub2c8\ub2e4. 'csv' \ub610\ub294 'html' \uc911 \uc120\ud0dd\ud558\uc138\uc694.")
  }
  message("Report saved to:",filepath)
  return(filepath)
}
