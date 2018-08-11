## Previous and faulty versions of interactive Shiny app for multitrack!


library(shiny)
library(plotly)
library(ggplot2)

# tester_top <- ggplot() + ggtitle("PTEN mean abundance scores") +
#   geom_segment(aes(x = 1, y = 0, xend = max(pten_extra$position)), yend = 0, size = 1, color = "grey70") +
#   geom_point(data = subset(pten_extra, !is.na(xca)), aes(x = position, y = 0), color = "black", size = 1.8) +
#   geom_point(data = subset(pten_extra, sheet == 1), aes(x = position, y = 0), color = "pink", size = 1.5) +
#   geom_point(data = subset(pten_extra, helix == 1), aes(x = position, y = 0), color = "cyan", size = 1.5) +
#   scale_x_continuous(breaks = seq(0, 403, 20), expand = c(0,0)) +
#   scale_y_continuous(breaks = NULL, expand = c(0,0)) +xlab(NULL) + ylab(NULL) +
#   theme(panel.border = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank())
# 
# tester_mid <- ggplot(pten_sum, aes(x=position, y=score)) +
#   geom_bar(position=position_dodge(), stat="identity", colour="#999999") +
#   geom_errorbar(aes(ymin=score-sd, ymax = score+sd), width=1, size=0.3, position=position_dodge()) +
#   ylab("VAMP-seq score") + 
#   theme(axis.title.x = element_blank(), axis.text.x = element_blank()) + 
#   scale_x_continuous(breaks = seq(0, 403, 20), expand = c(0,0)) + 
#   scale_y_continuous(expand = c(0,0)) + geom_vline(xintercept=185, color="black", size=.1) + 
#   geom_vline(xintercept=350, color="black", size=.1)
# 
# tester_bottom <- ggplot(pten1_proc_wt, aes(position, end)) + 
#   geom_tile(aes(fill=score)) + 
#   scale_fill_gradientn(colours = c("#3F7CB9", "#FFEAF3", "#B21F4E"), values = scales::rescale(c(-0.23, 0.42, 1, 1.2, 1.47))) + 
#   scale_x_continuous(breaks = seq(0, 403, 20), expand=c(0,0)) + 
#   theme(legend.position='bottom') + 
#   xlab("Position in TPMT") + 
#   scale_y_discrete(expand = c(0,0))

ui <- fluidPage(
   
   headerPanel("Title"),
  
 
   mainPanel(
      plotlyOutput("meanPlot", 
                   width=1000, 
                   height=800 
                  
      )
   )
)


server <- function(input, output) {
   ranges <- reactiveValues(x=NULL, y=NULL)
   tester_mid <- ggplot(pten_sum, aes(x=position, y=score)) +
     geom_bar(position=position_dodge(), stat="identity", colour="#999999") +
     geom_errorbar(aes(ymin=score-sd, ymax = score+sd), width=0.3, size=0.3, position=position_dodge()) +
     ylab("VAMP-seq score") + 
     theme(axis.title.x = element_blank(), axis.text.x = element_blank()) + 
     scale_x_continuous(breaks = seq(0, 403, 20), expand = c(0,0)) + 
     scale_y_continuous(expand = c(0,0))
   tester_bottom <- ggplot(pten1_proc_wt, aes(position, end)) + 
     geom_tile(aes(fill=score)) +
     scale_fill_gradientn(colours = c("#3F7CB9", "#FFEAF3", "#B21F4E"), values = scales::rescale(c(-0.23, 0.42, 1, 1.2, 1.47))) +
     scale_x_continuous(breaks = seq(0, 403, 20), expand=c(0,0)) +
     theme(legend.position='bottom') +
     xlab("Position in TPMT") +
     scale_y_discrete(expand = c(0,0)) #+
  
   output$meanPlot <- renderPlotly({
     plotList <- list(tester_mid, tester_bottom)
     subplot(tester_mid, tester_bottom, nrows=2, heights = c(0.3, 0.7))
   
   })
}

shinyApp(ui = ui, server = server)


