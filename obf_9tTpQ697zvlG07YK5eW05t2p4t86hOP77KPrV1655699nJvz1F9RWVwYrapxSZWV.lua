--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local Players = game:GetService("Players");
local UIS = game:GetService("UserInputService");
local CAS = game:GetService("ContextActionService");
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local SoundService = game:GetService("SoundService");
local CoreGui = game:GetService("CoreGui");
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local Camera = workspace.CurrentCamera;
local HalloweenMedia = {MusicPlaylist={"rbxassetid://1836009626","rbxassetid://137954899587949","rbxassetid://1838592691"},MusicVolume=0.28,GhostScreamId="rbxassetid://140524396139680",DeathLaughId="rbxassetid://125104262972128",BellStrikeId="rbxassetid://135723101541496",UIClickId="rbxassetid://5852470908",WhooshId="rbxassetid://135315310485417",WallDecals={{Texture="rbxthumb://type=Asset&id=4019318593&w=420&h=420",Size=Vector3.new(9.5, 3.6, 0.05)},{Texture="rbxthumb://type=Asset&id=8386764369&w=420&h=420",Size=Vector3.new(5.2, 5.2, 0.05)}}};
if _G.UniversalHubCleanup then
	pcall(_G.UniversalHubCleanup);
end
local HubConnections = {};
local HubRunning = true;
local function TrackConn(conn)
	table.insert(HubConnections, conn);
	return conn;
end
local function MarkSpookyFX(inst)
	pcall(function()
		inst:SetAttribute("UniversalSpookyFX", true);
	end);
	return inst;
end
local function IsSpookyFX(inst)
	if not inst then
		return false;
	end
	if inst:GetAttribute("UniversalSpookyFX") then
		return true;
	end
	local parent = inst.Parent;
	while parent and (parent ~= game) do
		if parent:GetAttribute("UniversalSpookyFX") then
			return true;
		end
		parent = parent.Parent;
	end
	return false;
end
local Settings = {RG_ESP=true,RG_Color=Color3.fromRGB(255, 0, 0),InvisWall_ESP=true,InvisWall_Bypass=false,InvisWall_Color=Color3.fromRGB(185, 80, 255),HalloweenAtmosphere=true,SpookyMedia=true,WallDecalsEnabled=true,CursedFootsteps=true,GhostApparitions=true,PumpkinHeads=true,OrbitingPumpkins=true,HalloweenLootESP=false,GhostPhase=false,ESP=true,ESPBoxes=true,ESPNames=true,ESPHighlights=true,ESPShowDetails=true,UseTeamColor=false,FriendColor=Color3.fromRGB(170, 85, 255),EnemyColor=Color3.fromRGB(255, 115, 15),SpecialPlayers={Zikayn_Zoom=true,Zikayn_Ofic=true,REP_MAN17=true,Dargas8Dead=true},SpecialColor=Color3.fromRGB(80, 255, 120),ForceFieldESP=true,ForceFieldColor=Color3.fromRGB(0, 210, 255),SeatESP=true,SeatColor=Color3.fromRGB(255, 90, 40),SeatTransparency=0.85,InfiniteJump=false,JumpImpulse=50,NoStaminaSprint=false,SprintBoostSpeed=10,AntiRagdoll=true,InfiniteStamina=true,ClickTeleport=true,GlideSpeed=38,AntiFling=true,RemoveRecoil=true,FreeCam=false,FreeCamSpeed=1.2,ZoomFOV=15,InstantInteract=true,FullBright=true,AltDelete=true,LaserRGB=true,DeleteMapDecorations=true,FPSBoost=true,FriendMiddleClick=true};
for _, name in ipairs({"UniversalESP","UniversalSeatESP","UniversalLootESP","UniversalRGESP","UniversalInvisWallESP","UniversalHubGUI"}) do
	if CoreGui:FindFirstChild(name) then
		CoreGui[name]:Destroy();
	end
end
for _, wsName in ipairs({"UniversalSpookyDecals","UniversalSpookySteps"}) do
	if workspace:FindFirstChild(wsName) then
		workspace[wsName]:Destroy();
	end
end
local ESPFolder = MarkSpookyFX(Instance.new("Folder"));
ESPFolder.Name = "UniversalESP";
ESPFolder.Parent = CoreGui;
local SeatFolder = MarkSpookyFX(Instance.new("Folder"));
SeatFolder.Name = "UniversalSeatESP";
SeatFolder.Parent = CoreGui;
local LootFolder = MarkSpookyFX(Instance.new("Folder"));
LootFolder.Name = "UniversalLootESP";
LootFolder.Parent = CoreGui;
local RGFolder = MarkSpookyFX(Instance.new("Folder"));
RGFolder.Name = "UniversalRGESP";
RGFolder.Parent = CoreGui;
local InvisWallFolder = MarkSpookyFX(Instance.new("Folder"));
InvisWallFolder.Name = "UniversalInvisWallESP";
InvisWallFolder.Parent = CoreGui;
local DecalsContainer = MarkSpookyFX(Instance.new("Folder"));
DecalsContainer.Name = "UniversalSpookyDecals";
DecalsContainer.Parent = workspace;
local StepsContainer = MarkSpookyFX(Instance.new("Folder"));
StepsContainer.Name = "UniversalSpookySteps";
StepsContainer.Parent = workspace;
local ActiveMusicSound = nil;
local CurrentTrackIndex = math.random(1, #HalloweenMedia.MusicPlaylist);
local function PlaySFX(soundId, volume, playbackSpeed, ignoreMediaSetting)
	if (not ignoreMediaSetting and not Settings.SpookyMedia) then
		return;
	end
	if (not soundId or (soundId == "")) then
		return;
	end
	pcall(function()
		local snd = MarkSpookyFX(Instance.new("Sound"));
		snd.SoundId = soundId;
		snd.Volume = volume or 0.6;
		snd.PlaybackSpeed = playbackSpeed or 1;
		snd.Parent = SoundService;
		snd:Play();
		snd.Ended:Connect(function()
			snd:Destroy();
		end);
		task.delay(12, function()
			if (snd and snd.Parent) then
				snd:Destroy();
			end
		end);
	end);
end
local function PlayClickSFX()
	PlaySFX(HalloweenMedia.UIClickId, 0.65, 1, true);
end
local function PlayWhooshSFX()
	PlaySFX(HalloweenMedia.WhooshId, 0.7, 1, true);
end
local function StartNextMusicTrack()
	if (not HubRunning or not Settings.SpookyMedia) then
		return;
	end
	if ActiveMusicSound then
		pcall(function()
			ActiveMusicSound:Destroy();
		end);
		ActiveMusicSound = nil;
	end
	local trackId = HalloweenMedia.MusicPlaylist[CurrentTrackIndex];
	CurrentTrackIndex = (CurrentTrackIndex % #HalloweenMedia.MusicPlaylist) + 1;
	local mus = MarkSpookyFX(Instance.new("Sound"));
	mus.Name = "UniversalHalloweenBGM";
	mus.SoundId = trackId;
	mus.Volume = HalloweenMedia.MusicVolume or 0.28;
	mus.Looped = false;
	mus.Parent = SoundService;
	ActiveMusicSound = mus;
	mus.Ended:Connect(function()
		if (HubRunning and Settings.SpookyMedia) then
			task.wait(1);
			StartNextMusicTrack();
		end
	end);
	pcall(function()
		mus:Play();
	end);
	task.delay(8, function()
		if ((ActiveMusicSound == mus) and HubRunning and Settings.SpookyMedia) then
			if (not mus.IsLoaded and (mus.TimePosition == 0)) then
				StartNextMusicTrack();
			end
		end
	end);
end
local function UpdateMusicState()
	if Settings.SpookyMedia then
		if (not ActiveMusicSound or not ActiveMusicSound.Parent or not ActiveMusicSound.IsPlaying) then
			StartNextMusicTrack();
		end
	elseif ActiveMusicSound then
		pcall(function()
			ActiveMusicSound:Stop();
			ActiveMusicSound:Destroy();
		end);
		ActiveMusicSound = nil;
	end
end
local IsGhostFlying = false;
local function Spawn3DGhostApparition()
	if (IsGhostFlying or not Camera) then
		return;
	end
	IsGhostFlying = true;
	task.spawn(function()
		local ghostModel = MarkSpookyFX(Instance.new("Model"));
		ghostModel.Name = "Universal3DSpookyGhost";
		ghostModel.Parent = workspace;
		local sheetBody = MarkSpookyFX(Instance.new("Model"));
		sheetBody.Name = "SheetSilhouette";
		sheetBody.Parent = ghostModel;
		local SHEET_COLOR = Color3.fromRGB(225, 245, 255);
		local DARK_VOID = Color3.fromRGB(12, 8, 18);
		local function MakeSheetPart(shape, size)
			local p = MarkSpookyFX(Instance.new("Part"));
			p.Shape = shape;
			p.Size = size;
			p.Color = SHEET_COLOR;
			p.Material = Enum.Material.SmoothPlastic;
			p.Transparency = 0.15;
			p.Anchored = true;
			p.CanCollide = false;
			p.CanTouch = false;
			p.CanQuery = false;
			p.CastShadow = false;
			p.Parent = sheetBody;
			return p;
		end
		local head = MakeSheetPart(Enum.PartType.Ball, Vector3.new(2.5, 2.6, 2.5));
		local neck = MakeSheetPart(Enum.PartType.Cylinder, Vector3.new(2, 2.3, 2.3));
		local chest = MakeSheetPart(Enum.PartType.Cylinder, Vector3.new(2.4, 2.8, 2.8));
		local skirt = MakeSheetPart(Enum.PartType.Ball, Vector3.new(3.1, 2.6, 3.1));
		local cloakTatters = {};
		for i = 1, 8 do
			local tatter = MakeSheetPart(Enum.PartType.Block, Vector3.new(0.85, 2.3, 0.45));
			local corner = MarkSpookyFX(Instance.new("SpecialMesh"));
			corner.MeshType = Enum.MeshType.Sphere;
			corner.Scale = Vector3.new(1, 1.15, 0.8);
			corner.Parent = tatter;
			table.insert(cloakTatters, tatter);
		end
		local leftArm = MakeSheetPart(Enum.PartType.Block, Vector3.new(0.75, 2.4, 0.85));
		local leftMesh = MarkSpookyFX(Instance.new("SpecialMesh", leftArm));
		leftMesh.MeshType = Enum.MeshType.Sphere;
		local rightArm = MakeSheetPart(Enum.PartType.Block, Vector3.new(0.75, 2.4, 0.85));
		local rightMesh = MarkSpookyFX(Instance.new("SpecialMesh", rightArm));
		rightMesh.MeshType = Enum.MeshType.Sphere;
		local bodyHighlight = MarkSpookyFX(Instance.new("Highlight"));
		bodyHighlight.Adornee = sheetBody;
		bodyHighlight.DepthMode = Enum.HighlightDepthMode.Occluded;
		bodyHighlight.FillColor = Color3.fromRGB(175, 230, 255);
		bodyHighlight.OutlineColor = Color3.fromRGB(240, 250, 255);
		bodyHighlight.FillTransparency = 0.25;
		bodyHighlight.OutlineTransparency = 0.15;
		bodyHighlight.Parent = sheetBody;
		local function MakeFaceFeature(size, color, mat)
			local f = MarkSpookyFX(Instance.new("Part"));
			f.Size = size;
			f.Color = color or DARK_VOID;
			f.Material = mat or Enum.Material.SmoothPlastic;
			f.Anchored = true;
			f.CanCollide = false;
			f.CanTouch = false;
			f.CanQuery = false;
			f.CastShadow = false;
			f.Parent = ghostModel;
			local m = MarkSpookyFX(Instance.new("SpecialMesh", f));
			m.MeshType = Enum.MeshType.Sphere;
			return f;
		end
		local leftEye = MakeFaceFeature(Vector3.new(0.55, 0.72, 0.25));
		local rightEye = MakeFaceFeature(Vector3.new(0.55, 0.72, 0.25));
		local leftPupil = MakeFaceFeature(Vector3.new(0.16, 0.16, 0.28), Color3.fromRGB(255, 140, 40), Enum.Material.Neon);
		local rightPupil = MakeFaceFeature(Vector3.new(0.16, 0.16, 0.28), Color3.fromRGB(255, 140, 40), Enum.Material.Neon);
		local mouth = MakeFaceFeature(Vector3.new(0.75, 1.05, 0.3));
		local light = MarkSpookyFX(Instance.new("PointLight"));
		light.Color = Color3.fromRGB(160, 225, 255);
		light.Range = 12;
		light.Brightness = 0.8;
		light.Parent = head;
		PlaySFX(HalloweenMedia.GhostScreamId, 0.8, 1, true);
		local char = LocalPlayer.Character;
		local root = char and char:FindFirstChild("HumanoidRootPart");
		local basePos = (root and root.Position) or Camera.CFrame.Position;
		local heightAbovePlayer = math.random(1, 10);
		local lookVec = Camera.CFrame.LookVector;
		local flatForward = Vector3.new(lookVec.X, 0, lookVec.Z);
		if (flatForward.Magnitude < 0.05) then
			flatForward = Vector3.new(0, 0, -1);
		else
			flatForward = flatForward.Unit;
		end
		local flatRight = Vector3.new(-flatForward.Z, 0, flatForward.X);
		local sideSign = ((math.random(0, 1) == 0) and -1) or 1;
		local centerPoint = Vector3.new(basePos.X, basePos.Y + heightAbovePlayer, basePos.Z) + (flatForward * 22);
		local startPos = centerPoint + (flatRight * sideSign * 15);
		local endPos = (centerPoint - (flatRight * sideSign * 15)) + Vector3.new(0, math.random(-1, 2), 0);
		local duration = 1.65;
		local elapsed = 0;
		local function UpdateGhostGeometry(cf, waveTime)
			head.CFrame = cf;
			neck.CFrame = cf * CFrame.new(0, -1.1, 0.08) * CFrame.Angles(0, 0, math.rad(90));
			chest.CFrame = cf * CFrame.new(0, -2.2, 0.22) * CFrame.Angles(math.rad(8), 0, math.rad(90));
			skirt.CFrame = cf * CFrame.new(0, -3.1, 0.4);
			for idx, tatter in ipairs(cloakTatters) do
				local angle = (idx / #cloakTatters) * math.pi * 2;
				local wave = math.sin((waveTime * 8) + (idx * 1.3)) * 0.28;
				local radius = 1.15 + (wave * 0.4);
				local tx = math.cos(angle) * radius;
				local tz = (math.sin(angle) * radius) + 0.45;
				tatter.CFrame = cf * CFrame.new(tx, -4.1 + (wave * 0.3), tz) * CFrame.Angles(math.rad(18 + (wave * 25)), -angle, 0);
			end
			local armWave = math.sin(waveTime * 6) * 0.2;
			leftArm.CFrame = cf * CFrame.new(-1.55, -1.45 + armWave, -0.75) * CFrame.Angles(math.rad(55), math.rad(15), math.rad(-25));
			rightArm.CFrame = cf * CFrame.new(1.55, -1.45 - armWave, -0.75) * CFrame.Angles(math.rad(55), math.rad(-15), math.rad(25));
			leftEye.CFrame = cf * CFrame.new(-0.46, 0.22, -1.18) * CFrame.Angles(0, math.rad(20), math.rad(-18));
			rightEye.CFrame = cf * CFrame.new(0.46, 0.22, -1.18) * CFrame.Angles(0, math.rad(-20), math.rad(18));
			leftPupil.CFrame = leftEye.CFrame * CFrame.new(0, -0.05, -0.05);
			rightPupil.CFrame = rightEye.CFrame * CFrame.new(0, -0.05, -0.05);
			mouth.CFrame = cf * CFrame.new(0, -0.48, -1.18) * CFrame.Angles(math.rad(8), 0, 0);
		end
		while (elapsed < duration) and HubRunning do
			local dt = RunService.RenderStepped:Wait();
			elapsed += dt
			local alpha = math.clamp(elapsed / duration, 0, 1);
			local bobbing = math.sin(alpha * math.pi * 2.5) * 1.1;
			local curPos = startPos:Lerp(endPos, alpha) + Vector3.new(0, bobbing, 0);
			local lookTarget = endPos:Lerp(Camera.CFrame.Position, math.sin(alpha * math.pi) * 0.85);
			local ghostCF = CFrame.lookAt(curPos, lookTarget);
			UpdateGhostGeometry(ghostCF, elapsed);
		end
		PlayWhooshSFX();
		for i = 1, 10 do
			bodyHighlight.FillTransparency = math.clamp(bodyHighlight.FillTransparency + 0.08, 0, 1);
			bodyHighlight.OutlineTransparency = math.clamp(bodyHighlight.OutlineTransparency + 0.09, 0, 1);
			for _, p in ipairs(ghostModel:GetDescendants()) do
				if p:IsA("BasePart") then
					p.Transparency = math.clamp(p.Transparency + 0.09, 0, 1);
					p.Size = p.Size * 0.88;
					p.CFrame = p.CFrame * CFrame.new(0, 0.2, 0);
				end
			end
			RunService.RenderStepped:Wait();
		end
		ghostModel:Destroy();
		IsGhostFlying = false;
	end);
end
local function HookCharacterDeathLaugh(player, character)
	local hum = character:WaitForChild("Humanoid", 5);
	if not hum then
		return;
	end
	hum.Died:Connect(function()
		if not Settings.SpookyMedia then
			return;
		end
		if (player == LocalPlayer) then
			PlaySFX(HalloweenMedia.DeathLaughId, 0.9, 1, true);
		else
			local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
			local theirRoot = character:FindFirstChild("HumanoidRootPart");
			if (myRoot and theirRoot and ((myRoot.Position - theirRoot.Position).Magnitude <= 45)) then
				PlaySFX(HalloweenMedia.DeathLaughId, 0.65, 1, true);
			end
		end
	end);
end
local ScreenGui = MarkSpookyFX(Instance.new("ScreenGui"));
ScreenGui.Name = "UniversalHubGUI";
ScreenGui.ResetOnSpawn = false;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
pcall(function()
	ScreenGui.Parent = CoreGui;
end);
if not ScreenGui.Parent then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
end
local THEME_ORANGE = Color3.fromRGB(255, 120, 20);
local THEME_PURPLE = Color3.fromRGB(155, 70, 255);
local THEME_BG = Color3.fromRGB(15, 11, 22);
local NotifyContainer = Instance.new("Frame");
NotifyContainer.Name = "Notifications";
NotifyContainer.AnchorPoint = Vector2.new(1, 1);
NotifyContainer.Position = UDim2.new(1, -20, 1, -20);
NotifyContainer.Size = UDim2.new(0, 285, 0, 420);
NotifyContainer.BackgroundTransparency = 1;
NotifyContainer.Parent = ScreenGui;
local NotifyLayout = Instance.new("UIListLayout");
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
NotifyLayout.Padding = UDim.new(0, 8);
NotifyLayout.Parent = NotifyContainer;
local function Notify(title, text, duration)
	duration = duration or 2.5;
	local card = Instance.new("Frame");
	card.Size = UDim2.new(1, 0, 0, 54);
	card.BackgroundColor3 = THEME_BG;
	card.BackgroundTransparency = 0.08;
	card.BorderSizePixel = 0;
	card.Parent = NotifyContainer;
	local corner = Instance.new("UICorner");
	corner.CornerRadius = UDim.new(0, 8);
	corner.Parent = card;
	local stroke = Instance.new("UIStroke");
	stroke.Color = THEME_ORANGE;
	stroke.Thickness = 1.4;
	stroke.Parent = card;
	local titleLbl = Instance.new("TextLabel");
	titleLbl.Size = UDim2.new(1, -16, 0, 20);
	titleLbl.Position = UDim2.new(0, 10, 0, 5);
	titleLbl.BackgroundTransparency = 1;
	titleLbl.Font = Enum.Font.GothamBold;
	titleLbl.TextSize = 13;
	titleLbl.TextColor3 = THEME_ORANGE;
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left;
	titleLbl.Text = "🎃 " .. title;
	titleLbl.Parent = card;
	local bodyLbl = Instance.new("TextLabel");
	bodyLbl.Size = UDim2.new(1, -16, 0, 20);
	bodyLbl.Position = UDim2.new(0, 10, 0, 26);
	bodyLbl.BackgroundTransparency = 1;
	bodyLbl.Font = Enum.Font.Gotham;
	bodyLbl.TextSize = 12;
	bodyLbl.TextColor3 = Color3.fromRGB(235, 225, 245);
	bodyLbl.TextXAlignment = Enum.TextXAlignment.Left;
	bodyLbl.Text = text;
	bodyLbl.Parent = card;
	task.delay(duration, function()
		if (card and card.Parent) then
			local tw = TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency=1});
			TweenService:Create(titleLbl, TweenInfo.new(0.3), {TextTransparency=1}):Play();
			TweenService:Create(bodyLbl, TweenInfo.new(0.3), {TextTransparency=1}):Play();
			TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency=1}):Play();
			tw:Play();
			tw.Completed:Wait();
			card:Destroy();
		end
	end);
