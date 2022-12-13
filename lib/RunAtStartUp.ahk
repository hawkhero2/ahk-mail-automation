/************************************************************************
 * @description Run at startup checks for settings files and creates the settings files if necessary
 * @file RunAtStartUp.ahk
 * @author Andrei Ivanciu
 * @date 2022/11/13
 * @version 0.0.1
 ***********************************************************************/

#Include CreateSettings.ahk
#Include CreateIdHistory.ahk

/*
Run at startup checks for settings files and creates the settings files if necessary
@params void
@return void
*/
run_at_startup() {
    /*
    Checks for the data folder,
    if it returns an empty string then
    create folder and files
    */
    if (DirExist("data") = "") {

        ; creates data folder
        DirCreate("data")

        files := ["data/settings.ini", "data/id_history.txt"]
        x := 1
        while (x >= files.length) {
            if (FileExist(files[x]) = 0) {
                FileAppend("", files[x])
            }
        }
    }
    ; if data folder exists then checks for the difference timestamp and when the settings files were created
    if (FileExist("data") = 1) {
        timestamp := FormatTime(A_Now, "")
        ; If the difference between timestamp and when the file was created is equal to zero, the file was created recently and needs to be structured
        if (DateDiff(A_Now, FileGetTime("data/settings.ini"), "days") = 0) {
            ; writes the settings file default structure

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

            ; Keys Values
            IniWrite("333333", "data/settings.ini", "Themes", "Dark")
            IniWrite("ffffff", "data/settings.ini", "Themes", "Light")

            IniWrite("333333", "data/settings.ini", "Default Settings", "theme")
            IniWrite("ffffff", "data/settings.ini", "Default Settings", "txt_color")

            IniWrite("409", "data/settings.ini", "Track Id Location", "x1")
            IniWrite("132", "data/settings.ini", "Track Id Location", "y1")
            IniWrite("468", "data/settings.ini", "Track Id Location", "x2")
            IniWrite("153", "data/settings.ini", "Track Id Location", "y2")

            IniWrite("399", "data/settings.ini", "Fleet Track Id Location", "x1")
            IniWrite("132", "data/settings.ini", "Fleet Track Id Location", "y1")
            IniWrite("458", "data/settings.ini", "Fleet Track Id Location", "x2")
            IniWrite("153", "data/settings.ini", "Fleet Track Id Location", "y2")

        }
        else if (DateDiff(A_Now, FileGetTime("data/rs_config.ini"), "days") = 0) {
            ; writes the rs cfg file default structure
        }
        ; id_history.txt does not need a special structure
    }

}