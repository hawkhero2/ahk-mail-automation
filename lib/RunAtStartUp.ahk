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

        create_settings_ini()
    }
    if (DirExist("data") = "D") {
        timestamp := FormatTime(A_Now, "")
        ; FileExist returns "X" when true and "" when false
        if (FileExist("data/settings.ini") = "") {
            create_settings_ini()
        }
        if (FileExist("data/id_history.txt") = "") {
            create_id_history()
        }
    }

}