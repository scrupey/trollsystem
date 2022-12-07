function TROLLSYS.TextEntry(settings)
    settings = settings or {}
	settings["w"] = settings["w"] or 140
	settings["h"] = settings["h"] or 30
	settings["x"] = settings["x"] or 0
	settings["y"] = settings["y"] or 0
	settings["title"] = settings["title"] or true
	settings["placeholder"] = settings["placeholder"] or ""

	if not settings["parent"] then
		return
	end

	textEntry = vgui.Create("DTextEntry", settings["parent"])
	textEntry:SetSize(TROLLSYS.WRes(settings["w"]), TROLLSYS.HRes(settings["h"]))
	textEntry:SetPos(TROLLSYS.WRes(settings["x"]), TROLLSYS.HRes( settings["y"]))
	textEntry:SetFont("TROLLSYS_15")
	textEntry:SetTextColor(settings["textcolor"])
	if settings["num"] then
		textEntry:SetNumeric(true)
	end

	if settings["placeholder"] then
		textEntry:SetPlaceholderText(settings["placeholder"])
	end
    
	function textEntry:Paint(w, h)
		draw.RoundedBox( 3, 0, 0, w, h, Color(89, 107, 107,255))
		surface.SetDrawColor(255,255,255,100)
		self:DrawTextEntryText(Color(255, 255, 255, 255), Color(30, 130, 255), Color(255, 255, 255, 255))

        if string.len(self:GetValue()) == 0 and settings["subtext"] != nil then
			if !self:HasFocus() then
        		draw.SimpleText(settings["subtext"], "TROLLSYS_15", 3, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
        end
	end

	if settings["title"] then
		local x = settings["x"]
		local y = settings["y"] - 30
		local overText = TROLLSYS.Text({parent = settings["parent"], w = settings["w"], h = settings["h"], x = x, y = -30, text = settings["text"], font = "TROLLSYS_20"})
	end

	return textEntry
end