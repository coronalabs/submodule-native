--------------------------------------------------------------------------------
-- Sample code is MIT licensed, see https://coronalabs.com/links/code/license
-- Copyright (c) 2017 Corona Labs Inc. All Rights Reserved.
--------------------------------------------------------------------------------

-- Hide the device status bar.
display.setStatusBar(display.HiddenStatusBar)

-- Display the background image.
local background = display.newImage("paper_bkg.png", true)
background.x = display.contentCenterX
background.y = display.contentCenterY

--------------------------------------------------------------------------------
-- The "myTests" module used below provides functions implemented in native code.
-- It demonstrates how to fetch arguments and return values of various types.
-- Test output is printed to the device's logging system.
--------------------------------------------------------------------------------

local booleanValue
local numericValue
local stringValue
local collection

booleanValue = myTests.getRandomBoolean()
myTests.printBoolean(booleanValue)

numericValue = myTests.getRandomNumber()
myTests.printNumber(numericValue)

stringValue = myTests.getRandomString()
myTests.printString(stringValue)

collection = myTests.getRandomArray()
myTests.printArray(collection)

collection = myTests.getRandomTable()
myTests.printTable(collection)

myTests.printTableValuesXY({ x = 1, y = 2, z = 3 })
myTests.printTableValuesXY({ x = "I'm all alone." })

function onCall()
	print("callLuaFunction() has succeeded")
end
myTests.callLuaFunction(onCall)

function onAsyncCall()
	print("asyncCallLuaFunction() has succeeded")
end
myTests.asyncCallLuaFunction(onAsyncCall)
