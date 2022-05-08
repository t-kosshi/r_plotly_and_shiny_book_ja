# 図13.4 ------------------------------------------
# 相関関係にある2変数の正規分布からランダムに値を選ぶ
if(!require("mvtnorm")) install.packages("mvtnorm")
s <- matrix(c(1, 0.3, 0.3, 1), nrow = 2)
m <- mvtnorm::rmvnorm(1e5, sigma = s)
x <- m[, 1]
y <- m[, 2]
s <- subplot(
  plot_ly(x = x, color = I("black")), 
  plotly_empty(), 
  plot_ly(x = x, y = y, color = I("black")) %>%
    add_histogram2dcontour(colorscale = "Viridis"), 
  plot_ly(y = y, color = I("black")),
  nrows = 2, heights = c(0.2, 0.8), widths = c(0.8, 0.2), margin = 0,
  shareX = TRUE, shareY = TRUE, titleX = FALSE, titleY = FALSE
)
layout(s, showlegend = FALSE)



# 図13.12 ------------------------------------------
library(shiny)
p <- plot_ly(x = rnorm(100))
htmltools::browsable(
  fluidPage(
    fluidRow(p),
    fluidRow(
      column(6, p), column(6, p) 
    )
  )
)

library(crosstalk)
bscols(p, bscols(p, p), widths = 12)
