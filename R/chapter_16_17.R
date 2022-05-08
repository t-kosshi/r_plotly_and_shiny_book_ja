# 図16.3 ------------------------------------------
time_series <- base %>%
  group_by(city) %>%
  add_lines(x = ~date, y = ~median)

highlight(
  time_series, 
  on = "plotly_click", 
  selectize = TRUE, 
  dynamic = TRUE, 
  persistent = TRUE
)



# 図17.26 速度改善版 ------------------------------------------
library(shiny)
library(dplyr)
library(nycflights13)
library(ggstat)

arr_time <- flights$arr_time
dep_time <- flights$dep_time
arr_bins <- bin_fixed(arr_time, bins = 250)
dep_bins <- bin_fixed(dep_time, bins = 250)
arr_stats <- compute_stat(arr_bins, arr_time) %>%
  filter(!is.na(xmin_))
dep_stats <- compute_stat(dep_bins, dep_time) %>%
  filter(!is.na(xmin_))

ui <- fluidPage(
  plotlyOutput("arr_time", height = 250),
  plotlyOutput("dep_time", height = 250)
)

server <- function(input, output, session) {
  
  output$arr_time <- renderPlotly({
    plot_ly(arr_stats, source = "arr_time") %>%
      add_bars(x = ~xmin_, y = ~count_) 
  })
  
  output$dep_time <- renderPlotly({
    plot_ly(dep_stats, source = "dep_time") %>%
      add_bars(x = ~xmin_, y = ~count_) 
  })
  
  # arr_timeの選択に応じてdep_timeを更新
  observe({
    brush <- event_data("plotly_brushing", source = "arr_time")
    p <- plotlyProxy("dep_time", session)
    
    # 選択されていない場合は初期状態に戻す
    if (is.null(brush)) {
      plotlyProxyInvoke(p, "restyle", "y", list(dep_stats$count_), 0)
    } else {
      in_filter <- between(arr_time, brush$x[1], brush$x[2])
      dep_count <- dep_bins %>%
        compute_stat(dep_time[in_filter]) %>%
        filter(!is.na(xmin_)) %>%
        pull(count_)
      
      plotlyProxyInvoke(p, "restyle", "y", list(dep_count), 0)
    }
  })
  
  observe({
    brush <- event_data("plotly_brushing", source = "dep_time")
    p <- plotlyProxy("arr_time", session)
    
    # 選択されていない場合は初期状態に戻す
    if (is.null(brush)) {
      plotlyProxyInvoke(p, "restyle", "y", list(arr_stats$count_), 0)
    } else {
      in_filter <- between(dep_time, brush$x[1], brush$x[2])
      arr_count <- arr_bins %>%
        compute_stat(arr_time[in_filter]) %>%
        filter(!is.na(xmin_)) %>%
        pull(count_)
      
      plotlyProxyInvoke(p, "restyle", "y", list(arr_count), 0)
    }
  })
  
}

shinyApp(ui, server)



# 図17.28 ------------------------------------------
# 図17.25のコードを実行するとdplyr::select()がMASS::select()にマスクされる
detach("package:MASS", unload = TRUE)
plotly_example("shiny", "crossfilter")
