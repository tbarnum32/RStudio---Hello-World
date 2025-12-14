### Code comes from 'Time Series for Data Science' by Woodward, Sadler and Robertson

### Import a time series
library(tswge)

### Plot the dfw data - x-axis is an index, not time 
plot(dfw.2011, type = 'l')

### Create a time series (ts) object
dfw.2011.ts <- ts(dfw.2011, start = c(2011, 1), frequency = 12)

### Plot the ts object, it will include year on the x-axis
plot(dfw.2011.ts)
