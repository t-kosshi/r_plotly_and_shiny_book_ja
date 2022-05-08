# 図12.1 ------------------------------------------
library(dplyr)
library(sf)
library(purrr)
library(tidycensus)
library(USAboundaries)
if(!require(USAboundariesData)) remotes::install_github("ropensci/USAboundariesData")

# ミネソタ州の各郡の地理的情報を得る
mn_sf <- us_counties(states = "MN")

# 訳者注：2021年12月時点でなぜかstate_name列が2列取得される
# 後のコードが動かないため，1列削除する処理を加えた
mn_sf$state_name <- NULL

# ミネソタ州の各郡の所得情報を得る
# 訳者注：API keyの取得と環境変数への追加が必要
# https://api.census.gov/data/key_signup.html
# Sys.setenv(CENSUS_API_KEY = 'your key')
# keyが発行されてからアクティブになるまでタイムラグがある
mn_income <- get_acs(
  geography = "county", variables = "B19013_001", state = "MN"
) %>%
  mutate(
    NAME = sub("County, Minnesota", "", NAME),
    county = reorder(NAME, estimate),
    color = scales::col_numeric("viridis", NULL)(estimate)
  )

# 注釈を置く場所を決めるために各郡の中心を見つける
mn_center <- mn_sf %>%
  st_centroid() %>%
  mutate(
    x = map_dbl(geometry, 1),
    y = map_dbl(geometry, 2)
  )

# 所得上位10郡の中心のx-y座標を得る
top10labels <- mn_income %>%
  top_n(10, estimate) %>%
  left_join(mn_center, by = c("GEOID" = "geoid"))

# 所得上位10位の郡を地図で可視化しラベル付け
map <- plot_ly() %>%
  add_sf(
    data = left_join(mn_sf, mn_income, by = c("geoid" = "GEOID")),
    color = ~I(color), split = ~NAME,
    stroke = I("black"), span = I(1), hoverinfo = "none"
  ) %>%
  add_annotations(
    data = select(top10labels, NAME, x, y),
    text = ~NAME, x = ~x, y = ~y
  ) 

# 各郡の所得情報をドットプロット（エラーバー付き）で可視化
bars <- ggplot(mn_income, aes(x = estimate, y = county)) +
  geom_errorbarh(aes(xmin = estimate - moe, xmax = estimate + moe)) +
  geom_point(aes(color = color), size = 2) +
  scale_color_identity()

# ブラウザで手動で編集したのち，Download plotをクリックしてSVGファイルを出力
ggplotly(
  bars, dynamicTicks = TRUE, tooltip = "y", 
  height = 8 * 96, width = 11 * 96
) %>%
  subplot(map, nrows = 1, widths = c(0.3, 0.7)) %>%
  layout(showlegend = FALSE) %>%
  config(
    edits = list(
      annotationPosition = TRUE,
      annotationTail = TRUE,
      annotationText = TRUE
    ),
    toImageButtonOptions = list(format = "svg")
  )
