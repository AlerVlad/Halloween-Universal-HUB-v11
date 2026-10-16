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
local CoreGui = game:GetService("CoreGui");
local TweenService = game:GetService("TweenService");
local SCRIPT_URL = "https://raw.githubusercontent.com/AlerVlad/Halloween-Universal-HUB-v11/refs/heads/main/obf_9tTpQ697zvlG07YK5eW05t2p4t86hOP77KPrV1655699nJvz1F9RWVwYrapxSZWV.lua";
if CoreGui:FindFirstChild("HalloweenLoaderGUI") then
	CoreGui.HalloweenLoaderGUI:Destroy();
end
local LoaderGui = Instance.new("ScreenGui");
LoaderGui.Name = "HalloweenLoaderGUI";
LoaderGui.ResetOnSpawn = false;
LoaderGui.Parent = CoreGui;
local MainBox = Instance.new("Frame");
MainBox.Size = UDim2.new(0, 340, 0, 110);
MainBox.Position = UDim2.new(0.5, -170, 0.5, -55);
MainBox.BackgroundColor3 = Color3.fromRGB(15, 11, 22);
MainBox.BorderSizePixel = 0;
MainBox.Parent = LoaderGui;
local Corner = Instance.new("UICorner");
Corner.CornerRadius = UDim.new(0, 12);
Corner.Parent = MainBox;
local Stroke = Instance.new("UIStroke");
Stroke.Color = Color3.fromRGB(255, 120, 20);
Stroke.Thickness = 2;
Stroke.Parent = MainBox;
local Title = Instance.new("TextLabel");
Title.Size = UDim2.new(1, 0, 0, 35);
Title.Position = UDim2.new(0, 0, 0, 12);
Title.BackgroundTransparency = 1;
Title.Font = Enum.Font.GothamBold;
Title.TextSize = 16;
Title.TextColor3 = Color3.fromRGB(255, 140, 30);
Title.Text = "🎃 Загрузка Halloween Hub...";
Title.Parent = MainBox;
local Status = Instance.new("TextLabel");
Status.Size = UDim2.new(1, 0, 0, 25);
Status.Position = UDim2.new(0, 0, 0, 42);
Status.BackgroundTransparency = 1;
Status.Font = Enum.Font.Gotham;
Status.TextSize = 13;
Status.TextColor3 = Color3.fromRGB(200, 190, 220);
Status.Text = "Подключение к защищенному серверу...";
Status.Parent = MainBox;
local BarBg = Instance.new("Frame");
BarBg.Size = UDim2.new(1, -40, 0, 10);
BarBg.Position = UDim2.new(0, 20, 0, 80);
BarBg.BackgroundColor3 = Color3.fromRGB(28, 20, 40);
BarBg.BorderSizePixel = 0;
BarBg.Parent = MainBox;
local BarBgCorner = Instance.new("UICorner");
BarBgCorner.CornerRadius = UDim.new(1, 0);
BarBgCorner.Parent = BarBg;
local BarFill = Instance.new("Frame");
BarFill.Size = UDim2.new(0, 0, 1, 0);
BarFill.BackgroundColor3 = Color3.fromRGB(255, 120, 20);
BarFill.BorderSizePixel = 0;
BarFill.Parent = BarBg;
local BarFillCorner = Instance.new("UICorner");
BarFillCorner.CornerRadius = UDim.new(1, 0);
BarFillCorner.Parent = BarFill;
task.spawn(function()
	Status.Text = "Проверка целостности...";
	TweenService:Create(BarFill, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size=UDim2.new(0.3, 0, 1, 0)}):Play();
	task.wait(0.7);
	Status.Text = "Загрузка скрипта...";
	TweenService:Create(BarFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {Size=UDim2.new(0.7, 0, 1, 0)}):Play();
	local success, result = pcall(function()
		return game:HttpGet(SCRIPT_URL);
	end);
	task.wait(0.5);
	if (not success or not result or (result == "")) then
		Status.Text = "Ошибка загрузки!";
		Stroke.Color = Color3.fromRGB(255, 40, 40);
		BarFill.BackgroundColor3 = Color3.fromRGB(255, 40, 40);
		task.wait(2);
		LoaderGui:Destroy();
		return;
	end
	Status.Text = "Готово! Запуск хаба...";
	TweenService:Create(BarFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size=UDim2.new(1, 0, 1, 0)}):Play();
	task.wait(0.5);
	local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad);
	TweenService:Create(MainBox, fadeInfo, {BackgroundTransparency=1}):Play();
	TweenService:Create(Stroke, fadeInfo, {Transparency=1}):Play();
	TweenService:Create(Title, fadeInfo, {TextTransparency=1}):Play();
	TweenService:Create(Status, fadeInfo, {TextTransparency=1}):Play();
	TweenService:Create(BarBg, fadeInfo, {BackgroundTransparency=1}):Play();
	TweenService:Create(BarFill, fadeInfo, {BackgroundTransparency=1}):Play();
	task.wait(0.5);
	LoaderGui:Destroy();
	local runSuccess, runErr = pcall(function()
		loadstring(result)();
	end);
	if (not runErr and runSuccess) then
		print("Halloween Hub успешно запущен!");
	else
		warn("Ошибка выполнения: " .. tostring(runErr));
	end
end);