## This version attempts to store range2 so that the first dblclick will revert to the previous range2 (if any) before going to the default zoom. However, since shiny's implementation of brush is to sample consistently, I have not found a way to get storedRange to only store the final sampled brush value, instead of consistenly updating while range2 is being updated. If you were to assign storedRange to range2 only when brush=NULL (when the plot is done being highlighted), storedRange would take on range2's value every 100 or so miliseconds. What a pain in the ass. Basically, need to find a way for stordRange to take on range2's value just ONCE. May need to use 'click' since 'dblclick' is already in use. But then again, we're already using 'brush', and 'brush' is made from a 'click' and a drag. So basically shiny is a piece of trash.

library(shiny)
#library(plotly)
library(ggplot2)


ui <- fluidPage(
  fluidPage(
    mainPanel(
      tabsetPanel(
        tabPanel(
           h4("Top plot controls bottom plot"),
           fluidRow(
             column(12,
               plotOutput("plot2", 
                          height = 300,
                          brush = brushOpts(
                            id = "plot2_brush",
                            resetOnNew = TRUE,
                            direction = "x",
                            delay = 200,
                            delayType = "debounce"
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
                          height = 300
               )
             )
           )#,
          # fluidRow(
          #   column(12,
          #     plotOutput("plot4",
          #                height = 300
          #     )
          #   )
          # )
        )
      )
    )
  ) 
)

server <- function(input, output) {

  
  # Linked plots (middle and right)
  range2 <- reactiveValues(x = NULL)
  rangeStored <- (x = NULL)
  
  output$plot2 <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) +
      geom_point() +
      coord_cartesian(xlim = range2$x, expand = FALSE)
  })
  
  output$plot3 <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) +
      geom_point() +
      coord_cartesian(xlim = range2$x, expand = FALSE)
  })
  
  # When a double-click happens, check if there's a brush on the plot.
  # If so, zoom to the brush bounds; if not, reset the zoom.
  observe({
    brush2 <- input$plot2_brush
    dblclick2 <- input$plot2_dblclick
    if (!is.null(brush2)) {
      rangeStored$x <- range2$x
      cat(file=stderr(), "immediately after brush, rangeStored and range2 hold", rangeStored$x, "and", range2$x, "respectively", "\n")
      range2$x <- c(brush2$xmin, brush2$xmax)
      cat(file=stderr(), "range2 then stores new value", range2$x, "and rangeStored holds old value", rangeStored$x, "\n")
    }
    if (!is.null(dblclick2)) {
      cat(file=stderr(), "dblclicked! range2 holds", range2$x, "and rangeStored holds", rangeStored$x, "\n")
      range2$x <- rangeStored$x
      cat(file=stderr(), "range2 now holds", range2$x, "afterwards", "\n")
      if (!is.null(rangeStored$x)) {
        rangeStored$x <- NULL
      }
    }
  })
  
}

shinyApp(ui, server)


## This version works (surprise!)
## brush to select region to zoomzoom, dblclick to unzoomzoom

library(shiny)
#library(plotly)
library(ggplot2)


ui <- fluidPage(
  fluidPage(
    mainPanel(
      tabsetPanel(
        tabPanel(
           h4("Top plot controls bottom plot"),
           fluidRow(
             column(12,
               plotOutput("plot2", 
                          height = 300,
                          brush = brushOpts(
                            id = "plot2_brush",
                            resetOnNew = TRUE,
                            direction = "x",
                            delay = 200,
                            delayType = "debounce"
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
                          height = 300
               )
             )
           )#,
          # fluidRow(
          #   column(12,
          #     plotOutput("plot4",
          #                height = 300
          #     )
          #   )
          # )
        )
      )
    )
  ) 
)

server <- function(input, output) {

  
  # Linked plots (middle and right)
  range2 <- reactiveValues(x = NULL)
  
  output$plot2 <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) +
      geom_point() +
      coord_cartesian(xlim = range2$x, expand = FALSE)
  })
  
  output$plot3 <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) +
      geom_point() +
      coord_cartesian(xlim = range2$x, expand = FALSE)
  })
  
  # When a double-click happens, check if there's a brush on the plot.
  # If so, zoom to the brush bounds; if not, reset the zoom.
  observe({
    brush2 <- input$plot2_brush
    dblclick2 <- input$plot2_dblclick
    if (!is.null(brush2)) {
      range2$x <- c(brush2$xmin, brush2$xmax)
    }
    if (!is.null(dblclick2)) {
        range2$x <- NULL
    }
  })
  
}

shinyApp(ui, server)

