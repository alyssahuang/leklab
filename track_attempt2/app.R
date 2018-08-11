##Deployment in RStudio console
#library(rsconnect)
#rsconnect::deployApp('path/to/your/app')    ##rsconnect::deployApp('~/leklab/leklab/track_attempt2/')


library(shiny)
library(ggplot2)
library(Rmisc)

ui <- fluidPage(
  fluidPage(
    mainPanel(
      tabsetPanel(
        tabPanel(
           h4("CLick and drag to zoom, double-click to zoom out"),
           fluidRow(
             column(12, 
               plotOutput("plot1",
                          width = 900,
                          height = 60,
                          brush = brushOpts(
                            id = "plot1_brush",
                            resetOnNew = TRUE,
                            direction = "x"
                          ),
                          dblclick = dblclickOpts(
                            id = "plot1_dblclick"
                          )
               )
             )
           ),
           fluidRow(
             column(12,
               plotOutput("plot2", 
                          width = 900,
                          height = 150,
                          brush = brushOpts(
                            id = "plot2_brush",
                            resetOnNew = TRUE,
                            direction = "x"
                          ),
                          dblclick = dblclickOpts(
                            id = "plot2_dblclick"
                          )
               )
             )
           ),
           fluidRow(
             column(12,
               plotOutput("plot3",
                          width = 900,
                          height = 400,
                          brush = brushOpts(
                            id = "plot3_brush",
                            resetOnNew = TRUE,
                            direction = "x"
                          ),
                          dblclick = dblclickOpts(
                            id = "plot3_dblclick"
                          )
               )
             )
           )
        )
      )
    )
  ) 
)

server <- function(input, output) {
  pten_data <- read.delim('./Data/pten1.txt')
  pten_proc <- pten_data[!is.na(pten_data$abundance_class),]
  pten_proc_wt <- pten_proc[!is.na(pten_proc$position),]
  pten_summary <- summarySE(pten_proc_wt, measurevar="score", groupvars="position")
  
  pten_extra <- read.table(file = './Data/PTEN_positional_data.tsv', sep = '\t', header = TRUE)

  
  # Linked plots (middle and right)
  rangeX <- reactiveValues(x = NULL)
  output$plot1 <- renderPlot({
    ggplot() + ggtitle("PTEN mean abundance scores") +
      geom_segment(aes(x = 1, y = 0, xend = max(pten_extra$position)), yend = 0, size = 1, color = "grey70") +
      geom_point(data = subset(pten_extra, !is.na(xca)), aes(x = position, y = 0), color = "black", size = 1.8) +
      geom_point(data = subset(pten_extra, sheet == 1), aes(x = position, y = 0), color = "pink", size = 1.5) +
      geom_point(data = subset(pten_extra, helix == 1), aes(x = position, y = 0), color = "cyan", size = 1.5) +
      scale_x_continuous(breaks = seq(0, 403, 20), expand = c(0,0)) +
      scale_y_continuous(breaks = NULL, expand = c(0,0)) +xlab(NULL) + ylab("sec struct") +
      # margin(l=20.5) is needed to pad the left side of the graph with space to align correctly with other graphs (because you can't use gridExtra or grid with shiny! I love shiny)
      # also, in order for padding to work, you must have a y-axis title
      theme(panel.border = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.title.y = element_text(margin=margin(l=20.5))) +
      coord_cartesian(xlim = rangeX$x, expand = FALSE)
  })
  
  output$plot2 <- renderPlot({
    ggplot(pten_summary, aes(x=position, y=score)) +
      geom_bar(position=position_dodge(), stat="identity", colour="#999999") +
      geom_errorbar(aes(ymin=score-sd, ymax = score+sd), width=0.3, size=0.3, position=position_dodge()) +
      ylab("VAMP-seq score") + 
      theme(axis.title.x = element_blank(), axis.text.x = element_blank()) + 
      scale_x_continuous(breaks = seq(0, 403, 20), expand = c(0,0)) + 
      scale_y_continuous(expand = c(0,0)) +
      coord_cartesian(xlim = rangeX$x, expand = FALSE)
  })
  
  output$plot3 <- renderPlot({
    ggplot(pten_proc_wt, aes(position, end)) + 
      geom_tile(aes(fill=score)) +
      scale_fill_gradientn(colours = c("#3F7CB9", "#FFEAF3", "#B21F4E"), values = scales::rescale(c(-0.23, 0.42, 1, 1.2, 1.47))) +
      scale_x_continuous(breaks = seq(0, 403, 20), expand=c(0,0)) +
      theme(legend.position='bottom', axis.title.y = element_text(margin=margin(l=7))) +
      xlab("Position in TPMT") +
      scale_y_discrete(expand = c(0,0)) +
      coord_cartesian(xlim = rangeX$x, expand = FALSE)
  })
  
  # When a double-click happens, check if there's a brush on the plot.
  # If so, zoom to the brush bounds; if not, reset the zoom.
  observe({
    brush1 <- input$plot1_brush
    brush2 <- input$plot2_brush
    brush3 <- input$plot3_brush
    dblclick1 <- input$plot1_dblclick
    dblclick2 <- input$plot2_dblclick
    dblclick3 <- input$plot3_dblclick
    
    if (!is.null(brush1)) {
      rangeX$x <- c(brush1$xmin, brush1$xmax)
    }
    if (!is.null(dblclick1)) {
      rangeX$x <- NULL
    }
    
    dblclick2 <- input$plot2_dblclick
    if (!is.null(brush2)) {
      rangeX$x <- c(brush2$xmin, brush2$xmax)
    }
    if (!is.null(dblclick2)) {
      rangeX$x <- NULL
    }
    
    dblclick3 <- input$plot3_dblclick
    if (!is.null(brush3)) {
      rangeX$x <- c(brush3$xmin, brush3$xmax)
    }
    if (!is.null(dblclick3)) {
      rangeX$x <- NULL
    }
  })
  
}

shinyApp(ui, server)