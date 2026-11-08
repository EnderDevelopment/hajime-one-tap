-- HAJIME ULTIMATE | One-Tap Mobile Control Center
-- Paste this LocalScript into StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "HajimeUltimateOneTap"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 100
gui.Parent = player:WaitForChild("PlayerGui")

local C = {bg=Color3.fromRGB(9,9,11), panel=Color3.fromRGB(20,20,24), light=Color3.fromRGB(31,31,37), red=Color3.fromRGB(220,35,48), bright=Color3.fromRGB(255,75,86), white=Color3.fromRGB(245,245,247), muted=Color3.fromRGB(155,155,165), line=Color3.fromRGB(55,55,63), green=Color3.fromRGB(63,205,125), yellow=Color3.fromRGB(236,185,70)}
local function make(class, props, parent)
	local x=Instance.new(class)
	for k,v in pairs(props) do x[k]=v end
	x.Parent=parent
	return x
end
local function round(x,n) make("UICorner",{CornerRadius=UDim.new(0,n)},x) end
local function outline(x,color) make("UIStroke",{Color=color,Thickness=1,Transparency=.2},x) end
local function animate(x,props,time) TweenService:Create(x,TweenInfo.new(time or .2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play() end

local launcher=make("TextButton",{Name="OneTapLauncher",AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-18,.5,0),Size=UDim2.fromOffset(70,70),BackgroundColor3=C.red,Text="HU",TextColor3=C.white,TextSize=19,Font=Enum.Font.GothamBold,AutoButtonColor=false,ZIndex=10},gui)
round(launcher,19); outline(launcher,C.bright)
local window=make("Frame",{Name="ControlCenter",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.55),Size=UDim2.new(.92,0,.78,0),BackgroundColor3=C.bg,Visible=false,ClipsDescendants=true},gui)
round(window,14); outline(window,C.line)
make("UISizeConstraint",{MinSize=Vector2.new(300,430),MaxSize=Vector2.new(560,670)},window)
local header=make("Frame",{Size=UDim2.new(1,0,0,72),BackgroundColor3=C.panel},window)
make("Frame",{Size=UDim2.new(0,5,1,0),BackgroundColor3=C.red},header)
make("TextLabel",{Position=UDim2.fromOffset(24,10),Size=UDim2.new(1,-100,0,28),BackgroundTransparency=1,Text="HAJIME ULTIMATE",TextColor3=C.white,TextSize=20,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},header)
make("TextLabel",{Position=UDim2.fromOffset(25,39),Size=UDim2.new(1,-100,0,18),BackgroundTransparency=1,Text="ONE-TAP CONTROL CENTER",TextColor3=C.bright,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},header)
local close=make("TextButton",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-15,.5,0),Size=UDim2.fromOffset(46,46),BackgroundColor3=C.light,Text="X",TextColor3=C.white,TextSize=18,Font=Enum.Font.GothamBold,AutoButtonColor=false},header); round(close,12)
local tabs=make("Frame",{Position=UDim2.new(0,14,0,84),Size=UDim2.new(1,-28,0,48),BackgroundTransparency=1},window)
make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6)},tabs)
local scroll=make("ScrollingFrame",{Position=UDim2.new(0,14,0,144),Size=UDim2.new(1,-28,1,-158),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=C.red,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new()},window)
local pages={}
local function newPage(name)
	local p=make("Frame",{Name=name,Size=UDim2.new(1,-6,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Visible=false},scroll)
	make("UIListLayout",{Padding=UDim.new(0,10)},p); pages[name]=p; return p
end
local function label(parent,text,size,color)
	return make("TextLabel",{Size=UDim2.new(1,0,0,size),BackgroundTransparency=1,Text=text,TextColor3=color or C.muted,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},parent)
end
local function action(parent,title,desc,fn,color)
	local b=make("TextButton",{Size=UDim2.new(1,0,0,64),BackgroundColor3=C.panel,Text="",AutoButtonColor=false},parent); round(b,10); outline(b,C.line)
	make("Frame",{Size=UDim2.new(0,4,1,0),BackgroundColor3=color or C.red},b)
	make("TextLabel",{Position=UDim2.fromOffset(18,9),Size=UDim2.new(1,-25,0,22),BackgroundTransparency=1,Text=title,TextColor3=C.white,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},b)
	make("TextLabel",{Position=UDim2.fromOffset(18,34),Size=UDim2.new(1,-25,0,18),BackgroundTransparency=1,Text=desc,TextColor3=C.muted,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},b)
	b.Activated:Connect(fn); return b
end
local function toggle(parent,title,desc,initial,fn)
	local row=make("Frame",{Size=UDim2.new(1,0,0,64),BackgroundColor3=C.panel},parent); round(row,10); outline(row,C.line)
	make("TextLabel",{Position=UDim2.fromOffset(16,9),Size=UDim2.new(1,-90,0,22),BackgroundTransparency=1,Text=title,TextColor3=C.white,TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},row)
	make("TextLabel",{Position=UDim2.fromOffset(16,35),Size=UDim2.new(1,-90,0,18),BackgroundTransparency=1,Text=desc,TextColor3=C.muted,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},row)
	local sw=make("TextButton",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-16,.5,0),Size=UDim2.fromOffset(54,30),BackgroundColor3=initial and C.red or C.line,Text="",AutoButtonColor=false},row); round(sw,15)
	local knob=make("Frame",{AnchorPoint=Vector2.new(0,.5),Position=initial and UDim2.new(1,-26,.5,0) or UDim2.new(0,4,.5,0),Size=UDim2.fromOffset(22,22),BackgroundColor3=C.white},sw); round(knob,11)
	local state=initial; sw.Activated:Connect(function() state=not state; animate(sw,{BackgroundColor3=state and C.red or C.line},.15); animate(knob,{Position=state and UDim2.new(1,-26,.5,0) or UDim2.new(0,4,.5,0)},.15); fn(state) end)
