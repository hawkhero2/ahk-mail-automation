#Persistent
#NoEnv
#NoTrayIcon
#Include, ui\Main_gui.ahk
#Include, ui\Settings_gui.ahk
#Include, lib\Functions.ahk
;--------------------------------------------UI -------------------------------------------------------------------

; ! get_default_theme not working

get_theme := get_default_theme()

Gui, Main:Show,AutoSize w500 h210
Gui, Main:Color,%get_theme%,e9edf0
Gui, Settings:Hide

return

;---------------------------------------------Labels------------------------------------------------------------------

; Save settings in Settings GUI

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

;---------------------------------------------------------Remmapings-----------------------------------------------------------------------
/*
Checks and opens Capture2text app, Moves mouse in certain position and move clicks 
*/
; TODO : Set key from Settings window from a getKeyPressed function -> save key into config file

MButton::
	Gui, Submit, NoHide
	set_track_id()
Return

XButton2::
	Gui, Submit, NoHide
	set_track_id()
Return

ScrollLock::
	Gui, Submit, NoHide
	set_track_id()
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
