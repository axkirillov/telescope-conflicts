local has_telescope, telescope = pcall(require, 'telescope')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

if not has_telescope then
  error('This plugin requires nvim-telescope/telescope.nvim')
end

M = {}

 M.pick = function(opts)
	local command = "git diff --name-only --diff-filter=U --relative"
	local handle = io.popen(command)
	if handle == nil then
		print("could not execute" .. command)
		return
	end
	local result = handle:read("*a")
	handle:close()

	local files = {}
	for token in string.gmatch(result, "[^%s]+") do
	   table.insert(files, token)
	end

	opts = opts or {}

	pickers.new(opts, {
		prompt_title = "conflicting files",
		finder = finders.new_table {
			results = files
		},
		sorter = conf.generic_sorter(opts),
	}):find()
end

return telescope.register_extension {
	exports = {
		conflicts = M.pick,
	}
}
