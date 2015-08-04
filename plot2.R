# prepare some constants
data.sourceurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
data.zipfilename <- "exdata.zip"
data.textfilename <- "household_power_consumption.txt"
outputfilename <- "plot2.jpg"

# check if data exists or get it
if (!file.exists(data.zipfilename)) {
    download.file(data.sourceurl, destfile=data.zipfilename)
}

# check if unzipped data exists or unzip it
if (!file.exists(data.textfilename)) {
    unzip(data.zipfilename)
}

# prepare to read date and time column
setClass("powerDate")
setAs("character","powerDate", function(from) as.Date(from, format="%d/%m/%Y") )

# read data file
# we will only be using data from the dates 2007-02-01 and 2007-02-02
powerconsumption <- read.table(data.textfilename, header = TRUE, sep = ";", 
                        na.strings = "?",
                        colClasses = c("powerDate", "character", rep("numeric", 7))
                    )

# subsetting for dates 2007-02-01 and 2007-02-02
pc <- powerconsumption[powerconsumption$Date >= as.Date("2007-02-01") & powerconsumption$Date <= as.Date("2007-02-02"),]
# add colum with date plus time
pc$DateTime <- strptime(paste(pc$Date, pc$Time, sep=" "), "%Y-%m-%d %H:%M:%S")

# to show english weekdays
curr_locale <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

png(file = outputfilename, width = 480, height = 480)
with(pc, plot(pc$DateTime, pc$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()

# reset to system language
Sys.setlocale("LC_TIME", curr_locale)
