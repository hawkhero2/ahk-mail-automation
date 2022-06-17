/*
*												IMPORTS & ##
*/

#Persistent
#NoEnv
#NoTrayIcon
#Include, lib\Functions.ahk
/*
Note	:	Always do Gui Color before Gui Show
*/

/*
*												GLOBAL VARIABLES
*/
global DEFAULT_THEME = get_default_theme()
global SETTINGS_FILE = "data/settings.ini"
global RS_CFG = "data/rs_config.ini"
IniRead, x1, %SETTINGS_FILE%,Track Id Location,x1
IniRead, y1, %SETTINGS_FILE%,Track Id Location,y1
IniRead, x2, %SETTINGS_FILE%,Track Id Location,x2
IniRead, y2, %SETTINGS_FILE%,Track Id Location,y2
global x_pos_1 = x1
global y_pos_1 = y1
global x_pos_2 = x2
global y_pos_2 = y2
/*
*												UI ELEMENTS
*/

;trackID of your file
Gui, Main:Add, Text,, TrackID
Gui, Main:Add, Edit, vTrackNr w200 0x2000 0x1

;the account for the subject
Gui, Main:Add, Text,, Account
Gui, Main:Add, Edit, vUserAcc w200 0x1

;trackID for doppelts
Gui, Main:Add, Text,, Doppelt 
Gui, Main:Add, Edit, vdoppeltNrs w200 0x2000 0x1

;date for the doppelt
Gui, Main:Add, Text,,Rejection Day
Gui, Main:Add, Edit, vrejDay w200 0x1

;field for difference value
Gui, Main:Add, Text,,Difference
Gui, Main:Add, Edit, vdiffVal w200 0x1

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

Gui, Main:Show,AutoSize w500 h210
Gui, Main:Color,%DEFAULT_THEME%
Return
/*
*												LABELS
*/
ButtonSetFleetTrackID:
	
Return

ButtonSetTrackID:

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
	Gui, Main:Show
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
TODO	:	Currently grabs the values from ini file, 
TODO	:	However need to remake the function if 
TODO	:	we want different positions for Fleet activity 
TODO	:	OR we use same function and subtract some pixels
TODO	:	OR use another if inside Hotkeys and feed 
TODO	:	the function the subtracted values
*/

MButton::
	Gui, Submit, NoHide
	set_track_id(x_pos_1, y_pos_1, x_pos_2, y_pos_2)
Return

XButton2::
	Gui, Submit, NoHide
	set_track_id(x_pos_1, y_pos_1, x_pos_2, y_pos_2)
Return

ScrollLock::
	Gui, Submit, NoHide
	set_track_id(x_pos_1, y_pos_1, x_pos_2, y_pos_2)
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
