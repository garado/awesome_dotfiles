
-- █▀▀ █░█ █▀▀ █▄░█ ▀█▀ █▄▄ █▀█ ▀▄▀ 
-- ██▄ ▀▄▀ ██▄ █░▀█ ░█░ █▄█ █▄█ █░█ 

local beautiful  = require("beautiful")
local ui    = require("utils.ui")
local dpi   = ui.dpi
local awful = require("awful")
local wibox = require("wibox")
local dash  = require("backend.state.dash")
local cal   = require("backend.system.calendar")
local calconf = require("cozyconf").calendar
local strutil = require("utils").string

local ebox_margin = 4
local SECONDS_IN_DAY = 24 * 60 * 60

--- @function gen_eventbox
-- @param event An event table
local function gen_eventbox(event, height, width)
  local hour_range = calconf.end_hour - calconf.start_hour + 1
  local hourline_spacing = height / hour_range

  local day_range = calconf.end_day - calconf.start_day + 1
  local dayline_spacing = width / day_range

  local duration = strutil.time_to_int(event.e_time) - strutil.time_to_int(event.s_time)

  -- Figure out y-pos (hour)
  local y = (strutil.time_to_int(event.s_time) * hourline_spacing) - (calconf.start_hour * hourline_spacing)

  -- Figure out x-pos (day)
  local x = (event.s_day - calconf.start_day) * dayline_spacing

  return wibox.widget({
    {
      {
        ui.textbox({
          text = event.title,
          font = beautiful.font_med_s,
          align = "left",
          color = beautiful.fg,
        }),
        ui.textbox({
          text = event.s_time .. ' - ' .. event.e_time,
          align = "left",
          color = beautiful.fg,
        }),
        layout = wibox.layout.fixed.vertical,
      },
      top = dpi(5),
      left = dpi(8),
      widget = wibox.container.margin,
    },
    shape = ui.rrect(5),
    bg = beautiful.primary[700],
    forced_height = (duration * hourline_spacing) - ebox_margin,
    forced_width = dayline_spacing - ebox_margin,
    widget = wibox.container.background,
    point = { x = x + (ebox_margin / 2), y = y + (ebox_margin / 2)},
  })
end

local eventboxes = wibox.widget({
  layout = wibox.layout.manual,
  -------
  add_event = function(self, e)
    local ebox = gen_eventbox(e, self._height, self._width)
    self:add(ebox)
  end
})

-- █▀ █ █▀▀ █▄░█ ▄▀█ █░░ █▀ 
-- ▄█ █ █▄█ █░▀█ █▀█ █▄▄ ▄█ 

local function weekview_update()
  local ts = cal:get_weekview_start_ts()
  local start_day = os.date("%Y-%m-%d", ts)
  local end_day   = os.date("%Y-%m-%d", ts + (7 * SECONDS_IN_DAY))
  cal:fetch_range("weekview", start_day, end_day)
end

dash:connect_signal("weekview::size_calculated", function(_, height, width)
  eventboxes._height = height
  eventboxes._width = width
  weekview_update()
end)

cal:connect_signal("cache::ready", weekview_update)

cal:connect_signal("ready::range::weekview", function(_, events)
  eventboxes.children = {}
  for i = 1, #events do
    local e = events[i]
    eventboxes:add_event({
      title  = e[cal.TITLE],
      s_time = e[cal.START_TIME],
      e_time = e[cal.END_TIME],
      s_day  = strutil.date_to_weekday_int(e[cal.START_DATE]),
      e_day  = strutil.date_to_weekday_int(e[cal.END_DATE]),
      loc    = e[cal.LOCATION],
    })
  end
end)

return eventboxes
