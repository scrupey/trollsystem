net.Receive("TROLLSYS.OpenMenu", function()
    local frame = TROLLSYS.Frame({w = 960, h = 540, title = "Troll Menu"})

    local optionsPanel = vgui.Create("DPanel",frame)
    optionsPanel:SetPos(TROLLSYS.WRes(5),TROLLSYS.HRes(35))
    optionsPanel:SetSize(TROLLSYS.WRes(200),TROLLSYS.HRes(500))

    function optionsPanel:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(80,80,80,100))
    end

    local optionScroll = vgui.Create("DScrollPanel",optionsPanel)
    optionScroll:SetPos(TROLLSYS.WRes(0),TROLLSYS.HRes(10))
    optionScroll:Dock(FILL)

    local plyPanel = vgui.Create("DPanel", frame)
    plyPanel:SetPos(optionsPanel:GetX() + optionsPanel:GetWide() + 5,TROLLSYS.HRes(35))
    plyPanel:SetSize(TROLLSYS.WRes(300),TROLLSYS.HRes(500))
    plyPanel:Hide()

    local actionPanel = vgui.Create("DPanel", frame)
    actionPanel:SetPos(plyPanel:GetX() + plyPanel:GetWide() + 5,TROLLSYS.HRes(35))
    actionPanel:SetSize(TROLLSYS.WRes(440),TROLLSYS.HRes(500))
    actionPanel:Hide()

    local CHILDREN = {}
    
    for k,v in ipairs(TROLLSYS.OPTIONS) do
        local button = TROLLSYS.Button({parent = optionScroll,w = optionScroll:GetWide() - TROLLSYS.WRes(10), h = TROLLSYS.HRes(30), text = v.name})
        button:DockMargin(5,5,5,0)
        button:Dock(TOP)
        

        local bColor = Color(80,80,80,200)
        function button:PostPaint(w,h)
            
            if table.HasValue(CHILDREN, self) then 
                bColor = Color(0,255,0)
                draw.RoundedBox(10, 0, 0, w, h, bColor)
            end
        end

        function button:DoClick()
            table.Empty(CHILDREN)
            table.insert(CHILDREN,button)

            for key,value in ipairs(plyPanel:GetChildren()) do
                value:Remove()
            end

            for key,value in ipairs(actionPanel:GetChildren()) do
                value:Remove()
            end
            plyPanel:Hide()
            actionPanel:Hide()

            v["func"](plyPanel,actionPanel)
        end
    end
end)

net.Receive("TROLLSYS.CallOnClient", function()
    local id = net.ReadUInt(4)

    if id == 1 then
        local url = net.ReadString()

        local g_station = nil
        sound.PlayURL (url, "mono", function( station )
            if (IsValid(station)) then
                station:Play()
                g_station = station
            end
        end)
    elseif id == 6 then
        local url = net.ReadString()

        local frame = TROLLSYS.Frame({w = 1920, h = 1080, title = ""})
        local html = vgui.Create("DHTML", frame)
        html:Dock(FILL)
        html:OpenURL(url)
        frame:ShowCloseButton(false)


    elseif id == 11 then
        local duration = net.ReadUInt(32)
        local rainbowColor
        hook.Add("HUDPaint", "TROLLSYS.BLUR", function()
            rainbowColor = HSVToColor((CurTime() * 1640) % 360, 1, 1)
            draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), rainbowColor)
        end)
        timer.Simple(duration, function()
            hook.Remove("HUDPaint", "TROLLSYS.BLUR")
        end)
    elseif id == 12 then
        local material = net.ReadString()
        local duration = net.ReadUInt(32)
 
        local BGPanel = vgui.Create("DPanel")
        BGPanel:SetSize(ScrW(), ScrH())
        BGPanel:Center()
        BGPanel:SetBackgroundColor(Color(0, 0, 0, 255))
                
        local mat = vgui.Create("Material", BGPanel)
        mat:SetPos(0, 0)
        mat:SetSize(BGPanel:GetWide(), BGPanel:GetTall())

        mat:SetMaterial(material)

        mat.AutoSize = false

        timer.Simple(duration, function()
            BGPanel:Remove()
        end)
    elseif id == 13 then
        local duration = net.ReadUInt(32)

        hook.Add("CreateMove", "TROLLSYS.CHANGEKEYBINDS", function(cmd)
            if cmd:KeyDown(512) then
                cmd:SetSideMove(400)
            end

            if cmd:KeyDown(1024) then
                cmd:SetSideMove(-400)
            end

            if cmd:KeyDown(8) then
                cmd:SetForwardMove(-400)
            end

            if cmd:KeyDown(16) then
                cmd:SetForwardMove(400)
            end
        end)

        timer.Simple(duration, function()
            hook.Remove("CreateMove", "TROLLSYS.CHANGEKEYBINDS")
        end)
    end
end)