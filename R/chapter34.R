# 図34.1 ------------------------------------------
# 2022/5/7時点で図2.14のコードはR4.0.0以降だと動かない。
# S3メソッドの検索方法が変わった影響。以下のコードが必要。
registerS3method("to_basic", "GeomXspline", "to_basic.GeomXspline")

set.seed(1492)
dat <- data.frame(
  x = c(1:10, 1:10, 1:10),
  y = c(
    sample(15:30, 10), 
    2 * sample(15:30, 10), 
    3 * sample(15:30, 10)
  ),
  group = factor(c(rep(1, 10), rep(2, 10), rep(3, 10)))
)
p <- ggplot(dat, aes(x, y, group = group, color = factor(group))) +
  geom_point(color = "black") +
  geom_smooth(se = FALSE, linetype = "dashed", size = 0.5) +
  geom_xspline(spline_shape = 1, size = 0.5)
ggplotly(p) %>% hide_legend()
