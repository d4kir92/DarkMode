-- zhCN
local _, DarkMode = ...
function DarkMode:Lang_zhCN()
	local tab = {
		["MMBTNLEFT"] = "左键点击 => 菜单选项",
		["MMBTNRIGHT"] = "右键点击 => 隐藏小地图按钮",
		["GENERAL"] = "常规",
		["SHOWMINIMAPBUTTON"] = "显示小地图按钮",
		["COLORMODE"] = "界面染色",
		["COLORMODEUF"] = "头像染色",
		["COLORMODETT"] = "鼠标提示染色",
		["COLORMODEF"] = "窗口染色",
		["CUSTOMUIC"] = "指定界面颜色",
		["CUSTOMUFC"] = "指定头像颜色",
		["CUSTOMTTC"] = "指定鼠标提示颜色",
		["CUSTOMFRC"] = "指定窗口颜色",
		["GRYPHONS"] = "动作条狮鹫染色",
	}

	DarkMode:UpdateLanguageTab(tab)
end