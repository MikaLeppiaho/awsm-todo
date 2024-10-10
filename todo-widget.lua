local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

--Define the popup widget
local todo_widget = awful.popup({
	widget = {
		{
			{
				text = "TODO List:",
				widget = wibox.widget.textbox,
			},
			{
				text = "1. Example task",
				widget = wibox.widget.textbox,
			},
			layout = wibox.layout.fixed.vertical,
		},
		margins = 10,
		widget = wibox.container.margin,
	},
	border_color = beautiful.border_color,
	border_width = 2,
	placement = awful.placement.centered,
	shape = gears.shape.rounded_rect,
	ontop = true,
	visible = false,
})

--Toggle the widget on and off
local function toggle_todo_widget()
	todo_widget.visible = not todo_widget.visible
end

--Get todos from list
local function read_table() end

return {
	toggle_todo_widget = toggle_todo_widget,
}
