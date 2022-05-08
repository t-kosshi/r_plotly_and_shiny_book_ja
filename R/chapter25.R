# 図25.1 ------------------------------------------
library(tibble)
library(forcats)

tooltip_data <- tibble(
  x = " ",
  y = 1,
  categories = as_factor(c(
    "Glyphs", "HTML tags", "Unicode", 
    "HTML entities", "A combination"
  )),
  text = c(
    "👋 glyphs ಠ_ಠ",
    "Hello <span style='color:red'><sup>1</sup>⁄<sub>2</sub></span> 
    fraction",
    "\U0001f44b unicode \U00AE \U00B6 \U00BF",
    "&mu; &plusmn; &amp; &lt; &gt; &nbsp; &times; &plusmn; &deg;",
    paste("<b>Wow</b> <i>much</i> options", emo::ji("dog2"))
  )
)

plot_ly(tooltip_data, hoverinfo = "text") %>%
  add_bars(
    x = ~x,
    y = ~y,
    color = ~fct_rev(categories),
    text = ~text
  ) %>%
  layout(
    barmode ="stack",
    hovermode = "x"
  )



# 図25.9 ------------------------------------------
library(scales)
p <- ggplot(txhousing, aes(date, median)) + 
  geom_line(aes(
    group = city, 
    text = paste("median:", label_number_si(median))
  ))
ggplotly(p, tooltip = c("text", "x", "city"))



# 図25.10 ------------------------------------------
# 前の図にgeom_smooth()を重ねてからplotlyに変換
w <- ggplotly(p + geom_smooth(se = FALSE))


# このplotlyオブジェクトは2つのトレースを持っている
# 1つはgeom_line()，もう1つはgeom_smooth()由来
# plotly_json(w)を使って2番目のトレースがgeom_smooth()由来と確認
length(w$x$data)

# 2番目のトレースのy属性を目的の形式で表示するためyを元にカスタムテキストを生成
text_y <- label_number_si(prefix = "Typical median house price: $")(
  w$x$data[[2]]$y
)

# 1番目のトレースのツールチップを非表示に
# 2番目のトレースのtextにカスタムテキストを指定
w %>%
  style(hoverinfo = "skip", traces = 1) %>%
  style(text = text_y, traces = 2)

