local pxColor = app.pixelColor

if app.apiVersion < 23 then
	return app.alert("Please update to version v1.3-rc3 or higher.")
end
  
local cel = app.cel
if not cel then
	return app.alert("Select image to convert to mask texture.")
end

local image = cel.image:clone()

for y = 0, image.height - 1, 1 do
    for x = 0, image.width - 1, 1 do
        local pixel = image:getPixel(x, y);

        if pxColor.rgbaA(pixel) ~= 0 then
            if pxColor.rgbaR(pixel) == 127 and pxColor.rgbaG(pixel) == 127 and pxColor.rgbaB(pixel) == 255 then
                image:drawPixel(x, y, pxColor.rgba(0, 0, 0, 255))
            else
                image:drawPixel(x, y, pxColor.rgba(255, 0, 0, 255))
            end
        end
    end
end

local sprite = app.sprite
local frame = app.frame
local layer = app.layer
local newLayerName = layer.name .. "_toMask"
local newLayer = nil

for _, layer in ipairs(sprite.layers) do
  if layer.name == newLayerName then
        newLayer = layer
  end
end

if newLayer == nil then
    newLayer = sprite:newLayer()
    newLayer.name = newLayerName
end
local newCel = sprite:newCel(newLayer, frame, image, cel.position)

app.refresh()