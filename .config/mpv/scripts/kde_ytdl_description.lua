local mp = require 'mp'
local utils = require 'mp.utils'

function kde_ytdl_description()
    local path = mp.get_property('path')
    if not path or not string.match(path, "^https?://") then 
        mp.osd_message('youtube-dl works only with network streams', 5)
        return 
    end

    mp.osd_message('Fetching video description...')

    local result = io.popen('xdotool getwindowfocus getwindowgeometry'):read('*all')
    local left, top, width, height = string.match(result, ".-(%d+),(%d+).-(%d+)x(%d+)")

    local new_width = math.floor(width * 0.8)
    local new_height = math.floor(height * 0.8)
    local w_diff_2 = math.floor((width - new_width) /2 )
    local h_diff_2 = math.floor((height - new_height) /2 )
    local geometry = string.format('%sx%s+%s+%s', new_width, new_height, left + w_diff_2, top + h_diff_2)

    io.popen(string.format([[
            { echo -e "Video description (%s)\n\n\n" \
            & youtube-dl --get-description "%s"; } \
            | kdialog --geometry %s --textbox - ]],
             mp.get_property('media-title'), path, geometry))
end

mp.register_script_message('kde-ytdl-description', kde_ytdl_description)
