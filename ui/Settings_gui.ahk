/*
* Work in progress
Settings_UI 
TODO : Setup the Keybinds for certain actions e.g. -> track_id or stop-start
TODO : Setup the zone for the track_id functionality
TODO : Create and import values from an external file ?
TODO : Use InputHook to get the keybinds
*/
#Include, lib\third-party\JSON.ahk
#Include, lib\third-party\Jxon.ahk

Gui, Settings:Add, DDL, vthemeVal, Dark|Light
Gui, Settings:Add, Button,x200 y150 w60 h25 gButtonSave,Save

selected_theme(theme_var):
Gui, Submit
; TODO Use .ini file instead of json
; TODO parse the JSON file and get the theme value based on themeVal
parsed_json := Jxon_Load() ; ? not tested yet
global theme_code
If (theme_var == "dark"){
    theme_code 
}
Return theme_code