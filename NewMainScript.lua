repeat task.wait() until game:IsLoaded()
shared.oldgetcustomasset = shared.oldgetcustomasset or getcustomasset
task.spawn(function()
    repeat task.wait() until shared.VapeFullyLoaded
    getgenv().getcustomasset = shared.oldgetcustomasset -- vape bad code moment
end)
local CheatEngineMode = false
if (not getgenv) or (getgenv and type(getgenv) ~= "function") then CheatEngineMode = true end
if getgenv and not getgenv().shared then CheatEngineMode = true; getgenv().shared = {}; end
if getgenv and not getgenv().debug then CheatEngineMode = true; getgenv().debug = {traceback = function(string) return string end} end
if getgenv and not getgenv().require then CheatEngineMode = true; end
if getgenv and getgenv().require and type(getgenv().require) ~= "function" then CheatEngineMode = true end
local debugChecks = {
    Type = "table",
    Functions = {
        "getupvalue",
        "getupvalues",
        "getconstants",
        "getproto"
    }
}
if identifyexecutor and type(identifyexecutor) == "function" and tostring(identifyexecutor()):lower() == "appleware" then CheatEngineMode = true end
local function checkDebug()
    if not getgenv().debug then 
        CheatEngineMode = true 
    else 
        if type(debug) ~= debugChecks.Type then 
            CheatEngineMode = true
        else 
            for i, v in pairs(debugChecks.Functions) do
                if not debug[v] or (debug[v] and type(debug[v]) ~= "function") then 
                    CheatEngineMode = true 
                else
                    local suc, res = pcall(debug[v]) 
                    if tostring(res) == "Not Implemented" then 
                        CheatEngineMode = true 
                    end
                end
            end
        end
    end
end
if (not CheatEngineMode) then checkDebug() end
local RiseMode = true
local baseDirectory = RiseMode and "rise/" or "vape/"
if (not isfolder('vape')) then makefolder('vape') end
if (not isfolder('rise')) then makefolder('rise') end
shared.CheatEngineMode = shared.CheatEngineMode or CheatEngineMode
local errorPopupShown = false
local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end
if not isfolder(baseDirectory) then makefolder(baseDirectory) end
local VWFunctions = {}
function VWFunctions.CreateID()
    pcall(function()
        local HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        local headers = {
            ["Content-type"] = "application/json",
            ["Authorization"] = "Bearer blankwontddosthis:3"
        }
        local data = {["client_id"] = tostring(HWID), ["user_id"] = tonumber(game:GetService("Players").LocalPlayer.UserId)}
        local final_data = game:GetService("HttpService"):JSONEncode(data)
        local url = "https://api.vapevoidware.xyz/create_id"
        local a = request({
            Url = url,
            Method = 'POST',
            Headers = headers,
            Body = final_data
        })
        
        if a['StatusCode'] == 200 then
            writefile(baseDirectory..'id.txt', game:GetService("HttpService"):JSONDecode(a["Body"])["id"])
        else
            writefile(baseDirectory..'id.txt', "discord")
        end
        --[[elseif a['StatusCode'] == 403 then
            game:GetService("Players").LocalPlayer:Kick("Voidware Error]: Error doing step1 Error code: 1986")
        elseif a['StatusCode'] == 401 then
            game:GetService("Players").LocalPlayer:Kick("Voidware Error]: Error doing step1 Error code: 1922")
        elseif a['StatusCode'] == 429 then
            game:GetService("Players").LocalPlayer:Kick("Voidware Error]: Error doing step1 Error code: 1954 Please rejoin!")
        else
            game:GetService("Players").LocalPlayer:Kick("Voidware Error]: Error doing step1 Error code: 2000".." | "..tostring(a["StatusCode"]))
        end--]]
        if shared.api_key then
            local key = shared.api_key
            local headers = {
                ["Content-type"] = "application/json",
                ["api-key"] = tostring(key)
            }
        
            local jsondata = {
                ["roblox_username"] = tostring(game.Players.LocalPlayer.Name)
            }
        
            local res = request({
                Url = 'https://whitelist.vapevoidware.xyz/edit_wl',
                Method = 'POST',
                Headers = headers,
                Body = game:GetService("HttpService"):JSONEncode(jsondata)
            })
        
            if res['StatusCode'] == 200 then
                InfoNotification("Voidware Whitelist", "Successfully whitelisted you upon execution. If you aren't whitelist, rejoin!", 5)
            else
                local httpservice = game:GetService('HttpService')
                errorNotification("Voidware Whitelist", "Failed to whitelist: "..((httpservice:JSONDecode(res.Body).error) or "Unknown error"), 10)
            end
        end

        if shared.connection_key then
            local key = shared.connection_key
            local headers = {
                ["Content-type"] = "application/json",
            }
        
            local jsondata = {
                ["roblox_user_id"] = tonumber(game:GetService("Players").LocalPlayer.UserId),
                ["connection_key"] = tostring(key),
            }
        
            local res = request({
                Url = 'https://storage.vapevoidware.xyz/storage/redeem-key',
                Method = 'POST',
                Headers = headers,
                Body = game:GetService("HttpService"):JSONEncode(jsondata)
            })

            print(res.Body)
        
            if res['StatusCode'] == 200 then
                InfoNotification("Voidware Connection Key", "Successfully connected key!", 5)
            else
                local httpservice = game:GetService('HttpService')
                errorNotification("Voidware Connection Key", "Failed to connect key: "..((httpservice:JSONDecode(res.Body).error) or "Unknown error"), 10)
            end
        end
    
        --[[if shared.VoidDev then
            print("Raw Response: "..tostring(a))
            print("Decompressed data showing below:")
            if type(a) == "table" then
                for i,v in pairs(a) do
                    print("Showing data for: "..tostring(i))
                    if type(a[i]) == "table" then
                        print("Table reponse for "..tostring(i).." detected! Showing the table:")
                        for i2, v2 in pairs(a[i]) do
                            print("Showing data for: "..tostring(i2))
                            print("Data: "..tostring(a[i][i2]))
                        end
                    else
                        print("Data: "..tostring(a[i]))
                    end
                    print("Continuing with next child of the table:")
                    print("[-----------------------------]")
                end
            else
                print("The response type is invalid! (Expected: table)")
            end
        end--]]
    end)
