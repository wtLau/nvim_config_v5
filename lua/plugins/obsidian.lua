return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", --  use latest release 
  lazy = true,
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/wtlau-obsidian/",
      },
      {
        name = "work",
        path = "~/Documents/wtlau-obsidian/notes/work",
      },
    },
    dir = vim.env.HOME .. "/Documents/wtlau-obsidian", -- vault location
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
    notes_subdir = "notes",
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = "daily.md",
    },
    completion = {
      nvim_cmp = false,
      blink = true,
    },
    preferred_link_style = "wiki",

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- E.g. like 'my-new-note-1657296016'
      local prefix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        prefix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If prefix is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          prefix = prefix .. string.char(math.random(65, 90))
        end
      end
      return prefix .. "-" .. tostring(os.time())
    end,

    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then note:add_alias(note.title) end
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
  },
}
