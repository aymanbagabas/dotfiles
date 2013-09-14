local os = os
local awful = require("awful")
local freedesktop = require("freedesktop")
local lfs = require("lfs")

args = args or {}

args.dir = args.dir or os.getenv("HOME") .. '/'
args.open_with = args.open_with or 'xdg-open' or 'thunar'

local menu = {}

function menu.ls(dir)
	local iter, dir_obj = lfs.dir(dir)
	local files = { }
	local directories = { }
	local line = dir_obj:next()

	while line ~= nil do
		if lfs.attributes( dir .. '/' .. line, 'mode') == 'directory' and string.sub(line,1,1) ~= '.' then
			table.insert(directories,line)
		elseif string.sub(line,1,1) ~= '.' then 
			table.insert(files,line)
		end
		line = dir_obj:next()
	end
	dir_obj:close()
	return files,directories,dir
end

function menu.parse(files,directories,dir)
	local result = { }
	for i=1,#directories do
		table.insert(result, { directories[i], menu.parse(menu.ls(dir .. directories[i] .. '/')), freedesktop.utils.lookup_icon({ icon = "folder" }) })
	end
	for i=1,#files do
		table.insert(result, { files[i], function () awful.util.spawn(args.open_with .. ' ' .. string.gsub(dir .. files[i],' ','\\ ')) end--[[, freedesktop.utils.lookup_file_icon({ filename = files[i], icon_sizes = {'48'} })]] })
	end
		table.insert(result, { ' ', function () awful.menu.hide(mymainmenu) end })
		table.insert(result, { 'Open Here', function () awful.util.spawn(args.open_with .. ' ' .. dir) end })
	return result
end

function menu.genMenu(dir)
	return menu.parse(menu.ls(dir))
end

return menu