end
local version = 1
function VWFunctions.LogStats()
    pcall(function()
        local executor
        if identifyexecutor then executor = identifyexecutor() else executor = "Unknown" end
        local HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        local executors = {"solara", "fluxus", "macsploit", "hydrogen", "wave", "codex", "arceus", "delta", "vega", "cubix", "celery", "cryptic", "cacti", "appleware", "synapse", "salad"}
        if identifyexecutor then
            for i,v in pairs(executors) do
                if string.find(string.lower(identifyexecutor()), executors[i]) then
                    executor = executors[i]
                    break
                end
            end
        end
        local headers = {
            ["Content-type"] = "application/json",
            ["Authorization"] = "Bearer imsureitwontgetddosed"
        }
        local data = {
            ["client_id"] = tostring(HWID), 
            ["executor"] = tostring(executor)
        }
        local final_data = game:GetService("HttpService"):JSONEncode(data)
        local url = "https://voidware-stats.vapevoidware.xyz/stats/data/add"
        local a = request({
            Url = url,
            Method = 'POST',
            Headers = headers,
            Body = final_data
        })
        local statusCodes = {
            ["403"] = "Voidware Error]: Error doing step2 Error code: 1986",
            ["401"] = "Voidware Error]: Error doing step2 Error code: 1922",
            ["429"] = "Voidware Error]: Error doing step2 Error code: 1954 Please rejoin!"
        }
        if a["StatusCode"] ~= 200 then if statusCodes[tostring(a["StatusCode"])] then warn(tostring(statusCodes[tostring(a["StatusCode"])])) else warn("Voidware Error]: Error doing step2 Error code: 1900") end end
    end)
end
function VWFunctions.GetHttpData()
    pcall(function()    
        local client_id = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        local user_id = tostring(game:GetService("Players").LocalPlayer.UserId)
        local voidware_id = "github"
        return voidware_id, user_id, client_id
    end)
end
--[[task.spawn(function()
    VWFunctions.CreateID()
    VWFunctions.LogStats()
end)--]]
shared.VWFunctions = VWFunctions
getgenv().VWFunctions = VWFunctions
local blacklistedexecutors = {"solara", "celery", "appleware"}
if identifyexecutor then
    local executor = identifyexecutor()
    for i,v in pairs(blacklistedexecutors) do
        if string.find(string.lower(executor), blacklistedexecutors[i]) then 
            shared.BlacklistedExecutor = {Value = true, Executor = tostring(executor)}
        end
    end
