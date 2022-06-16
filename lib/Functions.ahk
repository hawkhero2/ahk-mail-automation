;grabs default theme color code from settings.ini
get_default_theme(){    
    IniRead, tempVar, settings.ini, Default Settings, theme
    Return %tempVar%
}

;send mail, message=subject & message2 = body
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

;get track id from position in Cadosys
grab_track_id(x1,y1,x2,y2){
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

;Set track id to counter
set_track_id(){
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
				grab_track_id(x1,y1,x2,y2)
			}Else{
				grab_track_id(x1-10,y1,x2-10,y2)
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
}
; start-stop macro for counter
stop_start_func(tabs_nr){ ;is_glass is a boolean value, true if glass is being used, false if not
    If (WinExist("(")) {
        WinActivate
       Loop, %tabs_nr%{
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
}

; runs stop_start_func() for the appropriate number of tabs based on the activity
stop_start_func_activity(is_fleet){
    If (is_glass = True){
        stop_start_func(7)
    }
    Else{
        stop_start_func(4)
    }
}
