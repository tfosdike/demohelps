; Dropcloth
; Author:         Adam Pash <adam@lifehacker.com>
; A simple implementation of Backdrop (http://www.johnhaney.com/backdrop/) for Windows
; for Windows:
; Script Function:
;	Designed to provide a quick, blank desktop 
;	useful for taking screenshots or creating screencasts
;	

#SingleInstance,Force 
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, "%A_ScriptDir%"
Gosub,READINI
Gosub,TRAYMENU
;Goto,START

SysGet,monitorcount,MonitorCount
l=0
t=0
r=0
b=0
Loop,%monitorcount%
{
SysGet,monitor,MonitorWorkArea,%A_Index%
If (monitorLeft<l)
l:=monitorLeft
If (monitorTop<t)
t:=monitorTop
If (monitorRight>r)
r:=monitorRight
If (monitorBottom>b)
b:=monitorBottom
}
resolutionRight:=r+Abs(l)
resolutionBottom:=b+Abs(t)
Goto,ShowWindow

ShowWindow:
active_window := WinExist("A")
Gui,1: Destroy
Gui,1: +LastFound -Caption +ToolWindow
Gui,1: Color,%BGColor%
Gui,1: Show,w%resolutionRight% h%resolutionBottom% x%width%,Dropcloth
WinGet,windowID,ID
Gosub,SetTransparency
visible = 1
if focus = 1
	WinActivate,ahk_id %active_window%
return

SetTransparency:
Gui,1: +ToolWindow
WinSet, Transparent, %transparency%, ahk_id %windowID%
if ShowTaskBar
	Gui,1: -ToolWindow
return

ToggleWindow:
if visible = 1
{
	Gui,1:Destroy
	visible = 0
}
else
	Goto,ShowWindow
return

READINI:
IfNotExist,Dropcloth.ini 
	FileAppend,[Settings]`nColor=000000`nShowTaskbar=1`nTransparency=OFF`nHotkey=`n,Dropcloth.ini
IniRead,BGColor,Dropcloth.ini,Settings,Color
IniRead,ShowTaskbar,Dropcloth.ini,Settings,ShowTaskbar ; 0=False, 1=True
IniRead,Transparency,Dropcloth.ini,Settings,Transparency
ToggleHotkey := GetValFromIni("Settings","Hotkey","")
Focus := GetValFromIni("Settings","Focus",1)
if ToggleHotkey <>
{
	Hotkey,%ToggleHotkey%,ToggleWindow
}
return

GetValFromIni(section, key, default)
{
	IniRead,IniVal,Dropcloth.ini,%section%,%key%
	if IniVal = ERROR
	{
		IniWrite,%default%,Dropcloth.ini,%section%,%key%
		IniVal := default
	}
	return IniVal
}

TRAYMENU:
Menu,TRAY,NoStandard 
Menu,TRAY,DeleteAll 
Menu,Tray,Add,Dropcloth,PREFERENCES
Menu,TRAY,Add,&Preferences...,PREFERENCES
Menu,TRAY,Add,&Help,HELP
Menu,TRAY,Add,&About...,ABOUT
Menu,TRAY,Add,E&xit,EXIT
Menu,TRAY,Default,Dropcloth
Menu,Tray,Tip,Dropcloth
Return

PREFERENCES:
Gui,2: Destroy
Gui,2: Add,Text,x10 y10, Enter the HEX value of the background color you'd like:
Gui,2: Add,Edit,xp+10 yp+20 w80 vColor,%BGColor%
Gui,2: Add,Text,xp-10 yp+30,Don't know your HEX values?  
Gui,2: Font,underline bold
Gui,2: Add,Text,xp+20 yp+20 cBlue gColorPicker,This web site can help you pick a color.
Gui,2: Font
Gui,2: Add,Checkbox,xp-20 yp+30 vTaskbar Checked%ShowTaskbar%,Show in taskbar
Gui,2: Add,Checkbox, yp+20 vFocus Checked%Focus% gToggle,Focus mode (keeps the active application above the Dropcloth)
if transparency = OFF
	tslide = 255
else
	tslide = %transparency%
Gui,2: Add,Text,yp+30, Transparency (0: invisible`; 255: opaque`; currently: %tslide%):
Gui,2: Add,Text,yp+13 xp+15 cGrey, (performance is best when opaque)
Gui,2: Add, Slider, xp-10 yp+20 w380 vTransparencySlider Range0-255 ToolTipLeft TickInterval25, %tslide%
Gui,2: Add,Text,xp+20 yp+50,Toggle Dropcloth hotkey:
Gui,2: Add,Hotkey,xp+130 yp w100 vHotkeyBox, %ToggleHotkey%
Gui,2: Add,Button,xp+120 yp+40 w75 GSETTINGSOK Default,&OK
Gui,2: Add,Button,xp+80 w75 GSETTINGSCANCEL,&Cancel
Gui,2: Show,Autosize,Dropcloth Settings
return

SETTINGSOK:
Gui,2: Submit
Gui,2: Destroy
if TransparencySlider != %transparency%
{
	if TransparencySlider = 255
		transparency = OFF
	else
		transparency = %TransparencySlider%
	IniWrite,%transparency%,Dropcloth.ini,Settings,Transparency
	Gosub,SetTransparency
}
if HotkeyBox != %ToggleHotkey%
{
	ToggleHotkey = %HotkeyBox%
	if ToggleHotkey <>
	{
		Hotkey,%ToggleHotkey%,ToggleWindow,UseErrorLevel
		if ErrorLevel in 5
			MsgBox, nonexistent
	}
	IniWrite,%ToggleHotkey%,Dropcloth.ini,Settings,Hotkey
	HotKey,%ToggleHotkey%,On
}
if Color != %BGColor%
{
	BGColor=%Color%
	Gui,1: Color,%BGColor%
	IniWrite,%BGColor%,Dropcloth.ini,Settings,Color
}
if Taskbar != %ShowTaskbar%
{	
	ShowTaskbar=%Taskbar%
	IniWrite,%ShowTaskbar%,Dropcloth.ini,Settings,ShowTaskbar
	if ShowTaskBar
		Gui,1: -ToolWindow
	else
		Goto,ShowWindow
}
return

TOGGLE:
IniWrite,%A_GuiControl%,Dropcloth.ini,Settings,Focus
IniRead,Focus,Dropcloth.ini,Settings,Focus
return

SETTINGSCANCEL:
Gui,2: Destroy
return

ColorPicker:
Run,http://www.colorjack.com/sphere/
return

HELP:
Run,http://lifehacker.com/software//lifehacker-code-hidden-windows-245774.php
return

ABOUT:
Gui,4: Destroy
Gui,4: font, s36, Arial
Gui,4: Add, Text,x70 y5,Dropcloth 0.3
Gui,4: font, s9, Arial 
Gui,4: Add,Text,x10 y70 Center,Dropcloth is a one-trick app that provides `na quick, blank background for your computer.`nIt's handy for blocking out desktop distractions`n or taking screenshots/screencasts without showing`n the world your personal desktop.`nDropcloth is basically a rip-off of the Mac app Backdrop`nfor the Windows crowd.`n`nDropcloth is written by Adam Pash and distributed`nby Lifehacker under the GNU Public License.`nFor details on how to use Dropcloth, check out the
Gui,4:Font,underline bold
Gui,4:Add,Text,cBlue gDropclothHomepage Center x110 y240,Dropcloth homepage
Gui,4: Show,Autosize,About Dropcloth
return

DropclothHomepage:
Run,http://lifehacker.com/software//lifehacker-code-hidden-windows-245774.php
return

Exit:
ExitApp