end
local function install_profiles(num)
    if not num then return warn("No number specified!") end
    local httpservice = game:GetService('HttpService')
    local guiprofiles = {}
    local profilesfetched
    local repoOwner = RiseMode and "VapeVoidware/RiseProfiles" or "Erchobg/VoidwareProfiles"
    local function vapeGithubRequest(scripturl)
        if not isfile(baseDirectory..scripturl) then
            local suc, res = pcall(function() return game:HttpGet('https://raw.githubusercontent.com/'..repoOwner..'/main/'..scripturl, true) end)
            if not isfolder(baseDirectory.."Profiles") then
                makefolder(baseDirectory..'Profiles')
            end
            if not isfolder(baseDirectory..'ClosetProfiles') then makefolder(baseDirectory..'ClosetProfiles') end
            writefile(baseDirectory..scripturl, res)
            task.wait()
        end
        return print(scripturl)
    end
    local Gui1 = {
        MainGui = ""
    }
    local gui = Instance.new("ScreenGui")
        gui.Name = "idk"
        gui.DisplayOrder = 999
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        gui.OnTopOfCoreBlur = true
        gui.ResetOnSpawn = false
        gui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
        Gui1["MainGui"] = gui
    
    local function downloadVapeProfile(path)
        print(path)
        task.spawn(function()
            local textlabel = Instance.new('TextLabel')
            textlabel.Size = UDim2.new(1, 0, 0, 36)
            textlabel.Text = 'Downloading '..path
            textlabel.BackgroundTransparency = 1
            textlabel.TextStrokeTransparency = 0
            textlabel.TextSize = 30
            textlabel.Font = Enum.Font.SourceSans
            textlabel.TextColor3 = Color3.new(1, 1, 1)
            textlabel.Position = UDim2.new(0, 0, 0, -36)
            textlabel.Parent = Gui1.MainGui
            task.wait(0.1)
            textlabel:Destroy()
            vapeGithubRequest(path)
        end)
        return
    end
    task.spawn(function()
        local res1
        if num == 1 then
            res1 = "https://api.github.com/repos/"..repoOwner.."/contents/Profiles"
        elseif num == 2 then
            res1 = "https://api.github.com/repos/Erchobg/VoidwareProfiles/contents/ClosetProfiles"
        end
        res = game:HttpGet(res1, true)
        if res ~= '404: Not Found' then 
            for i,v in next, game:GetService("HttpService"):JSONDecode(res) do 
                if type(v) == 'table' and v.name then 
                    table.insert(guiprofiles, v.name) 
                end
            end
        end
        profilesfetched = true
    end)
    repeat task.wait() until profilesfetched
    for i, v in pairs(guiprofiles) do
        local name
        if num == 1 then name = "Profiles/" elseif num == 2 then name = "ClosetProfiles/" end
        downloadVapeProfile(name..guiprofiles[i])
        task.wait()
    end
    if (not isfolder(baseDirectory..'Libraries')) then makefolder(baseDirectory..'Libraries') end
    if num == 1 then writefile(baseDirectory..'Libraries/profilesinstalled3.txt', "true") elseif num == 2 then writefile(baseDirectory..'ClosetProfiles/profilesinstalled3.txt', "true") end 
end
local function are_installed_1()
    if not isfolder(baseDirectory..'Profiles') then makefolder(baseDirectory..'Profiles') end
    if isfile(baseDirectory..'Libraries/profilesinstalled3.txt') then return true else return false end
end
local function are_installed_2() 
    if not isfolder(baseDirectory..'ClosetProfiles') then makefolder(baseDirectory..'ClosetProfiles') end
    if isfile(baseDirectory..'ClosetProfiles/profilesinstalled3.txt') then return true else return false end
end
if not are_installed_1() then install_profiles(1) end
if not are_installed_2() then install_profiles(2) end
local url = RiseMode and "https://github.com/VapeVoidware/VWRise/" or "https://github.com/VapeVoidware/VoidwareBakup"
if not shared.VapeDeveloper then 
	local commit = "main"
	for i,v in pairs(game:HttpGet(url):split("\n")) do 
		if v:find("commit") and v:find("fragment") then 
			local str = v:split("/")[5]
			commit = str:sub(0, str:find('"') - 1)
			break
		end
	end
	if commit then
		if isfolder(baseDirectory) then 
		    writefile(baseDirectory.."commithash2.txt", commit)
			if ((not isfile(baseDirectory.."commithash.txt")) or (readfile(baseDirectory.."commithash.txt") ~= commit or commit == "main")) then
				for i,v in pairs({baseDirectory.."Universal.lua", baseDirectory.."MainScript.lua", baseDirectory.."GuiLibrary.lua"}) do 
					if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
                        if not shared.VoidDev then
						    delfile(v)
                        end
					end 
				end
				if isfolder(baseDirectory.."CustomModules") then 
					for i,v in pairs(listfiles(baseDirectory.."CustomModules")) do 
						if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
                            if not shared.VoidDev then
							    delfile(v)
                            end
						end 
					end
				end
				if isfolder(baseDirectory.."Libraries") then 
					for i,v in pairs(listfiles(baseDirectory.."Libraries")) do 
						if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
                            if not shared.VoidDev then
							    delfile(v)
                            end
						end 
					end
				end
				writefile(baseDirectory.."commithash2.txt", commit)
			end
		else
			makefolder("vape")
			writefile(baseDirectory.."commithash2.txt", commit)
		end
	else
		error("Failed to connect to github, please try using a VPN.")
	end
