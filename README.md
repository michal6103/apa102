# apa102
APA102 for NodeMCU

APA102 Datasheet: http://www.adafruit.com/datasheets/APA102.pdf

Nodemcu connection:
Digital pin D5 -> CI
Digital pin D7 -> DI

You will need level converter as Nodemcu uses 3v3 and APA102 uses 5V logic
Something like this: http://www.ebay.com/itm/IIC-I2C-Logic-Level-Converter-Bi-Directional-Module-5V-to-3-3V-For-Arduino-/131196183140

Frame format
Start Frame - LED Frame - End Frame

Start Frame 32bits = 0x00 0x00 0x00 0x00
LED Frame 32 bits = 111 | Global | Blue | Green | Red
Global is 5 bits
Blue, Green, Red are 8 bits each
End Frame 32 bits= 0xff 0xff 0xff 0xff






Nodemcu and ESP8266 pinout details:
ESP8266
Pin Name    GPIO    HSPI Function
MTDI    	GPIO12	MISO (DIN)
MTCK    	GPIO13	MOSI (DOUT)     ->>>>>>
MTMS    	GPIO14	CLOCK           ->>>>>>
MTDO        GPIO15	CS/SS

NODEMCU
IO index     ESP8266 pin
D5           GPIO14	 (SPI CLK)      ->>>>>>
D6           GPIO12	 (SPI MISO)
D7           GPIO13	 (SPI MOSI)     ->>>>>>
D8           GPIO15	 (SPI CS)
D9           GPIO3	 (UART RX)

