/*
Set state of element
@param String element
@param boolean state
@return void
*/
set_state(key :="", state := False){
	IniWrite(state,"data\settings.ini", "States", key)
}	

/*
Get state of element
@param string filename
@param string key
@return boolean
*/
get_state(key :="") {
	state := false
	if(IniRead("data\settings.ini", "States", key) = true) {
		state := true
	}
	return state
}
/*
Grab default txt color from ini file
@param String filename
@return String color code
*/
get_def_txt_color(filename){
	color := IniRead(filename,"Default Settings","txt_color")
	return color
}
/*
Set default location of the track id to ini file
@params int x1, int y1, int x2, int y2
@param String filename
@return void
*/ 
set_default_pos(x1 :="", y1 :="", x2 :="", y2 :="", filename :="", section :=""){
	IniWrite(x1, filename, section, "x1")
    IniWrite(y1, filename, section, "y1")
    IniWrite(x2, filename, section, "x2")
    IniWrite(y2, filename, section, "y2")
}

/*
Get mail from rs_config.ini
@param String filename
@return String email 
*/
get_email(filename :=""){
    result := IniRead(filename,"Email")
    return result
}

/*
Set chat account to be @mentioned
@param String filename
@param String recipient
@return void
*/
set_recipient(filename :="", recipient :=""){
    IniWrite(recipient,filename,"Chat","acc")    
}

/*
Write id to file
Function used to write grabbed id + date to a .txt file to act as history
@param String filename
@param String value
@return void
*/
write_id(filename :="", value :=""){
    FileAppend(value . "->" . A_DD . "-" . A_MM . "-" . A_YYYY,filename)
}

/*
Grab account from ini file 
@param String filename
@return String account
*/
get_acc(filename :="" ){
    result := IniRead(filename,"Account","acc")
    return result
}

/*
Set account to ini file 
@param string filename
@param string value
@return void
*/
set_acc(filename :="", value :=""){
    IniWrite(value, filename, "Account","acc")
}

/*
Grab recipient from ini file
@param String filename 
@return String recipient
*/
get_recipient(filename :=""){
    result := IniRead(filename, "Chat", "acc" )
    return result
}

/*
Grab signature from ini file 
@param String filename
@return String signature
*/
get_sign(filename :=""){
    result := IniRead(filename,"Signature","acc")
    return result
}

/*
Set signature to ini file
@param String filename
@param String signature
@return void
*/
set_sign(filename :="", signature :=""){
    IniWrite(signature, filename,"Signature","acc")
}

