function TROLLSYS.Text(settings)

	settings = settings or {}
	settings["w"] = settings["w"] or 500
	settings["h"] = settings["h"] or 30
	settings["x"] = settings["x"] or 0
	settings["y"] = settings["y"] or 0
	settings["text"] = settings["text"] or "text"
	settings["font"] = settings["font"] or "TROLLSYS_20"
	settings["color"] = settings["color"] or Color(255, 255, 255)

	if not settings["parent"] then
		return
	end

	local text = vgui.Create( "DLabel", settings["parent"])
	text:SetSize(TROLLSYS.WRes(settings["w"]), TROLLSYS.HRes(settings["h"]))
	text:SetPos(TROLLSYS.WRes(settings["x"]), TROLLSYS.HRes(settings["y"]))
	text:SetText(settings["text"])
	text:SetFont(settings["font"])
	text:SetWrap(true)
	text:SetTextColor(settings["color"])

	return text

end