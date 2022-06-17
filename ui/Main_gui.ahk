/*
*       Extracted the Main_UI elements from the main script Reject_Script
TODO :  Dynamically create the UI elements based on Class_GUI
TODO :  Dynamical values for the keybinds and coordinates x y setup in Settings Window
TODO :  Themes for the UI elements chosen from Settings_GUI
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

IniRead, IniOutput, rs_config.ini, Rejection,
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

;signature name
Gui, Main:Add, Text,,Signature Name
Gui, Main:Add, Edit, vsigName w200
Gui, Main:Show,AutoSize w500 h210
Return

ButtonSettings:
	Gui, Submit, NoHide
	Gui, Main:Hide,
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
		message = %chatRecipient%  %TrackNr% - Dieser Vorgang wurde bereits unter Vorgang %doppeltNrs% geprüft.
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
		message =  Hello, `n`n%TrackNr% %RejMes%`n`n`nBest Regards,`n%sigName%`nDatamondial

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