## Clear workspace
rm(list=ls()) 

## load data frame
householdPwrData <- read.table(
        "./data/household_power_consumption.txt", 
        header=TRUE,          ## sourcefile has header row
        sep=";",              ## data is separeted by semicolons
        na.strings = c("?"),  ## missing values are coded as '?'
        colClasses = c(
                ## (variable definitions below)
                'character',  ## Date
                'character',  ## Time
                'numeric',    ## Global_active_power
                'numeric',    ## Global_reactive_power
                'numeric',    ## Voltage
                'numeric',    ## Global_intensity
                'numeric',    ## Sub_metering_1
                'numeric',    ## Sub_metering_2
                'numeric'     ## Sub_metering_3
                ),
        stringsAsFactors=FALSE
        )

## combine Date & Time strings and convert to new POSIXlt variable  DateTime
householdPwrData$DateTime <- strptime(paste(householdPwrData$Date, householdPwrData$Time, sep=" "),"%d/%m/%Y %H:%M:%S")

## select target date range (ie - 1/2/2007 ≤ t ≤ 2/2/2007 )
householdPwrTarget <- subset(
        householdPwrData, 
        DateTime >= as.Date("1/2/2007 00:00:00", "%d/%m/%Y %H:%M:%S") 
        & DateTime < as.Date("3/2/2007 00:00:00", "%d/%m/%Y %H:%M:%S")
        )


## Set multipanel plot : 2xs
par(mfrow=c(2,2), mar = c(4, 4, 2, 1), oma = c(0, 0, 0, 0))

## Generate plot
with(householdPwrTarget, {
        ## Plot 1 - Global Active Power
        plot(DateTime, Global_active_power, 
             ylab="Global Active Power", xlab="", type="l")
        
        ## Plot 2 - Voltage
        plot(DateTime, Voltage, 
             ylab="Voltage", xlab="", type="l")
        
        ## Plot 3 - Energy Sub-Metering
        plot(DateTime, Sub_metering_1, ylab="Energy Sub-Metering", xlab="", type = "n")
        lines(DateTime, Sub_metering_1, col="Black")
        lines(DateTime, Sub_metering_2,col='Red')
        lines(DateTime, Sub_metering_3,col='Blue')
        legend("topright", 
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               col= c("black", "red", "blue"), lty="solid", cex=0.75, bty="n")
        
        ## Plot 4 j- Global Reactive Power
        plot(DateTime, Global_reactive_power, 
             ylab="Global Reactive Power", xlab="", type="l")
        }
     )

## Copy screen plot to .png
dev.copy(png,"plot4.png", width=480, height=480)
dev.off()



## ******************************** 
## VARIABLE DEFINITIONS
## 
## Date:
##      Date in format dd/mm/yyyy
## Time: 
##      time in format hh:mm:ss
## Global_active_power: 
##      household global minute-averaged active power (in kilowatt)
## Global_reactive_power: 
##      household global minute-averaged reactive power (in kilowatt)
## Voltage: 
##      minute-averaged voltage (in volt)
## Global_intensity: 
##      household global minute-averaged current intensity (in ampere)
## Sub_metering_1: 
##      energy sub-metering No. 1 (in watt-hour of active energy). 
##      It corresponds to the kitchen, containing mainly a dishwasher, an  
##      oven and a microwave (hot plates are not electric but gas powered).
## Sub_metering_2: 
##      energy sub-metering No. 2 (in watt-hour of active energy). 
##      It corresponds to the laundry room, containing a washing-machine, 
##      a tumble-drier, a refrigerator and a light.
## Sub_metering_3: 
##      energy sub-metering No. 3 (in watt-hour of active energy). 
##      It corresponds to an electric water-heater and an air-conditioner.
## 