end
local MainFrame = Instance.new("Frame");
MainFrame.Name = "MainFrame";
MainFrame.Size = UDim2.new(0, 335, 0, 480);
MainFrame.Position = UDim2.new(0, 30, 0.5, -240);
MainFrame.BackgroundColor3 = THEME_BG;
MainFrame.ClipsDescendants = true;
MainFrame.BorderSizePixel = 0;
MainFrame.Active = true;
MainFrame.Draggable = true;
MainFrame.Parent = ScreenGui;
local MainCorner = Instance.new("UICorner");
MainCorner.CornerRadius = UDim.new(0, 10);
MainCorner.Parent = MainFrame;
local MainStroke = Instance.new("UIStroke");
MainStroke.Color = THEME_ORANGE;
MainStroke.Thickness = 1.8;
MainStroke.Parent = MainFrame;
local Header = Instance.new("TextLabel");
Header.Size = UDim2.new(1, 0, 0, 40);
Header.BackgroundColor3 = Color3.fromRGB(28, 18, 42);
Header.BorderSizePixel = 0;
Header.Font = Enum.Font.GothamBold;
Header.TextSize = 14;
Header.TextColor3 = THEME_ORANGE;
Header.Text = "  🎃 HALLOWEEN HUB v11  [RightShift]";
Header.TextXAlignment = Enum.TextXAlignment.Left;
Header.ZIndex = 3;
Header.Parent = MainFrame;
local HeaderCorner = Instance.new("UICorner");
HeaderCorner.CornerRadius = UDim.new(0, 10);
HeaderCorner.Parent = Header;
local SpookyIcons = {"🎃","👻","🦇","💀","🍬"};
task.spawn(function()
	while HubRunning and ScreenGui and ScreenGui.Parent do
		if MainFrame.Visible then
			local icon = Instance.new("TextLabel");
			icon.BackgroundTransparency = 1;
			icon.Size = UDim2.new(0, 24, 0, 24);
			icon.Position = UDim2.new(math.random(5, 90) / 100, 0, -0.08, 0);
			icon.Text = SpookyIcons[math.random(1, #SpookyIcons)];
			icon.TextSize = math.random(14, 20);
			icon.TextTransparency = 0.72;
			icon.ZIndex = 1;
			icon.Parent = MainFrame;
			local fallTime = math.random(35, 60) / 10;
			local tw = TweenService:Create(icon, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {Position=UDim2.new(icon.Position.X.Scale + (math.random(-15, 15) / 100), 0, 1.08, 0),Rotation=math.random(-45, 45)});
			tw:Play();
			task.delay(fallTime, function()
				if icon then
					icon:Destroy();
				end
			end);
		end
		task.wait(0.7);
	end
end);
local Scroll = Instance.new("ScrollingFrame");
Scroll.Size = UDim2.new(1, -16, 1, -50);
Scroll.Position = UDim2.new(0, 8, 0, 44);
Scroll.BackgroundTransparency = 1;
Scroll.BorderSizePixel = 0;
Scroll.ScrollBarThickness = 4;
Scroll.ScrollBarImageColor3 = THEME_ORANGE;
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0);
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y;
Scroll.ZIndex = 2;
Scroll.Parent = MainFrame;
local ScrollLayout = Instance.new("UIListLayout");
ScrollLayout.Padding = UDim.new(0, 6);
ScrollLayout.Parent = Scroll;
local UIButtonUpdaters = {};
local function CreateToggleButton(label, settingKey, onToggle)
	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, -6, 0, 32);
	btn.BorderSizePixel = 0;
	btn.Font = Enum.Font.GothamSemibold;
	btn.TextSize = 13;
	btn.TextColor3 = Color3.fromRGB(245, 240, 255);
	btn.AutoButtonColor = false;
	btn.ZIndex = 2;
	btn.Parent = Scroll;
	local c = Instance.new("UICorner");
	c.CornerRadius = UDim.new(0, 6);
	c.Parent = btn;
	local btnStroke = Instance.new("UIStroke");
	btnStroke.Thickness = 1;
	btnStroke.Parent = btn;
	local function RefreshVisual()
		local state = Settings[settingKey];
		btn.Text = string.format("  %s : %s", label, (state and "ON") or "OFF");
		btn.BackgroundColor3 = (state and Color3.fromRGB(195, 80, 15)) or Color3.fromRGB(28, 22, 40);
		btnStroke.Color = (state and Color3.fromRGB(255, 165, 50)) or Color3.fromRGB(65, 45, 90);
	end
	btn.MouseButton1Click:Connect(function()
		Settings[settingKey] = not Settings[settingKey];
		PlayClickSFX();
		RefreshVisual();
		if onToggle then
			onToggle(Settings[settingKey]);
		end
	end);
	RefreshVisual();
	UIButtonUpdaters[settingKey] = RefreshVisual;
end
local function CreateActionButton(label, onClick)
	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, -6, 0, 32);
	btn.BackgroundColor3 = Color3.fromRGB(65, 32, 95);
	btn.BorderSizePixel = 0;
	btn.Font = Enum.Font.GothamBold;
	btn.TextSize = 13;
	btn.TextColor3 = Color3.fromRGB(255, 215, 130);
	btn.Text = "  " .. label;
	btn.AutoButtonColor = true;
	btn.ZIndex = 2;
	btn.Parent = Scroll;
	local c = Instance.new("UICorner");
	c.CornerRadius = UDim.new(0, 6);
	c.Parent = btn;
	local btnStroke = Instance.new("UIStroke");
	btnStroke.Color = THEME_PURPLE;
	btnStroke.Thickness = 1.2;
	btnStroke.Parent = btn;
	btn.MouseButton1Click:Connect(function()
		PlayClickSFX();
		if onClick then
			onClick();
		end
	end);
end
local function RefreshUIButton(key)
	if UIButtonUpdaters[key] then
		UIButtonUpdaters[key]();
	end
end
UpdateMusicState();
local SpawnedDecalParts = {};
local DecalRayParams = RaycastParams.new();
DecalRayParams.FilterType = Enum.RaycastFilterType.Exclude;
DecalRayParams.IgnoreWater = true;
local function ClearAllWallDecals()
	DecalsContainer:ClearAllChildren();
	table.clear(SpawnedDecalParts);
