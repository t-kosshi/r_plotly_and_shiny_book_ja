# 図2.11 ------------------------------------------
# stat_summary()でmean_cl_bootを使うためにHmiscパッケージが必要
library(Hmisc)
p <- ggplot(diamonds, aes(x=clarity, y=log(price), color=clarity)) +
  ggforce::geom_sina(alpha = 0.1) + 
  stat_summary(fun.data = "mean_cl_boot", color = "black") +
  facet_wrap(~cut)
toWebGL(ggplotly(p))



# 図2.14 ------------------------------------------
library(naniar)

# 2022/5/7時点で図2.14のコードはR4.0.0以降だと動かない。
# S3メソッドの検索方法が変わった影響。以下のコードが必要。
# to_basic()については34章を参照
registerS3method("to_basic", "GeomMissPoint", "to_basic.GeomMissPoint")

# 偽の欠損値を導入
diamonds$price_miss <- ifelse(diamonds$depth>60, diamonds$price, NA)
p <- ggplot(diamonds, aes(x = clarity, y = log(price_miss))) +
  geom_miss_point(alpha = 0.1) + 
  stat_summary(fun.data = "mean_cl_boot", colour = "black") +
  facet_wrap(~cut)
toWebGL(ggplotly(p))
