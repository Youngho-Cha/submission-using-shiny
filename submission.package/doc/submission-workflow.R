## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, include = FALSE---------------------------------------------------

library(submission.package)
library(epiR)
library(pROC)
library(dplyr)


## -----------------------------------------------------------------------------

library(submission.package)

# 예제 데이터 불러오기
data("example_data")
actual=example_data$actual
predicted=example_data$predicted
score=example_data$score

# 성능 지표 계산
metrics=calc_performance_metrics(actual,predicted,score)
formatted=format_performance_output(metrics)

# 보고서 포맷팅
report_ready=format_for_reporting(formatted,digits=3)

# 리포트 저장
save_performance_report(report_ready,format="csv")


