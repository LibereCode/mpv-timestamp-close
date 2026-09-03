---Copyright (c) 2026 LibereCode. All Rights Reserved.
---
---Version: 0.0.3

-- show the name of current playing file
-- press SHIFT+ENTER to call the function

local mp = require("mp")
local utils = require("mp.utils")
local options = require("mp.options")

local M = { time = {}, state = {} }

---INFO Creating path to state(json) file

M.state.dir = (os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")) .. "/mpv"
M.state.file = M.state.dir .. "/timestamp-close.json"
local dir_check = utils.file_info(M.state.dir)
if not (dir_check or {}).is_dir then
    os.execute("mkdir " .. M.state.dir)
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
    M.json_path = M.state.file -- "/tmp/mpv-timestamp-close.json"
    os.execute("touch " .. M.state.file) -- I am lazy
    M.json_tbl = M.json2lua(M.readFile(M.json_path)) or {}
    M.path = mp.get_property_native("path") or "idk"
    mp.commandv("seek", M.json_tbl[M.path] or 0)
end)

mp.add_key_binding("q", "shutdown_timestamp", function()
    M.json_tbl[M.path] = mp.get_property_native("time-pos")
    local json_str = M.lua2json(M.json_tbl)
    M.writeFile(M.json_path, json_str)
    mp.command("quit")
end)
