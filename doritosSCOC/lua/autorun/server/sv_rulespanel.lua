include("autorun/sh_rulespanel.lua")

util.AddNetworkString("rulesPanelOpen")
util.AddNetworkString("KickPlayer")

-- Function to open the rules panel
local function OpenRulesPanel(ply)
    net.Start("rulesPanelOpen")
    net.Send(ply)
end

-- Hook to open the rules panel for players when they initially spawn
hook.Add("PlayerInitialSpawn", "OpenRulesPanelOnSpawn", function(ply)
    OpenRulesPanel(ply)
end)

-- Hook to handle the command to open the rules panel
hook.Add("PlayerSay", "rulesCommand", function(ply, text, teamChat)
    local rulespanelCommand = string.lower(text:sub(1, 8))
    if rulespanelCommand == "!conduct" then
        OpenRulesPanel(ply)
        return ""
    end
end)

-- Receiver function to handle kicking players who haven't accepted the rules
net.Receive("KickPlayer", function(_, ply)
    if IsValid(ply) then
        ply:Kick((SIMPLERULES.Theme["KICK-REASON"])) 
    end
end)
