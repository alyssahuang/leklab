#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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
   #sidebarPanel(
   #  sliderInput('plotHeight', 'Height of plot (in pixels)', 
   #             min = 100, max = 2000, value = 1000)
   #),
 
   mainPanel(
      plotlyOutput("meanPlot", 
                   width=1000, 
                   height=800#, 
                   #dblclick="unsure_dblclick", 
                   #brush=brushOpts(
                   #  id="unsure_brush",
                   #  resetOnNew=TRUE
                   #)
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
     # coord_cartesian(xlim=ranges$x, ylim=ranges$y)
   
   # observeEvent(input$unsure_dblclick, {
   #   brush <- input$unsure_brush
   #   if (!is.null(brush)) {
   #      ranges$x <- c(brush$xmin, brush$xmax)
   #      ranges$y <- c(brush$ymin, brush$ymax)
   #   } else {
   #      ranges$x <- NULL
   #      ranges$y <- NULL
   #   }
   # })
   output$meanPlot <- renderPlotly({
     plotList <- list(tester_mid, tester_bottom)
     subplot(tester_mid, tester_bottom, nrows=2, heights = c(0.3, 0.7))
     #grid.arrange(arrangeGrob(tester_mid,tester_bottom,nrow=2,heights=c(.3,.7)))
     
     # ggplotly(tester_mid) %>%
     #    layout(height = 1000) #input$plotHeight, autosize=TRUE)
   })
}

shinyApp(ui = ui, server = server)

