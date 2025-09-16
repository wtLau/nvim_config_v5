return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
  -- event = { "bufreadpre " .. vim.fn.expand "~" .. "/wtlau-obsidian/**.md" },
  -- event = { "BufReadPre  */wtlau-obsidian/*.md" },
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
    dir = vim.env.HOME .. "/Documents/wtlau-obsidian", -- specify the vault location. no need to call 'vim.fn.expand' here

    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },

    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = "notes",

    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "daily",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "daily-notes" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "daily.md",
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Enables completion using nvim_cmp
      nvim_cmp = false,
      -- Enables completion using blink.cmp
      blink = true,
    },

    preferred_link_style = "wiki",
    -- Optional, customize how markdown links are formatted.
    markdown_link_func = function(opts) return require("obsidian.util").markdown_link(opts) end,

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
