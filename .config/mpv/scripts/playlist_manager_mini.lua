function remove_current()
    local index = mp.get_property_number('playlist-pos', 0)
    local total = mp.get_property_number('playlist-count', 0)
    print('removing', index, 'of', total)
    mp.commandv('playlist-remove', index)
end

function move_forward()
    local total = mp.get_property_number('playlist-count', 0)
    local index1 = mp.get_property_number('playlist-pos', 0)
    if index1 + 2 > total then 
        index2 = 0
    else
        index2 = index1 + 2
    end
    mp.commandv('playlist-move', index1, index2)
end

function move_backward()
    local index = mp.get_property_number('playlist-pos', 0)
    mp.commandv('playlist-move', index, index - 1)
end

mp.register_script_message('playlist-remove-current', remove_current)
mp.register_script_message('playlist-move-forward', move_forward)
mp.register_script_message('playlist-move-backward', move_backward)
