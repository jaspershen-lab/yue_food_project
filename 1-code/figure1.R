library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1-code/100-tools.R')

data1 <-
  readxl::read_xlsx("2-data/data1.xlsx")

dir.create("3-data_analysis/figure1")

setwd("3-data_analysis/figure1")

colnames(data1)[1] <- "time"
colnames(data1)[2] <- "Burger_coated1"
colnames(data1)[3] <- "Burger_coated2"
colnames(data1)[4] <- "Burger_coated3"

colnames(data1)[5] <- "Beef_coated1"
colnames(data1)[6] <- "Beef_coated2"
colnames(data1)[7] <- "Beef_coated3"

colnames(data1)[8] <- "Burger_uncoated1"
colnames(data1)[9] <- "Burger_uncoated2"
colnames(data1)[10] <- "Burger_uncoated3"

colnames(data1)[11] <- "Beef_uncoated1"
colnames(data1)[12] <- "Beef_uncoated2"
colnames(data1)[13] <- "Beef_uncoated3"

data1 <-
  data1 %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    burger_coated_mean = mean(c_across(Burger_coated1:Burger_coated3)),
    burger_coated_sd = sd(c_across(Burger_coated1:Burger_coated3)),
    beff_coated_mean = mean(c_across(Beef_coated1:Beef_coated3)),
    beff_coated_sd = sd(c_across(Beef_coated1:Beef_coated3)),
    burger_uncoated_mean = mean(c_across(Burger_uncoated1:Burger_uncoated3)),
    burger_uncoated_sd = sd(c_across(Burger_uncoated1:Burger_uncoated3)),
    beff_uncoated_mean = mean(c_across(Beef_uncoated1:Beef_uncoated3)),
    beff_uncoated_sd = sd(c_across(Beef_uncoated1:Beef_uncoated3))
  ) %>%
  ungroup()

data1_mean <-
  data1 %>%
  dplyr::select(time, dplyr::contains("mean")) %>%
  tidyr::pivot_longer(cols = -time,
                      names_to = "variable",
                      values_to = "mean") %>%
  dplyr::mutate(food_group = ifelse(grepl("burger", variable), "burger", "beef")) %>%
  dplyr::mutate(material = ifelse(grepl("uncoated", variable), "uncoated", "coated")) %>%
  dplyr::select(-variable)

data1_sd <-
  data1 %>%
  dplyr::select(time, dplyr::contains("sd")) %>%
  tidyr::pivot_longer(cols = -time,
                      names_to = "variable",
                      values_to = "sd") %>%
  dplyr::mutate(food_group = ifelse(grepl("burger", variable), "burger", "beef")) %>%
  dplyr::mutate(material = ifelse(grepl("uncoated", variable), "uncoated", "coated")) %>%
  dplyr::select(-variable)


data1 <-
  data1_mean %>%
  dplyr::left_join(data1_sd, by = c("time", "food_group", "material"))

plot1 <-
  data1 %>%
  dplyr::filter(food_group == "burger") %>%
  ggplot(aes(x = time, y = mean)) +
  geom_point(aes(color = material)) +
  geom_errorbar(aes(
    ymin = mean - sd,
    ymax = mean + sd,
    color = material
  ), width = 0.2) +
  base_theme +
  labs(x = "Time (min)", y = "Temperature") +
  scale_color_manual(values = material_color)

plot1

ggsave(plot1,
       filename = "burger.pdf",
       width = 8,
       height = 6)


plot2 <-
  data1 %>%
  dplyr::filter(food_group == "beef") %>%
  ggplot(aes(x = time, y = mean)) +
  geom_point(aes(color = material)) +
  geom_errorbar(aes(
    ymin = mean - sd,
    ymax = mean + sd,
    color = material
  ), width = 0.2) +
  base_theme +
  labs(x = "Time (min)", y = "Temperature") +
  scale_color_manual(values = material_color)

plot2

ggsave(plot2,
       filename = "beef.pdf",
       width = 8,
       height = 6)
