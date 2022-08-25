/************************************************************************
 * @description 
 *  This script will be used to search for the specified resource wihtin the specified file in the specified
 * @file SearchBar.ahk
 * @author Andrei Ivanciu
 * @date 2022/08/24
 * @version 0.0.1
 ***********************************************************************/
search_ui := Gui(
    "-Resize -Caption -Resize -MaximizeBox -MinimizeBox +AlwaysOnTop",
)
search_bar := search_ui.Add("Edit", "w480 h30","")

/*
@param string input
updates the search result list
*/
update_list(input:=""){

}

^Space::{
    search_ui.Show("w500 h50")
    while (){
        update_list(search_bar.Text)
    }
}

Esc::{
    search_ui.Hide()
}   