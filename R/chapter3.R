# 図3.21 ------------------------------------------
# 訳者追加：トレースタイプcandlestickを使ったコード例
library(quantmod)

msft <- getSymbols("MSFT", auto.assign = F)
dat <- as.data.frame(msft)
dat$date <- index(msft)
dat <- subset(dat, date >= "2016-01-01")

names(dat) <- sub("^MSFT\\.", "", names(dat))
plot_ly(dat) %>%
  add_trace(type="candlestick",
            close = ~Close, open = ~Open,
            high = ~High, low = ~Low)



# 図3.26 ------------------------------------------
m <- lm(mpg ~ wt, data = mtcars)
broom::augment(m, se_fit = TRUE) %>%
  plot_ly(x = ~wt, showlegend = FALSE) %>%
  add_markers(y = ~mpg, color = I("black")) %>%
  add_ribbons(ymin = ~.fitted - 1.96 * .se.fit, 
              ymax = ~.fitted + 1.96 * .se.fit, 
              color = I("gray80")) %>%
  add_lines(y = ~.fitted, color = I("steelblue"))
