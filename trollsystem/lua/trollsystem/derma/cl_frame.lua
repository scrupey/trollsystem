function TROLLSYS.Frame(settings)
    settings["x"] = settings["x"] or 0
    settings["y"] = settings["y"] or 0
    settings["w"] = settings["w"] or 600
    settings["h"] = settings["h"] or 400
    settings["title"] = settings["title"] or "Titel"
    settings["troll"] = settings["troll"] or false

    local frame = vgui.Create("DFrame")
    frame:SetSize(0, 0)
    frame:SetTitle("")
    frame:ShowCloseButton(true)
    
    if settings["x"] == 0 and settings["y"] == 0 then
        frame:Center()
    else
        frame:SetPos(TROLLSYS.WRes(settings["x"]),TROLLSYS.HRes(settings["y"]))
    end

    --Animation
    local isAnimating = true
    frame:SizeTo(TROLLSYS.WRes(settings["w"]), TROLLSYS.HRes(settings["h"]), 1.0, 0, 0.1, function()
        isAnimating = false
    end)

    frame.Think = function(me)
        if isAnimating then
            me:Center()
        end
    end
    --

    local speed = 120
    local rainbowColor

    function frame:Paint(w, h)
        rainbowColor = HSVToColor((CurTime() * speed) % 360, 1, 1)
        --Background
        draw.RoundedBox(0, 0,0, w, h, Color(50,50,50,255))

        --Outline

        --Header
        draw.RoundedBox(0, 1, TROLLSYS.HRes(25), w - TROLLSYS.WRes(2), 1, rainbowColor)
        draw.DrawText(settings["title"],"TROLLSYS_20",TROLLSYS.WRes(5),TROLLSYS.HRes(2.5),Color(255,255,255),0)
    end
    frame:ShowCloseButton(false)

    local closeButton = TROLLSYS.Button({parent = frame, w = 60, h = 15, x = settings["w"] - 62.5,y = 5,text = "X", font = "TROLLSYS_10"})

    function closeButton:DoClick()
        frame:Remove()
    end

    frame:SetDraggable(true)
    frame:MakePopup()
    return frame
end
