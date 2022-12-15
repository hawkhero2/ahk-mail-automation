/************************************************************************
 * @description
 * Work Enhancer v1.0 is an AHK script used to macro some of the work.
 * It uses AutoHotkey beta v2.
 * Its features include:
 * -	Able to grab track id of a file using an Open Source OCR library.
 * -	Macro to automatically stop-start current job in counter app used to track time.
 * -	Send formatted messaged containing track id to internal chat @-ing a specific user.
 * -	Send emails macro.
 * -	Light and Dark Theme Support.
 * - 	Manually set the location of the track id via settings ui.
 * -	Storing previous track ids in a file.
 * -   Run at startup.
 * -   Hotstrings.
 * @file Work Enhancer
 * @author Andrei Ivanciu
 * @date 2022/12/15
 * @version 0.1.3
 ***********************************************************************/


/*
 *                                              IMPORTS
*/

#Include lib\Functions.ahk
#Include lib\RunAtStartUp.ahk
; ------------------------------------------------------------------------

run_at_startup()

/*
*												GLOBAL VARIABLES
*/

global SETTINGS_FILE := "data/settings.ini"
global ID_HISTORY := "data/id_history.txt"
global DEFAULT_THEME := get_default_theme(SETTINGS_FILE)
global RS_CFG := "data/rs_config.ini"

global TXT_COLOR := "C" . get_def_txt_color(SETTINGS_FILE)
global SETTINGS_SIZE := "w600 h240"
global MAIN_SIZE := "w600 h270"
global BUTTON_SIZE := "w90 h30"
global NUMBERS_ONLY := "0x2000"
global CENTER_INPUT := "0x1"
global ACC := get_acc(SETTINGS_FILE)
global SIGN := get_sign(SETTINGS_FILE)
global RECIPIENT := get_recipient(SETTINGS_FILE)
global EMAIL := get_email(RS_CFG)
global CURRENT_DATE := A_DD . "-" . A_MM . "-" . A_YYYY
global THEME_LIST := ["Light", "Dark"]


/*
*                                               MAIN UI
*/

main_ui := Gui("-Resize -MaximizeBox", "Work Enhancer v1.0")

; *             TRACK ID
track_id_lbl := main_ui.Add("Text", "x140 y15 " . TXT_COLOR, "Track Id")
track_id := main_ui.Add("Edit", "0x2000 0x1 vtrack_id x10 y10", "")

; *             DOPPELT NR
doppelt_nr_lbl := main_ui.Add("Text", "x140 y55 " . TXT_COLOR, "Doppelt Number")
doppelt_nr := main_ui.Add("Edit", NUMBERS_ONLY . " " . CENTER_INPUT . " " . "vdoppelt_nr x10 y50 ", "")

; *             DOPPELT DATE
doppelt_date_lbl := main_ui.Add("Text", "x140 y95 " . TXT_COLOR, "Doppelt Date")
doppelt_date := main_ui.Add("Edit", CENTER_INPUT . " " . "vdoppelt_date x10 y90", "")

; *             DIFFERENCE
diff_lbl := main_ui.Add("Text", "x140 y135 " . TXT_COLOR, "Difference")
diff_val := main_ui.Add("Edit", " " . CENTER_INPUT . " " . "vdifference_val x10 y130", "")

; *             RADIO BUTTONS
list_radio := main_ui.Add("Radio", " x260 y15 " . TXT_COLOR, "List")
doppelt_radio := main_ui.Add("Radio", " x260 y35 " . TXT_COLOR, "Doppelt")
doppelt2_radio := main_ui.Add("Radio", " x260 y55 " . TXT_COLOR, "Doppelt v2")
diff_radio := main_ui.Add("Radio", " x260 y75 " . TXT_COLOR, "Difference")
kurze_radio := main_ui.Add("Radio", " x260 y95 " . TXT_COLOR, "Doppelt Kurze")
list_radio.Value := 1
; *             DROPDOWN REJECTION LIST
arr_rej_list := get_list(RS_CFG, "Rejection")
rejections_lbl := main_ui.Add("Text", "x10 y174 " . TXT_COLOR, "Rejection Reason")
reject_reason := main_ui.Add("DropDownList", "vreject_reason w580 x10 " . TXT_COLOR, arr_rej_list)

