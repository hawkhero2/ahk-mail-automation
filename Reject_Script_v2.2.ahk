#Persistent
#NoEnv
#NoTrayIcon
#Include, ui\Main_gui.ahk
#Include, ui\Settings_gui.ahk
;--------------------------------------------UI -------------------------------------------------------------------

Gui, Main:Show,AutoSize w500 h210
Gui, Main:Color,selected_theme(),e9edf0
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
ScrollLock::
	Gui, Submit, NoHide
    ;Check if process capture2text is running
    Process, Exist, capture2text.exe
	/*
	variables for mouse position
	Left edge of track id
	*/
	x1 = 409
	y1 = 132
	
	/*
	Right edge of track id
	*/
	x2 = 468
	y2 = 153
    
    ;if the ErrorLevel is not 0 that means its running, and the automation will commence
    If !(ErrorLevel=0){
        If (WinExist("CaptureThis")){
            WinActivate
			If !(ProcessFleet){
				trackIdGet(x1,y1,x2,y2)
			}Else{
				trackIdGet(x1-10,y1,x2-10,y2)
			}
        }
        
        ;checks for the counter app
        If (WinExist("(")){
            WinActivate
            Clipboard := Trim(Clipboard, " ")
            Send, ^{V}

            ;checks for the CadosysApp
            If (WinExist("CaptureThis")){
                WinActivate
            }Else
                MsgBox,Cadosys not running
        } else
            MsgBox,Counter not running
    }Else
        Run, Capture2Text.exe
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
	If (WinExist("(")){
		WinActivate
		Loop, 4{
			Sleep, 50
			Send, {Tab}
		}
		Loop, 2{
			Sleep, 50
			Send, {Enter}
		}
		Loop, 2{
			Send, {Tab}
		}
	}
	else
		MsgBox, Counter is not running
Return

+F5::Edit
^F5::Reload

GuiClose:
ExitApp

;-------------------------------------------------------------------Functions-----------------------------------------------------------------------------------
/*
Switches to mail window and fills up the email fields with message from input, and sends it
*/
; function to send mail, message=subject & message2 = body
mailSendFunc(message,message2){
	If WinExist("Roundcube"){
		WinActivate
		Sleep, 350
		MouseClick,left, 60, 140
		IniRead, mailVar, rs_config.ini, Email
		Clipboard:=""
		Clipboard =%mailVar%
		Sleep, 1000
		Send ^{V}
		Loop, 3{
			Send, {Tab}
		}
		Clipboard:=""
		Clipboard =%message2%
		Sleep, 100
		Send ^{V}
		Send {Tab}
		Clipboard := ""
		Clipboard = %message%
		Send ^{V}
		Send {Tab}
		Sleep, 100
		
	}
	else
		MsgBox, "Mail App not running""	
}

; function to send message in chat in the appropiate channel
chatSendFunc(message){
	If WinExist("Data"){
		WinActivate
		Sleep, 350
		Send ^{k}
		Sleep, 300
		Send Respingeri
		Sleep, 500
		Send {Enter}
		Sleep, 1000
		Send {1}
		Sleep, 150
		Send {BackSpace}
		Clipboard:=""
		Clipboard = %message%
		Sleep, 1000
		Send ^{V}
		Send ^{V}
	}
	else
		MsgBox, "Chat is not open"
}

; function to get track id
trackIdGet(x1,y1,x2,y2){
	/*
	First x1, y2 coordinates are where the selection starts
	*/
	MouseMove, x1, y1, 0
    Sleep, 80
	Clipboard:=""
    Send #q
    Sleep, 60
	/*
	Second x2, y2 coordinates are where the selection ends
	*/
    MouseClick, Left, x2,y2
    MouseMove, 70, 400, 0
}
Submit(){
	Gui, Submit, NoHide
}