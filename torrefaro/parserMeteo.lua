require "io"
io.input(daily.txt)
while true do
	local time, WindDir, WindSpd, WindGust, Humidity, Temp, TotRain, UV, SolarWind, DewPoint, BaromSL, DailyRain, HourRain= io.read("*time", "*number", "*number", "*number", "*number", "*number", "*number", "*number", "*number", "*number", "*number", "*number", "*number", "*number", "*number", "*number")
	if not n1 then breack
	end
	-- do something with data
	print(math.max(n1, n2, n3))
end
-- Example data
--Time         Wind Dir   Wind Spd  Wind Gust   Humidity       Temp   Tot Rain         UV      Solar Wind Chill Heat Index  Dew Point   Barom SL  DailyRain   HourRain   RainRate
-- hr:mm	°      km/hr      km/hr          %         °C         mm                 W/sqm         °C         °C         °C        hPa         mm         mm      mm/hr

-- 18:30             238       12.9       12.9         76       16.4      547.0        0.0          0       16.1       18.5       12.2     1020.8        0.0        0.0       0.00
