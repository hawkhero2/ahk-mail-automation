/************************************************************************
 * @description Run at startup checks for settings files and creates the settings files if necessary
 * @file RunAtStartUp.ahk
 * @author Andrei Ivanciu
 * @date 2022/11/13
 * @version 0.0.1
 ***********************************************************************/

#Include IdHistoryClass.ahk
#Include SettingsClass.ahk

/*
Run at startup checks for settings files and creates the settings files if necessary
*/
at_startup() {
    settings := SettingsClass()
    id_history := IdHistoryClass()

    /*
    Checks for the data folder,
    if it returns an empty string then
    create folder and files
    */
    if (DirExist("data") = "") {

        ; creates data folder
        DirCreate("data")
        /*
        files := ["data/settings.ini", "data/id_history.txt"]
        x := 1
        while (x >= files.length) {
            if (FileExist(files[x]) = 0) {
                FileAppend("", files[x])
            }
        }
        */
    }
    if (DirExist("data") = "D") {
        timestamp := FormatTime(A_Now, "")
        /*
        if (DateDiff(A_Now, FileGetTime("data/settings.ini"), "days") = 0) {
            settings.create_settings_ini()
        
        }
        
        */
        if (FileExist(settings.file_location) = "") {
            settings.create_settings_ini()
        }
        else if (FileExist(id_history.file_location) = "") {
            id_history.create_id_history()
        }
    }

}