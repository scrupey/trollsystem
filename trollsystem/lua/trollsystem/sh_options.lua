TROLLSYS.DEFAULTDELAY = 5 -- In seconds

TROLLSYS.OPTIONS = TROLLSYS.OPTIONS or {}
TROLLSYS.MENU = TROLLSYS.MENU or {}
TROLLSYS.MENU.SELECTEDPLAYERS = TROLLSYS.MENU.SELECTEDPLAYERS or {} 

TROLLSYS.OPTIONS = {
    [1] = {
        ["name"] = "Play Sound",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end


            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(TROLLSYS.WRes(5),TROLLSYS.HRes(0))
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local urlEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "URL (.mp3)"})
            urlEntry:DockMargin(5,5,5,0)
            urlEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 1
                if urlEntry:GetValue() == "" then return end
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteString(urlEntry:GetValue())
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = { URL = net.ReadString(), newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 1
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                net.Start("TROLLSYS.CallOnClient")
                    net.WriteUInt(actionID, 4)
                    net.WriteString(value["URL"])
                net.Send(v)
            end
        end
    },
    [2] = {
        ["name"] = "Ignite",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 2
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)

                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = { TIME = net.ReadUInt(32), newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 2
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                v:Ignite(value.TIME)
            end
        end
    },
    [3] = {
        ["name"] = "Explode",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 3
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = { TIME = net.ReadUInt(32), newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    local explode = ents.Create("env_explosion")
                    explode:SetPos(v:GetPos())
                    explode:Spawn()
                    explode:SetKeyValue("iMagnitude", "220")
                    explode:Fire("Explode", 0, 0 )
                    explode:EmitSound("weapon_AWP.Single",400,400)
                
                end)
            end
        end
    },
    [4] = {
        ["name"] = "Strip weapons",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 4
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = { TIME = net.ReadUInt(32), newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 4
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    v:StripWeapons()
                end)
            end
        end
    },
    [5] = {
        ["name"] = "Kill",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 5
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)

                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = { TIME = net.ReadUInt(32), newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 5
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    v:Kill()
                end)
            end
        end
    },
    [6] = {
        ["name"] = "Open browser",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local urlEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "URL"})
            urlEntry:DockMargin(5,5,5,0)
            urlEntry:Dock(TOP)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)



            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 6
                if urlEntry:GetValue() == "" then return end
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteString(urlEntry:GetValue())
                    net.WriteUInt(iEntry,32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = {URL = net.ReadString() ,TIME = net.ReadUInt(32), newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 6
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    net.Start("TROLLSYS.CallOnClient")
                        net.WriteUInt(actionID, 4)
                        net.WriteString(value["URL"])
                    net.Send(v)
                end)
            end
        end
    },
    [7] = {
        ["name"] = "Crash game",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local crashEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Crash time", num = true})
            crashEntry:DockMargin(5,5,5,0)
            crashEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 7
                if crashEntry:GetValue() == "" then return end
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteUInt(crashEntry:GetValue(),32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = {TIME = net.ReadUInt(32),CRASH = net.ReadUInt(32), newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 7
            local iCrash = value["CRASH"]
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    local cmd = "local clock = os.clock function sleep(n) local t0 = clock() while clock() - t0 <= n do end end sleep(".. iCrash ..")"
                    v:SendLua(cmd)
                end)
            end
        end
    },
    [8] = {
        ["name"] = "Teleport in air",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local heightEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Height", num = true})
            heightEntry:DockMargin(5,5,5,0)
            heightEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 8
                if heightEntry:GetValue() == "" then return end
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteUInt(heightEntry:GetValue(),32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = {TIME = net.ReadUInt(32),HEIGHT = net.ReadUInt(32),newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 8
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    local pos = v:GetPos()
                    pos.z = pos.z + value["HEIGHT"]
                    
                    v:SetPos(pos)
                end)
            end
        end
    },
    [9] = {
        ["name"] = "Slow",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local slowEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Speed", num = true})
            slowEntry:DockMargin(5,5,5,0)
            slowEntry:Dock(TOP)

            local durationEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Duration", num = true})
            durationEntry:DockMargin(5,5,5,0)
            durationEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 9
                if slowEntry:GetValue() == "" or durationEntry:GetValue() == "" then return end
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteUInt(slowEntry:GetValue(),32)
                    net.WriteUInt(durationEntry:GetValue(),32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = {TIME = net.ReadUInt(32),SLOW = net.ReadUInt(32),DURATION = net.ReadUInt(32),newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 9
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    local runSpeed = v:GetRunSpeed()
                    local walkSpeed = v:GetWalkSpeed()
    
                    v:SetRunSpeed(value["SLOW"])
                    v:SetWalkSpeed(value["SLOW"])
    
                    timer.Simple(value.DURATION, function()
                        
                    v:SetRunSpeed(runSpeed)
                    v:SetWalkSpeed(walkSpeed)
                    end)
                end)
            end
        end
    },
    [10] = {
        ["name"] = "Freeze",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local durationEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Duration", num = true})
            durationEntry:DockMargin(5,5,5,0)
            durationEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 10
                if durationEntry:GetValue() == "" then return end
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteUInt(durationEntry:GetValue(),32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = {TIME = net.ReadUInt(32),DURATION = net.ReadUInt(32),newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 10
            local duration = value.DURATION
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    v:Freeze(true)
    
                    timer.Simple(value.DURATION, function()
                        v:Freeze(false)
                    end)
                end)
            end
        end
    },
    [11] = {
        ["name"] = "Rainbow vision",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local durationEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Duration", num = true})
            durationEntry:DockMargin(5,5,5,0)
            durationEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 11
                if durationEntry:GetValue() == "" then return end
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteUInt(durationEntry:GetValue(),32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = {TIME = net.ReadUInt(32),DURATION = net.ReadUInt(32),newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 11
            local duration = value.DURATION
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    net.Start("TrollSystem.CallOnClient")
                        net.WriteUInt(actionID, 4)
                        net.WriteUInt(duration,32)
                    net.Send(v)
                end)
            end
        end
    },
    [12] = {
        ["name"] = "Material vision",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local durationEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Duration", num = true})
            durationEntry:DockMargin(5,5,5,0)
            durationEntry:Dock(TOP)

            local materialEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Material", num = false})
            materialEntry:DockMargin(5,5,5,0)
            materialEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 12
                if durationEntry:GetValue() == "" or materialEntry:GetValue() == "" then return end
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteUInt(durationEntry:GetValue(),32)
                    net.WriteString(materialEntry:GetValue())
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = {TIME = net.ReadUInt(32),DURATION = net.ReadUInt(32),MATERIAL = net.ReadString(),newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 12
            local duration = value.DURATION
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                timer.Simple(value.TIME, function()
                    net.Start("TROLLSYS.CallOnClient")
                        net.WriteUInt(actionID, 4)
                        net.WriteString(value.MATERIAL)
                        net.WriteUInt(duration,32)
                    net.Send(v)
                end)
            end
        end
    },
    [13] = {
        ["name"] = "Change keybinds",
        ["func"] = function(panel,actionPanel)
            TROLLSYS.ShowAnimation(panel,actionPanel)

            function panel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end
            function actionPanel:Paint(w,h) draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100)) end

            local elementList = vgui.Create("DScrollPanel",actionPanel)
            elementList:SetPos(5,0)
            elementList:SetSize(actionPanel:GetWide() - 10, actionPanel:GetTall() - 10)
            elementList:Dock(FILL)

            local timeEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Time (till event)", num = true})
            timeEntry:DockMargin(5,5,5,0)
            timeEntry:Dock(TOP)

            local durationEntry = TROLLSYS.TextEntry({parent = elementList, w = actionPanel:GetWide() - 10, h = 30,y = 0, x = 0, title = true, subtext = "Duration", num = true})
            durationEntry:DockMargin(5,5,5,0)
            durationEntry:Dock(TOP)

            local sendButton = TROLLSYS.Button({parent = elementList,w = actionPanel:GetWide() - 10, h = 30, text = "Send"})
            sendButton:DockMargin(5,5,5,0)
            sendButton:Dock(TOP)

            function sendButton:DoClick()
                local actionID = 13
                if durationEntry:GetValue() == "" then return end
                local iEntry = (timeEntry:GetValue() != "" and timeEntry:GetValue() or TROLLSYS.DEFAULTDELAY)
                net.Start("TROLLSYS.SendRequest")
                    net.WriteUInt(actionID,4)
                    net.WriteUInt(iEntry,32)
                    net.WriteUInt(durationEntry:GetValue(),32)
                    net.WriteTable(TROLLSYS.MENU.SELECTEDPLAYERS)
                net.SendToServer()
            end
        end,
        ["ReadServer"] = function()
            local temp = {TIME = net.ReadUInt(32),DURATION = net.ReadUInt(32),newValue = net.ReadTable() }
            return temp
        end,
        ["ExecuteServer"] = function(value)
            local actionID = 13
            local duration = value.DURATION
            for k,v in ipairs(value.newValue) do
                if !v:IsPlayer() then continue end
                
                timer.Simple(value.TIME, function()
                    net.Start("TROLLSYS.CallOnClient")
                        net.WriteUInt(actionID, 4)
                        net.WriteUInt(duration,32)
                    net.Send(v)
                end)
            end
        end
    }
}

function TROLLSYS.AddPlayerList(panel)

    local dSearchEntry = TROLLSYS.TextEntry({parent = panel, w = 290, h = 30,y = 5, x = 5, title = true, subtext = "Player"})
    dSearchEntry:SetUpdateOnType(true)
    
    local dPlayerScroll = vgui.Create("DScrollPanel", panel)
    dPlayerScroll:SetPos(TROLLSYS.WRes(0),TROLLSYS.HRes(35))
    dPlayerScroll:SetSize(panel:GetWide(), panel:GetTall() - TROLLSYS.HRes(40))


    local function loadFilter(val)
        dPlayerScroll:Clear()
    
        for k, v in ipairs(player.GetAll()) do
    
            if val and #val > 0 then
                local name = string.lower(v:Nick())
    
                if !string.find(name, string.lower(val)) then
                    continue
                end
            end

            local dPButton = TROLLSYS.Button({parent = dPlayerScroll,w = 195, h = 30, text = v:Nick()})
            dPButton:DockMargin(5,5,5,0)
            dPButton:Dock(TOP)

            function dPButton:DoClick()
                if !table.HasValue(TROLLSYS.MENU.SELECTEDPLAYERS, v) then
                    table.insert(TROLLSYS.MENU.SELECTEDPLAYERS, v)
                else
                    table.RemoveByValue(TROLLSYS.MENU.SELECTEDPLAYERS, v)
                end
            end

            function dPButton:PostPaint(w,h)
                if table.HasValue(TROLLSYS.MENU.SELECTEDPLAYERS, v) then
                    bColor = Color(0,255,0)
                    draw.RoundedBox(10, 0, 0, w, h, bColor)
                end
            end
        end
    end


    function dSearchEntry:OnValueChange(value)
        loadFilter(value)
    end
    dSearchEntry:SetValue("")
end

function TROLLSYS.ShowAnimation(plyPanel,actionPanel)
    plyPanel:Show()
    actionPanel:Show()

    TROLLSYS.AddPlayerList(plyPanel)

    plyPanel:SetSize(0,TROLLSYS.HRes(500))
    actionPanel:SetSize(0,TROLLSYS.HRes(500))

    plyPanel:SizeTo(TROLLSYS.WRes(300), TROLLSYS.HRes(500), 0.1, 0, 1, function()
        actionPanel:SizeTo(TROLLSYS.WRes(440), TROLLSYS.HRes(500), 0.1, 0, 1, function()
        end)
    end)
end
