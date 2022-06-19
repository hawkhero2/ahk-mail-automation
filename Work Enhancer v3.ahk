/*
*	Work Enhancer is an Autohotkey script designed to help with my daily work.
*	Its features include:	
*	-	Able to grab track id of a file using an Open Source OCR library.
*	-	Macro to automatically stop-start current job in counter app used to track time.
*	-	Send formatted messaged containing track id to internal chat @-ing a specific user.
*	-	Send emails to a specific email address containing formatted message.
*	-	Light and Dark Theme Support.
*	- 	Manually set the location of the track id via settings ui.
*	-	Storing previous track ids in a file.
*/

/*
*												IMPORTS & ##
*/

#Persistent
#NoEnv
#NoTrayIcon
#Include, lib\Functions.ahk
#InstallMouseHook
/*
!Note	:	Always do Gui Color before Gui Show
*/

/*
*												GLOBAL VARIABLES
*/
global DEFAULT_THEME = get_default_theme()
global SETTINGS_FILE = "data/settings.ini"
global RS_CFG = "data/rs_config.ini"

; global MAIN_UI_SIZE := Array(600,400) 
; global SETTINGS_UI_SIZE := Array(600,400)
global MAIN_WIDTH := 600
global MAIN_HEIGHT := 400
/*
*												DEFAULT POSITION OF THE TRACK ID
*/
global x_pos_1 = read_ini(SETTINGS_FILE, "Track Id Location", "x1")
global y_pos_1 = read_ini(SETTINGS_FILE, "Track Id Location", "y1")
global x_pos_2 = read_ini(SETTINGS_FILE, "Track Id Location", "x2")
global y_pos_2 = read_ini(SETTINGS_FILE, "Track Id Location", "y2")
/*
*												FLEET POSITION OF THE TRACK ID
*/
global x_fleet_pos_1 = read_ini(SETTINGS_FILE, "Fleet Track Id Location", "x1")
global y_fleet_pos_1 = read_ini(SETTINGS_FILE, "Fleet Track Id Location", "y1")
global x_fleet_pos_2 = read_ini(SETTINGS_FILE, "Fleet Track Id Location", "x2")
global y_fleet_pos_2 = read_ini(SETTINGS_FILE, "Fleet Track Id Location", "y2")

global NUMBERS_ONLY = 0x2000
global CENTER_INPUT = 0x1
/*
*												UI ELEMENTS
*/

;trackID of your file
Gui, Main:Add, Text,, TrackID
Gui, Main:Add, Edit, vTrackNr w200 %NUMBERS_ONLY% %CENTER_INPUT%

;the account for the subject
Gui, Main:Add, Text,, Account
Gui, Main:Add, Edit, vUserAcc w200 %CENTER_INPUT%

;trackID for doppelts
Gui, Main:Add, Text,, Doppelt 
Gui, Main:Add, Edit, vdoppeltNrs w200 %NUMBERS_ONLY% %CENTER_INPUT%

;date for the doppelt
Gui, Main:Add, Text,,Rejection Day
Gui, Main:Add, Edit, vrejDay w200 %CENTER_INPUT%

;field for difference value
Gui, Main:Add, Text,,Difference
Gui, Main:Add, Edit, vdiffVal w200 %CENTER_INPUT%

IniRead, IniOutput, %RS_CFG%, Rejection,
/*
DDL for rejection messages,
populated from rs_config.ini
*/
Gui, Main:Add, DropDownList, vRejMes w200 Sort, % StrReplace(IniOutput,"`n","|")

;Button Send Mail
Gui, Main:Add, Button,Default w200 gButtonSend , Mail

Gui, Main:Add, Button, w200 gButtonSettings, Settings

;Button Chat Send
Gui, Main:Add, Button, w200 gButtonChatSend, Chat

;radio List
Gui, Main:Add, Radio, vList, List

;radio Doppler
Gui, Main:Add, Radio, vDoppler, Doppler

;radio Doppler2
Gui, Main:Add, Radio, vDoppler2, Doppler2

;radio Doppler Kurze
Gui, Main:Add, Radio, vKurze, Doppler Kurze

;radio Difference
Gui, Main:Add, Radio, vDifference, Difference

;checkbox auto-send mail
Gui, Main:Add, Checkbox, vAutoSendMail, Auto-Send Mails?

;checkbox Processing Fleet ?
Gui, Main:Add, Checkbox, vProcessFleet, Process Fleet?

/*
TODO:	Add Groupbox for settings
TODO:	Gui, Add, GroupBox, w200 h100, Track Id Locations
TODO:	Add Tab3 for settings to group settings
TODO:	e.g. Gui, Add, Tab3,, General|View|Settings

*/

; Setting Text Label for DDL
Gui, Settings:Add, Text,y25, Theme

; Settings ddl for theme
Gui, Settings:Add, DDL,x70 y20 vtheme_key, Dark|Light

