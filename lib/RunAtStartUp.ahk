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
            create_settings_ini()

        }
        else if (DateDiff(A_Now, FileGetTime("data/rs_config.ini"), "days") = 0) {
            ; writes the rs cfg file default structure
        }
        ; id_history.txt does not need a special structure
    }

}