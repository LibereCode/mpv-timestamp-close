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

--- INFO REFERENCE
-- function on_pause_change(name, value)
--     if value == true then
--         mp.set_property("fullscreen", "no")
--     end
-- end
-- mp.observe_property("pause", "bool", on_pause_change)
-- ----
-- function my_fn(event)
--     print("start of playback!")
-- end
-- mp.register_event("file-loaded", my_fn)

local M = { time = {} }

---TEST DEBUG
local function print_time()
    local current = M.time.pos()
    M.time.last = M.time.current or current
    M.time.current = current
    print("time_since_START: ", M.time.current)
    print("time_since_LAST", M.time.current - M.time.last)
end
mp.add_key_binding("d", print_time)

---@return integer? time-pos current time of video progress.
function M.time.pos()
    return mp.get_property_native("time-pos")
end

---Read a file from `filepath`, and return content as a string
---@param filepath string
---@return string content `content` of **file** at `filepath`
function M.readFile(filepath)
    local file = io.open(filepath, "r")
    local content = assert(file, "File at <" .. filepath .. "> is missing"):read("*a")
    return content
end
---Write the _string_ `data` to `filepath`, and return success
---@param filepath string
---@return boolean success
function M.writeFile(filepath, data)
    local file = io.open(filepath, "w")
    local content = assert(file, "Couldnt write to <" .. filepath .. ">"):write(data):close()
    return content or false
end
---Parse a JSON-string to a lua-table, and return it
---@param str string
---@return table lua-table
function M.json2lua(str)
    return utils.parse_json(str)
end
---Parse a lua-table to a JSON-string, and return it
---@param tbl table
---@return string JSON-str
function M.lua2json(tbl)
    return utils.format_json(tbl)
end

---Initial time
mp.register_event("file-loaded", function()
    print("file-loaded:")
    local test = M.readFile("./test.json")
    print("TEST read ./test.json:")
    print("<" .. test .. ">")
    local test_parse = M.json2lua(test)
    print("TEST parsed to lua:")
    print("<")
    for k, v in pairs(test_parse) do
        print(k, "=", v)
    end
    print(">")
    test_parse.ticking = os.time()
    print("TEST back to json:")
    local test_parse_back = M.lua2json(test_parse)
    print("<" .. test_parse_back .. ">")
    print("TEST: write it")
    M.writeFile("./test.json", test_parse_back)
    print_time()
end)