; Settings Set Track ID Location Default
Gui, Settings:Add, Button ,x70 y70 gButtonSetTrackID, Set Track ID Location

; Settings Set Fleet Track Id location
Gui, Settings:Add, Button ,x70 y100 gButtonSetFleetTrackID, Set Fleet Track ID Location

; Settings Save button
Gui, Settings:Add, Button,x190 y150 w60 h25 gButtonSave,Save

; Settings Cancel button
Gui, Settings:Add, Button,x270 y150 w60 h25 gButtonCancel,Cancel

; Settings Theme select
Gui, Settings:Color,%DEFAULT_THEME%

;signature name
Gui, Main:Add, Text,,Signature Name
Gui, Main:Add, Edit, vsigName w200

Gui, Main:Show, w%MAIN_WIDTH% h%MAIN_HEIGHT%
Gui, Main:Color,%DEFAULT_THEME%
Return
/*
*												LABELS
*/
ButtonSetFleetTrackID:
	MsgBox, "Make a diagonal selection of where track id is positioned then click save"
	KeyWait, LButton, D
	MouseGetPos, cstm_x_pos1, cstm_y_pos1	;*	get start position of the track id coords
	KeyWait, LButton,
	MouseGetPos, cstm_x_pos2, cstm_y_pos2	;*	get end position of the track id coords
	write_ini(cstm_x_pos1,SETTINGS_FILE,"Fleet Track Id Location","x1")
	write_ini(cstm_y_pos1,SETTINGS_FILE,"Fleet Track Id Location","y1")
	write_ini(cstm_x_pos2,SETTINGS_FILE,"Fleet Track Id Location","x2")
	write_ini(cstm_y_pos2,SETTINGS_FILE,"Fleet Track Id Location","y2")	
Return

ButtonSetTrackID:
	/*
	todo	Set app to run at startup
	*/
	MsgBox, "Make a diagonal selection of where track id is positioned then click save"
	KeyWait, LButton, D
	MouseGetPos, cstm_x_pos1, cstm_y_pos1	;*	get start position of the track id coords
	KeyWait, LButton,
	MouseGetPos, cstm_x_pos2, cstm_y_pos2	;*	get end position of the track id coords
	write_ini(cstm_x_pos1,SETTINGS_FILE,"Track Id Location","x1")
	write_ini(cstm_y_pos1,SETTINGS_FILE,"Track Id Location","y1")
	write_ini(cstm_x_pos2,SETTINGS_FILE,"Track Id Location","x2")
	write_ini(cstm_y_pos2,SETTINGS_FILE,"Track Id Location","y2")
Return

ButtonSave:
	Gui, Submit, NoHide
	If !(%theme_key% = ""){	
		theme_name = %theme_key%
		IniRead, temp_color_code, %SETTINGS_FILE%, Themes,% theme_name
		IniWrite, %temp_color_code%, %SETTINGS_FILE%, Default Settings, theme
		Gui, Main:Color,%DEFAULT_THEME%
		Gui, Main:Show
		Gui, Settings:Hide
	}else{
		MsgBox, Please select a theme
	}
Return

ButtonCancel:
	Gui, Main:Color,%DEFAULT_THEME%
	Gui, Main:Show
	Gui, Settings:Hide
Return

ButtonSettings:
	Gui, Submit, NoHide
	Gui, Main:Hide,
	Gui, Settings:Color,%DEFAULT_THEME%
	Gui, Settings:Show, w350 h200, Settings
Return

ButtonChatSend:
	Gui, Submit, NoHide
	IniRead, chatAcc, rs_config.ini, Chat
	chatRecipient := %chatAcc%
	If(List){
		message = %chatRecipient% %TrackNr% - %RejMes%
		chatSendFunc(message)
		Send ^{v}
		Send {Enter}
		Return
	}
	If(Doppler){
		message = %chatRecipient% %TrackNr% - Dieser Vorgang wurde bereits am %rejDay% unter Vorgang %doppeltNrs% geprüft. Die Ergebnisberichte aus der vorangegangen Prüfung sind als eigene Dokumente beigefügt
		chatSendFunc(message)
		Send ^{v}
		Send {Enter}
		Return
	}
	If(Doppler2){
		message = %chatRecipient% %TrackNr% - Dieser Vorgang wurde bereits unter Vorgang %doppeltNrs% geprüft.
		chatSendFunc(message)
		Send ^{v}
		Send {Enter}
		Return
	}
	If(Kurze){
		message = %chatRecipient% %TrackNr% - Doppelt %doppeltNrs% - Der Vorgang steht unter der Vorgangsnummer %doppeltNrs% zur Prüfung an. Ein entsprechender Prüfbericht folgt in Kürze.
		chatSendFunc(message)
		Send ^{v}
		Send {Enter}
		Return
	}
	If(Difference){
		message = %chatRecipient% %TrackNr% - Difference of %diffVal% € - Der Kostenvoranschlag ist leider nicht vollständig. In der Kalkulation ist eine Differenz von %diffVal%€. Bitte senden Sie uns den Vorgang vollständig erneut zur Prüfung zu. Vielen Dank!
		chatSendFunc(message)
		Send ^{v}
		Send {Enter}
		Return
	}

