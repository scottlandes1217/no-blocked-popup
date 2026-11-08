-- Forever's Gamepad UI blocks protected calls after almost any addon touches
-- a Blizzard window (a Blizzard bug), and the popup it shows triggers the next
-- block, so it loops. Stop every other frame from hearing the event.
local events = { "ADDON_ACTION_FORBIDDEN", "ADDON_ACTION_BLOCKED" }
local f = CreateFrame("Frame")

local function Silence()
    for _, event in ipairs(events) do
        for _, frame in ipairs({ GetFramesRegisteredForEvent(event) }) do
            if frame ~= f then frame:UnregisterEvent(event) end
        end
    end
end

local told
for _, event in ipairs(events) do f:RegisterEvent(event) end
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(_, event, addon, func)
    Silence()
    if event:find("^ADDON_ACTION") and not told then
        told = true
        print("|cff88ccffNo Blocked Popup|r: hid a blocked-action popup from "
            .. tostring(addon) .. " (" .. tostring(func) .. "). Further ones this session are hidden silently.")
    end
end)
Silence()
