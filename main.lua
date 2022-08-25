local nextScene

local printScene = (function()
    local font = love.graphics.newFont(20)
    local text = love.graphics.newText(font, "drawing text object works")

    return function()
        love.graphics.print("love.graphics.print works", 10, 10)
        love.graphics.draw(text, 10, 25)
        love.graphics.printf("This text is aligned right, and wraps when it gets too big.", 10, 60, 125, "right")
        love.graphics.print("Renderer Info: " .. table.concat({love.graphics.getRendererInfo()}, " - "), 250, 10)
    end
end)()

local basicShapesScene = (function()
    return function()
        love.graphics.print("drawing basic shapes work (arc, circle, ellipse, line, points, polygon, rectangle)", 10, 10)

        love.graphics.arc("fill", 60, 60, 40, 0, math.pi * 0.9)
        love.graphics.arc("line", 200, 60, 40, 0, math.pi * 0.9)

        love.graphics.circle("fill", 60, 150, 40)
        love.graphics.circle("line", 200, 150, 40)

        love.graphics.ellipse("fill", 60, 250, 40, 30)
        love.graphics.ellipse("line", 200, 250, 40, 30)

        love.graphics.line(250, 100, 260, 110, 270, 140, 350, 110, 410, 140)

        love.graphics.points(250, 200, 260, 210, 270, 240, 350, 210, 410, 240)

        love.graphics.polygon("fill", 450, 100, 470, 110, 510, 150, 460, 160, 420, 140)
        love.graphics.polygon("line", 550, 100, 570, 110, 610, 150, 560, 160, 520, 140)

        love.graphics.rectangle("fill", 450, 250, 70, 50)
        love.graphics.rectangle("line", 550, 250, 70, 50)
    end
end)()

local transformationsScene = (function()
    local rect = function()
        love.graphics.rectangle("line", 20, 30, 70, 50)
    end

    return function()
        love.graphics.print("transformations and setColor work:")

        love.graphics.setColor(0, 0.2, 0.7, 1)
        rect()

        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.scale(1.3, 1.5)
        rect()

        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.origin()
        love.graphics.translate(150, 20)
        rect()

        love.graphics.origin()
        love.graphics.rotate(math.pi/8)
        love.graphics.setColor(0, 1, 0, 1)
        rect()

        love.graphics.origin()
        love.graphics.setColor(1, 1, 1, 1)
    end
end)()

local videoScene = (function()
    local video = love.graphics.newVideo("out.ogv", {audio = false})
    video:play()
    local width, height = video:getDimensions()
    local targetWidth, targetHeight = 1280 / 1.5, 720 / 1.5
    local sx, sy = targetWidth / width, targetHeight / height

    return function()
        love.graphics.print("rendering video works")
        if video:isPlaying() == false then
            video:rewind()
        end
        love.graphics.draw(video, 50, 50, 0, sx, sy)
    end
end)()

local shaderScene = (function()
    local shaderCode = [[
        uniform float red;

        vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
            if (screen_coords.x > 200.0) {
                return vec4(red, 0, 1, 1);
            } else {
                return vec4(red, 1, 0, 1);
            }
        }
    ]]
    local shader = love.graphics.newShader(shaderCode)
    shader:send("red", 0)

    return function()
        shader:send("red", love.timer.getTime() % 1)
        love.graphics.setShader(shader)
        love.graphics.rectangle("fill", 200 - 40, 100, 80, 40)

        love.graphics.setShader()
        love.graphics.print("using a custom shader works")
    end
end)()

local texturesScene = (function()
    local data = love.image.newImageData(40, 40)
    for i = 0,39 do
        for j=0,39 do
            if i <= 20 then
                if j <= 20 then
                    data:setPixel(i, j, 1, 0, 0, 1)
                else
                    data:setPixel(i, j, 0, 1, 0, 1)
                end
            else
                if j <= 20 then
                    data:setPixel(i, j, 0, 0, 1, 1)
                else
                    data:setPixel(i, j, 1, 1, 1, 1)
                end
            end
        end
    end

    local data2 = love.image.newImageData(40, 40)
    for i = 0,39 do
        for j=0,39 do
            if i <= 20 then
                if j <= 20 then
                    data2:setPixel(i, j, 1, 0.5, 0, 1)
                else
                    data2:setPixel(i, j, 0, 1, 0.5, 1)
                end
            else
                if j <= 20 then
                    data2:setPixel(i, j, 0, 0.5, 1, 1)
                else
                    data2:setPixel(i, j, 1, 0.5, 1, 1)
                end
            end
        end
    end

    local texture1 = love.graphics.newTexture(data)
    local texture2 = love.graphics.newTexture(data2)

    local arrayTexture = love.graphics.newArrayImage({data, data2})

    local cubeShader = love.graphics.newShader [[
        uniform CubeImage cube;

        vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
        {
            vec3 direction = normalize(vec3(screen_coords, 0));
            return Texel(cube, direction);
        }
    ]]

    local cubeTexture = love.graphics.newCubeImage("cube_map.png")
    cubeShader:send("cube", cubeTexture)

    return function()
        love.graphics.print("drawing basic textures work:")
        love.graphics.draw(texture1, 30, 30)
        love.graphics.draw(texture2, 30, 80)

        love.graphics.print("drawing array images works:", 0, 150)
        love.graphics.drawLayer(arrayTexture, 1, 30, 180)
        love.graphics.drawLayer(arrayTexture, 2, 30, 230)

        love.graphics.print("drawing a cube texture works", 200, 0)
        love.graphics.setShader(cubeShader)
        love.graphics.rectangle("fill", 250, 50, 100, 100)
        love.graphics.setShader()
    end
end)()

local canvasScene = (function()
    local canvas
    local text

    canvas = love.graphics.newCanvas(50, 50)
    love.graphics.setCanvas(canvas)
    love.graphics.rectangle("line", 0, 0, 50, 50)
    love.graphics.circle("fill", 25, 25, 10)
    love.graphics.setCanvas()

    return function()
        love.graphics.print("drawing to a canvas works")
        love.graphics.draw(canvas, 50, 50)
    end
end)()

local mipScene = (function()
    textureMip = love.graphics.newTexture("test.jpg", { mipmaps = true })
    texture = love.graphics.newTexture("test.jpg")

    return function()
        love.graphics.print("mip is not working yet :(")
        love.graphics.print("with mip maps:", 0, 15)

        love.graphics.draw(textureMip, 10, 40, 0, 1/4)
        love.graphics.draw(textureMip, 200, 40, 0, 1/8)
        love.graphics.draw(textureMip, 300, 40, 0, 1/16)

        love.graphics.print("without mip maps:", 0, 300)
        love.graphics.draw(texture, 10, 320, 0, 1/4)
        love.graphics.draw(texture, 200, 320, 0, 1/8)
        love.graphics.draw(texture, 300, 320, 0, 1/16)
    end
end)()

local scenes
local sceneIndex

function nextScene()
    sceneIndex = sceneIndex + 1
    if sceneIndex > #scenes then
        sceneIndex = 1
    end
end

function love.load()
    scenes = {
        printScene,
        basicShapesScene,
        transformationsScene,
        videoScene,
        shaderScene,
        texturesScene,
        canvasScene,
        mipScene,
    }
    sceneIndex = 1
end

function love.draw()
    scenes[sceneIndex]()
end

function love.keypressed(key)
    if key == "r" then
        love.event.quit("restart")
    end
    if key == "escape" then
        love.event.quit()
    end
    nextScene()
end

function love.touchpressed()
    nextScene()
end
