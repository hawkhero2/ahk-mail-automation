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
*/

/*
 *                                              IMPORTS
*/



#Include "lib\Functions.ahk" ;! import not working when compiling the script to .exe
; ----------------------------------------

/*
*												GLOBAL VARIABLES
*/
Persistent()
#Warn All, Off
startup_path := A_Startup "\Work Enhancer.ink"
global SETTINGS_FILE := "data/settings.ini"
global ID_HISTORY := "data/id_history.txt"
global DEFAULT_THEME := get_default_theme(SETTINGS_FILE)
global RS_CFG := "data/rs_config.ini"

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

/*
*   In order to pass constraints to UI elements they must be a string and
*   We need to concatenate the strings and blank space in between them
*   VAR . " " . VAR . " " . VAR
*/

Main_UI := Gui("-Resize -MaximizeBox", "Work Enhancer v1.0" )

; *             TRACK ID
Main_UI.Add("Text",,"Track Id" )
track_id := Main_UI.Add("Edit","0x2000 0x1 vtrack_id" ,"" ) 


; Main_UI.Add("Text",,"Account" )
; acc_field := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT vaccount :="",get_acc(SETTINGS_FILE) )

; *             DOPPELT NR
Main_UI.Add("Text",,"Doppelt Number" )
doppelt_nr := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT . " " . "vdoppelt_nr", "")

; *             DOPPELT DATE
Main_UI.Add("Text",,"Doppelt Date" )
doppelt_date := Main_UI.Add("Edit",CENTER_INPUT . " " . "vdoppelt_date", "")

; *             DIFFERENCE
Main_UI.Add("Text",,"Difference" )
diff_val := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT . " " . "vdifference_val", "")

; Radio buttons
; ! not working yet
List := Main_UI.Add("Radio","vList","List")
Doppelt := Main_UI.Add("Radio","vDoppelt","Doppelt")
Doppelt2 := Main_UI.Add("Radio","vDoppelt2","Doppelt v2")
Diff := Main_UI.Add("Radio","vDifference","Difference")
Kurze := Main_UI.Add("Radio","vKurze","Doppelt Kurze")


; *             DROPDOWN REJECTION LIST
arr_rej_list := get_list(RS_CFG,"Rejection")
Main_UI.Add("Text",,"Rejection Reason" )
reject_reason := Main_UI.Add("DropDownList", "vreject_reason" ,arr_rej_list ) ; ! NEEDS TO RECEIVE AN ARRAY WITH THE REJECTION REASONS

check_fleet := Main_UI.Add("Checkbox", "vcheck_fleet", "Fleet Processesing ?")

Main_UI.Add("Button",,"Send Mail").OnEvent("Click", send_email_listener )

Main_UI.Add("Button",,"Send Chat").OnEvent("Click", send_chat_listener )

Main_UI.Add("Button",,"Settings").OnEvent("Click",settings_btn_listener )

Main_UI.Show("w600" "h400")


/*
*                                             SETTINGS UI
*/

Settings_UI := Gui("-Resize -MaximizeBox", "Settings",Settings_UI_listener:=[] )

; *             SAVE BUTTON
Settings_UI.Add("Button","Default","Save").OnEvent("Click", save_btn_listener )

; *             CANCEL BUTTON
Settings_UI.Add("Button", ,"Cancel").OnEvent("Click", cancel_btn_listener )

; *             DEFAULT ID LOCATION
Settings_UI.Add("Text",,"Set default track id location")
Settings_UI.Add("Button",,"Set").OnEvent("Click",set_btn_listener )

; *             FLEET ID LOCATION 
Settings_UI.Add("Text",,"Set Fleet track id location" )
Settings_UI.Add("Button",,"Set").OnEvent("Click", set_fleet_btn_listener )

; *            RUN AT STARTUP
Settings_UI.Add("Button",,"Run at startup").OnEvent("Click", run_at_startup_listener )

; *             ACCOUNT
Settings_UI.Add("Text", ,"Account" )
acc_field := Settings_UI.Add("Edit", CENTER_INPUT . " " . "vaccount",ACC )

; *             RECIPIENT
Settings_UI.Add("Text",,"Chat Recipient" )
chat_acc := Settings_UI.Add("Edit",CENTER_INPUT . " " . "vrecipient" ,RECIPIENT )

; *             SIGNATURE
Settings_UI.Add("Text",,"Signature" )
signature_field := Settings_UI.Add("Edit", CENTER_INPUT . " " . "vsignature", SIGN )



return
/*
TODO    Get and Set hotstrings
TODO    Look into python OCR library
*/

/*
*                                             LISTENERS
*/ 
save_btn_listener(*){
    Setting.Submit()
    Settings_UI.Show()

    set_acc(SETTINGS_FILE, account)
    set_sign(SETTINGS_FILE, signature)
    set_recipient(SETTINGS_FILE, RECIPIENT)+

    Settings_UI.Hide()
}

send_email_listener(*){
    Main_UI.Submit(true)
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
    else if(Difference.Value){
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
    Main_UI.Submit(true)
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
    Settings_UI.Hide()
    Main_UI.Show()
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
    Main_UI.Hide()
    Settings_UI.Show()
}
run_at_startup_listener(*){
    if(FileExist(A_Startup"\Work Enhancer.ink")){
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
    Main_UI.Submit(true)
    if !(check_fleet.Value){
        set_track_id(x_pos_1, y_fleet_pos_1, x_pos_2, y_fleet_pos_2, ID_HISTORY)
    }
    else{
        set_track_id(x_fleet_pos_1,y_fleet_pos_1,x_fleet_pos_2,y_fleet_pos_2, ID_HISTORY)
    }
}
XButton2::
{
    Main_UI.Submit(true)
    if !(check_fleet.Value){
        set_track_id(x_pos_1, y_fleet_pos_1, x_pos_2, y_fleet_pos_2, ID_HISTORY)
    }
    else{
        set_track_id(x_fleet_pos_1,y_fleet_pos_1,x_fleet_pos_2,y_fleet_pos_2, ID_HISTORY)
    }
}
ScrollLock::
{
    Main_UI.Submit(true)
    if !(check_fleet.Value){
        set_track_id(x_pos_1, y_fleet_pos_1, x_pos_2, y_fleet_pos_2, SETTINGS_FILE)
    }
    else{
        set_track_id(x_fleet_pos_1,y_fleet_pos_1,x_fleet_pos_2,y_fleet_pos_2, SETTINGS_FILE)
    }
}
Pause::
{
    Main_UI.Submit(true)
    if !(check_fleet.Value){
        stop_start_activity(false)
    }
    else{
        stop_start_activity(true)
    }
}