end
if not shared.VapeDeveloper then 
	local commit = "main"
	for i,v in pairs(game:HttpGet("https://github.com/VapeVoidware/vapevoidware"):split("\n")) do 
		if v:find("commit") and v:find("fragment") then 
			local str = v:split("/")[5]
			commit = str:sub(0, str:find('"') - 1)
			break
		end
	end
	if commit then
		if isfolder("vape") then 
			if ((not isfile(baseDirectory.."commithash.txt")) or (readfile(baseDirectory.."commithash.txt") ~= commit or commit == "main")) then
				writefile(baseDirectory.."commithash.txt", commit)
			end
		else
			makefolder("vape")
			writefile(baseDirectory.."commithash.txt", commit)
		end
	else
		error("Failed to connect to github, please try using a VPN.")
	end
end
local function vapeGithubRequest(scripturl, isImportant)
    if isfile(baseDirectory..scripturl) then
        if not shared.VoidDev then
            pcall(function() delfile(baseDirectory..scripturl) end)
        else
            return readfile(baseDirectory..scripturl) 
        end
    end
    local suc, res
    local url = (scripturl == "MainScript.lua" or scripturl == "GuiLibrary.lua" or scripturl == "NewMainScript.lua") and RiseMode and "https://raw.githubusercontent.com/VapeVoidware/VWRise/" or "https://raw.githubusercontent.com/VapeVoidware/VoidwareBakup/"
    print(url..readfile(baseDirectory.."commithash2.txt").."/"..scripturl)
    suc, res = pcall(function() return game:HttpGet(url..readfile(baseDirectory.."commithash2.txt").."/"..scripturl, true) end)
    if not suc or res == "404: Not Found" then
        if isImportant then
            game:GetService("Players").LocalPlayer:Kick("Failed to connect to github : "..baseDirectory..scripturl.." : "..res)
        end
        warn(baseDirectory..scripturl, res)
    end
    if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
    return res
end
local function pload(fileName, isImportant, required)
    fileName = tostring(fileName)
    if string.find(fileName, "CustomModules") and string.find(fileName, "Voidware") then
        fileName = string.gsub(fileName, "Voidware", "VW")
    end        
    if shared.VoidDev and shared.DebugMode then warn(fileName, isImportant, required, debug.traceback(fileName)) end
    local res = vapeGithubRequest(fileName, isImportant)
    local a = loadstring(res)
    local suc, err = true, ""
    if type(a) ~= "function" then suc = false; err = tostring(a) else if required then return a() else a() end end
    if (not suc) then 
        if isImportant then
            if (not string.find(string.lower(err), "vape already injected")) and (not string.find(string.lower(err), "rise already injected")) then
                task.spawn(function()
                    repeat task.wait() until errorNotification
                    errorNotification("Failure loading critical file! : "..baseDirectory..tostring(fileName), " : "..tostring(debug.traceback(err)), 10) 
                end)
            end
            --warn("Failure loading critical file! : vape/"..tostring(fileName).." : "..tostring(debug.traceback(err)))
            --if (not string.find(string.lower(err), "vape already injected")) then game:GetService("Players").LocalPlayer:Kick("Failure loading critical file! : vape/"..tostring(fileName).." : "..tostring(debug.traceback(err))) end
        else
            task.spawn(function()
                repeat task.wait() until errorNotification
                if not string.find(res, "404: Not Found") then 
                    errorNotification('Failure loading: '..baseDirectory..tostring(fileName), tostring(debug.traceback(err)), 7)
                end
            end)
        end
    end
end
shared.pload = pload
getgenv().pload = pload
return pload("MainScript.lua", true)