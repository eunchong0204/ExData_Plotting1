#Package install and load.
install.packages("data.table")
install.packages("dplyr")
library(data.table)
library(dplyr)


#Download the file

if(!file.exists("./data/household_power_consumption.zip")){
        #create the data folder
        if(!file.exists("data")){
                dir.create("data")
        }
        
        #Download the file.
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile="./data/household_power_consumption.zip")
        dateDownload <- data()
        
        #Unzip the file.
        unzip("./data/household_power_consumption.zip", exdir="./data")
}

#Load the data file.
df <- data.table::fread("./data/household_power_consumption.txt"
                        , na.strings = "?")

#Filtering and as.Date.
df_modified <- df %>% 
        filter(Date == "1/2/2007" | Date == "2/2/2007") %>%
        mutate(datetime = as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S"))

#Open a device.
png("plot4.png", width=480, height=480)

# Set a partition
par(mfrow = c(2,2), mar = c(5.1, 6, 4.1, 2.1))

#Creating plots
#1
plot(df_modified[,datetime]
     , df_modified[,Global_active_power]
     , type = "l"
     , xlab = ""
     , ylab = "Global Active Power")

#2
plot(df_modified[,datetime]
     , df_modified[,Voltage]
     , type = "l"
     , xlab = "datetime"
     , ylab = "Voltage")

#3
plot(df_modified[,datetime]
     , df_modified[,Sub_metering_1]
     , type = "l"
     , xlab = ""
     , ylab = "Energy sub metering"
     , col = "black")
lines(df_modified[,datetime]
      , df_modified[,Sub_metering_2]
      , type = "l"
      , col = "red")
lines(df_modified[,datetime]
      , df_modified[,Sub_metering_3]
      , type = "l"
      , col = "blue")

#Create a legend
legend("topright"
       , col = c("black", "red", "blue")
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
       , lty = 1
       , cex = 0.7
       , bty = "n")

#4
plot(df_modified[,datetime]
     , df_modified[,Global_reactive_power]
     , type = "l"
     , xlab = "datetime"
     , ylab = "Global_reactive_power")


#Close a device
dev.off()