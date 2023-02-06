/************************************************************************
 * @description Used to create the default configuration for the settings.ini file
 * @file CreateSettings.ahk
 * @author Andrei Ivanciu
 * @date 2022/11/17
 * @version 0.0.1
 ***********************************************************************/

class SettingsClass extends Object {

    file_location := "data/settings.ini"
    recipient := ""
    account := ""
    email := ""
    glassCheck := "GC Track Id Location"
    expertise := "Track Id Location"
    fleet := "Fleet Track Id Location"
    default_theme := this.get_default_theme()


    /*
    Grabs default theme color code from .ini file
    @return > String with color code
    */
    get_default_theme() {
        global def_theme := IniRead(this.file_location, "Default Settings", "theme", "")
        Return def_theme
    }

    /*
    Get current coodinates of the track id from settings.ini
    @param string section
    @param string key
    @return array of coordinates or single coordinate if provided with key name
    */
    get_coords(section, key := "") {

        if (StrLen(key) > 0) {
            result := IniRead(this.file_location, section, key)
        } else {
            result := Array()
            source := StrSplit(IniRead(this.file_location, section), "`n")

            i := 1
            while i <= source.Length {
                tempArray := StrSplit(source[i], "=")
                result.Push(tempArray[2])
                i += 1
            }
        }
        return result
    }

    ; get_values(key) {
    ;     if (key == "x1")
    ;         return this.x1
    ;     else if (key == "x2")
    ;         return this.x2
    ;     else if (key == "y1")
    ;         return this.y1
    ;     else if (key == "y2")
    ;         return this.y2
    ; }

    set_values(key, value) {
        if (key) {
        }
    }


    /*
    Creates the default configuration for the settings.ini file
    */
    create_settings_ini() {
        ; Sections
        IniWrite("", "data/settings.ini", "Themes")
        IniWrite("", "data/settings.ini", "Default Settings")
        IniWrite("", "data/settings.ini", "Track Id Location")
        IniWrite("", "data/settings.ini", "Fleet Track Id Location")
        IniWrite("", "data/settings.ini", "GC Track Id Location")
        IniWrite("", "data/settings.ini", "Account")
        IniWrite("", "data/settings.ini", "Signature")
        IniWrite("", "data/settings.ini", "Chat")
        IniWrite("", "data/settings.ini", "States")

        ; Themes
        IniWrite("333333", "data/settings.ini", "Themes", "Dark")
        IniWrite("ffffff", "data/settings.ini", "Themes", "Light")

        ; Default Settings
        IniWrite("333333", "data/settings.ini", "Default Settings", "theme")
        IniWrite("ffffff", "data/settings.ini", "Default Settings", "txt_color")

        ; Track Id Location
        IniWrite("409", "data/settings.ini", "Track Id Location", "x1")
        IniWrite("132", "data/settings.ini", "Track Id Location", "y1")
        IniWrite("468", "data/settings.ini", "Track Id Location", "x2")
        IniWrite("153", "data/settings.ini", "Track Id Location", "y2")

        ; Fleet Track Id Location
        IniWrite("399", "data/settings.ini", "Fleet Track Id Location", "x1")
        IniWrite("132", "data/settings.ini", "Fleet Track Id Location", "y1")
        IniWrite("458", "data/settings.ini", "Fleet Track Id Location", "x2")
        IniWrite("153", "data/settings.ini", "Fleet Track Id Location", "y2")

        ; GC Track Id Location
        IniWrite("409", "data/settings.ini", "GC Track Id Location", "x1")
        IniWrite("132", "data/settings.ini", "GC Track Id Location", "y1")
        IniWrite("468", "data/settings.ini", "GC Track Id Location", "x2")
        IniWrite("153", "data/settings.ini", "GC Track Id Location", "y2")

        ; Account
        IniWrite("not set", "data/settings.ini", "Account", "acc")

        ; Signature
        IniWrite("not set", "data/settings.ini", "Signature", "acc")

        ; Chat
        IniWrite("not set", "data/settings.ini", "Chat", "acc")

        ; States
        IniWrite("0", "data/settings.ini", "States", "mbutton")
        IniWrite("0", "data/settings.ini", "States", "x1button")
        IniWrite("0", "data/settings.ini", "States", "x2button")
        IniWrite("0", "data/settings.ini", "States", "pause")
        IniWrite("0", "data/settings.ini", "States", "scrllock")
        IniWrite("0", "data/settings.ini", "States", "pausebreak")
        IniWrite("0", "data/settings.ini", "States", "fseven")
    }
}