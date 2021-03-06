--[[
Clock Rings by londonali1010 (2009)

This script draws percentage meters as rings, and also draws clock hands if you want! It is fully customisable; all options are described in the script. This script is based off a combination of my clock.lua script and my rings.lua script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement near the end of the script uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num > 5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num > 3; conversely if you update Conky every 0.5s, you should use update_num > 10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
	lua_load ~/scripts/clock_rings-v1.1.1.lua
	lua_draw_hook_pre clock_rings

Changelog:
+ v1.1.1 -- Fixed minor bug that caused the script to crash if conky_parse() returns a nil value (20.10.2009)
+ v1.1 -- Added colour option for clock hands (07.10.2009)
+ v1.0 -- Original release (30.09.2009)
]]

settings_table = {
	{
		name='time',
		arg='%S',
		max=60,
		bg_colour=0xFFFFFF,
		bg_alpha=0.6,
		fg_colour=0xFFDBC5,
		fg_alpha=1,
		x=160, y=155,
		radius=65,
		thickness=4,
		start_angle=0,
		end_angle=360
	},
	{
		name='cpu', -- CPU1
		arg='cpu1',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=160, y=155,
		radius=75,
		thickness=5,
		start_angle=93,
		end_angle=208
	},
	{
		name='cpu', -- CPU2
		arg='cpu2',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=160, y=155,
		radius=81,
		thickness=5,
		start_angle=93,
		end_angle=208
	},

	{
		name='cpu', -- CPU3
		arg='cpu3',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=160, y=155,
		radius=87,
		thickness=5,
		start_angle=93,
		end_angle=208
        },

	{
		name='cpu', -- CPU4
		arg='cpu4',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=160, y=155,
		radius=93,
		thickness=5,
		start_angle=93,
		end_angle=208
        },
	{
		name='memperc', -- MEMORY
		arg='',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=160, y=155,
		radius=84,
		thickness=22.5,
		start_angle=212,
		end_angle=329
	},
	{
		name='battery_percent', -- BATTERY
		arg='BAT0',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=160, y=155,
		radius=84,
		thickness=22.5,
		start_angle=-27,
		end_angle=88
	},
	{
		name='cpu',
		arg='',
		max=1,
		bg_colour=0x7E0032,
		bg_alpha=0.4,
		fg_colour=0x7E0032,
		fg_alpha=0,
		x=162, y=155,
		radius=118,
		thickness=2,
		start_angle=86,
		end_angle=120
	},
	{
		name='fs_used_perc',
		arg='/home',
		max=100,
		bg_colour=0xFFDBC5,
		bg_alpha=1,
		fg_colour=0xffffff,
		fg_alpha=0.6,
		x=160, y=155,
		radius=105,
		thickness=5,
		start_angle=1.5,
		end_angle=120
	},
	{
		name='hwmon',
		arg='2 temp 1',
		max=80,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=540, y=65,
		radius=35,
		thickness=4,
		start_angle=1.5,
		end_angle=357
	},
	{
		name='battery_percent',
		arg='BAT0',
		max=100,
		bg_colour=0xffffff,
		bg_alpha=0.2,
		fg_colour=0xffffff,
		fg_alpha=0.5,
		x=420, y=75,
		radius=45,
		thickness=6,
		start_angle=1.5,
		end_angle=357
	},
	{
		name='cpu',
		arg='',
		max=1,
		bg_colour=0x7E0032,
		bg_alpha=0.4,
		fg_colour=0x7E0032,
		fg_alpha=0,
		x=420, y=75,
		radius=52,
		thickness=2,
		start_angle=200,
		end_angle=265
	},
	{
		name='cpu',
		arg='',
		max=1,
		bg_colour=0x7E0032,
		bg_alpha=0.4,
		fg_colour=0x7E0032,
		fg_alpha=0,
		x=420, y=75,
		radius=56,
		thickness=2,
		start_angle=210,
		end_angle=235
	},
	{
		name='cpu',
		arg='',
		max=1,
		bg_colour=0x7E0032,
		bg_alpha=0.4,
		fg_colour=0x7E0032,
		fg_alpha=0,
		x=540, y=65,
		radius=41,
		thickness=2,
		start_angle=115,
		end_angle=165
	},
	{
		name='battery_percent',
		arg='',
		max=1,
		bg_colour=0xffffff,
		bg_alpha=0.3,
		fg_colour=0xffffff,
		fg_alpha=0.7,
		x=562, y=194,
		radius=25,
		thickness=1,
		start_angle=1.5,
		end_angle=357
	},
	{
		name='battery_percent',
		arg='',
		max=1,
		bg_colour=0x7E0032,
		bg_alpha=0.4,
		fg_colour=0xffffff,
		fg_alpha=0,
		x=562, y=194,
		radius=29,
		thickness=2,
		start_angle=176,
		end_angle=247
	},
	{
		name='battery_percent',
		arg='',
		max=1,
		bg_colour=0xffffff,
		bg_alpha=0.3,
		fg_colour=0xffffff,
		fg_alpha=0.7,
		x=487, y=233,
		radius=25,
		thickness=1,
		start_angle=1.5,
		end_angle=357
	},
}

-- Use these settings to define the origin and extent of your clock.

clock_r=60

-- "clock_x" and "clock_y" are the coordinates of the centre of the clock, in pixels, from the top left of the Conky window.

clock_x=160
clock_y=155
corner_r=50
-- Colour & alpha of the clock hands

clock_colour=0xC8293F
clock_alpha=0.6

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
	local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
	local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

	local angle_0=sa*(2*math.pi/360)-math.pi/2
	local angle_f=ea*(2*math.pi/360)-math.pi/2
	local t_arc=t*(angle_f-angle_0)

	-- Draw background ring

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
	cairo_set_line_width(cr,ring_w)
	cairo_stroke(cr)

	-- Draw indicator ring

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
	cairo_stroke(cr)
end

function draw_clock_hands(cr,xc,yc)
	local secs,mins,hours,secs_arc,mins_arc,hours_arc
	local xh,yh,xm,ym,xs,ys

	secs=os.date("%S")
	mins=os.date("%M")
	hours=os.date("%I")

	secs_arc=(2*math.pi/60)*secs
	mins_arc=(2*math.pi/60)*mins+secs_arc/60
	hours_arc=(2*math.pi/12)*hours+mins_arc/12

	-- Draw hour hand

	xh=xc+0.7*clock_r*math.sin(hours_arc)
	yh=yc-0.7*clock_r*math.cos(hours_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)

	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(clock_colour,clock_alpha))
	cairo_stroke(cr)

	-- Draw minute hand

	xm=xc+clock_r*math.sin(mins_arc)
	ym=yc-clock_r*math.cos(mins_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)

	cairo_set_line_width(cr,3)
	cairo_stroke(cr)
end

function conky_pad( number )
    return string.format( '%.2f' , conky_parse(number))
end

function conky_clock_rings()
	local function setup_rings(cr,pt)
		local str=''
		local value=0

		str=string.format('${%s %s}',pt['name'],pt['arg'])
		str=conky_parse(str)

		value=tonumber(str)
		if value == nil then value = 0 end
		pct=value/pt['max']

		draw_ring(cr,pct,pt)
    end

	-- Check that Conky has been running for at least 5s

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

	local cr=cairo_create(cs)	

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	if update_num>5 then
		for i in pairs(settings_table) do
			setup_rings(cr,settings_table[i])
		end
	end

	draw_clock_hands(cr,clock_x,clock_y)
end
