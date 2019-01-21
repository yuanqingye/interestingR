library(ggplot2)   # plotting on top of ggsoccer 
library(ggsoccer)  # create soccer pitch overlay
library(dplyr)     # data manipulation
library(purrr)     # create multiple dataframes for tweenr
library(tweenr)    # build frames for animation
library(gganimate) # animate plots
library(extrafont) # insert custom fonts into plots
library(ggimage)   # insert images and emoji into plots

# install.packages("https://cran.r-project.org/src/contrib/Archive/ggimage/ggimage_0.1.0.tar.gz", repo=NULL, type="source")

data <- data.frame(x = 1, y = 1)

ggplot(data) +
  annotate_pitch() +
  theme_pitch() +
  coord_flip(xlim = c(49, 101),
             ylim = c(-1, 101))

library(ggplot2)
library(dplyr)
library(ggsoccer)
library(extrafont)
library(ggimage)
library(countrycode)

cornerkick_data <- data.frame(x = 99, y = 0.3,
                              x2 = 94, y2 = 47)

osako_gol <- data.frame(x = 94, y = 49,
                        x2 = 100, y2 = 55.5)

player_label <- data.frame(x = c(92, 99), 
                           y = c(49, 2))

annotation_data <- data.frame(
  x = c(110, 105, 70, 92, 53), 
  y = c(30, 30, 45, 81, 85),
  hjust = c(0.5, 0.5, 0.5, 0.5, 0.5),
  label = c("Japan             (2) vs. Colombia             (1)",
            "Kagawa (PEN 6'), Quintero (39'), Osako (73')",
            "Japan press their man advantage, substitute Honda\ndelivers a delicious corner kick for Osako to (somehow) tower over\nColombia's defense and flick a header into the far corner!",
            "Bonus: Ospina looking confused and\ndoing a lil' two-step-or-god-knows-what.",
            "by Ryo Nakagawara (@R_by_Ryo)")
)

flag_data <- data.frame(
  x = c(110, 110),
  y = c(13, 53),
  team = c("japan", "colombia")
) %>% 
  mutate(
    image = team %>% 
      countrycode(., origin = "country.name", destination = "iso2c")
  ) %>% 
  select(-team)

wc_logo <- data.frame(x = 107,
                      y = 85) %>% 
  mutate(image = "https://upload.wikimedia.org/wikipedia/en/thumb/6/67/2018_FIFA_World_Cup.svg/1200px-2018_FIFA_World_Cup.svg.png")

ggplot(osako_gol) +
  annotate_pitch() +
  theme_pitch() +
  theme(text = element_text(family = "Dusha V5"),
        plot.margin=grid::unit(c(0,0,0,0), "mm")) +
  coord_flip(xlim = c(55, 112),
             ylim = c(-1, 101)) +
  geom_curve(data = cornerkick_data,
             aes(x = x, y = y, xend = x2, yend = y2),
             curvature = -0.15, 
             arrow = arrow(length = unit(0.25, "cm"),
                           type = "closed")) +
  geom_segment(aes(x = x, y = y, xend = x2, yend = y2),
               arrow = arrow(length = unit(0.25, "cm"),
                             type = "closed")) +
  geom_label(data = player_label, 
             aes(x = x, y = y),
             label = c("Osako", "Honda"), family = "Dusha V5") +
  geom_point(aes(x = 98, y = 50), size = 3, color = "green") +
  geom_text(aes(x = 99.7, y = 50), size = 5, label = "???", family = "Dusha V5") +
  geom_text(data = annotation_data,
            family = "Dusha V5", 
            aes(x = x, y = y,
                hjust = hjust, label = label), 
            size = c(6.5, 4.5, 4, 3.5, 3)) +
  ggimage::geom_flag(data = flag_data,
                     aes(x = x, y = y,
                         image = image),       
                     size = c(0.08, 0.08)) +
  ggimage::geom_emoji(aes(x = 95, 
                          y = 50),
                      image = "26bd", size = 0.035) +
  geom_image(data = wc_logo,
             aes(x = x, y = y,
                 image = image), size = 0.17)



pass_data <- data.frame(x = c( 84, 82),
                        y = c(  6, 32),
                        x2 = c(77, 84),
                        y2 = c(13, 8))

#                            corner kick + golovin cross
curve_data <- data.frame(x = c(100, 76),
                         y = c(0, 19),
                         x2 = c(94, 94),
                         y2 = c(35, 60))

# Saudi failed clearance, Gazinsky header
ball_data <- data.frame(x = c(94, 94),
                        y = c(35, 60),
                        x2 = c(82, 99.2),
                        y2 = c(33.5, 47.5))

# soccer ball image
goal_img <- data.frame(x = 100,
                       y = 47) %>% 
  mutate(image = "https://d30y9cdsu7xlg0.cloudfront.net/png/43563-200.png")

# golovin + zhirkov movement
movement_data <- data.frame(x = c(83, 98),
                            y = c(24.25, 2),
                            x2 = c(77, 88),
                            y2 = c(21, 6))

g <- ggplot(pass_data) +
  annotate_pitch() +
  geom_segment(aes(x = x, y = y, xend = x2, yend = y2),
               arrow = arrow(length = unit(0.25, "cm"),
                             type = "closed")) +
  geom_segment(data = ball_data,
               aes(x = x, y = y, xend = x2, yend = y2), 
               linetype = "dashed", size = 0.85,
               color = c("black", "red")) +
  geom_segment(data = movement_data,
               aes(x = x, y = y, xend = x2, yend = y2), 
               linetype = "dashed", size = 1.2,
               color = "darkgreen") +
  geom_curve(data = curve_data, 
             aes(x = x, y = y, xend = x2, yend = y2), 
             curvature = 0.25, 
             arrow = arrow(length = unit(0.25, "cm"),
                           type = "closed")) +
  # geom_image(data = goal_img,
  #            aes(x = x, y = y,
  #                image = image), 
  #            size = 0.035) +
  theme_pitch() + 
  theme(text = element_text(family = "Trebuchet MS")) +
  coord_flip(xlim = c(49, 101),
             ylim = c(-1, 101)) +
  ggtitle(label = "Russia (5) vs. (0) Saudi Arabia", 
          subtitle = "First goal, Yuri Gazinsky (12th Minute)") +
  labs(caption = "By Ryo Nakagawara (@R_by_Ryo)") +
  geom_label(aes(x = 94, y = 60, label = "Gazinsky"), hjust = -0.1) +
  geom_label(aes(x = 83, y = 23, label = "Golovin"), hjust = -0.05) +
  geom_label(aes(x = 75, y = 11, label = "Golovin"), hjust = -0.1) +
  geom_label(aes(x = 98, y = 0, label = "Zhirkov"), vjust = -0.3) +
  geom_label(aes(x = 84, y = 6, label = "Zhirkov"), vjust = -0.3) +
  annotate("text", x = 69, y = 65, family = "Trebuchet MS",
           label = "After a poor corner kick clearance\n from Saudi Arabia, Golovin picks up the loose ball, \n exchanges a give-and-go pass with Zhirkov\n before finding Gazinsky with a beautiful cross!")

ggsave(g, filename = "gazinsky_goal.png", height = 6, width = 8)