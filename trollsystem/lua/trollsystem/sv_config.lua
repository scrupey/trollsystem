TROLLSYS.GROUPS = TROLLSYS.GROUPS or {}
TROLLSYS.CMDSEPERATOR = TROLLSYS.CMDSEPERATOR or {}
TROLLSYS.CMD = TROLLSYS.CMD or ""

TROLLSYS.GROUPS = {     -- Groups that can access to the troll menu.
    superadmin = true,
    manager = true,
    developer = true,
    user = true           --!IMPORTANT! Leave out the comma at the last entry of your groups.
}

TROLLSYS.CMDSEPERATOR = {  -- it decides whether your menu can be opened with "/" or "!" or "@"
    "!",
    "/",
    "@"                         --!IMPORTANT! Leave out the comma at the last entry of your seperators.
}

TROLLSYS.CMD = "tr"
TROLLSYS.PRINTCMD = false