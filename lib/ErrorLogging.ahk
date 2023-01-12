/************************************************************************
 * @description
 * @file ErrorLogging.ahk
 * @author
 * @date 2023/01/12
 * @version 0.0.0
 ***********************************************************************/


/*
@param {Error} error object
Logs the errors in the specified file
*/
error_logging(error) {
    static logs := "data/error_log.txt"
    FileAppend(error, logs)
    FileAppend("---------------------------------------------", logs)

}