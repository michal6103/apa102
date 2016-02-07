
strip_apa102 = {
	-- FRAME = Start GlobalX BX GX RX End
	-- BX, RX, GX are repeated for every LED on the LED strip
	-- FRAME_START is defined in specs
    FRAME_START = string.rep(string.char(0x00),4),
	-- FRAME_END is defined as a wait time to propagate all the data to the last LED
	-- Length in bits should be count of LEDs divided by 2. We will use 2 bytes without initialization
    FRAME_END = string.rep(string.char(0xff),2),
    SPI_ID = 1,
    SPI_CLOCK_DIVIDER = 1,
    SPI_CS_PIN = 8,
    FRAME_GLOBAL_CONSTANT = 0xe0    -- constant added to every brightness frame
}



function strip_apa102.init()
    -- Set GPIO 8 to High to enable SPI_CS_PIN
    gpio.mode(strip_apa102.SPI_CS_PIN, gpio.OUTPUT)
    gpio.write(strip_apa102.SPI_CS_PIN, gpio.LOW)
    spi.setup(strip_apa102.SPI_ID, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, spi.DATABITS_8, strip_apa102.SPI_CLOCK_DIVIDER)
end


function strip_apa102.write(brightness, data)
    -- Write out a string of bytes to the strip_apa102 lights
    -- @param number brightness - 5 bits representing brightness for whole pixel. Values: 0-31
    -- @param string data - a string of bytes in bgr order to write


    local led_count = string.len(data) / 3
	-- One bit per LED pause between frames
	strip_apa102.FRAME_END = string.rep(string.char(0xff), led_count / 8)

    --check brightneess range and prepare global brightness frame
	brightness = math.floor(brightness)
    if brightness < 0 then
        brightness = 31
    end
    if brightness > 31 then
        brightness = 31
    end
    local brightness_char = string.char(strip_apa102.FRAME_GLOBAL_CONSTANT + brightness)

    local data_table = {}
	--Frame start
	data_table[1] = strip_apa102.FRAME_START
	-- add brightness byte before each BGR bytes
    for i = 1, #data-1, 3 do
        data_table[2+(i-1)/3] = brightness_char..data:sub(i, i+2)
    end
	-- Frame end
	data_table[#data_table+1] = strip_apa102.FRAME_END

    output_buffer = table.concat(data_table)

    for i=1,#output_buffer do
        print(string.format('%02X', output_buffer:byte(i)))
    end

    return spi.send(strip_apa102.SPI_ID, output_buffer)
end

