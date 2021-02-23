local mp = require 'mp'

local file_history = {}
local current = 0

local command = false

function file_loaded()
	local path = mp.get_property('path')
	if path and command == false then
		table.insert(file_history, path)
		current = #file_history
	end
	
	command = false
end
mp.register_event('file-loaded', file_loaded)


function back()
	if tonumber(current) > 1 then
		current = current - 1
		mp.osd_message('Opening file: ' .. file_history[current])
		command = true
		mp.commandv('loadfile', file_history[current], 'replace')
	else
		mp.osd_message('Could not open previous file')
	end
end

function forward()
	if tonumber(current) < #file_history then
		current = current + 1
		mp.osd_message('Opening file: ' .. file_history[current])
		command = true
		mp.commandv('loadfile', file_history[current], 'replace')
	else
		mp.osd_message('Could not open next file')
	end
end


-- handle commands
function history(command)
    if command == 'back' then
        back()
    elseif command == 'forward' then
        forward()
    else
        print('invalid usage of `history <back | forward>`')
    end
end

mp.register_script_message('history', history)
