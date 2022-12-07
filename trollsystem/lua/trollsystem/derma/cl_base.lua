function TROLLSYS.WRes(size)
	return ScrW() * (size / 1920)
end

function TROLLSYS.HRes(size)
	return ScrH() * (size / 1080)
end

TROLLSYS.CreateFonts()

hook.Add("OnScreenSizeChanged", "TROLLSYS.FONTSREFRESH", function(oldW,oldH)
	TROLLSYS.CreateFonts()
end)

function TROLLSYS.CreateFonts()
	for i=5, 35 do
		surface.CreateFont( "TROLLSYS_" .. i, {
			font = "Arial",
			extended = false,
			size = TROLLSYS.HRes(i),
			weight = 5020,
			blursize = 0,
			scanlines = 0,
			antialias = false,
			underline = false,
			italic = false,
			strikeout = false,
			symbol = false,
			rotary = false,
			shadow = false,
			additive = false,
			outline = false,
		} )
	end
end