end

local training=newPage("Training"); label(training,"TRAINING ACTIONS",28)
local status=label(training,"STATUS  •  READY",32)
action(training,"Start Training","Begin a local focused training session",function() status.Text="STATUS  •  TRAINING ACTIVE"; status.TextColor3=C.green end,C.green)
local started=os.clock()
action(training,"Reset Session","Clear the local session timer and status",function() started=os.clock(); status.Text="STATUS  •  READY"; status.TextColor3=C.muted end,C.red)
local timer=make("TextLabel",{Size=UDim2.new(1,0,0,52),BackgroundColor3=C.panel,Text="  Session time: 00:00",TextColor3=C.white,TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center},training); round(timer,10)
local settings=newPage("Settings"); label(settings,"QUICK SETTINGS",28)
toggle(settings,"Performance Mode","Lower local visual overhead",false,function() end)
toggle(settings,"Touch Haptics","Use animated press feedback",true,function() end)
toggle(settings,"Auto Open","Open after character spawn",false,function(enabled) autoOpen=enabled end)
label(settings,"Settings are local to this client and reset when the session ends.",42)
local customize=newPage("Customize"); label(customize,"INTERFACE",28)
action(customize,"Compact Layout","Fit more controls on smaller screens",function() window.Size=UDim2.new(.94,0,.72,0) end,C.yellow)
action(customize,"Comfort Layout","Restore larger touch targets",function() window.Size=UDim2.new(.92,0,.78,0) end,C.red)
local moveMode=false
action(customize,"Move Launcher","Drag the HU button to reposition it",function() moveMode=true; launcher.Text="DRAG"; launcher.BackgroundColor3=C.bright end,C.bright)
local performance=newPage("Performance"); label(performance,"OPTIMIZATION",28)
local perfStatus=label(performance,"OPTIMIZATION  •  READY",32)
action(performance,"Optimize Locally","Disable local particles, trails, and post effects",function() for _,x in ipairs(workspace:GetDescendants()) do if x:IsA("ParticleEmitter") or x:IsA("Trail") or x:IsA("PostEffect") then x.Enabled=false end end; perfStatus.Text="OPTIMIZATION  •  ACTIVE"; perfStatus.TextColor3=C.green end,C.green)
action(performance,"Restore Visuals","Re-enable local visual effects",function() for _,x in ipairs(workspace:GetDescendants()) do if x:IsA("ParticleEmitter") or x:IsA("Trail") or x:IsA("PostEffect") then x.Enabled=true end end; perfStatus.Text="OPTIMIZATION  •  RESTORED"; perfStatus.TextColor3=C.muted end,C.red)
local match=newPage("Match"); label(match,"MATCH INFORMATION",28)
local info=make("TextLabel",{Size=UDim2.new(1,0,0,126),BackgroundColor3=C.panel,TextColor3=C.white,TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center},match); round(info,10)
local cooldown=make("TextLabel",{Size=UDim2.new(1,0,0,68),BackgroundColor3=C.panel,TextColor3=C.white,TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center},match); round(cooldown,10)

local active
for i,name in ipairs({"Training","Settings","Customize","Performance","Match"}) do
	local b=make("TextButton",{LayoutOrder=i,Size=UDim2.new(.2,-5,1,0),BackgroundColor3=C.panel,Text=name,TextColor3=C.muted,TextSize=10,Font=Enum.Font.GothamBold,AutoButtonColor=false},tabs); round(b,8)
	b.Activated:Connect(function() if active then active.BackgroundColor3=C.panel; active.TextColor3=C.muted end; active=b; b.BackgroundColor3=C.red; b.TextColor3=C.white; for n,p in pairs(pages) do p.Visible=n==name end end)
	if i==1 then active=b; b.BackgroundColor3=C.red; b.TextColor3=C.white; pages[name].Visible=true end
end
local open=false
local function setOpen(value) open=value; if value then window.Visible=true; window.Position=UDim2.fromScale(.5,.55); animate(window,{Position=UDim2.fromScale(.5,.5)},.22) else local a=TweenService:Create(window,TweenInfo.new(.18),{Position=UDim2.fromScale(.5,.55)}); a:Play(); a.Completed:Connect(function() if not open then window.Visible=false end end) end end
launcher.Activated:Connect(function() if moveMode then moveMode=false; launcher.Text="HU"; launcher.BackgroundColor3=C.red else setOpen(not open) end end)
close.Activated:Connect(function() setOpen(false) end)
local dragging=false; local dragStart; local startPos
launcher.InputBegan:Connect(function(input) if moveMode and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1) then dragging=true; dragStart=input.Position; startPos=launcher.Position; input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then local d=input.Position-dragStart; launcher.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
local autoOpen=false
RunService.RenderStepped:Connect(function() local t=math.floor(os.clock()-started); timer.Text=string.format("  Session time: %02d:%02d",math.floor(t/60),t%60); info.Text=string.format("  PLACE\n  %s\n\n  PLAYERS\n  %d online",game.Name,#Players:GetPlayers()); cooldown.Text="  COOLDOWNS\n  System ready  •  Local display" end)
player.CharacterAdded:Connect(function() if autoOpen then task.delay(.5,function() setOpen(true) end) end end)
