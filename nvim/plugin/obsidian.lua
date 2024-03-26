require("obsidian").setup({
	dir = "~/Documents/yeehaa",
	notes_subdir = "Notes",

	-- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
	-- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
	log_level = vim.log.levels.DEBUG,

	daily_notes = {
		folder = "Daily Notes",
		date_format = "%Y-%m-%d",

	},

	-- Optional, completion.
	completion = {
		nvim_cmp = true,
		min_chars = 2,
		new_notes_location = "current_dir",
	},

	backlinks = {
		height = 10,
		wrap = true,
	},
	follow_url_func = function(url)
		vim.fn.jobstart({"xdg-open", url})
	end,

	note_id_func = function(title)
		return title
	end,
	disable_frontmatter = true
})
