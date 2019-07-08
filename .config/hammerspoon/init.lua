local hyper = {"ctrl", "alt", "cmd"}

-- Set CTRL+~ as terminal "visor" mode
hs.hotkey.bind({'cmd'}, '`', nil, function()
    app = hs.application.get('kitty')
    if app == nil then
        return
    end

    -- do nothing if the app isn't running
    if app:isRunning() == false then
        return
    end

    -- unhide the app if hidden, and bring all windows to the front
    if app:isHidden() then
        app:unhide()
        app:activate(true)
        return
    end

    -- hide the app if currently focused
    -- or activate it if not
    if app:isFrontmost() then
        app:hide()
    else
        app:activate(true)
    end
end, nil, nil)

-- Set up window management
hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0
spoon.MiroWindowsManager:bindHotkeys({
    up = {hyper, "up"},
    right = {hyper, "right"},
    down = {hyper, "down"},
    left = {hyper, "left"},
    fullscreen = {hyper, "f"}
})