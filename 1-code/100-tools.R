library(tidyverse)
library(ggplot2)

base_theme <-
  theme_bw() +
  theme(
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 12),
    strip.text = element_text(size = 12),
    strip.background = element_blank()
  )


material_color <-
  c("coated" = "#C0392BFF", "uncoated" = "#8E44ADFF")
