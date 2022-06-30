/*
*                       Work Enhancer v1.0 is an AHK script used to macro some of the work.
*                       It uses AutoHotkey beta v2.
*	                    Its features include:	
*	                    -	Able to grab track id of a file using an Open Source OCR library.
*	                    -	Macro to automatically stop-start current job in counter app used to track time.
*	                    -	Send formatted messaged containing track id to internal chat @-ing a specific user.
*	                    -	Send emails to a specific email address containing formatted message.
*	                    -	Light and Dark Theme Support.
*	                    - 	Manually set the location of the track id via settings ui.
*	                    -	Storing previous track ids in a file.
*                       -   Run at startup.
*/

/*
 *                                              IMPORTS
*/



#Include "lib\Functions.ahk" ;! import not working when compiling to .exe
#Warn All, Off
; ----------------------------------------

/*
*												GLOBAL VARIABLES
*/
startup_path := A_Startup "\Work Enhancer.ink"
global SETTINGS_FILE := "data/settings.ini"
global ID_HISTORY := "data/id_history.txt"
global DEFAULT_THEME := get_default_theme(SETTINGS_FILE)
global RS_CFG := "data/rs_config.ini"

global SETTINGS_SIZE :="w600 h240"
global MAIN_SIZE := "w600 h270"
global BUTTON_SIZE := "w90 h30"
global NUMBERS_ONLY := "0x2000"
global CENTER_INPUT := "0x1"
global ACC := get_acc( SETTINGS_FILE )
global SIGN := get_sign( SETTINGS_FILE )
global RECIPIENT := get_recipient( SETTINGS_FILE )
global EMAIL := get_email( RS_CFG )
global CURRENT_DATE := A_DD . "-" . A_MM . "-" . A_YYYY

; Assign positions to variables for default position
global x_pos_1 := IniRead(SETTINGS_FILE, "Track Id Location","x1","")
global y_pos_1 := IniRead(SETTINGS_FILE, "Track Id Location","y1","")
global x_pos_2 := IniRead(SETTINGS_FILE, "Track Id Location","x2","")
global y_pos_2 := IniRead(SETTINGS_FILE, "Track Id Location","y2","")

; Assign positions to variables for fleet
global x_fleet_pos_1 := IniRead(SETTINGS_FILE,"Fleet Track Id Location","x1")
global y_fleet_pos_1 := IniRead(SETTINGS_FILE,"Fleet Track Id Location","y1")
global x_fleet_pos_2 := IniRead(SETTINGS_FILE,"Fleet Track Id Location","x2")
global y_fleet_pos_2 := IniRead(SETTINGS_FILE,"Fleet Track Id Location","y2")


/*
 *                                              MAIN UI
*/

main_ui := Gui("-Resize -MaximizeBox", "Work Enhancer v1.0" )

; *             TRACK ID
main_ui.Add("Text","x140 y15","Track Id" )
track_id := main_ui.Add("Edit","0x2000 0x1 vtrack_id x10 y10" ,"" ) 

; *             DOPPELT NR
main_ui.Add("Text","x140 y55","Doppelt Number" )
doppelt_nr := main_ui.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT . " " . "vdoppelt_nr x10 y50 ", "")

; *             DOPPELT DATE
main_ui.Add("Text", "x140 y95","Doppelt Date" )
doppelt_date := main_ui.Add("Edit",CENTER_INPUT . " " . "vdoppelt_date x10 y90", "")

; *             DIFFERENCE
main_ui.Add("Text", "x140 y135","Difference" )
diff_val := main_ui.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT . " " . "vdifference_val x10 y130", "")

; *             RADIO BUTTONS
List := main_ui.Add("Radio","vList x260 y15","List")
Doppelt := main_ui.Add("Radio","vDoppelt x260 y35","Doppelt")
Doppelt2 := main_ui.Add("Radio","vDoppelt2 x260 y55","Doppelt v2")
Diff := main_ui.Add("Radio","vDifference x260 y75","Difference")
Kurze := main_ui.Add("Radio","vKurze x260 y95","Doppelt Kurze")


; *             DROPDOWN REJECTION LIST
arr_rej_list := get_list(RS_CFG,"Rejection")
main_ui.Add("Text", "x10 y174","Rejection Reason" )
reject_reason := main_ui.Add("DropDownList", "vreject_reason w580 x10" ,arr_rej_list ) 

check_fleet := main_ui.Add("Checkbox", "vcheck_fleet x260 y130", "Fleet Processesing ?")

main_ui.Add("Button",BUTTON_SIZE . A_Space . "x10 y220","Send Mail").OnEvent("Click", send_email_listener )

main_ui.Add("Button", BUTTON_SIZE . A_Space . "x120 y220","Send Chat").OnEvent("Click", send_chat_listener )

