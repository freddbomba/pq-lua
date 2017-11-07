-- http://lua-users.org/wiki/FileInputOutput
-- scarica l'ultima versione del file con curl
-- ogni quanto?

require 'textutils'require 'textutils'


t=os.execute('curl http://torrefarometeo.altervista.org/daily.txt | tail -n 1 > daily.txt')

--First lets read the file and put the contents in a table name tContents
local file = io.open("daily.txt", "r")
print('started the parsing')
sContents = file:read() -- capture file in a string
if sContents then
   tContents = textutils.unserialize(sContents)
  else
        tContents = {}
end
print (sContents)
file:close()
tContents = textutils.serializeJSON (os.execute('curl http://torrefarometeo.altervista.org/daily.txt | tail -n 1 > daily.txt'))-- convert string to table
--Print a specific line

print (tContents[3])


