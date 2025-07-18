% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metrics_save.R
\name{save_performance_report}
\alias{save_performance_report}
\title{Save performance metrics to CSV or HTML}
\usage{
save_performance_report(
  results_df,
  format = "csv",
  outdir = "results",
  filename = NULL
)
}
\arguments{
\item{results_df}{A data.frame created by format_performance_output()}

\item{format}{Output format: "csv" or "html"}

\item{outdir}{Output directory (default: "results")}

\item{filename}{Optional filename (auto-named if NULL)}
}
\value{
The file path where the report was saved
}
\description{
Save performance metrics to CSV or HTML
}