main_ui.Add("Button", BUTTON_SIZE . A_Space . "x230 y220","Settings").OnEvent("Click",settings_btn_listener )

main_ui.Add("Button", BUTTON_SIZE . A_Space . "x340 y220","Browse").OnEvent("Click",browse_btn_listener )

main_ui.OnEvent("Close", main_close)

main_ui.Show(MAIN_SIZE)

browse_btn_listener(*){
    pick_file := FileSelect() ; returns the path of the file selected
    /*
     * could be used for a functionality?
     */
}



/*
*                                             SETTINGS UI
*/

settings_ui := Gui("-Resize -MaximizeBox", "Settings",settings_ui_listener:=[] )

settings_ui.Add("GroupBox", "x290 y10 w250 h110", "Misc")
settings_ui.Add("GroupBox", "x10 y10 w250 h110", "Track Id Position")


; *             SAVE BUTTON
settings_ui.Add("Button","x10 y200 Default" . A_Space . BUTTON_SIZE,"Save").OnEvent("Click", save_btn_listener )

; *             CANCEL BUTTON
settings_ui.Add("Button","x110 y200" . A_Space . BUTTON_SIZE,"Cancel").OnEvent("Click", cancel_btn_listener )

; *                  ID LOCATION
settings_ui.Add("Text","x110 y35","Set default track id location")
settings_ui.Add("Button","x15 y30" . A_Space . BUTTON_SIZE,"Set").OnEvent("Click",set_btn_listener )

; *             FLEET ID LOCATION 
settings_ui.Add("Text", "x110 y85","Set Fleet track id location" )
settings_ui.Add("Button","x15 y80" . A_Space . BUTTON_SIZE,"Set").OnEvent("Click", set_fleet_btn_listener )

; *            RUN AT STARTUP
settings_ui.Add("Button","x10 y140" . A_Space . BUTTON_SIZE,"Run at startup").OnEvent("Click", run_at_startup_listener )


; *             ACCOUNT
settings_ui.Add("Text", "x440 y20","Account" )
acc_field := settings_ui.Add("Edit", CENTER_INPUT . " " . "vaccount w90 x330 y25",ACC )

; *             RECIPIENT
settings_ui.Add("Text","x440 y50" ,"Chat Recipient" )
chat_acc := settings_ui.Add("Edit",CENTER_INPUT . " " . "vrecipient w90 x330 y55" ,RECIPIENT )

; *             SIGNATURE
settings_ui.Add("Text","x440 y80" ,"Signature" )
signature_field := settings_ui.Add("Edit", CENTER_INPUT . " " . "vsignature w90 x330 y85", SIGN )

settings.OnEvent("Close", settings_close)
; settings_ui.Show(SETTINGS_SIZE)
return
/*
TODO    Get and Set hotstrings
TODO    Look into python OCR library
TODO    Quick Launch apps hotkeys
*/

/*
*                                             LISTENERS
*/ 
settings_close(*){
    settings_ui.Hide()
    main_ui.Show(MAIN_SIZE)
}

main_close(*){
    ExitApp
}

save_btn_listener(*){
    settings_ui.Submit(true)
    settings_ui.Show()

    set_acc(SETTINGS_FILE, acc_field.Text)
    set_sign(SETTINGS_FILE, signature_field.Text)
    set_recipient(SETTINGS_FILE, chat_acc.Text)

    settings_ui.Hide()
}

