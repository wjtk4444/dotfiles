local mp = require 'mp'

--local TARGET_DIRECTORY = '/home/wjtk4444/Videos/recordings'

mp.register_script_message('record-file', function()
        local date = os.date("%Y-%m-%d %H:%M:%S")
        local destination = string.format("%s - %s.ts", date, mp.get_property('media-title'))
        mp.commandv('dump-cache', '0', 'no', destination)
        mp.osd_message('Save file as ' .. destination)
    end)

