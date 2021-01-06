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
png("plot3.png", width=480, height=480)

#Creating a plot
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
       , cex = 1)

#Close a device
dev.off()