/*
Grabs default theme color code from .ini file
@param filename: String file path to .ini file
@return > String with color code
*/
get_default_theme(filename := ""){    
    global def_theme := IniRead( filename, "Default Settings", "theme","")
    Return def_theme
}
/*
Sets default theme color code to .ini file
@param filename: String file path to .ini file
@return void
*/
set_default_theme(filename := "", value := ""){
	if(value = "Light"){
		theme := IniRead(filename, "Themes", "Light")
		txt_color := IniRead(filename, "Themes","Dark")
		IniWrite(theme, filename, "Default Settings", "theme")
		IniWrite(txt_color, filename, "Default Settings", "txt_color")
	}
	if(value = "Dark"){
		theme := IniRead(filename, "Themes", "Dark")
		txt_color := IniRead(filename, "Themes","Light")
		IniWrite(theme, filename, "Default Settings", "theme")
		IniWrite(txt_color, filename, "Default Settings", "txt_color")
	}
/*
TODO: Add support for other themes	
 */
}
/*
Reads items from .ini file and given section and returns array of strings
@param filename: name of ini file, must be string
@param section: name of section, must be string, if omitted, returns all sections
@param key: name of key, must be string, if omitted, returns all items in section
@return: Array of strings
*/ 
get_list(filename :="",section :="",key :=""){
    ; reads ini file => array of strings
    global rej_list := StrSplit(IniRead(filename, section, key,"" ),"`n")
    Return rej_list
}
/*
Send mail macro
@param String subject
@param string body 
@param String filename
*/
mail_send(body, subject, filename){
	try {
		if WinExist("Roundcube"){
			WinActivate
			Sleep(350)
			MouseClick(L, 60, 140)
			A_Clipboard := ""
			A_Clipboard := get_email(filename)
			Sleep(1000)
			Send "^{V}"
			Loop 3{
				Send "{Tab}"
			}
			A_Clipboard:=""
			A_Clipboard := subject 
			Sleep( 100)
			Send "^{V}"
			Send "{Tab}"
			A_Clipboard := ""
			A_Clipboard := body
			Send "^{V}"
			Send "{Tab}"
			Sleep(100)
			
		}
		else
			MsgBox("Mail App not running")		
	} 
	catch Error as e {
		MsgBox("An error has been produced: " . e.Message)
	}
}
/*
Send message macro in chat in the appropiate channel
@param String message
*/
chat_send(message){
	try{
		If WinExist("Data"){
			WinActivate
			Sleep(350)
			Send "^{k}"
			Sleep(300)
			SendText(Respingeri) 
			Sleep(500)
			Send "{Enter}"
			Sleep(1000)
			SendText(1)
			Sleep(150)
			Send "{BackSpace}"
			A_Clipboard := ""
			A_Clipboard := message
			Sleep(1000)
			Send "^{V}"
			Send "^{V}"
		}
		else
			MsgBox("Chat is not open")
	}
	catch Error as e {
		MsgBox("An error has been produced: " . e.Message)
	}
}
/*
Grab track id from position in Cadosys
@params int x1, int y1, int x2, int y2
*/
grab_track_id(x1,y1,x2,y2){
	try {
		/*
		First x1, y2 coordinates are where the selection starts
		*/
		MouseMove( x1, y1, 0)
		Sleep(80)
		A_Clipboard := ""
		Send "#q"
		Sleep(60)
		/*
		Second x2, y2 coordinates are where the selection ends
		*/
		MouseClick("Left", x2,y2)
		MouseMove(70, 400, 0)
	} 
	catch Error as e {
		MsgBox("An error has been produced: " . e.Message)
	}
}

/*
Set track id to counter and write to .txt file
@params Int x1, int y1, int x2, int y2
@param String filename
*/
set_track_id(x1,y1,x2,y2,filename){
	try{

		if !(ProcessExist("Capture2text") = 0){
			if (WinExist("CaptureThis")){
				WinActivate()
				grab_track_id(x1,y1,x2,y2)
				;* writes id to .txt file for history
				FileAppend(A_Clipboard, filename) ; ! Not tested appending to .txt file track id from Clipboard
			}
			;checks for the counter app
			if (WinExist("(")){
				WinActivate()
				A_Clipboard := Trim(A_Clipboard, " ")
				Send "^{V}"
	
				;checks for the CadosysApp
				if (WinExist("CaptureThis")){
					WinActivate()
				}else
					MsgBox("Cadosys not running")
			} else
				MsgBox("Counter not running")
		}else
			Run( A_ScriptDir . "\Capture2Text\Capture2Text.exe")
	}catch Error as e {
		MsgBox("An error has been produced: " . e.Message)
	}
	
}

/*
Start-stop macro for counter
@param int tabs_nr : the amount of {Tabs} to send to counter
*/
stop_start(tabs_nr){ ;is_glass is a boolean value, true if glass is being used, false if not
    if (WinExist("(")) {
        WinActivate()
       Loop tabs_nr{
			Sleep(50)
			Send "{Tab}"
		}
		Loop 2{
			Sleep(50)
			Send "{Enter}"
		}
		Loop 2{
			Send "{Tab}"
		}
	}
	else
		MsgBox("Counter is not running")
}

/*
Runs stop_start() for the appropriate number of tabs based on the activity
@param bool is_fleet
*/
stop_start_activity(is_fleet){
    if (is_fleet = True){
        stop_start(6)
    }
    else{
        stop_start(4)
    }
}
