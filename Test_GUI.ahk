#NoEnv
#Persistent
; #Include, ui\Settings_gui.ahk

Gui, Main:Add, Button,w100 gtempVar, Test Button
Gui, Main:Add, DropDownList, vtemp_ddl, Dark|Light

Gui, Main:Show, w200 h200

def_theme := get_default_theme() 
Gui, Main:Color,%def_theme%
Return


tempVar:
    Gui, Submit, NoHide
    theme_name = %temp_ddl% 
    IniRead, temp_color_code, settings.ini, Themes,% theme_name
    IniWrite, %temp_color_code%, settings.ini, Default Settings, theme
    def_theme := get_default_theme() 
    Gui, Main:Color,%def_theme%
Return

GuiClose:
ExitApp

;   returns default theme color code from settings.ini
get_default_theme(){    
    IniRead, tempVar, settings.ini, Default Settings, theme
    Return %tempVar%
}
get_theme(theme){
    theme := theme
    IniRead, color_code, settings.ini, Themes,%theme%
    Return %color_code%
}

set_theme(theme_name){

}