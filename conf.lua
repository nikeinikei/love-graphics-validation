function love.conf(t)
    t.window.vsync = 1
    t.window.msaa = 4
    t.window.resizable = true
    t.renderers = {"vulkan", "opengl"}
    t.modules.audio = false
end
