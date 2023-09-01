-- zhTW
local _, DarkMode = ...

function DarkMode:Lang_zhTW()
	local tab = {
		["MMBTNLEFT"] = "左鍵點擊 => 選項設定",
		["MMBTNRIGHT"] = "右鍵點擊 => 隱藏小地圖按鈕",
		["GENERAL"] = "一般",
		["SHOWMINIMAPBUTTON"] = "顯示小地圖按鈕",
		["COLORMODE"] = "介面著色",
		["COLORMODEUF"] = "單位框架著色",
		["COLORMODETT"] = "滑鼠提示著色",
		["COLORMODEF"] = "視窗著色",
		["CUSTOMUIC"] = "指定介面顏色",
		["CUSTOMUFC"] = "指定單位框架顏色",
		["CUSTOMTTC"] = "指定滑鼠提示顏色",
		["CUSTOMFRC"] = "指定視窗顏色",
		["MASKACTIONBUTTONS"] = "替快捷鍵按鈕著色",
		["GRYPHONS"] = "替快捷列獅鷲著色",
	}

	DarkMode:UpdateLanguageTab(tab)
end