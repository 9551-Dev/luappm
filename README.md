# LuaPPM

A simple binary .ppm image [decoder](#decoder-usage)/[encoder](#encoder-usage) written written in Lua

### Decoder usage:
```lua
local img_src = select(1,...)
local pixel_x = tonumber(select(2,...))
local pixel_y = tonumber(select(3,...))

local ppmd = require("ppm_d")

local decoded = ppmd.decode({file=img_src})

local r,g,b = decoded.pixels[pixel_y][pixel_x]

print(("Pixel at %s:%s is #%x"):format(
    pixel_x,pixel_y,
    colors.packRGB(r,g,b)
))
```

### Encoder usage
```lua
local ppme = require("ppm_e")

local data = {
    {{1,0,0},{0,0,1}},
    {{0,1,1},{1,1,0}}
}

local dat = ppme.encode(data)
```
or something like this
```lua
local ppme = require("ppm_e")

local data = {
    {{1,0,0},{0,0,1}},
    {{0,1,1},{1,1,0}},
    {{0,0,1},{1,0,0}}
}

ppme.encode(data,2,3,nil,"epic_output.ppm")
```