; checkbox_fleet := main_ui.Add("Checkbox", "vcheckbox_fleet x260 y130 " . TXT_COLOR, "Fleet Processesing ?")

; *             RADIO BUTTONS ACTIVITY
processing_lbl := main_ui.Add("Text", "x360 y13 " . TXT_COLOR, "Processing:")
ec_radio := main_ui.Add("Radio", "x360 y35 " . TXT_COLOR, "EC / IC")
ec_radio.Value := 1
fleet_radio := main_ui.Add("Radio", "x360 y55 " . TXT_COLOR, "FLEET")
gc_radio := main_ui.Add("Radio", "x360 y75 " . TXT_COLOR, "GC")
; *             DROPDOWN LIST FOR FLEET ACTIVITY (LIFE / TEST)
fleet_ddl_items := ["LIVE", "TEST"]
fleet_activ_ddl := main_ui.Add("DropDownList", "x430 y50 " . TXT_COLOR, fleet_ddl_items)
fleet_activ_ddl.Choose("LIVE")
main_ui.Add("Button", BUTTON_SIZE . A_Space . "x10 y220", "Send Mail").OnEvent("Click", send_email_listener)
main_ui.Add("Button", BUTTON_SIZE . A_Space . "x120 y220", "Send Chat").OnEvent("Click", send_chat_listener)
main_ui.Add("Button", BUTTON_SIZE . A_Space . "x230 y220", "Settings").OnEvent("Click", settings_btn_listener)
main_ui.Add("Button", BUTTON_SIZE . A_Space . "x340 y220", "Copy").OnEvent("Click", copy_btn_listener)
; main_ui.Add("Button", BUTTON_SIZE . A_Space . "x340 y220", "Browse").OnEvent("Click", browse_btn_listener)
main_ui.OnEvent("Close", main_close)
main_ui.Show(MAIN_SIZE)
main_ui.BackColor := DEFAULT_THEME
/*
browse_btn_listener(*) {
    pick_file := FileSelect()    ; returns the path of the file selected
    ; could be used for a feature?
}
*/
; *         TEST BUTTON
main_ui.Add("Button", BUTTON_SIZE . A_Space . "x450 y220", "Test").OnEvent("Click", test_btn_listener)
test_btn_listener(*) {
    ; coords := get_list(SETTINGS_FILE, "Track Id Location")    ; returns the coordinates
    coords := get_coords(SETTINGS_FILE, "Track Id Location", "x")
    ; set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY)
}
/*
*                                             SETTINGS UI
*/
settings_ui := Gui("-Resize -MaximizeBox", "Settings", settings_ui_listener := [])
settings_ui.OnEvent("Close", settings_close)
tabs := settings_ui.Add("Tab2", "w580", ["Info", "Hotkeys"])
misc := settings_ui.Add("GroupBox", "x290 y40 w250 h110 " . TXT_COLOR, "Misc")
id_pos := settings_ui.Add("GroupBox", "x15 y40 w250 h110 " . TXT_COLOR, "Track Id Position")
tabs.UseTab()
; *             SAVE BUTTON
settings_ui.Add("Button", "x20 y190 Default" . A_Space . BUTTON_SIZE, "Save").OnEvent("Click", save_btn_listener)
; *             CANCEL BUTTON
settings_ui.Add("Button", "x120 y190" . A_Space . BUTTON_SIZE, "Cancel").OnEvent("Click", cancel_btn_listener)
tabs.UseTab(1)
; *                  ID LOCATION
def_pos_lbl := settings_ui.Add("Text", "x115 y65 " . TXT_COLOR, "Set default track id location")
settings_ui.Add("Button", "x20 y60" . A_Space . BUTTON_SIZE, "Set").OnEvent("Click", set_btn_listener)
; *             FLEET ID LOCATION
fleet_pos_lbl := settings_ui.Add("Text", "x115 y115 " . TXT_COLOR, "Set Fleet track id location")
settings_ui.Add("Button", "x20 y110" . A_Space . BUTTON_SIZE, "Set").OnEvent("Click", set_fleet_btn_listener)
; *            RUN AT STARTUP
settings_ui.Add("Button", "x220 y190" . A_Space . BUTTON_SIZE, "Run at startup").OnEvent("Click", run_at_startup_listener)
; *             ACCOUNT
acc_lbl := settings_ui.Add("Text", "x440 y60 " . TXT_COLOR, "Account")
acc_field := settings_ui.Add("Edit", CENTER_INPUT . " " . "vaccount w90 x330 y55", ACC)
; *             RECIPIENT
recip_lbl := settings_ui.Add("Text", "x440 y90 " . TXT_COLOR, "Chat Recipient")
chat_acc := settings_ui.Add("Edit", CENTER_INPUT . " " . "vrecipient w90 x330 y85", RECIPIENT)
; *             SIGNATURE
sign_lbl := settings_ui.Add("Text", "x440 y120 " . TXT_COLOR, "Signature")
signature_field := settings_ui.Add("Edit", CENTER_INPUT . " " . "vsignature w90 x330 y115", SIGN)
/*
*               THEME
*/
theme_lbl := settings_ui.Add("Text", "x440 y165 " . TXT_COLOR, "Theme")
theme_field := settings_ui.Add("DDL", "vtheme w90 x330 y160", THEME_LIST)
tabs.UseTab(2)
hotkeys := settings_ui.Add("GroupBox", "x10 y40 w250 h110 " . TXT_COLOR, "Track Id Hotkeys")
mbutton := settings_ui.Add("Checkbox", "x15 y60 " . TXT_COLOR, "Middle Mouse Button")
x1btn := settings_ui.Add("Checkbox", "x15 y80 " . TXT_COLOR, "Side Button 1")
x2btn := settings_ui.Add("Checkbox", "x15 y100 " . TXT_COLOR, "Side Button 2")
scrlock := settings_ui.Add("Checkbox", "x15 y120 " . TXT_COLOR, "Scroll Lock")
ss_macro := settings_ui.Add("GroupBox", "x290 y40 w250 h110 " . TXT_COLOR, "Start/Stop Macro")
pausebreak := settings_ui.Add("Checkbox", "x300 y60 " . TXT_COLOR, "Pause Break")
fseven := settings_ui.Add("Checkbox", "x300 y80 " . TXT_COLOR, "F7")
mbutton.Value := get_state("mbutton")
x1btn.Value := get_state("x1button")
x2btn.Value := get_state("x2button")
scrlock.Value := get_state("scrllock")
pausebreak.Value := get_state("pausebreak")
fseven.Value := get_state("fseven")
/*
*                                             LISTENERS
*/
copy_btn_listener(*) {
    if (list_radio.Value = 1) {
        A_Clipboard := ""
        A_Clipboard := reject_reason.Text
    } else if (doppelt_radio.Value = 1) {
        A_Clipboard := ""
        A_Clipboard := "Dieser Vorgang wurde bereits am " . doppelt_date.Text . " unter Vorgang " . doppelt_nr.Value . " geprüft. Die Ergebnisberichte aus der vorangegangen Prüfung sind als eigene Dokumente beigefügt"
    } else if (doppelt2_radio.Value = 1) {
        A_Clipboard := ""
        A_Clipboard := "Hello,`n`nDoppelt " . track_id.Value . " - " . " Dieser Vorgang wurde bereits unter Vorgang " . doppelt_nr.Value . " geprüft. `n`n`nBest Regards,`n" . get_sign(SETTINGS_FILE) . "`nDatamondial"
    } else if (kurze_radio.Value = 1) {
        A_Clipboard := ""
        A_Clipboard := " Der Vorgang steht unter der Vorgangsnummer " . doppelt_nr.Value . " zur Prüfung an. Ein entsprechender Prüfbericht folgt in Kürze."
    } else if (diff_radio.Value = 1) {
        A_Clipboard := ""
        A_Clipboard := "Der Kostenvoranschlag ist leider nicht vollständig. In der Kalkulation ist eine Differenz von " . diff_val.Value . "€. Bitte senden Sie uns den Vorgang vollständig erneut zur Prüfung zu. Vielen Dank!"
    } else {
        MsgBox("Please select one of the options: `nList`nDoppelt`nDoppelt v2`nDifference`nDoppelt Kurze")
    }
}
settings_close(*) {
    settings_ui.Hide()
    main_ui.Show(MAIN_SIZE)
    main_ui.BackColor := get_default_theme(SETTINGS_FILE)
}
main_close(*) {
    ExitApp
}
save_btn_listener(*) {
    set_acc(SETTINGS_FILE, acc_field.Text)
    set_sign(SETTINGS_FILE, signature_field.Text)
    set_recipient(SETTINGS_FILE, chat_acc.Text)
    set_default_theme(SETTINGS_FILE, theme_field.Text)
    settings_ui.Hide()
    main_ui.Show(MAIN_SIZE)
    main_ui.BackColor := get_default_theme(SETTINGS_FILE)
    TXT_COLOR := "C" . get_def_txt_color(SETTINGS_FILE)
    set_state("mbutton", mbutton.Value)
    set_state("x1button", x1btn.Value)
    set_state("x2button", x2btn.Value)
    set_state("scrllock", scrlock.Value)
    set_state("pausebreak", pausebreak.Value)
    set_state("fseven", fseven.Value)
    /*
    * Reload the color for the text labels
    */
    track_id_lbl.SetFont(TXT_COLOR)
    doppelt_nr_lbl.SetFont(TXT_COLOR)
    doppelt_date_lbl.SetFont(TXT_COLOR)
    diff_lbl.SetFont(TXT_COLOR)
    list_radio.SetFont(TXT_COLOR)
    doppelt_radio.SetFont(TXT_COLOR)
    doppelt2_radio.SetFont(TXT_COLOR)
    diff_radio.SetFont(TXT_COLOR)
    kurze_radio.SetFont(TXT_COLOR)
    rejections_lbl.SetFont(TXT_COLOR)
    ec_radio.SetFont(TXT_COLOR)
    fleet_radio.SetFont(TXT_COLOR)
    gc_radio.SetFont(TXT_COLOR)
    ; checkbox_fleet.SetFont(TXT_COLOR)
    misc.SetFont(TXT_COLOR)
    id_pos.SetFont(TXT_COLOR)
    def_pos_lbl.SetFont(TXT_COLOR)
    fleet_pos_lbl.SetFont(TXT_COLOR)
    acc_lbl.SetFont(TXT_COLOR)
    recip_lbl.SetFont(TXT_COLOR)
    sign_lbl.SetFont(TXT_COLOR)
    theme_lbl.SetFont(TXT_COLOR)
    mbutton.SetFont(TXT_COLOR)
    x1btn.SetFont(TXT_COLOR)
    x2btn.SetFont(TXT_COLOR)
}
send_email_listener(*) {
    subject := track_id.Value . A_Space . CURRENT_DATE . "," . A_Space . get_acc(SETTINGS_FILE)
    if (list_radio.Value = 1) {
        body := "Hello, `n`n" . track_id.Value . " - " . reject_reason.Text . "`n`n`nBest Regards,`n" . get_sign(SETTINGS_FILE) . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    } else if (doppelt_radio.Value = 1) {
        body := "Hello,`n`nDoppelt" . A_Space . track_id.Value . "-" . "Dieser Vorgang wurde bereits am " . doppelt_date.Text . A_Space . " unter Vorgang " . doppelt_nr.Value . " geprüft. Die Ergebnisberichte aus der vorangegangen Prüfung sind als eigene Dokumente beigefügt `n`n`nBest Regards,`n" . get_sign(SETTINGS_FILE) . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    } else if (doppelt2_radio.Value = 1) {
        body := "Hello,`n`nDoppelt" . track_id.Value . "-" . " Dieser Vorgang wurde bereits unter Vorgang " . doppelt_nr.Value . " geprüft. `n`n`nBest Regards,`n" . get_sign(SETTINGS_FILE) . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    } else if (diff_radio.Value = 1) {
        body := "Hello, `n`n" . track_id.Value . " Difference of " . diff_val.Value . "€ - Der Kostenvoranschlag ist leider nicht vollständig. In der Kalkulation ist eine Differenz von " . diff_val.Value . "€. Bitte senden Sie uns den Vorgang vollständig erneut zur Prüfung zu. Vielen Dank!`n`n`nBest Regards,`n" . get_sign(SETTINGS_FILE) . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    } else if (kurze_radio.Value = 1) {
        body := "Hello,`n`nDoppelt " . track_id.Value . "-" . " Der Vorgang steht unter der Vorgangsnummer " . doppelt_nr.Value . " zur Prüfung an. Ein entsprechender Prüfbericht folgt in Kürze.`n`n`nBest Regards,`n" . get_sign(SETTINGS_FILE) . "`nDatamondial"
        mail_send(body, subject, RS_CFG)
    } else {
        MsgBox("Please select an option")
    }
}
send_chat_listener(*) {
    if (list_radio.Value = 1) {
        body := get_recipient(SETTINGS_FILE) . A_Space . track_id.Value . "-" . A_Space . reject_reason.Text
        chat_macro(body)
    } else if (doppelt_radio.Value = 1) {
        body := get_recipient(SETTINGS_FILE) . A_Space . track_id.Value . "-" . " Dieser Vorgang wurde bereits am " . doppelt_date.Text . " unter Vorgang " . doppelt_nr.Value . " geprüft. Die Ergebnisberichte aus der vorangegangen Prüfung sind als eigene Dokumente beigefügt"
        chat_macro(body)
    } else if (doppelt2_radio.Value = 1) {
        body := get_recipient(SETTINGS_FILE) . A_Space . track_id.Value . "-" . " Dieser Vorgang wurde bereits unter Vorgang " . doppelt_nr.Value . " geprüft."
        chat_macro(body)
    } else if (diff_radio.Value = 1) {
        body := get_recipient(SETTINGS_FILE) . A_Space . track_id.Value . " Difference of" . diff_val.Value . "€ - Der Kostenvoranschlag ist leider nicht vollständig. In der Kalkulation ist eine Differenz von " . diff_val.Value . "€. Bitte senden Sie uns den Vorgang vollständig erneut zur Prüfung zu. Vielen Dank!"
        chat_macro(body)
    } else if (kurze_radio.Value = 1) {
        body := get_recipient(SETTINGS_FILE) . A_Space . track_id.Value . "-" . " Der Vorgang steht unter der Vorgangsnummer " . doppelt_nr.Value . " zur Prüfung an. Ein entsprechender Prüfbericht folgt in Kürze."
        chat_macro(body)
    } else {
        MsgBox("Please select an option")
    }
}
cancel_btn_listener(*) {
    settings_ui.Hide()
    main_ui.Show()
}
set_btn_listener(*) {
    MsgBox("Make a diagonal selection of where the track id is positioned then click save")
    KeyWait("LButton", "D")
    MouseGetPos(&cstm_x1, &cstm_y1)
    KeyWait("LButton", "U")
    MouseGetPos(&cstm_x2, &cstm_y2)
    set_default_pos(cstm_x1, cstm_y1, cstm_x2, cstm_y2, SETTINGS_FILE, "Track Id Location")
    MsgBox("Position set")
}
set_fleet_btn_listener(*) {
    MsgBox("Make a diagonal selection of where the track id is positioned then click save")
    KeyWait("LButton", "D")
    MouseGetPos(&cstm_x1, &cstm_y1)
    KeyWait("LButton", "U")
    MouseGetPos(&cstm_x2, &cstm_y2)
    set_default_pos(cstm_x1, cstm_y1, cstm_x2, cstm_y2, SETTINGS_FILE, "Fleet Track Id Location")
    MsgBox("Position set")
}
settings_btn_listener(*) {
    main_ui.Hide()
    settings_ui.Show(SETTINGS_SIZE)
    settings_ui.BackColor := get_default_theme(SETTINGS_FILE)
}
run_at_startup_listener(*) {
    if (FileExist(A_Startup . "\Work Enhancer.ink")) {
        MsgBox("Work Enhancer is already set to run at startup")
    } else {
        FileCreateShortcut(A_ScriptFullPath, A_Startup "\Work Enhancer.lnk")
    }
}
/*
*                                               HOTKEYS
*/
MButton:: {
    try {
        if (get_state("mbutton")) {
            if (ec_radio.Value = 1) {

                coords := get_coords(SETTINGS_FILE, "Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)

            } else if (fleet_radio.Value = 1) {

                coords := get_coords(SETTINGS_FILE, "Fleet Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)

            } else if (gc_radio.Value = 1) {

                coords := get_coords(SETTINGS_FILE, "GC Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)
            }
        }
    } catch Error as e {
        MsgBox(e.Message)
    }
}
XButton2:: {
    try {
        if (get_state("x2button")) {
            if (ec_radio.Value = 1) {
                coords := get_coords(SETTINGS_FILE, "Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)

            } else if (fleet_radio.Value = 1) {

                coords := get_coords(SETTINGS_FILE, "Fleet Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)

            } else if (gc_radio.Value = 1) {

                coords := get_coords(SETTINGS_FILE, "GC Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)

            }
        }
    } catch Error as e {
        MsgBox(e.Message)
    }
}
ScrollLock:: {
    try {
        if (get_state("scrllock")) {
            if (ec_radio.Value = 1) {

                coords := get_coords(SETTINGS_FILE, "Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)

            } else if (fleet_radio.Value = 1) {

                coords := get_coords(SETTINGS_FILE, "Fleet Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)

            } else if (gc_radio.Value = 1) {

                coords := get_coords(SETTINGS_FILE, "GC Track Id Location")
                set_track_id(coords[1], coords[2], coords[3], coords[4], ID_HISTORY, fleet_radio.Value, fleet_activ_ddl.Text)

            }
        }
    } catch Error as e {
        MsgBox(e.Message)
    }
}
XButton1:: {
    if (get_state("x1button")) {
        loop {
            if (GetKeyState("XButton1", "P") = true) {
                SendInput("{Enter}")
                Sleep(50)
            } else {
                break
            }
        }
    }
}
Pause:: {
    try {
        ; checks if the hotkey is enabled
        if (get_state("pausebreak")) {
            ; checks if the checkbox for fleet is enable and if the an activity was chosen
            if (fleet_radio.Value = 1 && fleet_activ_ddl.Value = 0) {
                MsgBox("Please select an activity from the dropdown menu next to the checkbox, you can pick either LIVE or TEST")
            }
            else if (fleet_radio.Value = 1 && fleet_activ_ddl.Value = 1) {
                stop_start(fleet_radio.Value)
            }
            else {
                stop_start(fleet_radio.Value)
            }
        }
    } catch Error as e {
        MsgBox(e.Message)
    }
}
F7:: {
    try {
        ; checks if the hotkey is enabled
        if (get_state("fseven")) {
            ; checks if the checkbox for fleet is  enable and if the an activity was chosen
            if (fleet_radio.Value = 1 && fleet_activ_ddl.Value = 0) {
                MsgBox("Please select an activity from the dropdown menu next to the checkbox, you can pick either LIVE or TEST")
            }
            else if (fleet_radio.Value = 1 && fleet_activ_ddl.Value = 1) {
                stop_start(fleet_radio.Value)
            }
            else {
                stop_start(fleet_radio.Value)
            }
        }
    } catch Error as e {
        MsgBox("Error ocurred while running F7 macro: " . e.Message)
    }
}
/*
 put id -> 4 tabs put live -> 5 tabs to return back to file id field
 6 tabs from file id to stop button
*/
