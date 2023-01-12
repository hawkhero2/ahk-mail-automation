/************************************************************************
 * @description
 * @file ErrorLogging.ahk
 * @author
 * @date 2023/01/12
 * @version 0.0.0
 ***********************************************************************/


/*
@description Logs the errors in the specified file
@param {Error} error object
@return void
*/
error_logging(error) {
    static logs := "data/error_log.txt"
    FileAppend(error, logs)
    FileAppend("---------------------------------------------", logs)

}

test_logging() {
    throw Error()
}