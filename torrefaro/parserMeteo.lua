require "io"
io.input(daily.txt)
while true do
	local time, n1, n2, n3. n4, n5 = io.read("*number", "*number", "*number", "*number", "*number", "*number")
	if not n1 then breack end
	-- do something with data
	print(math.max(n1, n2, n3))
end