send_email_listener(*){
    main_ui.Submit(true)
    subject := track_id.Value . A_Space . CURRENT_DATE . "," . A_Space . ACC
    if (List.Value){
        body := "Hello, `n`n" . track_id.Value . "-" . reject_reason.Text . "`n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    }
    else if(Doppelt.Value){
		body := "Hello,`n`nDoppelt" . track_id.Value . "-" . "Dieser Vorgang wurde bereits am" . doppelt_date.Value . "unter Vorgang" . doppelt_nr.Value . "geprüft. Die Ergebnisberichte aus der vorangegangen Prüfung sind als eigene Dokumente beigefügt `n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    }
    else if(Doppelt2.Value){
        body := "Hello,`n`nDoppelt" . track_id.Value . "-" . "Dieser Vorgang wurde bereits unter Vorgang" . doppelt_nr.Value . "geprüft. `n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)

    }
    else if(Diff.Value){
		body := "Hello, `n`n" . track_id.Value . "Difference of" . difference_val.Value . "€ - Der Kostenvoranschlag ist leider nicht vollständig. In der Kalkulation ist eine Differenz von" . difference_val.Value . "€. Bitte senden Sie uns den Vorgang vollständig erneut zur Prüfung zu. Vielen Dank!`n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    }
    else if(Kurze.Value){
		body := "Hello,`n`nDoppelt" . track_id.Value . "-" . "Der Vorgang steht unter der Vorgangsnummer" . doppelt_nr.Value . "zur Prüfung an. Ein entsprechender Prüfbericht folgt in Kürze.`n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    }
    else
    {
        MsgBox("Please select an option")
    }

}

send_chat_listener(*){
    main_ui.Submit(true)
    if (List.Value){
        body := RECIPIENT . " " . track_id.Value "-" reject_reason.Text
        chat_send(body)
    }
    else if(Doppelt.Value){
		body := RECIPIENT . " " . track_id.Value . "-" . "Dieser Vorgang wurde bereits am" . doppelt_date.Value . "unter Vorgang" . doppelt_nr.Value . "geprüft. Die Ergebnisberichte aus der vorangegangen Prüfung sind als eigene Dokumente beigefügt"
        chat_send(body)
    }
    else if(Doppelt2.Value){
        body := RECIPIENT . " " . track_id.Value . "-" . "Dieser Vorgang wurde bereits unter Vorgang" . doppelt_nr.Value . "geprüft."
        chat_send(body)

    }
    else if(Difference.Value){
		body := RECIPIENT . " " . track_id.Value . "Difference of" . difference_val.Value . "€ - Der Kostenvoranschlag ist leider nicht vollständig. In der Kalkulation ist eine Differenz von" . difference_val.Value . "€. Bitte senden Sie uns den Vorgang vollständig erneut zur Prüfung zu. Vielen Dank!"
        chat_send(body)
    }
    else if(Kurze.Value){
		body := RECIPIENT . " " . track_id.Value . "-" . "Der Vorgang steht unter der Vorgangsnummer" . doppelt_nr.Value . "zur Prüfung an. Ein entsprechender Prüfbericht folgt in Kürze."
        chat_send(body)
    }
    else
    {
        MsgBox("Please select an option")
    }
}
cancel_btn_listener(*){
    settings_ui.Hide()
    main_ui.Show()
}
set_btn_listener(*){
    MsgBox("Make a diagonal selection of where the track id is positioned then click save")
    
    KeyWait("LButton","D")
    MouseGetPos(&cstm_x1,&cstm_y1)
    KeyWait("LButton","U")
    MouseGetPos(&cstm_x2,&cstm_y2)
    
    set_default_pos(cstm_x1,cstm_y1,cstm_x2,cstm_y2,SETTINGS_FILE,"Track Id Location")
    MsgBox("Position set")
}
set_fleet_btn_listener(*){
    MsgBox("Make a diagonal selection of where the track id is positioned then click save")
    
    KeyWait("LButton","D")
    MouseGetPos(&cstm_x1,&cstm_y1)
    KeyWait("LButton","U")
    MouseGetPos(&cstm_x2,&cstm_y2)

    set_default_pos(cstm_x1,cstm_y1,cstm_x2,cstm_y2,SETTINGS_FILE,"Fleet Track Id Location")
    MsgBox("Position set")
}
settings_btn_listener(*){
    main_ui.Hide()
    settings_ui.Show(SETTINGS_SIZE)
}
run_at_startup_listener(*){

    if(FileExist(A_Startup . "\Work Enhancer.ink")){
        MsgBox("Work Enhancer is already set to run at startup")
    }else{
        FileCreateShortcut(A_ScriptFullPath,A_Startup "\Work Enhancer.lnk")
    }
}
/*
*                                               HOTKEYS 
*/
MButton::
{
    main_ui.Submit(true)
    if !(check_fleet.Value){
        set_track_id(x_pos_1, y_fleet_pos_1, x_pos_2, y_fleet_pos_2, ID_HISTORY)
    }
    else{
        set_track_id(x_fleet_pos_1,y_fleet_pos_1,x_fleet_pos_2,y_fleet_pos_2, ID_HISTORY)
    }
}
XButton2::
{
    main_ui.Submit(true)
    if !(check_fleet.Value){
        set_track_id(x_pos_1, y_fleet_pos_1, x_pos_2, y_fleet_pos_2, ID_HISTORY)
    }
    else{
        set_track_id(x_fleet_pos_1,y_fleet_pos_1,x_fleet_pos_2,y_fleet_pos_2, ID_HISTORY)
    }
}
ScrollLock::
{
    main_ui.Submit(true)
    if !(check_fleet.Value){
        set_track_id(x_pos_1, y_fleet_pos_1, x_pos_2, y_fleet_pos_2, SETTINGS_FILE)
    }
    else{
        set_track_id(x_fleet_pos_1,y_fleet_pos_1,x_fleet_pos_2,y_fleet_pos_2, SETTINGS_FILE)
    }
}
Pause::
{
    main_ui.Submit(true)
    if !(check_fleet.Value){
        stop_start_activity(false)
    }
    else{
        stop_start_activity(true)
    }
}