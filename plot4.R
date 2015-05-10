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


# Create a PNG graphics file consisting of 4 plots in a 2x2 configuration:
#    1. a histogram of the frequency for the global active power variable.
#    2. the minute averaged Voltage over time.
#    3. the 3 submetered energy usage levels in 3 different colors.
#    4. the household global minute-averaged reactive power.
# Use the default width/ height of 480 x 480 pixels. Shut down the PNG device when finished.

png("./data/plot4.png")

par(mfrow = c(2, 2),  mar = c(4, 4, 2, 1))

# sub-plot 1
plot(dataset$datetime, dataset$Global_active_power, type="l", xlab="", ylab="Global Active Power")

# sub-plot 2
plot(dataset$datetime, dataset$Voltage, type="l", xlab="datetime", ylab="Voltage")

# sub-plot 3
plot(dataset$datetime, dataset$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
points(dataset$datetime, dataset$Sub_metering_2, type="l", col="red")
points(dataset$datetime, dataset$Sub_metering_3, type="l", col="blue")
legend("topright", lty=1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# sub-plot 4
plot(dataset$datetime, dataset$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()