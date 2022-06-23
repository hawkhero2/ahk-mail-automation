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
*												GLOBAL VARIABLES
*/
global SETTINGS_FILE := "data/settings.ini"
global RS_CFG := "data/rs_config.ini"
global NUMBERS_ONLY := "0x2000"
global CENTER_INPUT := "0x1"

/*
 *                                              MAIN UI
*/


Main_UI := Gui("-Resize -MaximizeBox", "Work Enhancer v1.0",Main_UI_listener:=[])

Main_UI.Add("Text",,"Track Id")

;! Need to concatenate the strings and blank space in between them
;! VAR . " " . VAR . " " . VAR

id_field := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT vtrack_id :="",) 

Main_UI.Add("Text",,"Account")

acc_field := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT vaccount :="",)

Main_UI.Add("Text",,"Doppelt Number")

doppelt_field := Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT vdoppelt_nr :="",)

Main_UI.Add("Text",,"Doppelt Date")

Main_UI.Add("Edit",CENTER_INPUT vdoppelt_date :="",)

Main_UI.Add("Text",,"Difference")

Main_UI.Add("Edit",NUMBERS_ONLY . " " . CENTER_INPUT vdifference :="",)

/*
!   reads the rs_config.ini file and returns array of strings
!   Not functional yet.
*/
ini_reject_list := IniRead(RS_CFG,Rejection,"","")
Main_UI.Add("Text",,"Rejectiion Reason")
ddl_field := Main_UI.Add("DropDownList", vreject_reason :="",StrReplace(ini_reject_list,"`n","|")) ;! Not tested yet

Main_UI.Add("Text",,"Signature")

sign_field := Main_UI.Add("Edit", CENTER_INPUT vsignature :="",)

Main_UI.Show("w600" "h400")


/*
 *                                             SETTINGS UI
*/

Settings_UI := Gui("-Resize -MaximizeBox", "Settings",Settings_UI_listener:=[])

save_btn := Settings_UI.Add("Button","Default","Save")
save_btn.OnEvent("Click",save_btn_listener)

/*
TODO    Set chat recipient in ini file from settings window
TODO    Set account and signature in ini file from settings window
TODO    Get and Set hotstrings
TODO    Look into python OCR library 

TODO    Or switch to a different framework like Electron or Python with Qt and integrate AHK with it.
*/