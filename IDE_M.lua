local s = tick();
local Lines = script.Parent:WaitForChild("Lines")
local OnLine = script:WaitForChild("OnLine")
local Colors = require(script:WaitForChild("Colors"))

local GetLatestLine = function()
	local Num = #Lines:GetChildren() - 2
	if Num == 0  then
		return 0
	else
		for i,v in ipairs(Lines:GetChildren()) do
			if v:IsA("Frame") then
				if v.Num.Value == Num then
					return v	
				end
			end
		end
	end
end

local ToLettersTable = function(s)
	local t = {}
	s:gsub(".", function(c) table.insert(t, c) return c end)
	return t
end

local GetSplit = function(Str)
	return string.split(Str," ");
end

local AddSpaces = function(Table)
	local newtab_ = {};
	for i,v in ipairs(Table) do
		table.insert(newtab_,v);
		table.insert(newtab_," ");
	end;
	return (newtab_);
end

local FindColor = function(word)
	return Colors[word]
end;

local CombineTableToString = function(Table)
	local str = ""
	for i,v in ipairs(Table) do
		str = str..v
	end
	return str
end

local FindLineByNumber = function(Num1)
	for i,v in ipairs(Lines:GetChildren()) do
		if v:IsA("Frame") then
			if v.Num == Num1 then
				return v
			end
		end
	end
end

OnLine.Changed:Connect(function(Value)
	local Line = FindLineByNumber(Value)
end)

local UIS = game:GetService("UserInputService")

local Coloring = function(Line__)
	local Split = GetSplit(Line__:FindFirstChild("ContentBox").Text);
	if #Split >= 1 then
		for i,v in ipairs(Split) do
			local v_ = v
			local Color = FindColor(v)
			if typeof(Color) == "string" then
				Split[i] = '<font color="'..'rgb('..Color..")"..'"'..">"..v_.."</font>"
				local NewSplit = AddSpaces(Split)
				local FormedText = CombineTableToString(NewSplit)
				Line__:FindFirstChild("Content").Text = FormedText
			elseif typeof(Color) ~= "string" then
				local Color_ = FindColor(string.sub(v,1,1))
				
				if typeof(Color_) == "string" then
					
					if Color_ == "106, 244, 103" then
						
						local LastLetter = string.sub(
							v,
							1,
							string.len(v)
						)
						local Letters
						local Index_M = nil
						
						if LastLetter == '"' then
							Split[i] = '<font color="'..'rgb('..Color_..")"..'"'..">"..v_.."</font>"
						else
							Letters = ToLettersTable(v)
							for i,v in ipairs(Letters) do
								if v == '"' then
									Index_M = i
								end
							end
							local RestCombination = ""
							local m__ = ""
							
							if Index_M == nil then
								Split[i] = '<font color="'..'rgb('.."255, 255, 255"..")"..'"'..">"..v_.."</font>"
							elseif Index_M ~= nil then
								if Index_M ~= #Letters then
									for x,z in ipairs(Letters) do
										if x > Index_M then
											RestCombination = RestCombination .. z
										end
									end
								end
								
								repeat
									task.wait()
									table.remove(Letters,Index_M+1)
								until #Letters == Index_M
								
								m__ = CombineTableToString(Letters)
								
								Split[i] = '<font color="'..'rgb('..Color_..")"..'"'..">"..m__.."</font>"..RestCombination
							end
						end
						
					else
						Split[i] = '<font color="'..'rgb('..Color_..")"..'"'..">"..v_.."</font>"
					end;
					
					local NewSplit = AddSpaces(Split)
					local FormedText = CombineTableToString(NewSplit)
					Line__:FindFirstChild("Content").Text = FormedText
				end
			end
		end
	end;
end