Return

ButtonSend:
	Gui, Submit, NoHide
	If (List){
		message2 = %TrackNr%-%A_DD%.%A_MM%.%A_YYYY%, %UserAcc%
		message = Hello, `n`n%TrackNr% %RejMes%`n`n`nBest Regards,`n%sigName%`nDatamondial

		mailSendFunc(message,message2)
		if (AutoSendMail)
			Send {Enter}
		Return
	}

	If (Doppler){
		message2 = %TrackNr%-%A_DD%.%A_MM%.%A_YYYY%, %UserAcc%
		message = Hello,`n`nDoppelt %TrackNr% - Dieser Vorgang wurde bereits am %rejDay% unter Vorgang %doppeltNrs% geprüft. Die Ergebnisberichte aus der vorangegangen Prüfung sind als eigene Dokumente beigefügt `n`n`nBest Regards,`n%sigName% `nDatamondial

		mailSendFunc(message,message2)
		if (AutoSendMail)
			Send {Enter}
		Return
	}

	If(Doppler2){
		message2 = %TrackNr%-%A_DD%.%A_MM%.%A_YYYY%, %UserAcc%
		message = Hello,`n`nDoppelt %TrackNr% - Dieser Vorgang wurde bereits unter Vorgang %doppeltNrs% geprüft. `n`n`nBest Regards,`n%sigName% `nDatamondial

		mailSendFunc(message,message2)
		if (AutoSendMail)
			Send {Enter}
		Return
	}

	If (Kurze){
		message2 = %TrackNr%-%A_DD%.%A_MM%.%A_YYYY%, %UserAcc%
		message = Hello,`n`nDoppelt %doppeltNrs% - Der Vorgang steht unter der Vorgangsnummer %doppeltNrs% zur Prüfung an. Ein entsprechender Prüfbericht folgt in Kürze.`n`n`nBest Regards,`n%sigName% `nDatamondial

		mailSendFunc(message,message2)
		if (AutoSendMail)
			Send {Enter}
		Return
	}

	If (Difference){
		message2 = %TrackNr%-%A_DD%.%A_MM%.%A_YYYY%, %UserAcc%
		message = Hello, `n`n%TrackNr% Difference of %diffVal% € - Der Kostenvoranschlag ist leider nicht vollständig. In der Kalkulation ist eine Differenz von %diffVal%€. Bitte senden Sie uns den Vorgang vollständig erneut zur Prüfung zu. Vielen Dank!`n`n`nBest Regards,`n%sigName%`nDatamondial

		mailSendFunc(message,message2)
		if (AutoSendMail)
			Send {Enter}
		Return
	}

	else{
		MsgBox, You must select one option
	}
Return

get_theme = get_default_theme()

Gui, Main:Color,%DEFAULT_THEME%,e9edf0
Gui, Settings:Hide

/*
*												HOTKEYS
*/
/*
TODO	:	Possibly have the function write the track id in a file aswell
TODO	:	The writting should happen in the set_track_id() function
!		:	Possible problem -> OCR sometimes adds a space somewhere in the track id


*/


MButton::
	Gui, Submit, NoHide
	If !(%ProcessFleet%){
		set_track_id(x_pos_1, y_pos_1, x_pos_2, y_pos_2)
	}else{
		set_track_id(x_fleet_pos_1, y_fleet_pos_1, x_fleet_pos_2, y_fleet_pos_2)
	}
Return

XButton2::
	Gui, Submit, NoHide
	If !(%ProcessFleet%){
		set_track_id(x_pos_1, y_pos_1, x_pos_2, y_pos_2)
	}else{
		set_track_id(x_fleet_pos_1, y_fleet_pos_1, x_fleet_pos_2, y_fleet_pos_2)
	}
Return

ScrollLock::
	Gui, Submit, NoHide
	If !(%ProcessFleet%){
		set_track_id(x_pos_1, y_pos_1, x_pos_2, y_pos_2)
	}else{
		set_track_id(x_fleet_pos_1, y_fleet_pos_1, x_fleet_pos_2, y_fleet_pos_2)
	}
Return

/*
Mouse 4th button remapped to enter
*/
XButton1::
	Loop{
		Sleep, 50
		If (GetKeyState("XButton1", "P")){
			Send, {Enter}
		}
		Else
			Break
	}
Return

Pause::
	Gui, Submit, NoHide
	If (%ProcessFleet%){
		stop_start_func_activity(True)
	}Else{
		stop_start_func_activity(False)
	}
Return

+F5::Edit
^F5::Reload

GuiClose:
ExitApp
