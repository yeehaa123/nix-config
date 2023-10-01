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

  note_frontmatter_func = function(note)
    local out = { title = note.id }
    if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end
    return out
  end,

})
