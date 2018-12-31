
-- Fetch the launch arguments.
local launchArguments = ...

-- Check if a scene was requested in the Android intent which launched this Corona activity.
local sceneName = nil
if launchArguments then
	if launchArguments.androidIntent then
		local androidIntentExtras = launchArguments.androidIntent.extras
		if androidIntentExtras then
			sceneName = androidIntentExtras.sceneName
		end
	end
end

-- Load the requested scene.
if sceneName == "polygons" then
	require("polygonScene")
elseif sceneName == "fishies" then
	require("fishiesScene")
elseif sceneName == "clock" then
	require("clockScene")
else
	require("defaultScene")
end
