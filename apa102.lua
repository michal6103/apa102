-- Libraty for APA102 used on Nodemcu
-- Usage:
--	apa102.init()
--	data is string with 3 bytes for each pixel
--	apa102.write(31, data)


apa102 = {
    FRAME_START = string.rep(string.char(0x00),4),
    FRAME_END = string.rep(string.char(0xff),2),
    SPI_ID = 1,
    SPI_CLOCK_DIVIDER = 10,
    SPI_CS_PIN = 8,
    FRAME_GLOBAL_CONSTANT = 0xe0    -- cosntant added to every brightness frame
}



function apa102.init()
    -- Set GPIO 8 to High to enable SPI_CS_PIN
    gpio.mode(apa102.SPI_CS_PIN, gpio.OUTPUT)
    gpio.write(apa102.SPI_CS_PIN, gpio.LOW)
    spi.setup(apa102.SPI_ID, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, spi.DATABITS_8, apa102.SPI_CLOCK_DIVIDER)
end


function apa102.write(brightness, data)
    -- Write out a string of bytes to the apa102 lights
    -- @param number brightness - 5 bits representing brightness for whole pixel. Values: 0-31
    -- @param string data - a string of bytes in bgr order to write. 3 bytes for every pixel


    local output_buffer = ""
    local payload = ""

    local led_count = string.len(data) / 3

    --check brightneess range and prepare global brightness frame
    if brightness > 31 then
        brightness = 31
    end
    local brightness_char = string.char(apa102.FRAME_GLOBAL_CONSTANT + brightness)

    local data_table = nil
    data_table = {}
    for i = 1, #data-1, 3 do
        data_table[1+(i-1)/3] = data:sub(i, i+2)
    end

     for i=1,led_count do
      payload = payload..brightness_char..data_table[i] 
    end

    output_buffer = apa102.FRAME_START..payload..apa102.FRAME_END

    for i=1,#output_buffer do
        print(string.format('%02X', output_buffer:byte(i)))
    end

    return spi.send(apa102.SPI_ID, output_buffer)
end

