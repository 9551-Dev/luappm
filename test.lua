local ppme = require("ppm_e")
local ppmd = require("ppm_d")

local data = {
    {{1,0,0},{0,0,1}},
    {{0,1,1},{1,1,0}}
}

local dat = ppme.encode(data)
print(dat)

print("\nDecoding:")
local data = ppmd.decode({data=dat})
print(textutils.serialise(data.pixels))