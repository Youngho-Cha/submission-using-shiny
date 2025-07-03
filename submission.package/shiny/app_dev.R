
library(shiny)
library(submission.package)
library(DT)
library(pROC)
library(ggplot2)

ui=fluidPage(
  titlePanel("Clinical Performance Evaluation App"),

  sidebarLayout(
    sidebarPanel(
      fileInput("datafile","Upload CSV File",
                accept=c(".csv")),

      uiOutput("var_select_ui"),

      checkboxGroupInput("selected_metrics","Select Metrics to Calculate",
                         choices=c("sensitivity","specificity","ppv","npv","accuracy","auc"),
                         selected=c("sensitivity","specificity","auc")),

      selectInput("ci_method_binary","Binary Metric CI Method",
                  choices=c("cp","wilson","wald"),
                  selected="cp"),

      conditionalPanel(
        condition="'auc' %in% input.selected_metrics",
        selectInput("ci_method_auc","AUC CI Method",
                    choices=c("delong","bootstrap"),
                    selected="delong")
      ),

      numericInput("alpha","Significance level",value=0.05,min=0,max=0.3,step=0.01),

      conditionalPanel(
        condition="input.ci_method_auc=='bootstrap' && 'auc' %in% input.selected_metrics",
        numericInput("n_bootstrap","The Number of Bootstrap Sampling",value=2000,min=100,step=100)
      ),

      numericInput("digits","Decimal places",value=3,min=0,max=10),
      actionButton("analyze","Run Analysis")
    ),

    mainPanel(
      h4("Performance Metrics"),
      DTOutput("resultTable"),
      h4("ROC Curve"),
      plotOutput("rocPlot")
    )
  )
)

server=function(input,output,session) {

  dataset=reactiveVal(NULL)

  observeEvent(input$datafile,{
    req(input$datafile)
    data=read.csv(input$datafile$datapath)
    dataset(data)

    updateSelectInput(session,"actual_var",choices=names(data))
    updateSelectInput(session,"predicted_var",choices=names(data))
    updateSelectInput(session,"score_var",choices=names(data))
  })

  output$var_select_ui=renderUI({
    req(dataset())
    data=dataset()

    tagList(
      selectInput("actual_var","Select 'actual' variable",choices=names(data)),
      selectInput("predicted_var","Select 'predicted' variable",choices=names(data)),
      selectInput("score_var","Select 'score' variable(optional)",choices=c("None",names(data)),selected="None")
    )
  })

  analysisResult=eventReactive(input$analyze,{
    req(dataset(),input$actual_var,input$predicted_var,input$selected_metrics)
    data=dataset()

    actual=data[[input$actual_var]]
    predicted=data[[input$predicted_var]]
    score=if(input$score_var=="None") NULL else data[[input$score_var]]

    metrics=calc_performance_metrics(
      actual=actual,
      predicted=predicted,
      score=score,
      metrics_to_calc=input$selected_metrics,
      ci_method_binary=input$ci_method_binary,
      ci_method_auc=input$ci_method_auc,
      alpha=input$alpha,
      boot_n=if(input$ci_method_auc=="bootstrap") input$n_bootstrap else NULL
    )

    formatted=format_performance_output(metrics)
    formatted=formatted[formatted$Metric %in% input$selected_metrics,]
    report_ready=format_for_reporting(formatted,digits=input$digits)
    list(table=report_ready,
         roc=if("auc" %in% input$selected_metrics && !is.null(score)) roc(actual,score) else NULL)
  })

  output$resultTable=renderDT({
    req(analysisResult())
    datatable(analysisResult()$table)
  })

  output$rocPlot=renderPlot({
    roc_obj=analysisResult()$roc
    req(roc_obj)
    plot(roc_obj,main="ROC Curve")
  })

}

shinyApp(ui=ui,server=server)
