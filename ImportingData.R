### Code comes from 'Time Series for Data Science' by Woodward, Sadler and Robertson

### Import a time series
library(tswge)

### Plot the dfw data - x-axis is an index, not time 
plot(dfw.2011, type = 'l')

### Create a time series (ts) object
dfw.2011.ts <- ts(dfw.2011, start = c(2011, 1), frequency = 12)

### Plot the ts object, it will include year on the x-axis
plot(dfw.2011.ts)

### Now grab the lynx data.
data(lynx)
class(lynx)

plot(lynx)

### To plot the time series with ggplot, convert to a dataframe
lynx.df <- data.frame(Y = as.matrix(lynx), date = time(lynx))
ggplot(lynx.df, aes(x = date, y = Y))+
  geom_point(col = "deepskyblue")+
  geom_line(col = "deepskyblue")+
  ylab("Lynx")+
  xlab("Year")+
  theme_classic()
