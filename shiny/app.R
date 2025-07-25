library(shiny)
library(DT)
library(dplyr)
library(submission.package)

ui=fluidPage(
  titlePanel("Medical Device Performance Evaluation"),

  sidebarLayout(
    sidebarPanel(
      fileInput("file","Upload CSV File",accept=".csv"),

      uiOutput("select_actual"),
      uiOutput("select_actual_level"),

      uiOutput("select_predicted"),
      uiOutput("select_predicted_level"),

      uiOutput("select_score"),

      checkboxGroupInput("metrics","Select Metrics to Calculate",
                         choices=c("sensitivity","specificity","ppv","npv","accuracy","auc"),
                         selected=c("sensitivity","specificity","accuracy")),

      selectInput("ci_method_binary","Binary CI Method",choices=c("cp","wilson","wald"),selected="cp"),
      selectInput("ci_method_auc","AUC CI Method",choices=c("delong","bootstrap"),selected="delong"),
      numericInput("alpha","Significance Level (alpha)",value=0.05,min=0,max=0.2,step=0.01),
      numericInput("n_bootstrap","Bootstrap Iterations",value=2000,min=100,step=100),
      numericInput("digits","Decimal Places for Results",value=3,min=0,max=10),

      downloadButton("download","Download Report")
    ),

    mainPanel(
      verbatimTextOutput("data_summary"),
      verbatimTextOutput("conf_matrix"),
      dataTableOutput("results")
    )
  )
)

server=function(input,output,session) {
  data=reactive({
    req(input$file)
    read.csv(input$file$datapath,stringsAsFactors=FALSE)
  })

  output$select_actual=renderUI({
    req(data())
    selectInput("actual_col","Select Actual Variable",choices=names(data()))
  })

  output$select_predicted=renderUI({
    req(data())
    selectInput("predicted_col","Select Predicted Variable",choices=names(data()))
  })

  output$select_score=renderUI({
    req(data())
    selectInput("score_col","Select Score Variable (optional)",choices=c("None",names(data())))
  })

  # Conditional level selection
  output$select_actual_level=renderUI({
    req(input$actual_col)
    levs=unique(data()[[input$actual_col]])
    if (length(levs) == 2) {
      selectInput("actual_positive","Which value is POSITIVE for Actual?",choices=levs)
    }
  })

  output$select_predicted_level=renderUI({
    req(input$predicted_col)
    levs=unique(data()[[input$predicted_col]])
    if (length(levs) == 2) {
      selectInput("predicted_positive","Which value is POSITIVE for Predicted?",choices=levs)
    }
  })

  # Formatted reactive inputs
  formatted_data=reactive({
    req(input$actual_col,input$predicted_col)
    df=data()
    actual=ifelse(df[[input$actual_col]] == input$actual_positive,1,0)
    predicted=ifelse(df[[input$predicted_col]] == input$predicted_positive,1,0)
    score=if (!is.null(input$score_col) && input$score_col != "None") df[[input$score_col]] else NULL
    list(actual=actual,predicted=predicted,score=score)
  })

  # Data Summary
  output$data_summary=renderPrint({
    df=formatted_data()
    cat("Total records:",length(df$actual),"\n")
    cat("Actual class counts:\n")
    print(table(df$actual))
    cat("Predicted class counts:\n")
    print(table(df$predicted))
  })

  output$conf_matrix=renderPrint({
    df=formatted_data()
    cm=table(Predicted=df$predicted,Actual=df$actual)
    cat("Confusion Matrix:\n")
    print(cm)
  })

  metrics=reactive({
    df=formatted_data()
    calc_performance_metrics(
      actual=df$actual,
      predicted=df$predicted,
      score=df$score,
      metrics_to_calc=input$metrics,
      ci_method_binary=input$ci_method_binary,
      ci_method_auc=input$ci_method_auc,
      alpha=input$alpha,
      boot_n=if (input$ci_method_auc == "bootstrap") input$n_bootstrap else NULL
    )
  })

  formatted_results=reactive({
    df=format_performance_output(metrics())
    df %>%
      mutate(
        Estimate=round(Estimate,input$digits),
        Lower_95_CI=round(Lower_95_CI,input$digits),
        Upper_95_CI=round(Upper_95_CI,input$digits)
      )
  })

  output$results=renderDataTable({
    formatted_results()
  })

  output$download=downloadHandler(
    filename=function() {
      paste0("performance_report_",format(Sys.time(),"%Y%m%d_%H%M"),".csv")
    },
    content=function(file) {
      utils::write.csv(formatted_results(),file,row.names=FALSE)
    }
  )
}

shinyApp(ui,server)
