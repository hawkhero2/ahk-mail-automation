/************************************************************************
 * @description Creates a history file
 * @file CreateIdHistory.ahk
 * @author
 * @date 2022/11/17
 * @version 0.0.1
 ***********************************************************************/


/*
Creates the history file to store the ids
*/
create_id_history() {
    FileAppend("", "data/id_history.txt")
}