end
task.delay(4, function()
	if (HubRunning and Settings.GhostApparitions) then
		Spawn3DGhostApparition();
	end
end);
task.spawn(function()
	local nextGhostTime = os.clock() + math.random(45, 75);
	local nextBellTime = os.clock() + math.random(55, 85);
	while HubRunning and task.wait(3) do
		if (Settings.GhostApparitions and (os.clock() > nextGhostTime)) then
			Spawn3DGhostApparition();
			nextGhostTime = os.clock() + math.random(45, 75);
		end
		if (Settings.SpookyMedia and (os.clock() > nextBellTime)) then
			PlaySFX(HalloweenMedia.BellStrikeId, 0.55, 1);
			nextBellTime = os.clock() + math.random(60, 95);
		end
		if (Settings.WallDecalsEnabled and (#HalloweenMedia.WallDecals > 0)) then
			local char = LocalPlayer.Character;
			local root = char and char:FindFirstChild("HumanoidRootPart");
			if root then
				DecalRayParams.FilterDescendantsInstances = {char,DecalsContainer,StepsContainer,ESPFolder,SeatFolder,RGFolder,InvisWallFolder};
				local randomAngle = math.rad(math.random(0, 360));
				local dir = Vector3.new(math.cos(randomAngle), math.random(-5, 12) / 100, math.sin(randomAngle)).Unit * 60;
				local hit = workspace:Raycast(root.Position, dir, DecalRayParams);
				if (hit and hit.Instance and hit.Instance:IsA("BasePart")) then
					local hitPart = hit.Instance;
					local dist = (hit.Position - root.Position).Magnitude;
					local lowerName = string.lower(hitPart.Name);
					if (hitPart.Anchored and (hitPart.Transparency < 0.25) and (lowerName ~= "inviswall") and (dist >= 12) and (math.abs(hit.Normal.Y) < 0.35)) then
						if (#SpawnedDecalParts >= 18) then
							local oldest = table.remove(SpawnedDecalParts, 1);
							if oldest then
								pcall(function()
									oldest:Destroy();
								end);
							end
						end
						local chosenDecal = HalloweenMedia.WallDecals[math.random(1, #HalloweenMedia.WallDecals)];
						local surfacePlate = MarkSpookyFX(Instance.new("Part"));
						surfacePlate.Name = "SpookyWallDecal";
						surfacePlate.Size = chosenDecal.Size;
						surfacePlate.Transparency = 1;
						surfacePlate.Anchored = true;
						surfacePlate.CanCollide = false;
						surfacePlate.CanTouch = false;
						surfacePlate.CanQuery = false;
						surfacePlate.CFrame = CFrame.lookAt(hit.Position + (hit.Normal * 0.06), hit.Position + (hit.Normal * 2));
						surfacePlate.Parent = DecalsContainer;
						local decal = MarkSpookyFX(Instance.new("Decal"));
						decal.Face = Enum.NormalId.Front;
						decal.Texture = chosenDecal.Texture;
						decal.Transparency = 0.08;
						decal.Parent = surfacePlate;
						table.insert(SpawnedDecalParts, surfacePlate);
					end
				end
			end
		end
	end
end);
local LastStepPos = Vector3.zero;
local function ClearFootsteps()
	StepsContainer:ClearAllChildren();
end
local function SpawnCursedStepRing(footPos)
	if not Settings.CursedFootsteps then
		return;
	end
	local ring = MarkSpookyFX(Instance.new("Part"));
	ring.Name = "SpookyFootstep";
	ring.Shape = Enum.PartType.Cylinder;
	ring.Size = Vector3.new(0.08, 1.8, 1.8);
	ring.Color = ((math.random(1, 2) == 1) and THEME_ORANGE) or THEME_PURPLE;
	ring.Material = Enum.Material.Neon;
	ring.Transparency = 0.35;
	ring.Anchored = true;
	ring.CanCollide = false;
	ring.CanTouch = false;
	ring.CanQuery = false;
	ring.CastShadow = false;
	ring.CFrame = CFrame.new(footPos) * CFrame.Angles(0, 0, math.rad(90));
	ring.Parent = StepsContainer;
	local tw = TweenService:Create(ring, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=Vector3.new(0.02, 3.8, 3.8),Transparency=1});
	tw:Play();
	task.delay(1.15, function()
		if ring then
			ring:Destroy();
		end
	end);
end
TrackConn(RunService.Heartbeat:Connect(function()
	if not Settings.CursedFootsteps then
		return;
	end
	local char = LocalPlayer.Character;
	local root = char and char:FindFirstChild("HumanoidRootPart");
	local hum = char and char:FindFirstChildOfClass("Humanoid");
	if (not root or not hum or (hum.Health <= 0)) then
		return;
	end
	if ((hum.MoveDirection.Magnitude > 0.1) and ((root.Position - LastStepPos).Magnitude > 4.2)) then
		LastStepPos = root.Position;
		SpawnCursedStepRing(root.Position - Vector3.new(0, 2.85, 0));
	end
end));
local SavedNormalLighting = {Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,FogColor=Lighting.FogColor,FogStart=Lighting.FogStart,FogEnd=Lighting.FogEnd,GlobalShadows=Lighting.GlobalShadows,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient};
local SpookyCC = nil;
local SpookyBloom = nil;
local SpookySky = nil;
local WeatherPart = nil;
local MoonModel = nil;
local function Setup3DBloodMoon(enabled)
	if MoonModel then
		MoonModel:Destroy();
		MoonModel = nil;
	end
	if not enabled then
		return;
	end
	local model = MarkSpookyFX(Instance.new("Model"));
	model.Name = "Universal3DBloodMoon";
	model.Parent = workspace;
	local moon = MarkSpookyFX(Instance.new("Part"));
	moon.Name = "MoonCore";
	moon.Shape = Enum.PartType.Ball;
	moon.Size = Vector3.new(68, 68, 68);
	moon.Color = Color3.fromRGB(255, 95, 20);
	moon.Material = Enum.Material.Neon;
	moon.Anchored = true;
	moon.CanCollide = false;
	moon.CanTouch = false;
	moon.CanQuery = false;
	moon.CastShadow = false;
	moon.Parent = model;
	local halo = MarkSpookyFX(Instance.new("Part"));
	halo.Name = "MoonHalo";
	halo.Shape = Enum.PartType.Ball;
	halo.Size = Vector3.new(86, 86, 86);
	halo.Color = Color3.fromRGB(255, 60, 10);
	halo.Material = Enum.Material.ForceField;
	halo.Transparency = 0.45;
	halo.Anchored = true;
	halo.CanCollide = false;
	halo.CanTouch = false;
	halo.CanQuery = false;
	halo.CastShadow = false;
	halo.Parent = model;
	MoonModel = model;
end
local function SetupWeatherParticles(enabled)
	if WeatherPart then
		WeatherPart:Destroy();
		WeatherPart = nil;
	end
	if not enabled then
		return;
	end
	local part = MarkSpookyFX(Instance.new("Part"));
	part.Name = "UniversalSpookyWeather";
	part.Size = Vector3.new(90, 1, 90);
	part.Transparency = 1;
	part.Anchored = true;
	part.CanCollide = false;
	part.CanTouch = false;
	part.CanQuery = false;
	part.Parent = workspace;
	local embers = MarkSpookyFX(Instance.new("ParticleEmitter"));
	embers.Name = "HalloweenEmbers";
	embers.Texture = "rbxasset://textures/particles/sparkles_main.dds";
	embers.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, THEME_ORANGE),ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 60, 0)),ColorSequenceKeypoint.new(1, THEME_PURPLE)});
	embers.LightEmission = 0.8;
	embers.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4),NumberSequenceKeypoint.new(0.5, 0.7),NumberSequenceKeypoint.new(1, 0)});
	embers.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.25),NumberSequenceKeypoint.new(0.8, 0.4),NumberSequenceKeypoint.new(1, 1)});
	embers.Lifetime = NumberRange.new(4, 7);
	embers.Rate = 40;
	embers.Speed = NumberRange.new(3, 7);
	embers.SpreadAngle = Vector2.new(35, 35);
	embers.EmissionDirection = Enum.NormalId.Bottom;
	embers.Parent = part;
	WeatherPart = part;
end
local IsApplyingLighting = false;
local function ApplyAtmosphere()
	if IsApplyingLighting then
		return;
	end
	IsApplyingLighting = true;
	pcall(function()
		local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds");
		if (clouds and Settings.HalloweenAtmosphere) then
			clouds.Enabled = false;
		end
		for _, child in ipairs(Lighting:GetChildren()) do
			if (child:IsA("Atmosphere") and not IsSpookyFX(child)) then
				child.Density = (Settings.HalloweenAtmosphere and 0.14) or 0;
				if Settings.HalloweenAtmosphere then
					child.Color = Color3.fromRGB(240, 90, 15);
					child.Decay = Color3.fromRGB(65, 20, 95);
					child.Haze = 0;
				end
			end
		end
		if Settings.HalloweenAtmosphere then
			Lighting.Brightness = 1.5;
			Lighting.ClockTime = 3.2;
			Lighting.GlobalShadows = false;
			Lighting.FogColor = Color3.fromRGB(215, 78, 15);
			Lighting.FogStart = 45;
			Lighting.FogEnd = 820;
			Lighting.Ambient = Color3.fromRGB(155, 95, 75);
			Lighting.OutdoorAmbient = Color3.fromRGB(190, 105, 55);
			if (not SpookyCC or not SpookyCC.Parent) then
				SpookyCC = MarkSpookyFX(Instance.new("ColorCorrectionEffect"));
				SpookyCC.Name = "UniversalSpookyCC";
				SpookyCC.Parent = Lighting;
			end
			SpookyCC.Enabled = true;
			SpookyCC.TintColor = Color3.fromRGB(255, 222, 200);
			SpookyCC.Contrast = 0.12;
			SpookyCC.Saturation = 0.18;
			if (not SpookyBloom or not SpookyBloom.Parent) then
				SpookyBloom = MarkSpookyFX(Instance.new("BloomEffect"));
				SpookyBloom.Name = "UniversalSpookyBloom";
				SpookyBloom.Parent = Lighting;
			end
			SpookyBloom.Enabled = true;
			SpookyBloom.Intensity = 0.22;
			SpookyBloom.Size = 18;
			SpookyBloom.Threshold = 0.95;
			if (not SpookySky or not SpookySky.Parent) then
				SpookySky = MarkSpookyFX(Instance.new("Sky"));
				SpookySky.Name = "UniversalSpookySky";
				SpookySky.StarCount = 3500;
				SpookySky.MoonAngularSize = 30;
				SpookySky.CelestialBodiesShown = true;
				SpookySky.Parent = Lighting;
			end
		else
			if SpookyCC then
				SpookyCC.Enabled = false;
			end
			if SpookyBloom then
				SpookyBloom.Enabled = false;
			end
			if SpookySky then
				SpookySky:Destroy();
				SpookySky = nil;
			end
			if Settings.FullBright then
				Lighting.Brightness = 1;
				Lighting.ClockTime = 12;
				Lighting.GlobalShadows = false;
				Lighting.FogColor = Color3.fromRGB(192, 192, 192);
				Lighting.FogStart = 0;
				Lighting.FogEnd = 786543;
				Lighting.Ambient = Color3.fromRGB(178, 178, 178);
				Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178);
			else
				Lighting.Brightness = SavedNormalLighting.Brightness;
				Lighting.ClockTime = SavedNormalLighting.ClockTime;
				Lighting.FogColor = SavedNormalLighting.FogColor;
				Lighting.FogStart = SavedNormalLighting.FogStart;
				Lighting.FogEnd = SavedNormalLighting.FogEnd;
				Lighting.GlobalShadows = SavedNormalLighting.GlobalShadows;
				Lighting.Ambient = SavedNormalLighting.Ambient;
				Lighting.OutdoorAmbient = SavedNormalLighting.OutdoorAmbient;
			end
		end
	end);
	IsApplyingLighting = false;
end
for _, prop in ipairs({"Brightness","ClockTime","FogEnd","FogColor","GlobalShadows","Ambient"}) do
	TrackConn(Lighting:GetPropertyChangedSignal(prop):Connect(function()
		if (Settings.HalloweenAtmosphere or Settings.FullBright) then
			ApplyAtmosphere();
		end
	end));
end
ApplyAtmosphere();
SetupWeatherParticles(Settings.HalloweenAtmosphere);
Setup3DBloodMoon(Settings.HalloweenAtmosphere);
local TrackedRGObjects = {};
local function RemoveRGESP(obj)
	local entry = TrackedRGObjects[obj];
	if entry then
		TrackedRGObjects[obj] = nil;
		for _, v in ipairs(entry) do
			pcall(function()
				v:Destroy();
			end);
		end
	end
end
local function CheckAndHighlightRG(obj)
	if (not Settings.RG_ESP or not obj or TrackedRGObjects[obj] or IsSpookyFX(obj)) then
		return;
	end
	if (string.lower(obj.Name) ~= "rg") then
		return;
	end
	if not (obj:IsA("BasePart") or obj:IsA("Model")) then
		return;
	end
	if (obj.Parent and (string.lower(obj.Parent.Name) == "rg") and (obj.Parent:IsA("Model") or obj.Parent:IsA("BasePart"))) then
		return;
	end
	local created = {};
	TrackedRGObjects[obj] = created;
	local hl = MarkSpookyFX(Instance.new("Highlight"));
	hl.Name = "RG_Highlight";
	hl.Adornee = obj;
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
	hl.FillColor = Settings.RG_Color;
	hl.OutlineColor = Color3.fromRGB(255, 60, 60);
	hl.FillTransparency = 0.55;
	hl.OutlineTransparency = 0;
	hl.Parent = RGFolder;
	table.insert(created, hl);
	local targetPart = (obj:IsA("BasePart") and obj) or obj:FindFirstChildWhichIsA("BasePart", true);
	if targetPart then
		local box = MarkSpookyFX(Instance.new("BoxHandleAdornment"));
		box.Name = "RG_Box";
		box.Adornee = (obj:IsA("BasePart") and obj) or targetPart;
		box.Size = (obj:IsA("BasePart") and (obj.Size + Vector3.new(0.15, 0.15, 0.15))) or obj:GetExtentsSize();
		box.Color3 = Settings.RG_Color;
		box.Transparency = 0.55;
		box.AlwaysOnTop = true;
		box.ZIndex = 6;
		box.Parent = RGFolder;
		table.insert(created, box);
		local sel = MarkSpookyFX(Instance.new("SelectionBox"));
		sel.Name = "RG_Outline";
		sel.Adornee = obj;
		sel.Color3 = Settings.RG_Color;
		sel.LineThickness = 0.06;
		sel.SurfaceColor3 = Settings.RG_Color;
		sel.SurfaceTransparency = 0.75;
		sel.Parent = RGFolder;
		table.insert(created, sel);
	end
	obj.AncestryChanged:Connect(function(_, parent)
		if not parent then
			RemoveRGESP(obj);
		end
	end);
end
local function RefreshAllRGESP()
	RGFolder:ClearAllChildren();
	table.clear(TrackedRGObjects);
	if not Settings.RG_ESP then
		return;
	end
	for _, obj in ipairs(workspace:GetDescendants()) do
		CheckAndHighlightRG(obj);
	end
end
local TrackedInvisWalls = {};
local SavedInvisWallCollide = {};
local function ApplyInvisWallCollisionState(obj)
	if not obj then
		return;
	end
	local function ProcessPart(p)
		if p:IsA("BasePart") then
			if (SavedInvisWallCollide[p] == nil) then
				SavedInvisWallCollide[p] = p.CanCollide;
			end
			if Settings.InvisWall_Bypass then
				p.CanCollide = false;
			else
				p.CanCollide = SavedInvisWallCollide[p];
			end
		end
	end
	if obj:IsA("BasePart") then
		ProcessPart(obj);
	elseif obj:IsA("Model") then
		for _, d in ipairs(obj:GetDescendants()) do
			ProcessPart(d);
		end
	end
end
local function UpdateAllInvisWallCollisions()
	for obj in pairs(TrackedInvisWalls) do
		if (obj and obj.Parent) then
			ApplyInvisWallCollisionState(obj);
		end
	end
end
local function RemoveInvisWallESP(obj)
	local entry = TrackedInvisWalls[obj];
	if entry then
		TrackedInvisWalls[obj] = nil;
		for _, v in ipairs(entry) do
			pcall(function()
				v:Destroy();
			end);
		end
	end
