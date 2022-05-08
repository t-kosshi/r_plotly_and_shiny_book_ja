# 図4.10 ------------------------------------------
library(rnaturalearth)
if(!require(rnaturalearthhires)) remotes::install_github("ropensci/rnaturalearthhires")
canada <- ne_states(country = "Canada", returnclass = "sf")
plot_ly(canada, split = ~name, color = ~provnum_ne)



# 図4.13 ------------------------------------------
library(cartogram)
if (!require(albersusa)) remotes::install_github("hrbrmstr/albersusa")
library(albersusa)
us_cont <- cartogram_cont(usa_sf("laea"), "pop_2014")

plot_ly(sf::st_cast(us_cont,  "MULTIPOLYGON")) %>% 
  add_sf(
    color = ~pop_2014, 
    split = ~name, 
    span = I(1),
    text = ~paste(name, scales::label_number_si()(pop_2014)),
    hoverinfo = "text",
    hoveron = "fills"
  ) %>%
  layout(showlegend = FALSE) %>%
  colorbar(title = "Population \n 2014")



# 図4.14 ------------------------------------------
us <- usa_sf("laea")
us_dor <- cartogram_dorling(us, "pop_2014")

plot_ly(stroke = I("black"), span = I(1)) %>% 
  add_sf(
    data = us, 
    color = I("gray95"),
    hoverinfo = "none"
  ) %>%
  add_sf(
    data = us_dor, 
    color = ~pop_2014,
    split = ~name, 
    text = ~paste(name, scales::label_number_si()(pop_2014)), 
    hoverinfo = "text", 
    hoveron = "fills"
  ) %>%
  layout(showlegend = FALSE)



# 図4.15 ------------------------------------------
us <- usa_sf("laea")
us_dor <- sf::st_cast(cartogram_ncont(us, "pop_2014"), "MULTIPOLYGON")

plot_ly(stroke = I("black"), span = I(1)) %>% 
  add_sf(
    data = us_dor, 
    color = I("gray95"),
    hoverinfo = "none"
  ) %>%
  add_sf(
    data = us_dor, 
    color = ~pop_2014,
    split = ~name, 
    text = ~paste(name, scales::label_number_si()(pop_2014)), 
    hoverinfo = "text", 
    hoveron = "fills"
  ) %>%
  layout(showlegend = FALSE)
