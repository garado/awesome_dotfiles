
-- █░█░█ █▀▀ ▄▀█ ▀█▀ █░█ █▀▀ █▀█ 
-- ▀▄▀▄▀ ██▄ █▀█ ░█░ █▀█ ██▄ █▀▄ 

-- Note: weather widget has been modified to fit into the dashboard
-- It is optimized for temperatures that are never sub-zero

local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local colorize  = require("helpers.ui").colorize_text
local weather = require("modules.weather.weather")
local config = require("cozyconf")

local api_key = config.agenda.weather_api_key
local coords  = config.agenda.weather_coords

local cozyconf_valid = config and api_key and api_key ~= "" and coords and #coords == 2

local widget_to_display

if cozyconf_valid then
  widget_to_display = weather({
    api_key = api_key,
    coordinates = coords,
    time_format_12h = true,
    units = 'imperial',
    both_units_widget = false,
    font_name = beautiful.base_font_name,
    icons = 'pixels',
    icons_extension = '.png',
    show_daily_forecast = true,
    show_current_forecast = false,
    timeout = 10 * 60, -- 10 min refresh rate
  })
else
  widget_to_display = {
    markup = colorize("Couldn't display weather.\nMaybe check your cozyconf?", beautiful.fg_1),
    align  = "center",
    valign = "center",
    font   = beautiful.font_reg_s,
    widget = wibox.widget.textbox,
  }
end

local widget = wibox.widget({
  wibox.widget({
    markup = colorize("Weekly Forecast", beautiful.fg_0),
    align = "center",
    valign = "center",
    font = beautiful.font_reg_l,
    widget = wibox.widget.textbox,
  }),
  {
    widget_to_display,
    valign = 'center',
    widget = wibox.container.place,
  },
  spacing = dpi(10),
  layout = wibox.layout.fixed.vertical,
})

return widget