end
local function CheckAndHighlightInvisWall(obj)
	if (not obj or TrackedInvisWalls[obj] or IsSpookyFX(obj)) then
		return;
	end
	if (string.lower(obj.Name) ~= "inviswall") then
		return;
	end
	if not (obj:IsA("BasePart") or obj:IsA("Model")) then
		return;
	end
	if (obj.Parent and (string.lower(obj.Parent.Name) == "inviswall") and (obj.Parent:IsA("Model") or obj.Parent:IsA("BasePart"))) then
		return;
	end
	local created = {};
	TrackedInvisWalls[obj] = created;
	ApplyInvisWallCollisionState(obj);
	if Settings.InvisWall_ESP then
		local sel = MarkSpookyFX(Instance.new("SelectionBox"));
		sel.Name = "InvisWall_Outline";
		sel.Adornee = obj;
		sel.Color3 = Settings.InvisWall_Color;
		sel.LineThickness = 0.05;
		sel.SurfaceColor3 = Settings.InvisWall_Color;
		sel.SurfaceTransparency = 0.78;
		sel.Parent = InvisWallFolder;
		table.insert(created, sel);
		local function AddAdornmentForPart(part)
			local box = MarkSpookyFX(Instance.new("BoxHandleAdornment"));
			box.Name = "InvisWall_Box";
			box.Adornee = part;
			box.Size = part.Size;
			box.Color3 = Settings.InvisWall_Color;
			box.Transparency = 0.76;
			box.AlwaysOnTop = true;
			box.ZIndex = 3;
			box.Parent = InvisWallFolder;
			table.insert(created, box);
		end
		if obj:IsA("BasePart") then
			AddAdornmentForPart(obj);
		elseif obj:IsA("Model") then
			for _, sub in ipairs(obj:GetDescendants()) do
				if sub:IsA("BasePart") then
					AddAdornmentForPart(sub);
				end
			end
		end
	end
	obj.AncestryChanged:Connect(function(_, parent)
		if not parent then
			RemoveInvisWallESP(obj);
		end
	end);
end
local function RefreshAllInvisWallESP()
	InvisWallFolder:ClearAllChildren();
	table.clear(TrackedInvisWalls);
	for _, obj in ipairs(workspace:GetDescendants()) do
		if (string.lower(obj.Name) == "inviswall") then
			CheckAndHighlightInvisWall(obj);
		end
	end
end
local function Create3DPumpkinHead(character, enabled)
	if not character then
		return;
	end
	local existing = character:FindFirstChild("UniversalPumpkinHead");
	if existing then
		existing:Destroy();
	end
	if not enabled then
		return;
	end
	local head = character:FindFirstChild("Head");
	if (not head or not head:IsA("BasePart")) then
		return;
	end
	local model = MarkSpookyFX(Instance.new("Model"));
	model.Name = "UniversalPumpkinHead";
	model.Parent = character;
	local core = MarkSpookyFX(Instance.new("Part"));
	core.Name = "PumpkinCore";
	core.Shape = Enum.PartType.Ball;
	core.Size = Vector3.new(2.35, 2.05, 2.35);
	core.Color = Color3.fromRGB(235, 95, 15);
	core.Material = Enum.Material.SmoothPlastic;
	core.CanCollide = false;
	core.CanTouch = false;
	core.CanQuery = false;
	core.Massless = true;
	core.CFrame = head.CFrame * CFrame.new(0, 0.15, 0);
	core.Parent = model;
	local mainWeld = MarkSpookyFX(Instance.new("WeldConstraint"));
	mainWeld.Part0 = head;
	mainWeld.Part1 = core;
	mainWeld.Parent = core;
	for angle = 0, 135, 45 do
		local rib = MarkSpookyFX(Instance.new("Part"));
		rib.Shape = Enum.PartType.Ball;
		rib.Size = Vector3.new(2.5, 1.95, 1.65);
		rib.Color = (((angle % 90) == 0) and Color3.fromRGB(215, 82, 10)) or Color3.fromRGB(240, 105, 18);
		rib.Material = Enum.Material.SmoothPlastic;
		rib.CanCollide = false;
		rib.CanTouch = false;
		rib.CanQuery = false;
		rib.Massless = true;
		rib.CFrame = core.CFrame * CFrame.Angles(0, math.rad(angle), 0);
		rib.Parent = model;
		local w = MarkSpookyFX(Instance.new("WeldConstraint"));
		w.Part0 = core;
		w.Part1 = rib;
		w.Parent = rib;
	end
	local stem = MarkSpookyFX(Instance.new("Part"));
	stem.Shape = Enum.PartType.Cylinder;
	stem.Size = Vector3.new(0.55, 0.35, 0.35);
	stem.Color = Color3.fromRGB(45, 100, 35);
	stem.Material = Enum.Material.Wood;
	stem.CanCollide = false;
	stem.CanTouch = false;
	stem.CanQuery = false;
	stem.Massless = true;
	stem.CFrame = core.CFrame * CFrame.new(0, 1.05, 0) * CFrame.Angles(0, 0, math.rad(80));
	stem.Parent = model;
	local stemWeld = MarkSpookyFX(Instance.new("WeldConstraint"));
	stemWeld.Part0 = core;
	stemWeld.Part1 = stem;
	stemWeld.Parent = stem;
	local function AddWarmFeature(size, offsetCFrame)
		local feat = MarkSpookyFX(Instance.new("Part"));
		feat.Size = size;
		feat.Color = Color3.fromRGB(255, 185, 45);
		feat.Material = Enum.Material.SmoothPlastic;
		feat.Reflectance = 0.1;
		feat.CanCollide = false;
		feat.CanTouch = false;
		feat.CanQuery = false;
		feat.Massless = true;
		feat.CFrame = core.CFrame * offsetCFrame;
		feat.Parent = model;
		local w = MarkSpookyFX(Instance.new("WeldConstraint"));
		w.Part0 = core;
		w.Part1 = feat;
		w.Parent = feat;
	end
	AddWarmFeature(Vector3.new(0.42, 0.38, 0.2), CFrame.new(-0.45, 0.25, -1.15) * CFrame.Angles(0, math.rad(18), math.rad(-15)));
	AddWarmFeature(Vector3.new(0.42, 0.38, 0.2), CFrame.new(0.45, 0.25, -1.15) * CFrame.Angles(0, math.rad(-18), math.rad(15)));
	AddWarmFeature(Vector3.new(0.75, 0.22, 0.2), CFrame.new(0, -0.35, -1.18));
	AddWarmFeature(Vector3.new(0.45, 0.22, 0.2), CFrame.new(-0.48, -0.22, -1.12) * CFrame.Angles(0, math.rad(22), math.rad(-25)));
	AddWarmFeature(Vector3.new(0.45, 0.22, 0.2), CFrame.new(0.48, -0.22, -1.12) * CFrame.Angles(0, math.rad(-22), math.rad(25)));
	local light = MarkSpookyFX(Instance.new("PointLight"));
	light.Color = THEME_ORANGE;
	light.Range = 7;
	light.Brightness = 0.45;
	light.Parent = core;
end
local function UpdateAllPumpkinHeads()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			pcall(Create3DPumpkinHead, player.Character, Settings.PumpkinHeads);
		end
	end
end
local OrbitNodes = {};
local function ClearOrbitingPumpkins()
	for _, node in ipairs(OrbitNodes) do
		if node.Part then
			pcall(function()
				node.Part:Destroy();
			end);
		end
	end
	table.clear(OrbitNodes);
end
local function CreateOrbitingPumpkins()
	ClearOrbitingPumpkins();
	if not Settings.OrbitingPumpkins then
		return;
	end
	for i = 1, 3 do
		local orb = MarkSpookyFX(Instance.new("Part"));
		orb.Name = "UniversalSpookyOrb";
		orb.Shape = Enum.PartType.Ball;
		orb.Size = Vector3.new(0.85, 0.75, 0.85);
		orb.Color = (((i % 2) == 1) and THEME_ORANGE) or THEME_PURPLE;
		orb.Material = Enum.Material.SmoothPlastic;
		orb.Transparency = 0.1;
		orb.Anchored = true;
		orb.CanCollide = false;
		orb.CanTouch = false;
		orb.CanQuery = false;
		orb.Parent = workspace;
		local a0 = MarkSpookyFX(Instance.new("Attachment", orb));
		a0.Position = Vector3.new(0, 0.35, 0);
		local a1 = MarkSpookyFX(Instance.new("Attachment", orb));
		a1.Position = Vector3.new(0, -0.35, 0);
		local tr = MarkSpookyFX(Instance.new("Trail"));
		tr.Attachment0 = a0;
		tr.Attachment1 = a1;
		tr.Lifetime = 0.45;
		tr.LightEmission = 0.65;
		tr.Color = ColorSequence.new(THEME_ORANGE, THEME_PURPLE);
		tr.Transparency = NumberSequence.new(0.25, 1);
		tr.Parent = orb;
		table.insert(OrbitNodes, {Part=orb,Index=i});
	end
