/************************************************************************
 * @description Creates a history file
 * @file CreateIdHistory.ahk
 * @author Andrei Ivanciu
 * @date 2022/11/17
 * @version 0.0.1
 ***********************************************************************/

class IdHistoryClass extends Class {
    file_location := "data/id_history.txt"

    /*
    Creates the history file to store the ids
    */
    create_id_history() {
        FileAppend("", "data/id_history.txt")
    }
}