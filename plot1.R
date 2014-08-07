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
# Generate plot #1
png("plot1.png", width = 480, height = 480)
hist(DT$Global_active_power, main="Global Active Power", xlab = "Global Active Power (kilowatts)", col="red")
dev.off()
