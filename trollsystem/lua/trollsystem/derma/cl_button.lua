function TROLLSYS.Button(settings)
    settings = settings or {}
	settings["w"] = settings["w"] or 140
	settings["h"] = settings["h"] or 30
	settings["x"] = settings["x"] or 0
	settings["y"] = settings["y"] or 0
	settings["text"] = settings["text"] or "text"
	settings["textcolor"] = settings["textcolor"] or Color(255, 255, 255)

	if not settings["parent"] then
		return
	end

	button = vgui.Create("DButton", settings["parent"])
	button:SetSize(TROLLSYS.WRes(settings["w"]), TROLLSYS.HRes(settings["h"]))
	button:SetPos(TROLLSYS.WRes(settings["x"]), TROLLSYS.HRes( settings["y"]))
	button:SetText(settings["text"])
	button:SetFont("TROLLSYS_15")
	button:SetTextColor(settings["textcolor"])

	function button:Paint(w, h)
		draw.RoundedBox( 10, 0, 0, w, h, Color(89, 107, 107,settings["alpha"] or 100))
        
		surface.SetDrawColor(255,255,255,100)
		if self.PostPaint then self:PostPaint(w,h) end
	end

	button.WasHovered = false
	function button:Think()
		
		local hover = self:IsHovered() 
		local hoverLast = self.WasHovered
		if hover != hoverLast then
			self.WasHovered = hover
			surface.PlaySound("garrysmod/ui_hover.wav")
		end
	end

	function button:OnReleased()
		if(self.disabled or false) then return end
		surface.PlaySound("ui/buttonclick.wav")
	end

	return button
end