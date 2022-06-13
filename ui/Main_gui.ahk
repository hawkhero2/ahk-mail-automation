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
/*
DDL for rejection messages,
populated from rs_config.ini
*/
IniRead, IniOutput, rs_config.ini, Rejection,
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