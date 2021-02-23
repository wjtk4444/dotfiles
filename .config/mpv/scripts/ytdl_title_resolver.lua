local mp = require 'mp'
local utils = require 'mp.utils'

mp.register_script_message("ytdl-resolve-title", function(filename)
        print('started resolving title for:', filename)
        
        -- title cannot be resolved using youtube-dl
        if not string.match(filename, "^https?://") then
            print('not a network resource')
            return
        end

        local res = io.popen('youtube-dl --flat-playlist -sJ '..
            filename):read("*all")
        local json, err = utils.parse_json(res)
        if err then
            print('error parsing json')
            return
        else 
            local playlist = json['_type'] and json['_type'] == 'playlist'
            local title = (playlist and '[playlist]: ' or '') .. json['title']
            mp.commandv('script-message', 'osc-update-title', filename, title)
        end
            
        print('finished resolving title for:', filename)
    end)
