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
Persistent()
#Warn All, Off
#Include "lib\Functions.ahk"

/*
*												GLOBAL VARIABLES
*/

global SETTINGS_FILE := "data/settings.ini"
global ID_HISTORY := "data/id_history.txt"
global DEFAULT_THEME := get_default_theme(SETTINGS_FILE)
global RS_CFG := "data/rs_config.ini"

global NUMBERS_ONLY := "0x2000"
global CENTER_INPUT := "0x1"
global ACC := get_acc( SETTINGS_FILE )
global SIGN := get_sign( SETTINGS_FILE )
global RECIPIENT := get_recipient( SETTINGS_FILE )
global EMAIL := get_email( SETTINGS_FILE )

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

MsgBox(A_DD . "." . A_MM . "." . A_YYYY)

/*
 *                                              MAIN UI
*/

/*
*   In order to pass constraints to UI elements they must be a string and
*   We need to concatenate the strings and blank space in between them
*   VAR . " " . VAR . " " . VAR
*/

Main_UI := Gui("-Resize -MaximizeBox", "Work Enhancer v1.0" )

Main_UI.Add("Text",,"Track Id" )

id_field := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT "vtrack_id" ,"" ) 

; Main_UI.Add("Text",,"Account" )

; acc_field := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT vaccount :="",get_acc(SETTINGS_FILE) )

Main_UI.Add("Text",,"Doppelt Number" )

doppelt_field := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT "vdoppelt_nr", "")

Main_UI.Add("Text",,"Doppelt Date" )

dopp_date_field :=  Main_UI.Add("Edit",CENTER_INPUT "vdoppelt_date", "")

Main_UI.Add("Text",,"Difference" )

diff_field := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT "vdifference_val", "")

; Radio buttons
Main_UI.Add("Radio","vList","List")
Main_UI.Add("Radio","vDoppelt","Doppelt")
Main_UI.Add("Radio","vDoppelt2","Doppelt v2")
Main_UI.Add("Radio","vDifference","Difference")
Main_UI.Add("Radio","vKurze","Doppelt Kurze")



arr_rej_list := get_list(RS_CFG)
Main_UI.Add("Text",,"Rejectiion Reason" )
ddl_field := Main_UI.Add("DropDownList", "vreject_reason" ,arr_rej_list ) ; ! NEEDS TO RECEIVE AN ARRAY WITH THE REJECTION REASONS


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

; *             ACCOUNT
Settings_UI.Add("Text", ,"Account" )
Settings_UI.Add("Edit", CENTER_INPUT "vaccount",ACC )

; *             RECIPIENT
Settings_UI.Add("Text",,"Chat Recipient" )
Settings_UI.Add("Edit",CENTER_INPUT "vrecipient" ,RECIPIENT )

; *             SIGNATURE
Settings_UI.Add("Text",,"Signature" )
sign_field := Settings_UI.Add("Edit", CENTER_INPUT "vsignature", SIGN )



return
/*
TODO    Get and Set hotstrings
TODO    Look into python OCR library
TODO    Make up run at startup option
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
    Main_UI.Submit()
    
    subject := track_id . "-" . A_DD . "." . A_MM . "." . A_YYYY . "-" . ACC
    
    if (List){
        body := "Hello, `n`n" . track_id "-" reject_reason"`n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    }
    else if(Doppelt){
		body = "Hello,`n`nDoppelt" . track_id . "-" . "Dieser Vorgang wurde bereits am" . doppelt_date . "unter Vorgang" . doppelt_nr . "geprüft. Die Ergebnisberichte aus der vorangegangen Prüfung sind als eigene Dokumente beigefügt `n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    }
    else if(Doppelt2){
        body = "Hello,`n`nDoppelt" . track_id . "-" . "Dieser Vorgang wurde bereits unter Vorgang" . doppelt_nr . "geprüft. `n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)

    }
    else if(Difference){
		body = "Hello, `n`n" . track_id . "Difference of" . difference_val . "€ - Der Kostenvoranschlag ist leider nicht vollständig. In der Kalkulation ist eine Differenz von" . difference_val . "€. Bitte senden Sie uns den Vorgang vollständig erneut zur Prüfung zu. Vielen Dank!`n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    }
    else if(Kurze){
		body = "Hello,`n`nDoppelt" . track_id . "-" . "Der Vorgang steht unter der Vorgangsnummer" . doppelt_nr . "zur Prüfung an. Ein entsprechender Prüfbericht folgt in Kürze.`n`n`nBest Regards,`n" . SIGN . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    }
    else
    {
        MsgBox("Please select an option")
    }

}

send_chat_listener(*){

}

cancel_btn_listener(*){
    Settings_UI.Hide()
    Main_UI.Show()
}

set_btn_listener(*){

}

set_fleet_btn_listener(*){

}