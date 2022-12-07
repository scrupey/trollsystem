--Â© Copyright by Scrupey[76561198323285182]
TROLLSYS = TROLLSYS or {}

TROLLSYS.Version = "1.0"
TROLLSYS.Name = "TrollSystem"
TROLLSYS.Author = "Scrupey"

TROLLSYS.Prefix = "TrollSystem"

function TROLLSYS.Loading(modulesPath, loaderName)	
	local load_col = Color( 255, 200, 60 )
	local text_col = Color(255, 255, 255)
	local file_col = Color(33, 255, 0)
    local folder_col = Color(250, 100, 75)
    local curStackLevel = 0

    local function stackLevel()
		local str = "-"
		for i=0, curStackLevel do
			str = str .. "-"
		end
		return str
	end

	local function LoadFile(path,name)
		MsgC(load_col, "["..loaderName.."] ", text_col, stackLevel() .. " ", file_col, "File", text_col, ": ", load_col, name, "\n")
		
		if name[1] == "c" and name[2] == "l" then 
			if SERVER then 
				AddCSLuaFile(path..name) 
			end
			if CLIENT then
				include(path..name)
			end
		elseif name[1] == "s" and name[2] == "v" then 
			if SERVER then 
				include(path..name) 
			end
		elseif name[1] == "s" and name[2] == "h" then 
			if SERVER then 
				AddCSLuaFile(path..name) 
			end
			include(path..name)	
        end	
	end


	local function LoadFolder(path)
		MsgC(load_col, "["..loaderName.."] ", text_col, stackLevel() .. " ", folder_col, "Folder", text_col, " ", load_col, path, text_col, "\n")
		
        curStackLevel = curStackLevel + 1

		local _files, dir_ = file.Find(path.. "*", "LUA")

        for _,_file in ipairs(_files) do
            LoadFile(path, _file)
        end

		for _,folder_T in ipairs(dir_) do 
			LoadFolder(path .. folder_T .. "/")
		end

        curStackLevel = curStackLevel - 1
	end
    
    local _files, dir_ = file.Find(modulesPath .. "*", "LUA")
	LoadFolder(modulesPath)
	MsgC(load_col, "\n[" .. loaderName .. "] ", file_col, "All files were loaded. \n\n")

	if not TROLLSYS.Loaded then 
		TROLLSYS.Loaded = true
		hook.Run("TROLLSYS:Loaded")
	end
end

hook.Add("Initialize", "TROLLSYS.Init.LoadModules", function()
	TROLLSYS.Loading("trollsystem/", "TrollSystem")
end)
TROLLSYS.Loading("trollsystem/", "TrollSystem") 

