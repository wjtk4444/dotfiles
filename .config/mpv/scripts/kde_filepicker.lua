local mp = require 'mp'
local utils = require 'mp.utils'

function get_absolute_path()
    local path = mp.get_property('path', nil)
    if path and not string.match(path, "^https?://") then
        return utils.join_path(mp.get_property('working-directory', ''), path)
    end

    return nil
end

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

function show_open_dialog(name, args)
    local path = get_absolute_path()
    if path and not starts_with(path, '/home/wjtk4444/Pictures/mpv_waifus/') then
        args = args .. ' "' .. path .. '"'
    end

    local handle = io.popen('kdialog ' .. args)
    if not handle then
        mp.osd_message('Error opening ' .. name .. ' dialog\n' .. 
            'Make sure kdialog is installed.', 5)
        return
    end

    local result = handle:read("*all")
    if result == '' then
        mp.osd_message('No ' .. name .. ' selected')
        return
    end

    result = string.sub(result, 1, -2)
    local _, filename = utils.split_path(result)
	mp.commandv('loadfile', result, 'replace')
end

function locate_current_file()
    local path = get_absolute_path()
    if not path then
        mp.osd_message('No file', 5)
        return
    elseif string.match(path, "^https?://") then
        mp.osd_message('Currently openened file is a network resource')
        return
    end

    local handle = io.popen('dolphin --select "' .. path .. '" & disown')
    if not handle then
        mp.osd_message('Error opening ' .. path .. '\n' .. 
            'Make sure dolphin is installed.', 5)
        return
    end

    local _, filename = utils.split_path(path)
    mp.osd_message('Opening file ' .. filename .. ' in dolphin', 5)
end


-- handle commands
function kde_filepicker(command, argument)
    if command == 'open' then
        if argument == 'file' then
            show_open_dialog('file', '--getopenfilename') 
        elseif argument == 'directory' then
            show_open_dialog('directory', '--getexistingdirectory')
        else
            print('invalid usage of `kde_filepicker open <file | directory>`')
        end
    elseif command == 'locate' then
        locate_current_file()
    else
        print('invalid usage of `kde_filepicker <open <file | directory> | locate>`')
    end
end

mp.register_script_message('kde-filepicker', kde_filepicker)
