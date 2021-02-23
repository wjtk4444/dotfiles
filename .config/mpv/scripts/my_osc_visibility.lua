local mp = require 'mp'

local is_paused         = true -- should match mpv.conf value
local is_loading        = false
local music_mode        = false
local current_extension = nil

local IMAGE_EXTENSIONS = { 
        ['png' ] = true,
        ['jpg' ] = true, 
        ['jpeg'] = true,
        ['bmp' ] = true,
    }

-- harcoded 16:9 support
local lavfi = [[
        @music_mode:!lavfi = [
                [in]
                        split
                    [box][bg];

                [bg]   
                        crop=iw:iw*9/16:0:(iw-iw*9/16)*0.5,
                        eq=gamma=0.5,
                        gblur=sigma=16
                    [bg];

                [bg][box]
                        scale2ref=ih*16/9:ih
                    [bg][box];

                [box]
                        scale=ih * (1 - 0.25/(iw-ih+1)):-1, 
                        drawbox=c=black@0
                    [box];

                [bg][box]
                        overlay=main_w-overlay_w:(main_h-overlay_h)*0.5
                    [out]
            ]
    ]]

lavfi = string.gsub(lavfi, '%s+', '')
mp.commandv('vf', 'add', lavfi)
--mp.command('no-osd vf toggle @music_mode')

function music_mode_tick() 
    if mp.get_property_number('chapters', 0) == 0 then
        mp.command('no-osd script-message osc-playlist 1.05')
    else
        mp.command('no-osd script-message osc-chapterlist 1.05')
    end
end

local music_mode_timer = mp.add_periodic_timer(1.0, music_mode_tick)
music_mode_timer:kill()

function toggle_music_mode()
    if music_mode then
        music_mode_timer:kill()
        music_mode = false
        mp.osd_message('Music mode: off')
        mp.command('no-osd vf toggle @music_mode')
        mp.command('no-osd set keep-open always')
        update_osc_visibility()
    else
        mp.osd_message('Music mode: on')
        music_mode_timer:resume()
        music_mode = true
        mp.command('no-osd vf toggle @music_mode')
        mp.command('no-osd script-message osc-visibility always no-osd')
        mp.command('no-osd set keep-open yes')
    end
end

local fade_osc_timer = mp.add_timeout(0.5, function() 
        mp.command('no-osd script-message osc-visibility auto no-osd') 
    end)
fade_osc_timer:kill()

function my_seek(time)
    -- seek trough the playlist if file is an image
    if IMAGE_EXTENSIONS[current_extension] then
        if tonumber(time) > 0 then
            mp.command('no-osd playlist-next')
        else
            mp.command('no-osd playlist-prev')
        end
        mp.osd_message(string.format('[%d/%d]', 
            mp.get_property('playlist-pos-1'), mp.get_property('playlist-count')))
        return
    end

    if not is_paused and not music_mode then
        mp.command('no-osd script-message osc-visibility always no-osd') 
        fade_osc_timer:kill()
        fade_osc_timer:resume()
    end
    mp.command('no-osd seek ' .. time .. ' exact')
    if music_mode then music_mode_tick() end -- update displayed chapter
end

function my_add_chapter(amount)
    fade_osc_timer:kill()
    fade_osc_timer:resume()

    mp.command('no-osd add chapter ' .. amount)
    mp.command('no-osd script-message osc-chapterlist 1')
end

function my_playlist_next()
    mp.command('no-osd playlist-next')
    mp.command('no-osd script-message osc-playlist 1')
end

function my_playlist_prev()
    mp.command('no-osd playlist-prev')
    mp.command('no-osd script-message osc-playlist 1')
end

function update_osc_visibility()
    local visibility = 'auto'
    -- conditions are checked in a specific order of priorities
    if music_mode then
        visibility = 'always'
    elseif is_paused and not IMAGE_EXTENSIONS[current_extension] then
        visibility = 'always'
    end
    mp.command('no-osd script-message osc-visibility ' .. visibility .. ' no-osd')
end

function on_load()
    is_loading = true
    local path = mp.get_property('path', '-')
    current_extension = path:match("[^.]+$")

    -- set visibility to always when opening remote files
    if string.match(path, "^https?://") then
        mp.command('no-osd script-message osc-visibility always no-osd')
    else
        update_osc_visibility()
    end
end

function on_loaded()
    is_loading = false
    update_osc_visibility()
    if music_mode then music_mode_tick() end -- update display
end

function on_pause_change(_, value)
    if value ~= nil then is_paused = value end
    if not is_loading then update_osc_visibility() end
end

mp.add_hook('on_load', 50, on_load)
mp.register_event('file-loaded', on_loaded)
mp.observe_property('pause', 'bool', on_pause_change)

mp.register_script_message('toggle-music-mode', toggle_music_mode)
mp.register_script_message('my-seek', my_seek)
mp.register_script_message('my-add-chapter', my_add_chapter)
mp.register_script_message('my-playlist-next', my_playlist_next)
mp.register_script_message('my-playlist-prev', my_playlist_prev)
