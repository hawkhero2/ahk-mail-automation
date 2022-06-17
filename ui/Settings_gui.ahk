/*
* Work in progress
Settings_UI 
TODO : Setup the Keybinds for certain actions e.g. -> track_id or stop-start
TODO : Setup the zone for the track_id functionality
TODO : Create and import values from an external file ?
TODO : Use InputHook to get the keybinds
*/
; #Include, lib\third-party\JSON.ahk
; #Include, lib\third-party\Jxon.ahk
#Include, lib\Functions.ahk

Gui, Settings:Add, DDL, vtheme_key, Dark|Light
Gui, Settings:Add, Button,x200 y150 w60 h25 gButtonSave,Save
Gui, Settings:Add, Button,x200 y195 w60 h25 gButtonCancel,Cancel
Return

def_theme = get_default_theme()
Gui, Settings:Color,%def_theme%

Return

/*
todo	Save previous track_id to file and show it if needed
todo	Set app to run at startup
todo	Set manually grab_track_id() coordinates -> use MouseGetPos and KeyWait
*/

ButtonSave:
	Gui, Submit, NoHide
	theme_name = %theme_key%
	IniRead, temp_color_code, settings.ini, Themes,% theme_name
    IniWrite, %temp_color_code%, settings.ini, Default Settings, theme
    def_theme := get_default_theme() 
	Gui, Main:Show
	Gui, Main:Color,%color_code%,e9edf0
	Gui, Settings:Hide
Return

ButtonCancel:
	Gui, Main:Show
Return