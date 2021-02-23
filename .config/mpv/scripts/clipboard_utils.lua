local mp = require 'mp'
local utils = require 'mp.utils'

function detect_platform()
	local o = {}
	-- Kind of a dumb way of detecting the platform but whatever
	if mp.get_property_native('options/vo-mmcss-profile', o) ~= o then
        print('w')
		return 'windows'
	elseif mp.get_property_native('options/input-app-events', o) ~= o then
		return 'macos'
	end
	return 'linux'
end

local platform = detect_platform()

function trim(s)
    return s:match"^%s*(.-)%s*$" or s
end


function set_clipboard(content)
	content = '"' .. content .. '"' -- let os handle the quotes
	if platform == 'linux' then
		os.execute('echo ' .. content .. ' | xclip -selection c')
	elseif platform == 'windows' then
		os.execute('powershell -NoProfile -Command Set-Clipboard -Value "' .. content .. '"')
	elseif platform == 'macos' then
		os.execute('echo ' .. content .. ' | pbcopy')
	end
end

local TMPFILE = nil
function get_clipboard()
	local handle = nil
    if platform == 'linux' then
        handle = io.popen('xclip -selection c -o')
    elseif platform == 'windows' then
		handle = io.popen('powershell -NoProfile -Command Get-Clipboard')
    elseif platform == 'macos' then
        handle = io.popen('pbpaste')
	end

    if not handle then
        return nil
    end

	local result = handle:read("*all")

    -- try getting the clipboard image if on linux
    if result == '' and platform == 'linux' then
        result = io.popen('xclip -selection c -o -t image/png | head -c1'):read("*all")
        if result == '' then
            return nil
        end
        
        TMPFILE = trim(io.popen('mktemp --suffix .png'):read("*all"))
        print('"' .. TMPFILE .. '"')
        result = io.popen('xclip -selection c -o -t image/png > ' .. TMPFILE):read("*all")
        return TMPFILE
    end
    
    return trim(result)
end


function load_file_from_clipboard(append)
	local content = get_clipboard(true)
	
	if content and content ~= '' then
		mp.osd_message('Opening file: ' .. content)
		local res = mp.commandv('loadfile', content, (append and 'append-play' or 'replace'))
        if TMPFILE ~= nil then
            io.popen('rm -f ' .. TMPFILE):read("*all")
            TMPFILE = nil
        end
	else
		mp.osd_message('Clipboard empty or not a string')
	end
end

function load_audio_from_clipboard()
	local content = get_clipboard(true)
	
	if content and content ~= '' then
		mp.osd_message('Opening file: ' .. content)
		local res = mp.commandv('audio-add', content, 'select')
        if TMPFILE ~= nil then
            io.popen('rm -f ' .. TMPFILE):read("*all")
            TMPFILE = nil
        end
	else
		mp.osd_message('Clipboard empty or not a string')
	end
end

function copy_file_path_to_clipboard()
	local filename = mp.get_property('path')
	if filename then
		mp.osd_message('Filename copied to clipboard: ' .. filename)
		set_clipboard(filename)
	else
		mp.osd_message('No file')
	end
end

function screenshot_to_clipboard(flags)
    local tmp = trim(io.popen('mktemp --suffix .png'):read("*all"))
    local res = mp.commandv('screenshot-to-file', tmp, flags)
    res = io.popen('xclip -selection c -t image/png -i ' .. tmp):read("*all")
    mp.osd_message('Screenshot saved to clipboard')
    --io.popen('rm -f ' .. tmp):read("*all")
end

-- handle commands
function clipboard_utils(command, argument)
    if command == 'copy' then
        copy_file_path_to_clipboard()
    elseif command == 'open' then
        if argument == nil or argument == 'replace' then
            load_file_from_clipboard(false)
        elseif argument == 'append' then
            load_file_from_clipboard(true)
        elseif argument == 'audio' then
            load_audio_from_clipboard()
        else
            print('invalid usage of `open [replace (default) | append | audio]`')
        end
    elseif command == 'screenshot' then
        if argument == nil or argument == 'subtitles' then
            screenshot_to_clipboard('subtitles')
        elseif argument == 'video' then
            screenshot_to_clipboard('video')
        elseif argument == 'window' then
            screenshot_to_clipboard('window')
        else
            print('invalid usage of `screenshot [subtitles (default) | video | window]`')
        end
    else
        print('invalid usage of `open [replace (default) | append]`')
    end
end

mp.register_script_message('clipboard-utils', clipboard_utils)

