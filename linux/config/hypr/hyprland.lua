-- Monitors
hl.monitor({ output = "DP-2", mode = "2560x1440@165", position = "1920x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1200", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-3", mode = "1920x1200", position = "4480x0", scale = 1, transform = 3 })

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("waybar --config ~/configs/linux/config/waybar/config --style ~/configs/linux/config/waybar/style.css")
	hl.exec_cmd("~/configs/scripts/keyboard_layout_hyprland.sh")
	hl.exec_cmd("~/configs/scripts/spotify_info.sh")
	hl.exec_cmd("~/configs/scripts/laptop_battery.sh")
	hl.exec_cmd("alacritty -e ~/configs/scripts/open_startup_file.sh", { workspace = "3 silent" })
end)

-- Input
hl.config({
	input = {
		kb_model = "pc105",
		kb_layout = "us,fi",
		kb_options = "grp:alt_shift_toggle",
		follow_mouse = 1,
	},
})

-- General
hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 0,
		border_size = 1,
		layout = "dwindle",
	},
})

-- Dwindle layout
hl.config({
	dwindle = {
		preserve_split = true,
	},
})

-- Misc
hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

-- Keybindings
local mod = "SUPER"

-- Terminal
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("alacritty"))

-- Close focused window
hl.bind(mod .. " + Q", hl.dsp.window.close())

-- Launcher
hl.bind(mod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))

-- Kill window
hl.bind(mod .. " + SHIFT + X", hl.dsp.exec_cmd("~/configs/scripts/hyprkill.sh"))

-- Focus (vim keys)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))

-- Move focused window (vim keys)
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

-- Split direction (dwindle preselect)
hl.bind(mod .. " + U", hl.dsp.layout("preselect r"))
hl.bind(mod .. " + N", hl.dsp.layout("preselect d"))

-- Fullscreen
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Layout toggle split (dwindle)
hl.bind(mod .. " + E", hl.dsp.layout("togglesplit"))

-- Toggle tiling / floating
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- Focus toggle tiling / floating
hl.bind(mod .. " + SPACE", hl.dsp.window.cycle_next())

-- Workspaces - switch
for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end

-- Workspaces - move container
for i = 1, 10 do
	local key = i % 10
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Reload config
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))

-- Exit Hyprland
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

-- Resize submap (equivalent to sway's resize mode)
hl.bind(mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
	hl.bind("L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
	hl.bind("RETURN", hl.dsp.submap("reset"))
	hl.bind("ESCAPE", hl.dsp.submap("reset"))
	hl.bind(mod .. " + R", hl.dsp.submap("reset"))
end)

-- Open Firefox
hl.bind(mod .. " + B", hl.dsp.exec_cmd("firefox"))

-- Screenshot of selected region
hl.bind(
	mod .. " + Z",
	hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/Images/screenshot/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png")
)
