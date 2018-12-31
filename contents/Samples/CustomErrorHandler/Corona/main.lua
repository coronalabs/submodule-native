--------------------------------------------------------------------------------
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (c) 2017 Corona Labs Inc. All Rights Reserved.
--------------------------------------------------------------------------------

-- Import the widget library.
local widget = require("widget")

-- Hide the status bar.
display.setStatusBar(display.HiddenStatusBar)

-- Display a background.
local background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
background:setFillColor(1.0, 0.65, 0)


-- Set up a button to cause a Lua error to be handled by the Java LuaErrorHandlerFunction class.
function onLuaErrorButtonTapped()
	callNonExistingFunction()
end
luaErrorButton = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Throw Lua Error",
	labelColor = 
	{ 
		default = { 1.0, 1.0, 1.0 }, 
	},
	font = native.systemFontBold,
	emboss = true,
	onRelease = onLuaErrorButtonTapped,
}
luaErrorButton.x = display.contentWidth / 2
luaErrorButton.y = (display.contentHeight / 2) + (luaErrorButton.contentHeight / 2)


-- Set up a button to cause an unhandled Java exception.
function onExceptionButtonTapped()
	myTests.throwException()
end
exceptionButton = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Throw Native Exception",
	labelColor = 
	{ 
		default = { 1.0, 1.0, 1.0 }, 
	},
	font = native.systemFontBold,
	emboss = true,
	onRelease = onExceptionButtonTapped,
}
exceptionButton.x = display.contentWidth / 2
exceptionButton.y = luaErrorButton.y + luaErrorButton.contentHeight + (exceptionButton.contentHeight / 2)
