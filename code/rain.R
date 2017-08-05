#http://my.sfwmd.gov/nexrad/jsp/nexrad_main.jsp

#load raindar
raindar <- read.table(file.path("data", "rain", "NexradRainData.txt"), skip = 5)
raindar <- raindar[raindar[,7] != "NRT",]
names(raindar)[c(3,5)] <- c("date", "C111.rain")
raindar <- raindar[,c(3,5)]
raindar$date <- as.POSIXct(strptime(raindar$date, format = "%m/%d/%Y"))
raindar$date <- strftime(raindar$date, format = "%Y-%m")
raindar$date <- as.POSIXct(strptime(paste0(raindar$date, "-01"), format = "%Y-%m-%d"))

#load gage data
gage <- read.csv(file.path("data", "rain", "ENPOps_rain.csv"))
gage <- gage[,c("date", "TaylorSlough", "C.111.basin")]
gage$date <- as.POSIXct(strptime(gage$date, format = "%m/%d/%Y"))
gage$date <- as.character(strftime(gage$date, format = "%Y-%m"))

library(dplyr)
gage <- data.frame(summarise_each(group_by(gage, date), funs(sum)))

gage$date <- as.POSIXct(strptime(paste0(gage$date, "-01"), 
                                 format = "%Y-%m-%d"))

#merge gage data with raindar
gage_v_raindar <- merge(raindar, gage)
plot(gage_v_raindar[,3], gage_v_raindar[,2], xlab = "Gage", ylab = "Raindar", xlim = c(0, 15), ylim = c(0, 15))
abline(a=0, b=1, col = "red", lwd = 2)
legend("topleft", legend = "one-to-one_line")

library(ggplot2)
gg <- ggplot(gage_v_raindar)
gg <- gg + geom_line(aes(x = date, y = TaylorSlough))
#gg <- gg + geom_line(aes(x = date, y = C.111.basin), color = "red")
gg <- gg + theme_bw() + labs(x = "", y = "Watershed Precipitation (in)") + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        axis.text = element_text(size = 12), 
        axis.title = element_text(size = 12, face = "bold"))
gg
ggsave("figures/rain.png", width = 4, height = 3)

# #load raindar
# raindar <- read.table(file.path("data", "rain", "NexradRainData.txt"), skip = 5)
# raindar <- raindar[raindar[,7] != "NRT",]
# names(raindar)[c(3,5)] <- c("date", "C111.rain")
# raindar <- raindar[,c(3,5)]
# raindar$date <- as.POSIXct(strptime(raindar$date, format = "%m/%d/%Y"))
# raindar$date <- strftime(raindar$date, format = "%Y-%m")
# raindar$date <- as.POSIXct(strptime(paste0(raindar$date, "-01"), format = "%Y-%m-%d"))
# 
# #load gage data
# gage <- read.csv(file.path("data", "rain", "ENPOps_rain.csv"))
# gage <- gage[,c("date","TaylorSlough", "C.111.basin")]
# gage$date <- as.POSIXct(strptime(gage$date, format = "%m/%d/%Y"))
# gage$date <- as.character(strftime(gage$date, format = "%Y-%m"))
# 
# library(dplyr)
# gage <- data.frame(summarise_each(group_by(gage, date), funs(sum)))
# gage$date <- as.POSIXct(strptime(paste0(gage$date, "-01"), format = "%Y-%m-%d"))
# 
# #merge gage data with raindar
# gage_v_raindar <- merge(raindar, gage)
# # plot(gage_v_raindar[,3], gage_v_raindar[,2], xlab = "Gage", ylab = "Raindar", xlim = c(0, 15), ylim = c(0, 15))
# # abline(a=0, b=1, col = "red", lwd = 2)
# # legend("topleft", legend = "one-to-one_line")
# 
# library(ggplot2)
# gg <- ggplot(gage_v_raindar)
# gg <- gg + geom_line(aes(x = date, y = TaylorSlough))
# #gg <- gg + geom_line(aes(x = date, y = C.111.basin), color = "red")
# gg <- gg + theme_bw() + labs(x = "", y = "Precipitation (in)") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.text = element_text(size = 12), axis.title = element_text(size = 12, face = "bold"))
# gg