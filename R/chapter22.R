# 図22.1 ------------------------------------------
library(plotly)
library(htmltools)

nms <- names(mtcars)

p <- plot_ly(colors = "RdBu") %>%
  add_heatmap(
    x = nms,
    y = nms,
    z = ~round(cor(mtcars), 3)
  ) %>%
  onRender("
    function(el) {
      d3.json('mtcars.json')
      .then(function(mtcars) {
        el.on('plotly_click', function(d) {
          var x = d.points[0].x;
          var y = d.points[0].y;
          var trace = {
            x: mtcars[x],
            y: mtcars[y],
            mode: 'markers'
          };
          Plotly.newPlot('filtered-plot', [trace]);
        });
      });
    }
")

# d3.js を参照するための情報を整理
# 以下の引数scriptにd3.v3.min.jsを渡せばv3を読み込むこともできる
src_d3js <- htmlDependency("d3", "7", src = c(href="https://d3js.org/"),
                           script = "d3.v7.min.js")
# htmlwidget（plotlyオブジェクト）にd3.jsへの参照を追加
p$dependencies <- append(p$dependencies, list(src_d3js))

# JSON形式にしたデータセットmtcarsとindex.htmlを一時的なディレクトリに保存
# ウェブサーバー経由でindex.htmlファイルを開く
withr::with_path(tempdir(), {
  jsonlite::write_json(as.list(mtcars), "mtcars.json")
  html <- tagList(p, tags$div(id = "filtered-plot"))
  save_html(html, "index.html")
  if (interactive()) servr::httd()
})



# 図22.4 ------------------------------------------
data_grid_js <- runpkg::download_files(
  "react-data-grid@6.1.0", 
  "dist/react-data-grid.min.js"
)

# テーブル出力先のプレースホルダー
data_grid <- tags$div(id = "data-grid")

# マーカーをクリックするとidがvideoであるDOM要素で動画が再生される
p <- plot_ly(mtcars, x = ~wt, y = ~mpg) %>%
  add_markers(customdata = row.names(mtcars)) %>% 
  layout(dragmode = "select") %>%
  onRender(babel_transform(   
    "el => {
       var container = document.getElementById('data-grid');
       var columns = [
         {key: 'x', name: 'Weight'}, 
         {key: 'y', name: 'MPG'}, 
         {key: 'customdata', name: 'Model'}
        ];
       el.on('plotly_selecting', d => {
          if (d.points) {
            var grid = <ReactDataGrid 
              columns={columns} 
              rowGetter={i => d.points[i]} 
              rowsCount={d.points.length} 
            />;
            ReactDOM.render(grid, container);
          }
        });
        el.on('plotly_deselect', d => { 
          ReactDOM.render(null, container); 
        });
     }"
  ))

# HTMLページを作成
browsable(
  tagList(p, data_grid, html_dependency_react(), data_grid_js)
)
