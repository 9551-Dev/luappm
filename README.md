# LuaPPM

A simple binary .ppm image decoder written written in Lua

### usage:
```lua
local img_src = select(1,...)
local pixel_x = tonumber(select(2,...))
local pixel_y = tonumber(select(3,...))

local ppm = require("ppm")

local decoded = ppm.decode({file=img_src})

local r,g,b = decoded.pixels[pixel_y][pixel_x]

print(("Pixel at %s:%s is #%x"):format(
    pixel_x,pixel_y,
    colors.packRGB(r,g,b)
))
```