end
CreateOrbitingPumpkins();
TrackConn(RunService.RenderStepped:Connect(function()
	if Camera then
		local camPos = Camera.CFrame.Position;
		if WeatherPart then
			WeatherPart.CFrame = CFrame.new(camPos + Vector3.new(0, 28, 0));
		end
		if MoonModel then
			local moonPos = camPos + Vector3.new(210, 185, -310);
			local core = MoonModel:FindFirstChild("MoonCore");
			local halo = MoonModel:FindFirstChild("MoonHalo");
			if core then
				core.CFrame = CFrame.new(moonPos);
			end
			if halo then
				halo.CFrame = CFrame.new(moonPos);
			end
		end
	end
	if (Settings.OrbitingPumpkins and (#OrbitNodes > 0)) then
		local char = LocalPlayer.Character;
		local root = char and char:FindFirstChild("HumanoidRootPart");
		if root then
			local t = os.clock() * 2.4;
			for _, node in ipairs(OrbitNodes) do
				if (node.Part and node.Part.Parent) then
					local angle = t + (node.Index * ((math.pi * 2) / 3));
					local radius = 4.2;
					local height = math.sin((t * 1.8) + node.Index) * 1.2;
					local offset = Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius);
					node.Part.CFrame = CFrame.new(root.Position + offset);
				end
			end
		end
	end
end));
local function GetESPColor(player)
	if Settings.SpecialPlayers[player.Name] then
		return Settings.SpecialColor;
	end
	if (Settings.UseTeamColor and player.Team) then
		return player.TeamColor.Color;
	end
	if (LocalPlayer.Team and (LocalPlayer.Team == player.Team)) then
		return Settings.FriendColor;
	end
	return Settings.EnemyColor;
end
local function RemoveESP(player)
	local folder = ESPFolder:FindFirstChild(player.Name);
	if folder then
		folder:Destroy();
	end
	if player.Character then
		local highlight = player.Character:FindFirstChild("UniversalESPHighlight");
		if highlight then
			highlight:Destroy();
		end
		local ff = player.Character:FindFirstChild("UniversalForceFieldESP");
		if ff then
			ff:Destroy();
		end
		local pk = player.Character:FindFirstChild("UniversalPumpkinHead");
		if pk then
			pk:Destroy();
		end
	end
end
local function CreateESP(player)
	if (player == LocalPlayer) then
		if (player.Character and Settings.PumpkinHeads) then
			pcall(Create3DPumpkinHead, player.Character, true);
		end
		return;
	end
	if not Settings.ESP then
		return;
	end
	local character = player.Character;
	if not character then
		return;
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid");
	local head = character:FindFirstChild("Head");
	if (not humanoid or not head) then
		return;
	end
	RemoveESP(player);
	local folder = MarkSpookyFX(Instance.new("Folder"));
	folder.Name = player.Name;
	folder.Parent = ESPFolder;
	local color = GetESPColor(player);
	if Settings.ESPBoxes then
		local box = MarkSpookyFX(Instance.new("BoxHandleAdornment"));
		box.Name = "Box";
		box.Adornee = character;
		box.Size = Vector3.new(4, 6, 2);
		box.Color3 = color;
		box.Transparency = 0.7;
		box.AlwaysOnTop = true;
		box.ZIndex = 5;
		box.Parent = folder;
	end
	if Settings.ESPNames then
		local gui = MarkSpookyFX(Instance.new("BillboardGui"));
		gui.Name = "NameTag";
		gui.Adornee = head;
		gui.Size = UDim2.new(0, 230, 0, 52);
		gui.StudsOffset = Vector3.new(0, 3.2, 0);
		gui.AlwaysOnTop = true;
		gui.MaxDistance = 10000;
		local text = Instance.new("TextLabel");
		text.Name = "Text";
		text.BackgroundTransparency = 1;
		text.Size = UDim2.new(1, 0, 1, 0);
		text.Text = "🎃 " .. player.Name;
		text.TextSize = 14;
		text.Font = Enum.Font.SourceSansBold;
		text.TextColor3 = color;
		text.TextStrokeColor3 = Color3.new(0, 0, 0);
		text.TextStrokeTransparency = 0.3;
		text.Parent = gui;
		gui.Parent = folder;
	end
	if Settings.ESPHighlights then
		local highlight = MarkSpookyFX(Instance.new("Highlight"));
		highlight.Name = "UniversalESPHighlight";
		highlight.Adornee = character;
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
		highlight.FillColor = color;
		highlight.OutlineColor = color;
		highlight.FillTransparency = 0.62;
		highlight.OutlineTransparency = 0.08;
		highlight.Parent = character;
	end
	if Settings.PumpkinHeads then
		pcall(Create3DPumpkinHead, character, true);
	end
	pcall(function()
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
	end);
end
local function UpdateESP(player)
	if (player == LocalPlayer) then
		return;
	end
	local character = player.Character;
	if not character then
		return;
	end
	local color = GetESPColor(player);
	local folder = ESPFolder:FindFirstChild(player.Name);
	if folder then
		local box = folder:FindFirstChild("Box");
		if box then
			box.Color3 = color;
		end
		local tag = folder:FindFirstChild("NameTag");
		if tag then
			local text = tag:FindFirstChild("Text");
			if text then
				text.TextColor3 = color;
			end
		end
	end
	local highlight = character:FindFirstChild("UniversalESPHighlight");
	if highlight then
		highlight.FillColor = color;
		highlight.OutlineColor = color;
	end
end
task.spawn(function()
	while HubRunning and task.wait(0.15) do
		if (Settings.ESP and Settings.ESPNames) then
			local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
			for _, player in ipairs(Players:GetPlayers()) do
				if ((player ~= LocalPlayer) and player.Character) then
					local folder = ESPFolder:FindFirstChild(player.Name);
					local tag = folder and folder:FindFirstChild("NameTag");
					local textLbl = tag and tag:FindFirstChild("Text");
					if textLbl then
						local char = player.Character;
						local hum = char:FindFirstChildOfClass("Humanoid");
						local root = char:FindFirstChild("HumanoidRootPart");
						local tool = char:FindFirstChildOfClass("Tool");
						local hp = (hum and math.floor(hum.Health)) or 0;
						local dist = (myRoot and root and math.floor((myRoot.Position - root.Position).Magnitude)) or 0;
						local toolName = (tool and tool.Name) or "Empty";
						local badge = "🎃";
						if Settings.SpecialPlayers[player.Name] then
							badge = "⭐";
						elseif (hp <= 35) then
							badge = "💀";
						end
						if Settings.ESPShowDetails then
							textLbl.Text = string.format("%s %s [%dm]\n%d HP | [%s]", badge, player.Name, dist, hp, toolName);
						else
							textLbl.Text = string.format("%s %s", badge, player.Name);
						end
					end
				end
			end
		end
	end
end);
local LootKeywords = {"pumpkin","candy","treat","soul","chest","crate","gift","key","token","relic","artifact"};
local TrackedLoot = {};
local function IsLootName(name)
	local lower = string.lower(name);
	for _, kw in ipairs(LootKeywords) do
		if string.find(lower, kw, 1, true) then
			return true;
		end
	end
	return false;
end
local function ClearLootESP()
	LootFolder:ClearAllChildren();
	table.clear(TrackedLoot);
end
local function CheckAndAddLoot(obj)
	if (not Settings.HalloweenLootESP or TrackedLoot[obj] or IsSpookyFX(obj)) then
		return;
	end
	if not (obj:IsA("BasePart") or obj:IsA("Model")) then
		return;
	end
	if not IsLootName(obj.Name) then
		return;
	end
	local ancestorModel = obj:FindFirstAncestorOfClass("Model");
	if (ancestorModel and Players:GetPlayerFromCharacter(ancestorModel)) then
		return;
	end
	local adornee = (obj:IsA("BasePart") and obj) or obj:FindFirstChildWhichIsA("BasePart");
	if not adornee then
		return;
	end
	TrackedLoot[obj] = true;
	local bill = MarkSpookyFX(Instance.new("BillboardGui"));
	bill.Name = "LootTag";
	bill.Adornee = adornee;
	bill.Size = UDim2.new(0, 160, 0, 36);
	bill.StudsOffset = Vector3.new(0, 2, 0);
	bill.AlwaysOnTop = true;
	bill.MaxDistance = 3000;
	bill.Parent = LootFolder;
	local lbl = Instance.new("TextLabel");
	lbl.Size = UDim2.new(1, 0, 1, 0);
	lbl.BackgroundTransparency = 1;
	lbl.Font = Enum.Font.GothamBold;
	lbl.TextSize = 13;
	lbl.TextColor3 = Color3.fromRGB(255, 165, 30);
	lbl.TextStrokeTransparency = 0.2;
	lbl.Text = "🍬 " .. obj.Name;
	lbl.Parent = bill;
	obj.AncestryChanged:Connect(function(_, parent)
		if not parent then
			TrackedLoot[obj] = nil;
			if bill then
				bill:Destroy();
			end
		end
	end);
end
local function ScanAllWorkspaceForLoot()
	ClearLootESP();
	if not Settings.HalloweenLootESP then
		return;
	end
	for _, obj in ipairs(workspace:GetDescendants()) do
		CheckAndAddLoot(obj);
	end
end
local FFConnections = {};
local function DisconnectFF(player)
	local connections = FFConnections[player];
	if not connections then
		return;
	end
	for _, connection in ipairs(connections) do
		pcall(function()
			connection:Disconnect();
		end);
	end
	FFConnections[player] = nil;
end
local function RemoveForceFieldESP(player)
	local character = player.Character;
	if not character then
		return;
	end
	local highlight = character:FindFirstChild("UniversalForceFieldESP");
	if highlight then
		highlight:Destroy();
	end
end
local function UpdateForceField(player)
	if (player == LocalPlayer) then
		return;
	end
	local character = player.Character;
	if not character then
		return;
	end
	local forceField = character:FindFirstChildOfClass("ForceField");
	local highlight = character:FindFirstChild("UniversalForceFieldESP");
	if (Settings.ForceFieldESP and forceField) then
		if not highlight then
			highlight = MarkSpookyFX(Instance.new("Highlight"));
			highlight.Name = "UniversalForceFieldESP";
			highlight.Adornee = character;
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
			highlight.FillColor = Settings.ForceFieldColor;
			highlight.OutlineColor = Settings.ForceFieldColor;
			highlight.FillTransparency = 0.25;
			highlight.OutlineTransparency = 0;
			highlight.Parent = character;
		else
			highlight.FillColor = Settings.ForceFieldColor;
			highlight.OutlineColor = Settings.ForceFieldColor;
		end
	elseif highlight then
		highlight:Destroy();
	end
end
local function TrackForceField(player)
	if (player == LocalPlayer) then
		return;
	end
	DisconnectFF(player);
	local connections = {};
	FFConnections[player] = connections;
	local function BindCharacter(character)
		task.defer(function()
			UpdateForceField(player);
		end);
		table.insert(connections, character.ChildAdded:Connect(function(obj)
			if obj:IsA("ForceField") then
				task.defer(function()
					pcall(UpdateForceField, player);
				end);
			end
		end));
		table.insert(connections, character.ChildRemoved:Connect(function(obj)
			if obj:IsA("ForceField") then
				task.defer(function()
					RemoveForceFieldESP(player);
				end);
			end
		end));
	end
	table.insert(connections, player.CharacterAdded:Connect(BindCharacter));
	table.insert(connections, player.CharacterRemoving:Connect(function(character)
		local highlight = character:FindFirstChild("UniversalForceFieldESP");
		if highlight then
			highlight:Destroy();
		end
	end));
	if player.Character then
		BindCharacter(player.Character);
	end
end
local ActiveLasers = {};
local function TrackPlayerLasers(player)
	local function CheckObj(obj)
		if ((obj.Name == "Laser") and obj:IsA("BasePart")) then
			ActiveLasers[obj] = true;
			obj.AncestryChanged:Connect(function(_, parent)
				if not parent then
					ActiveLasers[obj] = nil;
				end
			end);
		end
	end
	for _, obj in ipairs(player:GetDescendants()) do
		CheckObj(obj);
	end
	player.DescendantAdded:Connect(CheckObj);
end
task.spawn(function()
	while HubRunning and task.wait(0.05) do
		if Settings.LaserRGB then
			local alpha = (math.sin(os.clock() * 3) + 1) / 2;
			local spookyColor = THEME_ORANGE:Lerp(THEME_PURPLE, alpha);
			for laser in pairs(ActiveLasers) do
				if (laser and laser.Parent) then
					laser.Color = spookyColor;
				else
					ActiveLasers[laser] = nil;
				end
			end
		end
	end
end);
TrackConn(RunService.Stepped:Connect(function()
	if not Settings.AntiFling then
		return;
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if ((player ~= LocalPlayer) and player.Character) then
			for _, part in ipairs(player.Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.CanCollide = false;
					if ((part.AssemblyAngularVelocity.Magnitude > 50) or (part.AssemblyLinearVelocity.Magnitude > 100)) then
						part.AssemblyAngularVelocity = Vector3.zero;
						part.AssemblyLinearVelocity = Vector3.zero;
					end
				end
			end
		end
	end
end));
local SavedGhostAppearance = {};
local function SetGhostPhaseVisuals(enabled)
	local character = LocalPlayer.Character;
	if not character then
		return;
	end
	if enabled then
		PlaySFX(HalloweenMedia.GhostScreamId, 0.55, 1.1);
		for _, part in ipairs(character:GetDescendants()) do
			if (part:IsA("BasePart") and (part.Name ~= "HumanoidRootPart") and not IsSpookyFX(part) and (part.Transparency < 0.9)) then
				if not SavedGhostAppearance[part] then
					SavedGhostAppearance[part] = {Transparency=part.Transparency,Color=part.Color,Material=part.Material};
				end
				part.Transparency = 0.55;
				part.Color = THEME_ORANGE;
				part.Material = Enum.Material.ForceField;
			end
		end
	else
		PlayWhooshSFX();
		for part, data in pairs(SavedGhostAppearance) do
			if (part and part.Parent) then
				part.Transparency = data.Transparency;
				part.Color = data.Color;
				part.Material = data.Material;
			end
		end
		table.clear(SavedGhostAppearance);
	end
end
TrackConn(RunService.Stepped:Connect(function()
	if not Settings.GhostPhase then
		return;
	end
	local character = LocalPlayer.Character;
	if not character then
		return;
	end
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false;
			part.CanTouch = false;
		end
	end
end));
local StaminaKeywords = {"stamina","energy","endurance","breath"};
local ExhaustKeywords = {"exhaust","fatigue","tired","ragdoll","collapse","faint"};
local function MatchesKeyword(str, list)
	if (type(str) ~= "string") then
		return false;
	end
	local lower = string.lower(str);
	for _, word in ipairs(list) do
		if string.find(lower, word, 1, true) then
			return true;
		end
	end
	return false;
end
local DisabledJumpConns = {};
local function SetGameJumpConnectionsEnabled(enabled)
	pcall(function()
		if not getconnections then
			return;
		end
		if not enabled then
			for _, conn in ipairs(getconnections(UIS.JumpRequest)) do
				if conn.Enabled then
					conn:Disable();
					table.insert(DisabledJumpConns, conn);
				end
			end
			local char = LocalPlayer.Character;
			local hum = char and char:FindFirstChildOfClass("Humanoid");
			if hum then
				for _, conn in ipairs(getconnections(hum.Jumping)) do
					if conn.Enabled then
						conn:Disable();
						table.insert(DisabledJumpConns, conn);
					end
				end
			end
		else
			for _, conn in ipairs(DisabledJumpConns) do
				pcall(function()
					conn:Enable();
				end);
			end
			table.clear(DisabledJumpConns);
		end
	end);
end
local function HookStaminaObject(obj)
	if ((obj:IsA("NumberValue") or obj:IsA("IntValue")) and MatchesKeyword(obj.Name, StaminaKeywords)) then
		local maxVal = math.max(obj.Value, 100);
		obj:GetPropertyChangedSignal("Value"):Connect(function()
			if (Settings.InfiniteStamina and (obj.Value < maxVal)) then
				obj.Value = maxVal;
			end
		end);
	elseif (obj:IsA("BoolValue") and MatchesKeyword(obj.Name, ExhaustKeywords)) then
		obj:GetPropertyChangedSignal("Value"):Connect(function()
			if ((Settings.InfiniteStamina or Settings.AntiRagdoll) and (obj.Value == true)) then
				obj.Value = false;
			end
		end);
	end
end
local function SetupLocalCharacterBypass(character)
	if not character then
		return;
	end
	HookCharacterDeathLaugh(LocalPlayer, character);
	local humanoid = character:WaitForChild("Humanoid", 5);
	if not humanoid then
		return;
	end
	pcall(function()
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false);
	end);
	humanoid.StateChanged:Connect(function(_, newState)
		if Settings.AntiRagdoll then
			if ((newState == Enum.HumanoidStateType.Ragdoll) or (newState == Enum.HumanoidStateType.FallingDown) or (newState == Enum.HumanoidStateType.Physics)) then
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
			end
		end
	end);
	for _, obj in ipairs(character:GetDescendants()) do
		HookStaminaObject(obj);
	end
	character.DescendantAdded:Connect(HookStaminaObject);
	if Settings.InfiniteJump then
		task.delay(0.3, function()
			SetGameJumpConnectionsEnabled(false);
		end);
	end
	if Settings.GhostPhase then
		task.delay(0.3, function()
			SetGhostPhaseVisuals(true);
		end);
	end
	if Settings.PumpkinHeads then
		task.delay(0.3, function()
			Create3DPumpkinHead(character, true);
		end);
	end
end
if LocalPlayer.Character then
	task.spawn(SetupLocalCharacterBypass, LocalPlayer.Character);
end
TrackConn(LocalPlayer.CharacterAdded:Connect(SetupLocalCharacterBypass));
TrackConn(RunService.Stepped:Connect(function()
	if not Settings.AntiRagdoll then
		return;
	end
	local character = LocalPlayer.Character;
	if not character then
		return;
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid");
	if (not humanoid or (humanoid.Health <= 0)) then
		return;
	end
	if humanoid.PlatformStand then
		humanoid.PlatformStand = false;
	end
	if (humanoid.Sit and not humanoid.SeatPart) then
		humanoid.Sit = false;
	end
	for _, desc in ipairs(character:GetDescendants()) do
		if (desc:IsA("Motor6D") and (desc.Enabled == false)) then
			desc.Enabled = true;
		end
	end
end));
local function SetupPlayer(player)
	TrackPlayerLasers(player);
	if (player == LocalPlayer) then
		if (player.Character and Settings.PumpkinHeads) then
			task.defer(function()
				pcall(Create3DPumpkinHead, player.Character, true);
			end);
		end
		return;
	end
	player.CharacterAdded:Connect(function(char)
		HookCharacterDeathLaugh(player, char);
		task.wait(0.15);
		pcall(CreateESP, player);
		pcall(TrackForceField, player);
	end);
	player.CharacterRemoving:Connect(function()
		RemoveESP(player);
		DisconnectFF(player);
	end);
	player:GetPropertyChangedSignal("TeamColor"):Connect(function()
		UpdateESP(player);
	end);
	TrackForceField(player);
	if player.Character then
		HookCharacterDeathLaugh(player, player.Character);
		task.defer(function()
			pcall(CreateESP, player);
			pcall(UpdateForceField, player);
		end);
	end
end
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(SetupPlayer, player);
end
TrackConn(Players.PlayerAdded:Connect(SetupPlayer));
TrackConn(Players.PlayerRemoving:Connect(function(player)
	RemoveESP(player);
	DisconnectFF(player);
end));
local SeatObjects = {};
local function RemoveSeat(seat)
	local highlight = SeatObjects[seat];
	if highlight then
		SeatObjects[seat] = nil;
		pcall(function()
			highlight:Destroy();
		end);
	end
end
local function AddSeat(seat)
	if (not Settings.SeatESP or SeatObjects[seat]) then
		return;
	end
	local highlight = MarkSpookyFX(Instance.new("Highlight"));
	highlight.Name = "UniversalSeatHighlight";
	highlight.Adornee = seat;
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
	highlight.FillColor = Settings.SeatColor;
	highlight.OutlineColor = Settings.SeatColor;
	highlight.FillTransparency = Settings.SeatTransparency;
	highlight.OutlineTransparency = 0.35;
	highlight.Parent = SeatFolder;
	SeatObjects[seat] = highlight;
	seat.AncestryChanged:Connect(function(_, parent)
		if not parent then
			RemoveSeat(seat);
		end
	end);
end
local function ProcessWorkspaceObject(obj)
	if (not obj or IsSpookyFX(obj)) then
		return;
	end
	if Settings.RG_ESP then
		CheckAndHighlightRG(obj);
	end
	if (string.lower(obj.Name) == "inviswall") then
		CheckAndHighlightInvisWall(obj);
	end
	if Settings.HalloweenLootESP then
		CheckAndAddLoot(obj);
	end
	if (obj:IsA("ProximityPrompt") and Settings.InstantInteract) then
		pcall(function()
			obj.HoldDuration = 0;
		end);
		return;
	end
	if (obj:IsA("Seat") or obj:IsA("VehicleSeat")) then
		AddSeat(obj);
		return;
	end
	if Settings.FPSBoost then
		pcall(function()
			if (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") or obj:IsA("PostEffect")) then
				obj.Enabled = false;
			elseif (obj:IsA("Texture") or obj:IsA("Decal")) then
				obj.Transparency = 1;
			end
		end);
	end
end
TrackConn(ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
	if Settings.InstantInteract then
		pcall(function()
			prompt.HoldDuration = 0;
			if fireproximityprompt then
				fireproximityprompt(prompt);
			end
		end);
	end
end));
if Settings.DeleteMapDecorations then
	local map = workspace:FindFirstChild("MapDecorations");
	if map then
		pcall(function()
			map:Destroy();
		end);
	end
end
TrackConn(workspace.ChildAdded:Connect(function(obj)
	if (Settings.DeleteMapDecorations and (obj.Name == "MapDecorations")) then
		task.defer(function()
			pcall(function()
				obj:Destroy();
			end);
		end);
	end
end));
for _, obj in ipairs(workspace:GetDescendants()) do
	ProcessWorkspaceObject(obj);
end
TrackConn(workspace.DescendantAdded:Connect(function(obj)
	task.defer(function()
		ProcessWorkspaceObject(obj);
	end);
end));
local IsGliding = false;
local GlideTarget = nil;
local GlideSteppedConn = nil;
local GlideHeartbeatConn = nil;
local ActiveBodyVelocity = nil;
local GlideFXCleanup = {};
local SavedCollideStates = {};
local function StopGlide()
	IsGliding = false;
	GlideTarget = nil;
	if GlideSteppedConn then
		GlideSteppedConn:Disconnect();
		GlideSteppedConn = nil;
	end
	if GlideHeartbeatConn then
		GlideHeartbeatConn:Disconnect();
		GlideHeartbeatConn = nil;
	end
	if ActiveBodyVelocity then
		ActiveBodyVelocity:Destroy();
		ActiveBodyVelocity = nil;
	end
	for _, fx in ipairs(GlideFXCleanup) do
		pcall(function()
			fx:Destroy();
		end);
	end
	table.clear(GlideFXCleanup);
	for part, state in pairs(SavedCollideStates) do
		if (part and part.Parent) then
			part.CanCollide = state.CanCollide;
			part.CanTouch = state.CanTouch;
		end
	end
	table.clear(SavedCollideStates);
	local character = LocalPlayer.Character;
	local root = character and character:FindFirstChild("HumanoidRootPart");
	if root then
		root.AssemblyLinearVelocity = Vector3.zero;
	end
end
local function GlideToPosition(rawTargetPos)
	local character = LocalPlayer.Character;
	if not character then
		return;
	end
	local root = character:FindFirstChild("HumanoidRootPart");
	local humanoid = character:FindFirstChildOfClass("Humanoid");
	if (not root or not humanoid or (humanoid.Health <= 0)) then
		return;
	end
	StopGlide();
	PlayWhooshSFX();
	IsGliding = true;
	GlideTarget = rawTargetPos + Vector3.new(0, 3, 0);
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			SavedCollideStates[part] = {CanCollide=part.CanCollide,CanTouch=part.CanTouch};
		end
	end
	local bv = MarkSpookyFX(Instance.new("BodyVelocity"));
	bv.Name = "UniversalGlideBV";
	bv.MaxForce = Vector3.new(100000, 100000, 100000);
	bv.Velocity = Vector3.zero;
	bv.Parent = root;
	ActiveBodyVelocity = bv;
	local att0 = MarkSpookyFX(Instance.new("Attachment"));
	att0.Name = "GlideAtt0";
	att0.Position = Vector3.new(0, 1.8, 0);
	att0.Parent = root;
	table.insert(GlideFXCleanup, att0);
	local att1 = MarkSpookyFX(Instance.new("Attachment"));
	att1.Name = "GlideAtt1";
	att1.Position = Vector3.new(0, -1.8, 0);
	att1.Parent = root;
	table.insert(GlideFXCleanup, att1);
	local trail = MarkSpookyFX(Instance.new("Trail"));
	trail.Name = "UniversalHalloweenTrail";
	trail.Attachment0 = att0;
	trail.Attachment1 = att1;
	trail.Lifetime = 0.75;
	trail.MinLength = 0.05;
	trail.FaceCamera = true;
	trail.LightEmission = 0.85;
	trail.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, THEME_ORANGE),ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 0)),ColorSequenceKeypoint.new(1, THEME_PURPLE)});
	trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1),NumberSequenceKeypoint.new(0.6, 0.4),NumberSequenceKeypoint.new(1, 1)});
	trail.WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.3),NumberSequenceKeypoint.new(1, 0)});
	trail.Parent = root;
	table.insert(GlideFXCleanup, trail);
	local sparks = MarkSpookyFX(Instance.new("ParticleEmitter"));
	sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds";
	sparks.Color = ColorSequence.new(THEME_ORANGE, THEME_PURPLE);
	sparks.LightEmission = 0.85;
	sparks.Size = NumberSequence.new(0.55, 0);
	sparks.Lifetime = NumberRange.new(0.3, 0.6);
	sparks.Rate = 60;
	sparks.Speed = NumberRange.new(2, 5);
	sparks.SpreadAngle = Vector2.new(180, 180);
	sparks.Parent = root;
	table.insert(GlideFXCleanup, sparks);
	GlideSteppedConn = RunService.Stepped:Connect(function()
		if (not IsGliding or not character.Parent) then
			StopGlide();
			return;
		end
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false;
				part.CanTouch = false;
			end
		end
	end);
	GlideHeartbeatConn = RunService.Heartbeat:Connect(function()
		if (not IsGliding or not root or not root.Parent or not GlideTarget or not ActiveBodyVelocity) then
			StopGlide();
			return;
		end
		local diff = GlideTarget - root.Position;
		if (diff.Magnitude < 2.2) then
			StopGlide();
			return;
		end
		ActiveBodyVelocity.Velocity = diff.Unit * Settings.GlideSpeed;
	end);
