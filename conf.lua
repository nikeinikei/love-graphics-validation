function love.conf(t)
    t.window.vsync = 1
    t.window.msaa = 4
    t.renderers = {"vulkan"}
    t.modules.audio = false
end
