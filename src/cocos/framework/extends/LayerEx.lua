--[[

Copyright (c) 2011-2014 chukong-inc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

local Layer = cc.Layer

function Layer:onTouch(callback, isMultiTouches, swallowTouches)
    if type(isMultiTouches) ~= "boolean" then isMultiTouches = false end
    if type(swallowTouches) ~= "boolean" then swallowTouches = false end

    self:registerScriptTouchHandler(function(state, ...)
        local args = {...}
        local event = {name = state}
        if isMultiTouches then
            args = args[1]
            local points = {}
            for i = 1, #args, 3 do
                local x, y, id = args[i], args[i + 1], args[i + 2]
                points[id] = {x = x, y = y, id = id}
            end
            event.points = points
        else
            event.x = args[1]
            event.y = args[2]
        end
        return callback( event )
    end, isMultiTouches, 0, swallowTouches)
    self:setTouchEnabled(true)
    return self
end

function Layer:pauseTouch()
    self:setTouchEnabled(false)
end

function Layer:resumeTouch()
    self:setTouchEnabled(true)
end

function Layer:removeTouch()
    self:unregisterScriptTouchHandler()
    self:setTouchEnabled(false)
    return self
end

function Layer:onKeypad(callback)
    --old
    -- self:registerScriptKeypadHandler(callback)
    -- self:setKeyboardEnabled(true)

    --new
    local keyboardCallback = function ( keyCode, event )
        local event = { keycode = keyCode, target = event:getCurrentTarget() }
        return callback(event)
    end

    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(keyboardCallback, cc.Handler.EVENT_KEYBOARD_PRESSED )

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    return self
end

function Layer:pauseKeyPad()
    self:setKeyboardEnabled(false)
end

function Layer:resumeKeyPad()
    self:setKeyboardEnabled(true)
end

function Layer:removeKeypad()
    self:unregisterScriptKeypadHandler()
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListenersForType( cc.EVENT_KEYBOARD )
    self:setKeyboardEnabled(false)
    return self
end

function Layer:onAccelerate(callback)
    self:registerScriptAccelerateHandler(callback)
    self:setAccelerometerEnabled(true)
    return self
end

function Layer:pauseAccelerate()
    self:setAccelerometerEnabled(false)
end

function Layer:resumeAccelerate()
    self:setAccelerometerEnabled(true)
end

function Layer:removeAccelerate()
    self:unregisterScriptAccelerateHandler()
    self:setAccelerometerEnabled(false)
    return self
end

function Layer:pauseAllInput()
    self:pauseTouch()
    self:pauseKeyPad()
    self:pauseAccelerate()
end

function Layer:resumeAllInput()
    self:resumeTouch()
    self:resumeAccelerate()
    self:resumeKeyPad()
end
