# 図21.1 ------------------------------------------
library(htmlwidgets)

p <- plot_ly(mtcars, x = ~wt, y = ~mpg) %>%
  add_markers(
    text = rownames(mtcars),
    customdata = paste0("https://google.com/search?q=", rownames(mtcars))
  )

onRender(
  p, "
  function(el) {
    el.on('plotly_click', function(d) {
      var url = d.points[0].customdata;
      window.open(url);
    });
  }
")



# 図21.3 ------------------------------------------
library(htmltools)

x <- 1:3
y <- 1:3
logos <- c("r-logo", "penguin", "rstudio")
# 各画像をBase64でエンコードした文字列を作成
uris <- purrr::map_chr(
  logos, ~base64enc::dataURI(file = sprintf("images/%s.png", .x))
)
# hoverinfo = "none"は plotly.jsのツールチップを非表示にするが
# plotly_hoverイベントは機能する
p <- plot_ly(hoverinfo = "none") %>%
  add_text(x = x, y = y, customdata = uris, text = logos) %>%
  htmlwidgets::onRender(readLines("js/tooltip-image.js"))

# d3.jsを参照するための情報を整理
src_d3js <- htmlDependency("d3", "7", src = c(href="https://d3js.org"),
                           script = "d3.v7.min.js")
# htmlwidget（plotlyオブジェクト）にd3.jsへの参照を追加しレンダリング
p$dependencies <- append(p$dependencies, list(src_d3js))
p



# 図21.4 ------------------------------------------
p <- plot_ly(hoverinfo = "none") %>%
  add_heatmap(
    z = matrix(1:9, nrow = 3),
    customdata = replicate(uris, n = 3, simplify = FALSE)
  ) %>%
  htmlwidgets::onRender(readLines("js/tooltip-image.js"))

# d3.jsを参照するための情報を整理
src_d3js <- htmlDependency("d3", "7", src = c(href="https://d3js.org"),
                           script = "d3.v7.min.js")
# htmlwidget（plotly オブジェクト）にd3.jsへの参照を追加しレンダリング
p$dependencies <- append(p$dependencies, list(src_d3js))
p



# 図21.6 ------------------------------------------
# d3.jsを参照するための情報を整理
src_d3js <- htmlDependency("d3", "7", src = c(href = "https://d3js.org"),
                           script = "d3.v7.min.js")
# htmlwidget(plotly オブジェクト)にd3.jsへの参照を追加しレンダリング
sales_hover$dependencies <- append(sales_hover$dependencies, list(src_d3js))
onRender(sales_hover, readLines("js/tx-mean-sales.js"))