local CreateNewLine = function()
	local Line_ = GetLatestLine()
	if Line_ == 0 then
		local Line__ = script.Parent.Line:Clone()
		Line__.Parent = Lines
		Line__.ContentBox.Text = "";
		Line__.Content.Text = "";
		Line__.Num.Value = 1
		Line__.Visible = true
		Line__:FindFirstChild("ContentBox"):GetPropertyChangedSignal("Text"):Connect(function()
			Coloring(Line__)
		end)
		Line__:FindFirstChild("ContentBox").Changed:Connect(function()
			Line__:FindFirstChild("Content").Text = Line__:FindFirstChild("ContentBox").Text
			Coloring(Line__)
		end)
	else
		local Line__ = Line_:Clone()
		Line__.Parent = Lines
		Line__.ContentBox.Text = "";
		Line__.Content.Text = "";
		Line__.Num.Value = (Line_.Num.Value + 1)
		Line__:FindFirstChild("ContentBox"):GetPropertyChangedSignal("Text"):Connect(function()
			Coloring(Line__)
		end)
		Line__:FindFirstChild("ContentBox").Changed:Connect(function()
			Line__:FindFirstChild("Content").Text = Line__:FindFirstChild("ContentBox").Text
			Coloring(Line__)
		end)
	end
end

UIS.InputBegan:Connect(function(Input,GP)
	if not GP then
		if Input.KeyCode == Enum.KeyCode.Return or Input.KeyCode == Enum.KeyCode.KeypadEnter then
			CreateNewLine()		
		end
	end
end)

--(( Functionality ))

local Echo = function(s)
	local _a = script.Parent.Output:Clone()
	_a.Parent = script.Parent.Console
	_a.Visible = true
	_a.Text = s
end;

local FindMethod = function(met, tab)
	for i,v in tab do
		if string.find(string.lower(v),string.lower(met)) then
			return i
		end
	end
	return 0
end

local AllMethods = {
	":echo",
	":addobject"
}

local FindVariable = function(nam)
	for i,v in ipairs(Lines:GetChildren()) do
		if v:IsA("Frame") then
			if string.find(string.lower(v.Content.Text),'def') then
				local split = ToLettersTable(v.Content.Text)
				local mark1 = nil;
				local mark2 = nil;
				print("Passed")
				for i,v in ipairs(split) do
					if v == " " then
						table.remove(split,i)
					end
				end
				
				table.remove(split,1)
				table.remove(split,1)
				table.remove(split,1)
				table.remove(split,1)
				
				local equalsindex = nil;
				for i,v in ipairs(split) do
					if v == "=" then
						equalsindex = i
						break
					end
				end
				
				local Left_ = equalsindex - 1
				local varname = "";
				local cura = 0;
				repeat
					cura += 1
					task.wait()
					varname = varname..split[Left_-cura]
				until cura == Left_
				print(varname)
				
				if string.lower(varname) == string.lower(nam) then
					--// getting value

					for y,x in split do
						if x == '"' then
							if mark1 == nil then
								mark1 = y
							elseif mark2 == nil then
								mark2 = y
							elseif mark1 ~= nil and mark2 ~= nil then
								break
							end
						end
					end

					local Left = (mark2-mark1)-1
					local curi = 0;
					local Formed = "";
					repeat
						curi += 1
						task.wait()
						Formed = Formed..split[Left+curi]
					until curi == Left
					
					return Formed
				end
				
			end
		end
	end
end

