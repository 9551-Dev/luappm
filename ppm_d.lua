local lua_ppm = {}

local spacer_bytes = {
    ["\x80"] = true,
    ["\x20"] = true,
    ["\xA0"] = true,
    ["\x0A"] = true,
    ["\x0D"] = true,
}

local string_byte = string.byte
local function read_full_string(stream_str,seek)
    local output_string = ""

    local str_byte = true
    while not spacer_bytes[str_byte] and not (str_byte == "") do
        str_byte = stream_str:sub(seek,seek)
        seek     = seek + 1

        output_string = output_string .. str_byte
    end

    return output_string:sub(1,-2),seek
end

local function comment_skip(stream_str,seek)
    local str_byte = stream_str:sub(seek,seek)
    seek = seek + 1

    if str_byte == "#" then
        while str_byte ~= 0xA do
            str_byte = string_byte(stream_str,seek,seek)
            seek = seek + 1
        end
    end

    return seek-1
end

local function read_int(stream_str,seek)
    seek = comment_skip(stream_str,seek)

    local seek_end,int_str = seek,nil
    while not tonumber(int_str) do
        int_str,seek_end = read_full_string(stream_str,seek_end)
    end
    return tonumber(int_str),seek_end
end

function lua_ppm.decode(data_source)
    local seek_head = 1

    local stream
    if data_source.data then
        stream = data_source.data
    elseif data_source.handle then
        stream = handle.readAll()
    elseif data_source.file then
        local file_handle = fs.open(data_source.file,"rb")

        if file_handle then
            stream = file_handle.readAll()
            file_handle.close()
        end
    end

    local header_id,seek_head = read_full_string(stream,seek_head)
    seek_head = comment_skip(stream,seek_head)

    if header_id == "P3" then
        error("ASCII encoded ppm not supported.",2)
    elseif header_id ~= "P6" then
        error(("Not a valid PPM header ID: %s"):format(header_id),2)
    end

    local width, seek_head = read_int(stream,seek_head)
    local height,seek_head = read_int(stream,seek_head)
    local depth, seek_head = read_int(stream,seek_head)

    local image_result = {
        channel_resolution = depth,

        width  = width,
        height = height,
        pixels = {}
    }

    local image_pixeldata = image_result.pixels

    for current_y=1,height do
        local scanline = {}
        image_pixeldata[current_y] = scanline

        for current_x=1,width do
            local channel_r = string_byte(stream,seek_head)  /depth
            local channel_g = string_byte(stream,seek_head+1)/depth
            local channel_b = string_byte(stream,seek_head+2)/depth

            seek_head = seek_head + 3

            scanline[current_x] = {
                channel_r,
                channel_g,
                channel_b
            }
        end
    end

    return image_result
end

return lua_ppm