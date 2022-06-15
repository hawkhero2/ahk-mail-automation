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

Gui, Settings:Add, DDL, vthemeVal, Dark|Light
Gui, Settings:Add, Button,x200 y150 w60 h25 gButtonSave,Save

; Get default theme value from settings.ini
; get_theme(){ ; ! Not tested yet
    
;     IniRead, tempVar, settings.ini, Default Settings, theme
;     global default_theme_code := tempVar
;     Return default_theme_code ; TODO Test output for "default_theme_code"
; }

; Set default theme value in settings.ini
; set_theme(){
;     global theme_code
;     global default_theme_code
;     default_theme_code := tempVar

;     ; Reads settings.ini and sets the theme based on the ddl var
;     ; ! Not working yet
;     IniRead, tempVar,settings.ini , Themes,%themeVal%
;     theme_code := tempVar
    
; 	IniWrite, %theme_code%, settings.ini, Default Settings, theme
; }

ButtonSave:
Gui, Submit, NoHide
    set_theme()
    ; color_code := get_default_theme()
	Gui, Main:Show
	Gui, Main:Color,%color_code%,e9edf0
	Gui, Settings:Hide
Return
