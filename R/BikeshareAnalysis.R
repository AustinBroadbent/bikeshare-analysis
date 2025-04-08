library(tidyverse)
library(showtext) 

####Formatting & Values --------------------------------------------------------
font_add_google("Questrial", "questrial") 
font_add_google("Nunito", "nunito")
showtext_auto()

background_color <- "#f5f5f5" #Plot design colors
text_color <- "#3f4252"

rider_colors <- c("casual" = "#F9918A", "member" = "#33CCD0")
rider_labels <- c("Casual Riders", "Members")

bike_colors <- c("electric_scooter" = "#FF7F50", "electric_bike" = "#33C860", "classic_bike" = "#81B0FF")
bike_labels <- c("Classic Bike", "Electric Bike", "Electric Scooter") # Labels for rideable type plot

hour_labels <- setNames(format(strptime(0:23, format = "%H"), "%l %p"), 0:23) #Formatting for x-axis of hourly plots
breaks_seq <- seq(0, 23, by = 4)
labels_seq <- hour_labels[as.character(breaks_seq)]


#### Dataframe Creation --------------------------------------------------------

#Full dataframe
df <- read_csv("C:/Users/Administrator/Downloads/cleaned_bikeshare_data.csv")
df <- df |> select(c(ride_id, member_casual, rideable_type, started_at, ended_at, ride_duration_minutes)) #Only needed columns

df$started_at <- ymd_hms(df$started_at, tz="UTC") #Extract time components
df <- df |> 
  mutate(
    hour = hour(started_at),
    weekday = weekdays(started_at),
    month = month(started_at)
  )
day_order <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday") #Order weekdays for plotting
df$weekday <- factor(df$weekday, levels = day_order, ordered = TRUE)

#Rider Type
rider_type <- df |> 
  group_by(member_casual) |> 
  summarize(ride_count = n(),
            avg_duration = mean(ride_duration_minutes))

#Ride Preferences
ride_preference <- df |> 
  group_by(member_casual, rideable_type) |> 
  summarize(ride_count = n())

#Hourly
hourly_rider_type <- df |> 
  group_by(member_casual, hour) |>
  summarize(ride_count = n(),
            avg_duration = mean(ride_duration_minutes))

#Weekday
weekday_rider_type <- df |> 
  group_by(member_casual, weekday) |>
  summarize(ride_count = n(),
            avg_duration = mean(ride_duration_minutes))

#Monthly
monthly_rider_type <- df |>
  group_by(member_casual, month) |> 
  summarize(ride_count = n(),
            avg_duration = mean(ride_duration_minutes))

rm(df) #save space by removing the original dataframe from memory

#### Summary Statistics --------------------------------------------------------

duration_stats <- df |> 
  group_by(member_casual) |> 
  summarize(
    n = n(),
    avg_duration = mean(ride_duration_minutes),
    median_duration = median(ride_duration_minutes),
    sd_duration = sd(ride_duration_minutes),
    min_duration = min(ride_duration_minutes),
    max_duration = max(ride_duration_minutes),
    q25_duration = quantile(ride_duration_minutes, 0.25),
    q75_duration = quantile(ride_duration_minutes, 0.75)
  )

#### Visualizations ------------------------------------------------------------

#Total Number of Rides
ggplot(rider_type, aes(x = member_casual, y = ride_count, fill = member_casual)) +
  geom_bar(stat = "identity", color = text_color) +
  labs(
    title = "Total Number of Rides",
    subtitle = "Casual Riders vs. Members",
    fill = "Rider Type"
  ) +
  geom_text(aes(label = c("1,495,902","2,609,532"), vjust = 2), color = background_color, size = 5) + 
  scale_fill_manual(values = rider_colors, labels = rider_labels) +
  theme_void() + 
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),                             
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color)
  )

#Total Average Duration
ggplot(rider_type, aes(x = member_casual, y = avg_duration, fill = member_casual)) +
  geom_bar(stat = "identity", color = text_color) +
  labs(
    title = "Total Average Duration in Minutes",
    subtitle = "Casual Riders vs. Members",
    fill = "Rider Type"
  ) +
  geom_text(aes(label = c("23:06", "12:15"), vjust = 2), color = background_color, size = 5) + 
  scale_fill_manual(values = rider_colors, labels = rider_labels) + 
  theme_void() + 
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),                            
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color)
  )

#Rideable Type
ggplot(ride_preference, aes(fill = rideable_type, y = member_casual, x = ride_count)) +
  geom_bar(position = "dodge", stat = "identity", color = text_color, alpha = 0.8) +
  labs(
    title = "Bike Preferences",
    subtitle = "Casual Riders vs. Members",
    fill = "Bike Type",
    y = element_blank(),
    x = "Number of Rides"
  ) +
  scale_fill_manual(values = bike_colors, labels = bike_labels) +
  scale_x_continuous(labels = scales::comma,) +
  scale_y_discrete(labels = c("Casual", "Member")) +
  theme_minimal() +
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color)
  )

