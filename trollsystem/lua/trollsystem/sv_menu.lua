util.AddNetworkString("TROLLSYS.OpenMenu")
util.AddNetworkString("TROLLSYS.SendRequest")

--Clientside
util.AddNetworkString("TROLLSYS.CallOnClient")

hook.Add("PlayerSay", "TROLLSYS.CHATCMD", function(ply,text)
    if TROLLSYS.GROUPS[ply:GetUserGroup()] then

        local sCmd = string.lower(text)
        local sCMDSeperator = string.sub(sCmd, 0, 1)

        local tCmd = {}

        if table.HasValue(TROLLSYS.CMDSEPERATOR, sCMDSeperator) then
            for k,v in ipairs(TROLLSYS.CMDSEPERATOR) do
                if string.StartWith(sCmd, v) then
                    tCmd = string.Split(sCmd, v)
                end
            end
        end
        if tCmd[2] == TROLLSYS.CMD then
            net.Start("TROLLSYS.OpenMenu")
            net.Send(ply)
            return TROLLSYS.PRINTCMD or false
        end

    end
end)

net.Receive("TROLLSYS.SendRequest", function(len,ply)
    if TROLLSYS.GROUPS[ply:GetUserGroup()] then
        local actionID = net.ReadUInt(4)
        local actionValue = TROLLSYS.OPTIONS[actionID]["ReadServer"]()
        TROLLSYS.OPTIONS[actionID]["ExecuteServer"](actionValue)
    end
end)