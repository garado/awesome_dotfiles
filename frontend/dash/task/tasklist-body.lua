
-- ▀█▀ ▄▀█ █▀ █▄▀ █░░ █ █▀ ▀█▀    █▄▄ █▀█ █▀▄ █▄█ 
-- ░█░ █▀█ ▄█ █░█ █▄▄ █ ▄█ ░█░    █▄█ █▄█ █▄▀ ░█░ 

-- Displays a list of tasks for the currently-selected
-- tag and project.

local beautiful  = require("beautiful")
local ui    = require("utils.ui")
local dpi   = ui.dpi
local wibox = require("wibox")
local gears = require("gears")
local singlesel = require("frontend.widget.single-select")
local strutil = require("utils.string")
local task  = require("backend.system.task")

local tasklist = {}

--- @function gen_taskitem
-- @brief Generate a single tasklist entry.
local function gen_taskitem(t)
  local desc = ui.textbox({
    text = t.description
  })

  local indicator = wibox.widget({
    forced_height = dpi(3),
    forced_width  = dpi(3),
    bg = beautiful.neutral[800],
    shape  = gears.shape.circle,
    widget = wibox.container.background,
    visible = true,
  })

  local desc_indicator = wibox.widget({
    indicator,
    desc,
    spacing = dpi(10),
    layout = wibox.layout.fixed.horizontal,
  })

  local due_text, overdue, color
  if t.due then
    due_text, overdue = strutil.iso_to_relative(t.due)
    color = overdue and beautiful.red[400] or beautiful.fg
  else
    due_text = "no due date"
    color = beautiful.fg
  end

  local due = ui.textbox({
    text = due_text,
    color = color
  })

  local taskitem = wibox.widget({
    desc_indicator,
    nil,
    due,
    layout = wibox.layout.align.horizontal,
    -----
    desc = desc, -- need an easy-access reference for later
  })

  taskitem:connect_signal("mouse::enter", function(self)
    self.parent.active_element.desc:update_color(beautiful.fg)
    desc:update_color(beautiful.primary[500])
  end)

  taskitem:connect_signal("mouse::leave", function(self)
    self:update()
  end)

  function taskitem:update()
    local c = self.selected and beautiful.primary[400] or beautiful.fg
    indicator.bg = self.selected and beautiful.fg or beautiful.neutral[800]
    desc:update_color(c)
  end

  return taskitem
end

-- TODO: this whole thing
--- @function gen_scrollbar
local function gen_scrollbar()
end

tasklist = wibox.widget({
  spacing = dpi(15),
  layout  = wibox.layout.fixed.vertical,
})

tasklist = singlesel({ layout = tasklist, keynav = true, name = "nav_tasklist" })

tasklist.area:connect_signal("area::left", function()
  tasklist.active_element.desc:update_color(beautiful.fg)
end)

tasklist.area:connect_signal("area::enter", function()
  tasklist.active_element:update()
end)

-- █▀ █ █▀▀ █▄░█ ▄▀█ █░░ █▀    ▄▀█ █▄░█ █▀▄    █▀ ▀█▀ █░█ █▀▀ █▀▀ 
-- ▄█ █ █▄█ █░▀█ █▀█ █▄▄ ▄█    █▀█ █░▀█ █▄▀    ▄█ ░█░ █▄█ █▀░ █▀░ 

task:connect_signal("ready::tasks", function(_, tag, project, tasks)
  tasklist:clear_elements()
  tasklist.tag = tag
  tasklist.project = project
  for i = 1, #tasks do
    local taskitem = gen_taskitem(tasks[i])
    tasklist:add_element(taskitem)
  end

  -- Assume the first task is selected
  tasklist.active_element = tasklist.children[1]
  tasklist.children[1].selected = true
  tasklist.children[1]:update()
  tasklist.children[1].desc:update_color(beautiful.fg)
end)

return function() return tasklist end