#Hourly Ride Count
ggplot(hourly_rider_type, aes(x = hour, y = ride_count, fill = member_casual)) +
  geom_col(position = "dodge", color = text_color, alpha = 0.8) +  
  labs(
    title = "Ride Distribution by Hour",
    subtitle = "Comparison of Members vs. Casual Riders",
    x = element_blank(),
    y = "Number of Rides",
    fill = "Rider Type"
  ) +
  scale_x_continuous(breaks = breaks_seq, labels = labels_seq) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = rider_colors, labels = rider_labels) +
  facet_wrap(~member_casual,labeller = as_labeller(c("casual" = "Casual Riders", "member" = "Members"))) +
  theme_minimal() + 
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),
    strip.text = element_text(colour = text_color),
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_blank()
    )

#Hourly Average Duration
ggplot(hourly_rider_type, aes(x = hour, y = avg_duration, color = member_casual)) +
  geom_line(linewidth = 2.5, color = text_color, aes(group = member_casual)) +
  geom_line(linewidth = 2, aes(group = member_casual)) +
  geom_point(size = 4) +
  geom_point(size = 4, color = text_color, shape = 1) +
  labs(
    title = "Average Duration by Hour",
    subtitle = "Comparison of Members vs. Casual Riders",
    x = element_blank(),
    y = "Average Duration (minutes)",
    color = "Rider Type"
  ) +
  scale_x_continuous(breaks = breaks_seq, labels = labels_seq) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = rider_colors, labels = rider_labels) +
  theme_minimal() + 
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_blank()
  )

#Weekday Ride Count
ggplot(weekday_rider_type, aes(x = start_weekday, y = ride_count, fill = member_casual)) +
  geom_col(position = "dodge", color = text_color, alpha = 0.8) +  
  labs(
    title = "Ride Distribution by Weekday",
    subtitle = "Comparison of Members vs. Casual Riders",
    x = element_blank(),
    y = "Number of Rides",
    fill = "Rider Type") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = rider_colors, labels = rider_labels) +
  facet_wrap(~member_casual,labeller = as_labeller(c("casual" = "Casual Riders", "member" = "Members"))) +
  theme_minimal() + 
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),
    strip.text = element_text(colour = text_color),
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_blank()
  )

#Weekday Average Duration
ggplot(weekday_rider_type, aes(x = start_weekday, y = avg_duration, color = member_casual)) +
  geom_line(linewidth = 2.5, color = text_color, aes(group = member_casual)) +
  geom_line(linewidth = 2, aes(group = member_casual)) +
  geom_point(size = 4) +
  geom_point(size = 4, color = text_color, shape = 1) +
  labs(
    title = "Average Duration by Weekday",
    subtitle = "Comparison of Members vs. Casual Riders",
    x = element_blank(),
    y = "Average Duration (minutes)",
    color = "Rider Type"
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = rider_colors, labels = rider_labels) +
  theme_minimal() +  
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_blank()
  )

#Monthly Ride Count
ggplot(monthly_rider_type, aes(x = month, y = ride_count, fill = member_casual)) +
  geom_col(position = "dodge", color = text_color, alpha = 0.8) +  
  labs(
    title = "Ride Distribution by Month",
    subtitle = "Comparison of Members vs. Casual Riders",
    x = element_blank(),
    y = "Number of Rides",
    fill = "Rider Type") +
  scale_x_discrete(limits = month.name[1:12], labels = month.name[1:12]) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = rider_colors, labels = rider_labels) +
  facet_wrap(~member_casual,labeller = as_labeller(c("casual" = "Casual Riders", "member" = "Members"))) +
  theme_minimal() +
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),
    strip.text = element_text(colour = text_color),
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_blank()
  )

#Monthly Average Duration
ggplot(monthly_rider_type, aes(x = month, y = avg_duration, color = member_casual)) +
  geom_line(linewidth = 2.5, color = text_color, aes(group = member_casual)) +
  geom_line(linewidth = 2, aes(group = member_casual)) +
  geom_point(size = 4) +
  geom_point(size = 4, color = text_color, shape = 1) +
  labs(
    title = "Average Duration by Month",
    subtitle = "Comparison of Members vs. Casual Riders",
    x = element_blank(),
    y = "Average Duration (minutes)",
    color = "Rider Type"
  ) +
  scale_x_discrete(limits = month.name[1:12], labels = month.name[1:12]) +
  scale_y_continuous(labels = scales::comma) +
  scale_color_manual(values = rider_colors, labels = rider_labels) +
  theme_minimal() +  
  theme(
    plot.margin = margin(t = 10, r = 10, b = 10, l = 10),
    plot.title = element_text(family = "questrial", face = "bold", color = text_color),
    text = element_text(family = "nunito", color = text_color),
    plot.background = element_rect(fill = background_color, color = background_color),
    panel.background = element_rect(fill = background_color, color = background_color),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_blank()
  )
