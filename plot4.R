library(data.table)

# Auxiliary function: load and process data
get_data <- function() {
    
    DT <- fread("household_power_consumption.txt", sep=";", header=TRUE)
    # fread() "bumps" all data to character class due to "?" values
    # in some rows, will need to coerce them to numeric later.
    
    # Convert Date to Date class.
    # Same as:
    # DF$Date <- as.Date(DF$Date, format="%d/%m/%Y")
    # only faster
    DT[, Date:=as.Date(Date, format="%d/%m/%Y")]

    # We need data for these two days only:
    DT2 <- DT[DT$Date=="2007-02-01"|DT$Date=="2007-02-02",]
    
    # Create a DateTime column of POSIXct type
    DT2[,DateTime:=as.POSIXct(paste(Date, Time))]
    
    # Coerce observed values to numeric
    DT2[,Global_active_power:=as.numeric(Global_active_power)]
    DT2[,Global_reactive_power:=as.numeric(Global_reactive_power)]
    DT2[,Voltage:=as.numeric(Voltage)]
    DT2[,Global_intensity:=as.numeric(Global_intensity)]
    DT2[,Sub_metering_1:=as.numeric(Sub_metering_1)]
    DT2[,Sub_metering_2:=as.numeric(Sub_metering_2)]
    DT2[,Sub_metering_3:=as.numeric(Sub_metering_3)]
    
    DT2
}

# Get the data
DT <- get_data()
# Generate plot #4
png("plot4.png", width = 480, height = 480)

# 2x2 cells, fill in rows
par(mfrow = c(2, 2))

# Sub plot #1
plot(DT$DateTime, DT$Global_active_power, xlab = "", ylab = "Global Active Power", type="l")

# Sub plot #2
plot(DT$DateTime, DT$Voltage, xlab = "datetime", ylab = "Voltage", type="l")

# Sub plot #3
plot(DT$DateTime, DT$Sub_metering_1, xlab = "", ylab = "Energy sub metering", type="l")
lines(DT$DateTime, DT$Sub_metering_2, col="red")
lines(DT$DateTime, DT$Sub_metering_3, col="blue")
legend(
    "topright",
    lty = rep("solid",3),
    col = c("black", "red", "blue"),
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    bty = "n")

# Sub plot #4
plot(DT$DateTime, DT$Global_reactive_power, xlab = "", ylab = "Global Rective Power", type="l")

dev.off()