end
local function GetPlayerFromMouse()
	local target = Mouse.Target;
	if not target then
		return nil;
	end
	local character = target:FindFirstAncestorOfClass("Model");
	if not character then
		return nil;
	end
	local player = Players:GetPlayerFromCharacter(character);
	if (player == LocalPlayer) then
		return nil;
	end
	return player;
end
local function PhantomBackstabGlide()
	local myChar = LocalPlayer.Character;
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart");
	if not myRoot then
		return;
	end
	local targetPlayer = GetPlayerFromMouse();
	if not targetPlayer then
		local bestDist = 120;
		for _, p in ipairs(Players:GetPlayers()) do
			if ((p ~= LocalPlayer) and not Settings.SpecialPlayers[p.Name] and p.Character) then
				local r = p.Character:FindFirstChild("HumanoidRootPart");
				local h = p.Character:FindFirstChildOfClass("Humanoid");
				if (r and h and (h.Health > 0)) then
					local d = (r.Position - myRoot.Position).Magnitude;
					if (d < bestDist) then
						bestDist = d;
						targetPlayer = p;
					end
				end
			end
		end
	end
	if (targetPlayer and targetPlayer.Character) then
		local theirRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart");
		if theirRoot then
			local behindPos = theirRoot.Position - (theirRoot.CFrame.LookVector * 3.8);
			GlideToPosition(behindPos - Vector3.new(0, 2.5, 0));
			Notify("Phantom Backstab [H]", "Залетаем за спину: " .. targetPlayer.Name, 2.2);
			return;
		end
	end
	Notify("Phantom Backstab [H]", "Рядом нет подходящей цели!", 2);
end
local function GlideToNearestRG()
	local myChar = LocalPlayer.Character;
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart");
	if not myRoot then
		return;
	end
	local nearestPos = nil;
	local minDist = math.huge;
	for obj in pairs(TrackedRGObjects) do
		if (obj and obj.Parent) then
			local part = (obj:IsA("BasePart") and obj) or obj:FindFirstChildWhichIsA("BasePart", true);
			if part then
				local d = (part.Position - myRoot.Position).Magnitude;
				if (d < minDist) then
					minDist = d;
					nearestPos = part.Position;
				end
			end
		end
	end
	if nearestPos then
		GlideToPosition(nearestPos);
		Notify("RG Finder [B]", string.format("Летим к ближайшему 'rg' (%dm)", math.floor(minDist)), 2.5);
	else
		Notify("RG Finder [B]", "Объекты 'rg' на карте не найдены!", 2);
	end
end
TrackConn(RunService.Heartbeat:Connect(function(dt)
	if (not Settings.NoStaminaSprint or IsGliding or Settings.FreeCam) then
		return;
	end
	local character = LocalPlayer.Character;
	if not character then
		return;
	end
	local root = character:FindFirstChild("HumanoidRootPart");
	local humanoid = character:FindFirstChildOfClass("Humanoid");
	if (root and humanoid and (humanoid.Health > 0) and (humanoid.MoveDirection.Magnitude > 0)) then
		root.CFrame = root.CFrame + (humanoid.MoveDirection * Settings.SprintBoostSpeed * dt);
	end
end));
local FreeCamYaw = 0;
local FreeCamPitch = 0;
local SavedWalkSpeed = 16;
local DefaultFOV = Camera.FieldOfView;
local function SetFreeCam(enabled)
	Settings.FreeCam = enabled;
	RefreshUIButton("FreeCam");
	local character = LocalPlayer.Character;
	local humanoid = character and character:FindFirstChildOfClass("Humanoid");
	local root = character and character:FindFirstChild("HumanoidRootPart");
	if enabled then
		StopGlide();
		local rx, ry = Camera.CFrame:ToOrientation();
		FreeCamPitch = rx;
		FreeCamYaw = ry;
		Camera.CameraType = Enum.CameraType.Scriptable;
		if root then
			root.Anchored = true;
		end
		if humanoid then
			SavedWalkSpeed = humanoid.WalkSpeed;
		end
		Notify("FreeCam: ON [C]", "Нажми [T], чтобы прилететь сюда телом!", 3);
	else
		Camera.CameraType = Enum.CameraType.Custom;
		if humanoid then
			Camera.CameraSubject = humanoid;
			humanoid.WalkSpeed = SavedWalkSpeed;
		end
		if root then
			root.Anchored = false;
		end
		UIS.MouseBehavior = Enum.MouseBehavior.Default;
	end
