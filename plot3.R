# This script creates a plot to examine how household energy usage varies over a 2-day period in 
# February, 2007. The data examined is th “Individual household electric power consumption Data Set”
# from the UC Irvine Machine Learning Repository. This data set contains measurements of electric 
# power consumption in one household with a one-minute sampling rate over a period of almost 4 
# years. Different electrical quantities and some sub-metering values are available.


# This script utilizes the sqldf package to perform SQL selects. Load the sqldf package.

require(sqldf)


# Create a directory called data to use for this script. If the directory already exists, it will 
# not be overwritten nor will an error message be displayed.

dir.create("./data", showWarnings = FALSE)


# Download and unzip the information to the data directory.

fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file (fileurl, "./data/power.zip", method = "curl")
unzip("./data/power.zip", exdir = "./data")


# Use the read.csv.sql function from sqldf to read the downloaded data into R, filtering it for the 
# analysis dates with the included sql select statement.

dataset <- read.csv.sql("./household_power_consumption.txt", sql = "select * from file where Date like '1/2/2007' or Date like '2/2/2007'", sep = ";")


# Combine the chr columns into a new list, datetime. Use strptime to convert the chr values to objects
# of class "POSIXlt" and "POSIXct" representing calendar dates and times. Add the new list to dataset
# as a column. This is done to allow computations to be performed on the date/ time for plotting.

datetime <- strptime(paste (dataset$Date, dataset$Time), format = "%d/%m/%Y %H:%M:%S")
dataset <- cbind(dataset[ , 1:2], datetime, dataset[ , 3:9])


# Create a PNG graphics file of the plot  of the 3 submetered energy usage levels in 3 different colors.  and air conditioning.
# Use plot to create the initial plot of one value. Use points to add the additional data.
# Use legend to create a key to the data in the top right of the plot.
# Use the default width/ height of 480 x 480 pixels. Shut down the PNG device when finished.

png("./data/plot3.png")

plot(dataset$datetime, dataset$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
points(dataset$datetime, dataset$Sub_metering_2, type="l", col="red")
points(dataset$datetime, dataset$Sub_metering_3, type="l", col="blue")

legend("topright", lty=1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
