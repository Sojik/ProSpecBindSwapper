--[[---------------------------------------------------------

	ProSpecBindSwapper v1.0
		by Sokik < scott@pscottgrossman.com >

-----------------------------------------------------------]]--

local keys = {
"'", "`", 'Ä', 'Ö', 'Ü', '#', ',', '-', '.', '/', ';', '=', 'A', 'B', 
'BACKSPACE', 'C', 'D', 'DELETE', 'E', 'END', 'ENTER', 'ESCAPE', 'F', 
'G', 'H', 'HOME', 'I', 'INSERT', 'J', 'K', 'L', 'M', 'MOUSEWHEELDOWN', 
'MOUSEWHEELUP', 'N', 'NUMLOCK', 'NUMPADENTER', 'NUMPADMINUS', 
'NUMPADMULTIPLY', 'NUMPADPERIOD', 'NUMPADPLUS', 'NUMPADSLASH', 'O', 'P', 
'PAGEDOWN', 'PAGEUP', 'Q', 'R', 'S', 'SPACE', 'T', 'TAB', 'U', 'V', 'W', 
'X', 'Y', 'Z', '[', '\\', ']', '^',
}
for i = 0, 9 do
	keys[#keys+1] = tostring(i)
	keys[#keys+1] = 'NUMPAD'..i
end
for i = 1, 12 do
	keys[#keys+1] = 'F'..i
end
for i = 1, 5 do -- FrameXML/GlobalStrings.lua implies that the game supports up to 31 Mouse Buttons but 5 should be enough.
	keys[#keys+1] = 'BUTTON'..i
end
local modifiers = {
	'', 'ALT-', 'CTRL-', 'SHIFT-', 'ALT-CTRL-', 'ALT-SHIFT-', 'CTRL-SHIFT-', 'ALT-CTRL-SHIFT-'
}

local a = CreateFrame("Frame")

local function SuperAwesomeFunction(self, event, ...)
	local arg1 = ...
	if arg1 ~= PSBS["CurrentSpec"] then
		local temp = {}
		for _, key in ipairs(keys) do
			for _, modifier in ipairs(modifiers) do
				local action = GetBindingAction(modifier..key)
				if action and action ~= "" then
					temp[modifier..key] = action
					if PSBS["FirstLoad"]==false then
						SetBinding(modifier..key, nil)
					end
				end
			end
		end
		PSBS["CurrentSpec"] = arg1
		if PSBS["FirstLoad"]==true then
			PSBS["FirstLoad"] = false
		else
			for k, v in pairs(PSBS["OffspecBinds"]) do
				SetBinding(k, v)
			end
			SaveBindings(GetCurrentBindingSet())
		end
		PSBS["OffspecBinds"] = temp
		temp = nil
	end
end

local function OnPlayerEnteringWorld()
a:UnregisterEvent("PLAYER_ENTERING_WORLD")
PSBS = PSBS or {}
PSBS["OffspecBinds"] = PSBS["OffspecBinds"] or {}
PSBS["FirstLoad"] = PSBS["FirstLoad"] or true
PSBS["CurrentSpec"] = PSBS["CurrentSpec"] or nil
a:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
a:SetScript("OnEvent", SuperAwesomeFunction)
end

a:RegisterEvent("PLAYER_ENTERING_WORLD")
a:SetScript("OnEvent", OnPlayerEnteringWorld)