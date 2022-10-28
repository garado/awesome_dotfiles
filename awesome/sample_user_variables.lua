-- █▀ ▄▀█ █▀▄▀█ █▀█ █░░ █▀▀    █░█ █▀ █▀▀ █▀█    █░█ ▄▀█ █▀█ █▀ 
-- ▄█ █▀█ █░▀░█ █▀▀ █▄▄ ██▄    █▄█ ▄█ ██▄ █▀▄    ▀▄▀ █▀█ █▀▄ ▄█ 

-- Copy this to user_variables.lua!

return {
  theme_name  = "mountain",
  theme_style = "fuji",
  theme_switch_integration = false,
  -- Define displayed_themes if you want to only show specific themes
  -- in the theme switcher
  -- displayed_themes = {
  --   ["mountain"] = true,
  --   ["kanagawa"] = true,
  --   ["nord"] = true,
  -- },
  ---
  display_name = "Display Name",
  goals = {
    "Update user_vars",
    "Post to r/unixporn",
    "Be kind to myself",
  },
  ledger = {
    ledger_file = "~/.config/awesome/misc/sample.ledger",
    budget_file = "~/.config/awesome/misc/budget.ledger",
  },
  pomo = {
    topics = {
      "School",
      "Personal",
      "Hobby",
      "Rice",
    },
  },
  pixela = {
    user  = "",
    token = "",
  },
  titles = {
    "Mechromancer",
    "Open sourcerer",
    "Vim wizard",
    "CLI sorcerer",
    "Uses Arch, btw",
  },
  habit = {
    -- { name,        graph_id,       frequency},
    { "Make bed",     "make-bed",     "daily" },
    { "Journal",      "journal",      "daily"},
    { "Touch grass",  "go-outside",   "daily"},
    { "Ledger",       "ledger",       "daily"},
    { "Coding",       "pomocode",     "daily"},
    { "Read",         "reading",      "daily"},
  },
  git = {
    {
      name = "",
      repo = "",
      msg = "",
    },
  }
}
