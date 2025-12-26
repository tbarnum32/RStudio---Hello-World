### Retrieve stream gage data for time series analysis
library(dataRetrieval)
library(ggplot2)
library(dplyr)

## Find active USGS gages in Maryland
out.sf <- dataRetrieval::read_waterdata_monitoring_location(
    state_name = "Maryland", 
    properties = c("monitoring_location_id", "state_name", "hydrologic_unit_code"))

md.gages <- dataRetrieval::read_waterdata_monitoring_location(
  state_name = "Maryland", 
  site_type = "Stream",
  properties = c("monitoring_location_id"))

### Plot all known gages
ggplot(data = out.sf) +
  geom_sf()

# Note, this downloads all records that fit the query, 
#  meaning that there are duplicate monitoring location ids in this sf
active.sites <- dataRetrieval::read_waterdata_ts_meta(
  last_modified = "P13M",
  parameter_name = "Discharge",
  properties = c("monitoring_location_id", "computation_period_identifier")
) 
active.list <- unique(active.sites$monitoring_location_id)

# Create new field in wi_gages for active in past 13 months
md.gages <- md.gages %>%
  dplyr::mutate(active_gage = 
                  case_when(monitoring_location_id %in% active.list ~ "active",
                            TRUE ~ "inactive"))

# plot
ggplot(data = md.gages) +
  geom_sf(aes(color = active_gage, size = active_gage)) +
  # print active sites on top
  geom_sf(data = md.gages |> dplyr::filter(active_gage == "active"),
          color = "black", size = 1) +
  scale_color_manual(values = c("red", "grey60")) +
  scale_size_manual(values = c(2, 1)) +
  theme_void() + 
  theme(legend.position = "bottom")

active.md <- filter(md.gages, active_gage == "active")
active.md.list <- split(active.md, active.md$monitoring_location_id)

cont.water <- purrr::map(active.md.list[1:100], ~read_waterdata_latest_continuous(monitoring_location_id = paste(.$monitoring_location_id)))


one.gage <- dataRetrieval::read_waterdata_monitoring_location(
    monitoring_location_id = "USGS-01491000", 
    properties = c("monitoring_location_id", "state_name", "hydrologic_unit_code"))

site <- "USGS-01491000"

data_at_site <- summarize_waterdata_samples(monitoringLocationIdentifier = site)
View(data_at_site)

user.char <- "Discharge, instantaneous"
water.data <- read_waterdata_samples(monitoringLocationIdentifier = site,
                                    characteristicUserSupplied = user.char)
