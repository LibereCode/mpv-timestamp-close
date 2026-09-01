-- show the name of current playing file
-- press SHIFT+ENTER to call the function

local mp = require("mp")
local utils = require("mp.utils")
local options = require("mp.options")

--[[
    INFO:
    On close (or before it)
    Update a file with a (JSON ?) table of values,
    with the path to media and timestamp at exit.

    EXAMPLE:
    ```json
    {
        "/path/to/video.mp4": 1234.723
        "/another/path/to/vid.mp4": 111.111
    }
    ```
    Where the number is the amount of time in seconds.

    tasks/features:
    - Async
    - Read file with json-parser.
    - Set time if `json_parsed[path]` have a value (~= nil).
    - On exit-event, use:
        ```lua
        json_parsed[path] = timestamp;
        local new_json_str = lua_2_json(json_parsed)
        io.open(path/state.json, "w"):write(new_json_str)
        ```
--]]

--[[
    Events <https://rksvc.github.io/mpv-manual/command-interface/list-of-events/>
    ------
    - start-file (MPV_EVENT_START_FILE)
    - end-file (MPV_EVENT_END_FILE)
        Alternative do the action before quit command ?
--]]

function on_pause_change(name, value)
    if value == true then
        mp.set_property("fullscreen", "no")
    end
end
mp.observe_property("pause", "bool", on_pause_change)