local RemoveMarkdownAndGetInfoMethods = function(tab)
	local ToRemove = {
		"<font",
		"color=",
		">",
		"</font>",
		")'"
	}
	local ToIgnore = {
		'"'
	}
	local TabToRet = {
		Result = {};
		Method = "";
		Arguments = {};
	}
	local tab_ = tab
	local newtab = table.clone(tab)
	
	local self = {};
	self.IsArg = function(s)
		local L1 = string.sub(s,1,1)
		local L2 = string.sub(s,string.len(s),string.len(s))
		if L1 == '"' and L2 == '"' then
			return true
		else
			return false
		end
	end
	
	for i,v in ipairs(tab) do
		for x,y in ipairs(ToRemove) do
			if string.find(string.lower(v),string.lower(y)) then
				
				for p,q in ipairs(AllMethods) do
					
					if not string.find(string.lower(v),":") then
						table.remove(newtab,i)
					elseif string.find(string.lower(v),":") then
						local ltrs_ = ToLettersTable(v)
						local IndexLeft
						local IndexRight
						local IndexIndicator
						for __1,__2 in ltrs_ do
							if __2 == ">" then
								IndexLeft = __1
								break
							end
						end
						for ___1,___2 in ltrs_ do
							if ___2 then
								if typeof(IndexLeft) == "number" then
									if ___1 > IndexLeft then
										if ___2 == "<" then
											IndexRight = ___1
											break
										end
									end
								end
							end
						end
						for ____1,____2 in ltrs_ do
							if ____2 == ":" then
								IndexIndicator = ____1
								break
							end
						end
						
						local MethodLetters = (IndexRight-IndexLeft)-2
						local MethodLettersWithIndicator = (IndexRight-IndexLeft)-1
						
						local FormedMethod = "";
						
						local Curi = IndexLeft
						repeat
							Curi += 1
							task.wait()
							FormedMethod = FormedMethod..ltrs_[Curi]
						until Curi == (IndexRight-1)
						
						if string.find(string.lower(FormedMethod),":") then
							FormedMethod = string.gsub(FormedMethod,":","");
						end
						
						TabToRet.Method = FormedMethod
						
					end
					
				end
				
			end
		end	
	end
	TabToRet.Result = newtab
	
	if tab_[#tab_] == "" then
		table.insert(TabToRet.Arguments,tab_[#tab_-1])
	elseif tab_[#tab_] ~= "" then
		table.insert(TabToRet.Arguments,tab_[#tab_])
	end
	return TabToRet
end

local GetRawArgument = function(s)
	local LTRS = ToLettersTable(s)
	local one = nil
	local two = nil
	local three = nil
	for i,v in ipairs(LTRS) do
		if v == '"' and one == nil then
			one = i
		elseif v == '"' and two == nil then
			two = i
		elseif v == '"' and three == nil then
			three = i
		end
	end
	local curi = 0;
	if two and three then
		local Left = (three-two)-1
		local Formed = "";
		repeat
			task.wait()
			curi += 1
			Formed = Formed..LTRS[two+curi]
		until curi == Left
		return Formed
	elseif two == nil and three == nil then
		local ky = false
		local Formed = "";

		if string.find(s,">") and string.find(s,"<") then
			ky = true
			local a_ = nil
			local b_ = nil
			for i,v in ipairs(LTRS) do
				if v == ">"  then
					a_ = i
					break
				end
			end
			for i,v in ipairs(LTRS) do
				if v == "<" then
					b_ = i
					break
				end
			end

			local Left = (b_-a_)-1
			repeat
				task.wait()
				curi += 1
				Formed = Formed..LTRS[a_+curi]
			until curi == Left
			return Formed
		end
		
		local var = FindVariable(Formed)
		print(var)
		
		if ky == true then
			return Formed
		else
			return var
		end
	else
		return ""
	end
end

local attempt = 0
script.Parent.R.MouseButton1Down:Connect(function()
	local a = tick()
	attempt += 1
	for i,v in ipairs(Lines:GetChildren()) do
		if v:IsA("Frame") then
			local Content = v:FindFirstChild("Content").Text
			local SpacesSplit = string.split(Content," ")
			local NoMarkdown = RemoveMarkdownAndGetInfoMethods(SpacesSplit)
			local RawArg
			if NoMarkdown.Method ~= "" then
				RawArg = GetRawArgument(NoMarkdown.Arguments[1])
			elseif NoMarkdown.Method == "" then
				RawArg = ""
			end
			if string.lower(NoMarkdown.Method) == "echo" then
				Echo(RawArg)	
			end
		end
	end
	local b = tick()
	local r = math.floor(b-a)
	print("Ran With Speed: " .. r .. "s" .. " / On Attempt: " .. attempt)
end)

local n = tick()
print([[

IDE STARTED

SECONDS:
]].. " " .. n-s .."s")