end
TrackConn(RunService.RenderStepped:Connect(function(dt)
	if not Settings.FreeCam then
		return;
	end
	Camera.CameraType = Enum.CameraType.Scriptable;
	if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition;
		local delta = UIS:GetMouseDelta();
		FreeCamYaw = FreeCamYaw - (delta.X * 0.003);
		FreeCamPitch = math.clamp(FreeCamPitch - (delta.Y * 0.003), -math.rad(89), math.rad(89));
	else
		UIS.MouseBehavior = Enum.MouseBehavior.Default;
	end
	local rotCFrame = CFrame.Angles(0, FreeCamYaw, 0) * CFrame.Angles(FreeCamPitch, 0, 0);
	local moveVec = Vector3.zero;
	if not UIS:GetFocusedTextBox() then
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			moveVec += Vector3.new(0, 0, -1)
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			moveVec += Vector3.new(0, 0, 1)
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			moveVec += Vector3.new(-1, 0, 0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			moveVec += Vector3.new(1, 0, 0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.E) then
			moveVec += Vector3.new(0, 1, 0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.Q) then
			moveVec += Vector3.new(0, -1, 0)
		end
	end
	local speedMult = (UIS:IsKeyDown(Enum.KeyCode.LeftShift) and (Settings.FreeCamSpeed * 3)) or Settings.FreeCamSpeed;
	local newPos = Camera.CFrame.Position + (rotCFrame:VectorToWorldSpace(moveVec) * speedMult * 60 * dt);
	Camera.CFrame = CFrame.new(newPos) * rotCFrame;
end));
local LastJumpTick = 0;
local function DoCleanBypassJump()
	if (not Settings.InfiniteJump or Settings.FreeCam) then
		return;
	end
	local now = os.clock();
	if ((now - LastJumpTick) < 0.18) then
		return;
	end
	LastJumpTick = now;
	if IsGliding then
		StopGlide();
	end
	local character = LocalPlayer.Character;
	if not character then
		return;
	end
	local root = character:FindFirstChild("HumanoidRootPart");
	local humanoid = character:FindFirstChildOfClass("Humanoid");
	if (not root or not humanoid or (humanoid.Health <= 0)) then
		return;
	end
	if Settings.CursedFootsteps then
		SpawnCursedStepRing(root.Position - Vector3.new(0, 2.5, 0));
	end
	local vel = root.AssemblyLinearVelocity;
	root.AssemblyLinearVelocity = Vector3.new(vel.X, Settings.JumpImpulse, vel.Z);
end
local function UpdateSpaceIntercept()
	CAS:UnbindAction("UniversalCleanJump");
	if Settings.InfiniteJump then
		SetGameJumpConnectionsEnabled(false);
		CAS:BindActionAtPriority("UniversalCleanJump", function(_, inputState)
			if (inputState == Enum.UserInputState.Begin) then
				DoCleanBypassJump();
			end
			return Enum.ContextActionResult.Sink;
		end, false, Enum.ContextActionPriority.High.Value + 500, Enum.KeyCode.Space);
	else
		SetGameJumpConnectionsEnabled(true);
	end
end
CreateToggleButton("🟣 Обводка 'InvisWall'", "InvisWall_ESP", function(val)
	RefreshAllInvisWallESP();
	Notify("InvisWall ESP", (val and "Все невидимые стены 'InvisWall' подсвечены!") or "Обводка InvisWall скрыта");
end);
CreateToggleButton("🧱 Проход сквозь 'InvisWall'", "InvisWall_Bypass", function(val)
	UpdateAllInvisWallCollisions();
	Notify("InvisWall Bypass", (val and "Коллизия InvisWall отключена (можно проходить)!") or "Коллизия InvisWall возвращена");
end);
CreateToggleButton("🔴 Обводка объектов 'rg'", "RG_ESP", function(val)
	RefreshAllRGESP();
	Notify("RG Red Outline", (val and "Все объекты 'rg' обведены красным!") or "Выключено");
end);
CreateToggleButton("🕯️ Кружки под ногами при беге", "CursedFootsteps", function(val)
	if not val then
		ClearFootsteps();
	end
	Notify("Кружки под ногами", (val and "Включены") or "Выключены и очищены!");
end);
CreateToggleButton("🖼️ Декали на стенах (Хэллоуин)", "WallDecalsEnabled", function(val)
	if not val then
		ClearAllWallDecals();
	end
	Notify("Декали на стенах", (val and "Твои декали (4019318593, 8386764369): ON") or "Декали отключены и удалены!");
end);
CreateToggleButton("👻 3D Призрак перед глазами", "GhostApparitions", function(val)
	if val then
		Spawn3DGhostApparition();
	end
	Notify("3D Ghost Apparition", (val and "3D Призрак на уровне игрока: ON") or "Выключен");
end);
CreateActionButton("⚡ Вызвать 3D Призрака сейчас", function()
	Spawn3DGhostApparition();
end);
CreateActionButton("🗡️ Залететь за спину врагу [H]", function()
	PhantomBackstabGlide();
end);
CreateActionButton("🔴 Полёт к ближайшему 'rg' [B]", function()
	GlideToNearestRG();
end);
CreateToggleButton("🎵 Музыка, Колокол и Смех", "SpookyMedia", function(val)
	UpdateMusicState();
	Notify("Halloween Audio", (val and "Фоновый плейлист и спецэффекты: ON") or "Звуки выключены");
end);
CreateToggleButton("🌕 Spooky Fog & 3D Blood Moon", "HalloweenAtmosphere", function(val)
	ApplyAtmosphere();
	SetupWeatherParticles(val);
	Setup3DBloodMoon(val);
	if val then
		PlaySFX(HalloweenMedia.BellStrikeId, 0.7, 1, true);
	end
	Notify("Blood Moon & Fog", (val and "3D Кровавая Луна и туман: ON") or "Обычный FullBright");
end);
CreateToggleButton("🎃 3D Тыквы на головах", "PumpkinHeads", function(val)
	UpdateAllPumpkinHeads();
	Notify("Pumpkin Heads", (val and "3D Тыквы (мягкий свет) надеты!") or "Тыквы сняты");
end);
CreateToggleButton("🔥 Летающие Тыквы-Духи", "OrbitingPumpkins", function(val)
	CreateOrbitingPumpkins();
	Notify("Orbiting Spirits", (val and "Тыквы-фамильяры со шлейфом: ON") or "Выключены");
end);
CreateToggleButton("🍬 Поиск Тыкв и Лута (ESP)", "HalloweenLootESP", function(val)
	ScanAllWorkspaceForLoot();
	Notify("Halloween Loot ESP", (val and "Подсветка конфет/тыкв/сундуков: ON") or "Выключено");
end);
CreateToggleButton("🌀 Ghost Phase Noclip [G]", "GhostPhase", function(val)
	SetGhostPhaseVisuals(val);
	Notify("Ghost Phase [G]", (val and "Режим фантома сквозь стены: ON") or "Выключен");
end);
CreateToggleButton("👁️ FreeCam [C] (Полёт туда: [T])", "FreeCam", function(val)
	SetFreeCam(val);
end);
CreateToggleButton("🦇 Infinite Jump [Z]", "InfiniteJump", function(val)
	UpdateSpaceIntercept();
	Notify("Infinite Jump", (val and "Включён (стамина не тратится)") or "Выключен");
end);
CreateToggleButton("⚡ No-Stamina Sprint [X]", "NoStaminaSprint", function(val)
	Notify("No-Stamina Sprint", (val and "Бесконечный спринт: ON") or "Выключен");
end);
CreateToggleButton("🔪 Instant Interact [E = 0s]", "InstantInteract", function(val)
	if val then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("ProximityPrompt") then
				pcall(function()
					obj.HoldDuration = 0;
				end);
			end
		end
	end
	Notify("Instant Interact", (val and "Мгновенное нажатие E: ON") or "Выключено");
end);
CreateToggleButton("🧹 Ctrl + Click (Trail Glide)", "ClickTeleport", function(val)
	if not val then
		StopGlide();
	end
	Notify("Trail Glide", (val and "Полёт с хэллоуинским Trail: ON") or "Выключен");
end);
local FriendCooldown = {};
TrackConn(UIS.InputBegan:Connect(function(input, processed)
	if (input.KeyCode == Enum.KeyCode.RightShift) then
		MainFrame.Visible = not MainFrame.Visible;
		PlayClickSFX();
		return;
	end
	if (IsGliding and ((input.KeyCode == Enum.KeyCode.Space) or (input.KeyCode == Enum.KeyCode.W) or (input.KeyCode == Enum.KeyCode.A) or (input.KeyCode == Enum.KeyCode.S) or (input.KeyCode == Enum.KeyCode.D))) then
		StopGlide();
	end
	if processed then
		return;
	end
	if ((input.KeyCode == Enum.KeyCode.T) and Settings.FreeCam) then
		local camTarget = Camera.CFrame.Position;
		PlayClickSFX();
		SetFreeCam(false);
		GlideToPosition(camTarget);
		Notify("FreeCam Glide [T]", "Персонаж летит в точку FreeCam!", 2.5);
		return;
	end
	if (input.KeyCode == Enum.KeyCode.H) then
		PlayClickSFX();
		PhantomBackstabGlide();
		return;
	end
	if (input.KeyCode == Enum.KeyCode.B) then
		PlayClickSFX();
		GlideToNearestRG();
		return;
	end
	if (input.KeyCode == Enum.KeyCode.Z) then
		Settings.InfiniteJump = not Settings.InfiniteJump;
		PlayClickSFX();
		RefreshUIButton("InfiniteJump");
		UpdateSpaceIntercept();
		Notify("Infinite Jump [Z]", (Settings.InfiniteJump and "ON (Без траты стамины)") or "OFF");
		return;
	end
	if (input.KeyCode == Enum.KeyCode.X) then
		Settings.NoStaminaSprint = not Settings.NoStaminaSprint;
		PlayClickSFX();
		RefreshUIButton("NoStaminaSprint");
		Notify("No-Stamina Sprint [X]", (Settings.NoStaminaSprint and "ON (Бесконечный бег)") or "OFF");
		return;
	end
	if (input.KeyCode == Enum.KeyCode.G) then
		Settings.GhostPhase = not Settings.GhostPhase;
		PlayClickSFX();
		RefreshUIButton("GhostPhase");
		SetGhostPhaseVisuals(Settings.GhostPhase);
		Notify("Ghost Phase [G]", (Settings.GhostPhase and "ON (Проход сквозь стены)") or "OFF");
		return;
	end
	if (input.KeyCode == Enum.KeyCode.C) then
		PlayClickSFX();
		SetFreeCam(not Settings.FreeCam);
		return;
	end
	if (input.KeyCode == Enum.KeyCode.V) then
		DefaultFOV = Camera.FieldOfView;
		TweenService:Create(Camera, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {FieldOfView=Settings.ZoomFOV}):Play();
		return;
	end
	if (input.UserInputType == Enum.UserInputType.MouseButton1) then
		local target = Mouse.Target;
		if (target and (target:IsA("Seat") or target:IsA("VehicleSeat"))) then
			StopGlide();
			local character = LocalPlayer.Character;
			local root = character and character:FindFirstChild("HumanoidRootPart");
			if root then
				PlayWhooshSFX();
				root.CFrame = target.CFrame + (target.CFrame.UpVector * 2);
			end
			return;
		end
		if (Settings.ClickTeleport and (UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl))) then
			if Mouse.Hit then
				GlideToPosition(Mouse.Hit.Position);
			end
			return;
		end
		if (Settings.AltDelete and (UIS:IsKeyDown(Enum.KeyCode.LeftAlt) or UIS:IsKeyDown(Enum.KeyCode.RightAlt))) then
			if (target and not IsSpookyFX(target)) then
				local model = target:FindFirstAncestorOfClass("Model");
				local isPlayer = model and Players:GetPlayerFromCharacter(model);
				if not isPlayer then
					pcall(function()
						target:Destroy();
						PlayClickSFX();
						Notify("Alt + Delete", "Объект удалён: " .. target.Name, 1.5);
					end);
				end
			end
			return;
		end
	end
	if (input.UserInputType == Enum.UserInputType.MouseButton3) then
		local targetPlayer = GetPlayerFromMouse();
		if (UIS:IsKeyDown(Enum.KeyCode.LeftAlt) or UIS:IsKeyDown(Enum.KeyCode.RightAlt)) then
			PlayClickSFX();
			if (targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")) then
				Camera.CameraSubject = targetPlayer.Character:FindFirstChildOfClass("Humanoid");
				Notify("Spectate", "Наблюдение за: " .. targetPlayer.Name, 2.5);
			else
				local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");
				if myHum then
					Camera.CameraSubject = myHum;
					Notify("Spectate", "Камера возвращена тебе", 2);
				end
			end
			return;
		end
		if (Settings.FriendMiddleClick and targetPlayer and not FriendCooldown[targetPlayer]) then
			FriendCooldown[targetPlayer] = true;
			PlayClickSFX();
			task.spawn(function()
				pcall(function()
					if not LocalPlayer:IsFriendsWith(targetPlayer.UserId) then
						LocalPlayer:RequestFriendship(targetPlayer);
						Notify("Friend Request", "Отправлено: " .. targetPlayer.Name, 2.5);
					else
						Notify("Friends", "Уже в друзьях: " .. targetPlayer.Name, 2);
					end
				end);
				task.wait(1);
				FriendCooldown[targetPlayer] = nil;
			end);
		end
	end
end));
TrackConn(UIS.InputEnded:Connect(function(input)
	if (input.KeyCode == Enum.KeyCode.V) then
		TweenService:Create(Camera, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {FieldOfView=(DefaultFOV or 70)}):Play();
	end
end));
task.spawn(function()
	while HubRunning and task.wait(0.5) do
		if Settings.RemoveRecoil then
			local recoil = LocalPlayer:FindFirstChild("Recoil");
			if recoil then
				pcall(function()
					recoil:Destroy();
				end);
			end
		end
	end
end);
_G.UniversalHubCleanup = function()
	HubRunning = false;
	StopGlide();
	ClearOrbitingPumpkins();
	SetupWeatherParticles(false);
	Setup3DBloodMoon(false);
	Settings.SpookyMedia = false;
	UpdateMusicState();
	Settings.InvisWall_Bypass = false;
	UpdateAllInvisWallCollisions();
	if DecalsContainer then
		DecalsContainer:Destroy();
	end
	if StepsContainer then
		StepsContainer:Destroy();
	end
	if SpookyCC then
		SpookyCC:Destroy();
	end
	if SpookyBloom then
		SpookyBloom:Destroy();
	end
	if SpookySky then
		SpookySky:Destroy();
	end
	if Settings.FreeCam then
		SetFreeCam(false);
	end
	if Settings.GhostPhase then
		SetGhostPhaseVisuals(false);
	end
	Settings.PumpkinHeads = false;
	UpdateAllPumpkinHeads();
	CAS:UnbindAction("UniversalCleanJump");
	SetGameJumpConnectionsEnabled(true);
	for _, c in ipairs(HubConnections) do
		pcall(function()
			c:Disconnect();
		end);
	end
end;
PlaySFX(HalloweenMedia.BellStrikeId, 0.75, 1, true);
Notify("Halloween Hub v11", "InvisWall ESP + Твои Декали + Фикс кружков!", 4);
local BloodMoonConfig = {Enabled=true,BatsEnabled=true,WhiteMoonTexture="rbxasset://sky/moon.jpg",BloodMoonTextures={"rbxthumb://type=Asset&id=1084722542&w=420&h=420"},BatSwarmSoundId="rbxassetid://117491181431951",BellSoundId="rbxassetid://135723101541496",ClickSoundId="rbxassetid://5852470908",RiseDuration=14,HoldDuration=45,CycleInterval=75};
if workspace:FindFirstChild("Universal3DBloodMoon") then
	workspace.Universal3DBloodMoon:Destroy();
end
if workspace:FindFirstChild("UniversalSingleMoon") then
	workspace.UniversalSingleMoon:Destroy();
end
local function HideDefaultSkyboxMoon()
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:IsA("Sky") then
			child.CelestialBodiesShown = false;
		end
	end
end
HideDefaultSkyboxMoon();
local MoonCarrier = MarkSpookyFX(Instance.new("Part"));
MoonCarrier.Name = "UniversalSingleMoon";
MoonCarrier.Size = Vector3.new(95, 95, 0.2);
MoonCarrier.Transparency = 1;
MoonCarrier.Anchored = true;
MoonCarrier.CanCollide = false;
MoonCarrier.CanTouch = false;
MoonCarrier.CanQuery = false;
MoonCarrier.CastShadow = false;
MoonCarrier.Parent = workspace;
local MoonSurface = MarkSpookyFX(Instance.new("SurfaceGui"));
MoonSurface.Name = "MoonSurface";
MoonSurface.Face = Enum.NormalId.Front;
MoonSurface.LightInfluence = 0;
MoonSurface.Brightness = 2.2;
MoonSurface.AlwaysOnTop = false;
MoonSurface.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
MoonSurface.CanvasSize = Vector2.new(512, 512);
MoonSurface.Parent = MoonCarrier;
local MoonGlow = Instance.new("ImageLabel");
MoonGlow.Name = "Glow";
MoonGlow.AnchorPoint = Vector2.new(0.5, 0.5);
MoonGlow.Position = UDim2.new(0.5, 0, 0.5, 0);
MoonGlow.Size = UDim2.new(1, 0, 1, 0);
MoonGlow.BackgroundTransparency = 1;
MoonGlow.Image = "rbxassetid://4996891970";
MoonGlow.ImageColor3 = Color3.fromRGB(220, 230, 255);
MoonGlow.ImageTransparency = 0.45;
MoonGlow.Parent = MoonSurface;
local MoonImage = Instance.new("ImageLabel");
MoonImage.Name = "MoonDecal";
MoonImage.AnchorPoint = Vector2.new(0.5, 0.5);
MoonImage.Position = UDim2.new(0.5, 0, 0.5, 0);
MoonImage.Size = UDim2.new(0.68, 0, 0.68, 0);
MoonImage.BackgroundTransparency = 1;
MoonImage.Image = BloodMoonConfig.WhiteMoonTexture;
MoonImage.ImageColor3 = Color3.fromRGB(255, 255, 255);
MoonImage.ImageTransparency = 0.05;
MoonImage.Parent = MoonSurface;
local MoonCorner = Instance.new("UICorner");
MoonCorner.CornerRadius = UDim.new(1, 0);
MoonCorner.Parent = MoonImage;
local CurrentMoonElevation = 36;
local IsBloodMoonActive = false;
local IsBloodMoonTransitioning = false;
TrackConn(RunService.RenderStepped:Connect(function()
	HideDefaultSkyboxMoon();
	local oldBall = workspace:FindFirstChild("Universal3DBloodMoon");
	if oldBall then
		oldBall:Destroy();
	end
	if (not Camera or not MoonCarrier or not MoonCarrier.Parent) then
		return;
	end
	MoonSurface.Enabled = BloodMoonConfig.Enabled;
	if not BloodMoonConfig.Enabled then
		return;
	end
	local camPos = Camera.CFrame.Position;
	local elevRad = math.rad(CurrentMoonElevation);
	local azimuthRad = math.rad(35);
	local dist = 480;
	local horizDist = math.cos(elevRad) * dist;
	local offset = Vector3.new(math.sin(azimuthRad) * horizDist, math.sin(elevRad) * dist, -math.cos(azimuthRad) * horizDist);
	local moonPos = camPos + offset;
	MoonCarrier.CFrame = CFrame.lookAt(moonPos, camPos);
end));
local IsBatSwarmFlying = false;
local function Spawn3DBatSwarm()
	if (IsBatSwarmFlying or not Camera or not BloodMoonConfig.BatsEnabled) then
		return;
	end
	IsBatSwarmFlying = true;
	PlaySFX(BloodMoonConfig.BatSwarmSoundId, 0.85, 1, true);
	task.spawn(function()
		local swarmModel = MarkSpookyFX(Instance.new("Model"));
		swarmModel.Name = "Universal3DBatSwarm";
		swarmModel.Parent = workspace;
		local bats = {};
		local batCount = 15;
		for i = 1, batCount do
			local body = MarkSpookyFX(Instance.new("Part"));
			body.Shape = Enum.PartType.Ball;
			body.Size = Vector3.new(0.45, 0.38, 0.75);
			body.Color = Color3.fromRGB(18, 12, 24);
			body.Material = Enum.Material.SmoothPlastic;
			body.Anchored = true;
			body.CanCollide = false;
			body.CanTouch = false;
			body.CanQuery = false;
			body.CastShadow = false;
			body.Parent = swarmModel;
			local eyes = MarkSpookyFX(Instance.new("Part"));
			eyes.Size = Vector3.new(0.28, 0.1, 0.12);
			eyes.Color = Color3.fromRGB(255, 70, 20);
			eyes.Material = Enum.Material.Neon;
			eyes.Anchored = true;
			eyes.CanCollide = false;
			eyes.CanTouch = false;
			eyes.CanQuery = false;
			eyes.Parent = swarmModel;
			local leftWing = MarkSpookyFX(Instance.new("WedgePart"));
			leftWing.Size = Vector3.new(0.08, 0.55, 1.35);
			leftWing.Color = Color3.fromRGB(25, 16, 35);
			leftWing.Material = Enum.Material.SmoothPlastic;
			leftWing.Anchored = true;
			leftWing.CanCollide = false;
			leftWing.CanTouch = false;
			leftWing.CanQuery = false;
			leftWing.CastShadow = false;
			leftWing.Parent = swarmModel;
			local rightWing = leftWing:Clone();
			rightWing.Parent = swarmModel;
			table.insert(bats, {Body=body,Eyes=eyes,LeftWing=leftWing,RightWing=rightWing,Offset=Vector3.new(math.random(-140, 140) / 10, math.random(-40, 80) / 10, math.random(-90, 90) / 10),FlapSpeed=math.random(24, 32),Phase=(math.random() * math.pi * 2)});
		end
		local char = LocalPlayer.Character;
		local root = char and char:FindFirstChild("HumanoidRootPart");
		local basePos = (root and root.Position) or Camera.CFrame.Position;
		local lookVec = Camera.CFrame.LookVector;
		local flatForward = Vector3.new(lookVec.X, 0, lookVec.Z);
		if (flatForward.Magnitude < 0.05) then
			flatForward = Vector3.new(0, 0, -1);
		else
			flatForward = flatForward.Unit;
		end
		local startCenter = basePos + (flatForward * 48) + Vector3.new(0, 18, 0);
		local endCenter = (basePos - (flatForward * 35)) + Vector3.new(0, 8, 0);
		local duration = 3.2;
		local elapsed = 0;
		while (elapsed < duration) and HubRunning do
			local dt = RunService.RenderStepped:Wait();
			elapsed += dt
			local alpha = math.clamp(elapsed / duration, 0, 1);
			local swarmCenter = startCenter:Lerp(endCenter, alpha);
			for _, b in ipairs(bats) do
				local waveY = math.sin((elapsed * 6) + b.Phase) * 1.2;
				local waveX = math.cos((elapsed * 4) + b.Phase) * 1.5;
				local pos = swarmCenter + b.Offset + Vector3.new(waveX, waveY, 0);
				local batCF = CFrame.lookAt(pos, endCenter + b.Offset);
				b.Body.CFrame = batCF;
				b.Eyes.CFrame = batCF * CFrame.new(0, 0.08, -0.35);
				local flapAngle = math.sin((elapsed * b.FlapSpeed) + b.Phase) * math.rad(55);
				b.LeftWing.CFrame = batCF * CFrame.new(-0.65, 0, 0) * CFrame.Angles(0, math.rad(90), flapAngle);
				b.RightWing.CFrame = batCF * CFrame.new(0.65, 0, 0) * CFrame.Angles(0, math.rad(-90), -flapAngle);
			end
		end
		for i = 1, 8 do
			for _, b in ipairs(bats) do
				b.Body.Transparency = i / 8;
				b.Eyes.Transparency = i / 8;
				b.LeftWing.Transparency = i / 8;
				b.RightWing.Transparency = i / 8;
			end
			RunService.RenderStepped:Wait();
		end
		swarmModel:Destroy();
		IsBatSwarmFlying = false;
	end);
end
local function TriggerBloodMoonRise()
	if (IsBloodMoonTransitioning or not BloodMoonConfig.Enabled) then
		return;
	end
	IsBloodMoonTransitioning = true;
	IsBloodMoonActive = true;
	task.spawn(function()
		for i = 1, 15 do
			local t = i / 15;
			MoonImage.ImageTransparency = t;
			MoonGlow.ImageTransparency = 0.45 + (t * 0.55);
			task.wait(0.03);
		end
		local chosenBloodTex = BloodMoonConfig.BloodMoonTextures[math.random(1, #BloodMoonConfig.BloodMoonTextures)];
		MoonImage.Image = chosenBloodTex;
		MoonImage.ImageColor3 = Color3.fromRGB(255, 220, 220);
		MoonImage.Size = UDim2.new(0.82, 0, 0.82, 0);
		MoonGlow.ImageColor3 = Color3.fromRGB(255, 35, 15);
		CurrentMoonElevation = 2;
		PlaySFX(BloodMoonConfig.BellSoundId, 0.75, 0.92, true);
		Notify("Кровавая Луна 🩸", "Восходит Кровавая Луна и вылетают мыши!", 3.5);
		task.delay(1.2, Spawn3DBatSwarm);
		pcall(function()
			TweenService:Create(Lighting, TweenInfo.new(4), {FogColor=Color3.fromRGB(165, 25, 15),OutdoorAmbient=Color3.fromRGB(175, 55, 45)}):Play();
		end);
		local riseSteps = 120;
		local stepWait = BloodMoonConfig.RiseDuration / riseSteps;
		for i = 1, riseSteps do
			if not HubRunning then
				break;
			end
			local alpha = i / riseSteps;
			local eased = 1 - math.pow(1 - alpha, 2);
			CurrentMoonElevation = 2 + (36 * eased);
			MoonImage.ImageTransparency = math.clamp(1 - (alpha * 2.5), 0.02, 1);
			MoonGlow.ImageTransparency = math.clamp(1 - (alpha * 1.5), 0.25, 1);
			task.wait(stepWait);
		end
		task.wait(BloodMoonConfig.HoldDuration);
		for i = 1, 20 do
			local t = i / 20;
			MoonImage.ImageTransparency = t;
			MoonGlow.ImageTransparency = 0.25 + (t * 0.75);
			task.wait(0.04);
		end
		MoonImage.Image = BloodMoonConfig.WhiteMoonTexture;
		MoonImage.ImageColor3 = Color3.fromRGB(255, 255, 255);
		MoonImage.Size = UDim2.new(0.68, 0, 0.68, 0);
		MoonGlow.ImageColor3 = Color3.fromRGB(220, 230, 255);
		CurrentMoonElevation = 36;
		pcall(function()
			TweenService:Create(Lighting, TweenInfo.new(3), {FogColor=Color3.fromRGB(215, 78, 15),OutdoorAmbient=Color3.fromRGB(190, 105, 55)}):Play();
		end);
		for i = 1, 20 do
			local t = 1 - (i / 20);
			MoonImage.ImageTransparency = math.clamp(t, 0.05, 1);
			MoonGlow.ImageTransparency = math.clamp(0.45 + (t * 0.55), 0.45, 1);
			task.wait(0.04);
		end
		IsBloodMoonActive = false;
		IsBloodMoonTransitioning = false;
	end);
end
CreateActionButton("🩸 Вызвать Восход Кровавой Луны", function()
	TriggerBloodMoonRise();
end);
CreateActionButton("🦇 Вызвать 3D Стаю Мышей", function()
	Spawn3DBatSwarm();
end);
CreateToggleButton("🦇 Стая Летучих Мышей (Авто)", "BatsEnabled", function(val)
	BloodMoonConfig.BatsEnabled = val;
	Notify("Летучие Мыши", (val and "Авто-пролёт стаи мышей: ON") or "Выключены");
end);
task.delay(6, function()
	if HubRunning then
		TriggerBloodMoonRise();
	end
end);
task.spawn(function()
	local nextMoonTime = os.clock() + BloodMoonConfig.CycleInterval;
	local nextBatTime = os.clock() + math.random(35, 55);
	while HubRunning and task.wait(3) do
		if (BloodMoonConfig.Enabled and not IsBloodMoonActive and (os.clock() > nextMoonTime)) then
			TriggerBloodMoonRise();
			nextMoonTime = os.clock() + BloodMoonConfig.CycleInterval + math.random(15, 35);
		end
		if (BloodMoonConfig.BatsEnabled and not IsBatSwarmFlying and (os.clock() > nextBatTime)) then
			Spawn3DBatSwarm();
			nextBatTime = os.clock() + math.random(40, 70);
		end
	end
end);
if _G.UniversalArmPoseCleanup then
	pcall(_G.UniversalArmPoseCleanup);
end
local ArmPoseConfig = {Key=Enum.KeyCode.B,RightRaiseAngle=110,RightInwardYaw=16,RightPalmRoll=90,SmoothSpeed=14};
local IsHoldingPoseKey = false;
local CurrentPoseAlpha = 0;
local SavedRightC0 = nil;
local SavedLeftC0 = nil;
local LastRightMotor = nil;
local LastLeftMotor = nil;
local PoseConnections = {};
local function GetArmMotors(character)
	if not character then
		return nil, nil, false;
	end
	local torso = character:FindFirstChild("Torso");
	if torso then
		local r6Right = torso:FindFirstChild("Right Shoulder");
		local r6Left = torso:FindFirstChild("Left Shoulder");
		if (r6Right and r6Left) then
			return r6Right, r6Left, true;
		end
	end
	local rUpper = character:FindFirstChild("RightUpperArm");
	local lUpper = character:FindFirstChild("LeftUpperArm");
	if (rUpper and lUpper) then
		local r15Right = rUpper:FindFirstChild("RightShoulder");
		local r15Left = lUpper:FindFirstChild("LeftShoulder");
		if (r15Right and r15Left) then
			return r15Right, r15Left, false;
		end
	end
	return nil, nil, false;
end
CAS:UnbindAction("UniversalRaiseRightArmB");
CAS:BindActionAtPriority("UniversalRaiseRightArmB", function(_, inputState)
	if (inputState == Enum.UserInputState.Begin) then
		IsHoldingPoseKey = true;
	elseif ((inputState == Enum.UserInputState.End) or (inputState == Enum.UserInputState.Cancel)) then
		IsHoldingPoseKey = false;
	end
	return Enum.ContextActionResult.Sink;
end, false, Enum.ContextActionPriority.High.Value + 600, ArmPoseConfig.Key);
table.insert(PoseConnections, UIS.InputEnded:Connect(function(input)
	if (input.KeyCode == ArmPoseConfig.Key) then
		IsHoldingPoseKey = false;
	end
end));
table.insert(PoseConnections, RunService.Stepped:Connect(function(_, dt)
	local character = LocalPlayer.Character;
	if not character then
		return;
	end
	local rightMotor, leftMotor, isR6 = GetArmMotors(character);
	if (not rightMotor or not leftMotor) then
		return;
	end
	if (rightMotor ~= LastRightMotor) then
		LastRightMotor = rightMotor;
		SavedRightC0 = rightMotor.C0;
	end
	if (leftMotor ~= LastLeftMotor) then
		LastLeftMotor = leftMotor;
		SavedLeftC0 = leftMotor.C0;
	end
	local targetAlpha = (IsHoldingPoseKey and 1) or 0;
	if ((math.abs(CurrentPoseAlpha - targetAlpha) < 0.004) and (targetAlpha == 0)) then
		return;
	end
	CurrentPoseAlpha = CurrentPoseAlpha + ((targetAlpha - CurrentPoseAlpha) * math.clamp(dt * ArmPoseConfig.SmoothSpeed, 0, 1));
	local a = CurrentPoseAlpha;
	if isR6 then
		local rightOffset = CFrame.new(0.18 * a, 0.04 * a, -0.14 * a);
		local rightRotation = CFrame.Angles(0, math.rad(ArmPoseConfig.RightInwardYaw * a), 0) * CFrame.Angles(0, 0, math.rad(ArmPoseConfig.RightRaiseAngle * a)) * CFrame.Angles(0, math.rad(ArmPoseConfig.RightPalmRoll * a), 0);
		rightMotor.C0 = SavedRightC0 * rightOffset * rightRotation;
		local leftOffset = CFrame.new(0.38 * a, -0.12 * a, -0.32 * a);
		local leftRotation = CFrame.Angles(math.rad(52 * a), math.rad(85 * a), math.rad(-22 * a));
		leftMotor.C0 = SavedLeftC0 * leftOffset * leftRotation;
	else
		local rightOffset = CFrame.new(-0.14 * a, 0.04 * a, -0.18 * a);
		local rightRotation = CFrame.Angles(0, 0, math.rad(ArmPoseConfig.RightInwardYaw * a)) * CFrame.Angles(math.rad(ArmPoseConfig.RightRaiseAngle * a), 0, 0) * CFrame.Angles(0, math.rad(ArmPoseConfig.RightPalmRoll * a), 0);
		rightMotor.C0 = SavedRightC0 * rightOffset * rightRotation;
		local leftOffset = CFrame.new(0.3 * a, -0.1 * a, 0.35 * a);
		local leftRotation = CFrame.Angles(math.rad(-28 * a), math.rad(-45 * a), math.rad(48 * a));
		leftMotor.C0 = SavedLeftC0 * leftOffset * leftRotation;
	end
	if (a > 0.02) then
		rightMotor.Transform = CFrame.identity;
		leftMotor.Transform = CFrame.identity;
	end
end));
_G.UniversalArmPoseCleanup = function()
	CAS:UnbindAction("UniversalRaiseRightArmB");
	for _, c in ipairs(PoseConnections) do
		pcall(function()
			c:Disconnect();
		end);
	end
	if (LastRightMotor and SavedRightC0) then
		LastRightMotor.C0 = SavedRightC0;
	end
	if (LastLeftMotor and SavedLeftC0) then
		LastLeftMotor.C0 = SavedLeftC0;
	end
end;