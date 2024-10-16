local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Define the popup widget
local todo_widget = awful.popup({
	widget = wibox.layout.fixed.vertical,
	border_color = beautiful.border_color,
	border_width = 2,
	placement = awful.placement.centered,
	shape = gears.shape.rounded_rect,
	ontop = true,
	visible = false,
})

local input_prompt = awful.widget.prompt()

-- Add a background to make it more visible
local function read_tasks_from_file()
	local tasks = dofile("test.lua")
	return tasks
end

local function update_todo_widget(tasks)
	todo_widget.widget:reset()
	--add title
	todo_widget.widget:add(wibox.widget({
		text = "TODO List:",
		widget = wibox.widget.textbox,
	}))

	-- add the tasks from the datafile to the widget
	for i, task in ipairs(tasks) do
		local task_text = string.format("%d. %s", i, task.task)
		todo_widget.widget:add(wibox.widget({
			text = task_text,
			widget = wibox.widget.textbox,
		}))
	end

	todo_widget.widget:add(input_prompt)
end
--Append task to file
local function append_to_file(tasks)
	local file = io.open("test.lua", "w")
	if file then
		file:write("return {\n")
		for _, task in ipairs(tasks) do
			file:write(string.format("    { task = %q, completed = %s },\n", task.task, tostring(task.completed)))
		end
		file:write("}\n")
		file:close()
	else
		print("Error: Could not open file for writing.")
	end
end

-- Add new tasks
local function handle_input(input)
	if input and #input > 0 then
		local tasks = read_tasks_from_file()
		table.insert(tasks, { task = input, completed = false })
		append_to_file(tasks)
		update_todo_widget(tasks)
	end
end

--Toggle the widget on and off
local function toggle_todo_widget()
	local tasks = read_tasks_from_file()
	update_todo_widget(tasks)
	if todo_widget.visible == false then
		awful.prompt.run({
			prompt = "New task: ",
			exe_callback = handle_input,
			textbox = input_prompt.widget,
		})
	end
	todo_widget.visible = not todo_widget.visible
end

return {
	toggle_todo_widget = toggle_todo_widget,
}
