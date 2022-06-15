class Base_UI{
    /*
    *       This class is the main class of the GUI.
    TODO    Continue reading Class documentation for more information.
    */

    static name := ""

;   Destroy UI
    __Destroy(name){
        ;* Destroy the GUI
        ; TODO 
        global

        Gui, %name%:Destroy

        Gui%name% := ""
        Gui%name%_Controls := ""
        Gui%name%_Submit := ""
        
    }

;   Create new UI
    __New(name, title, width, height){
        ;* Create a new GUI
        ; TODO 
        return Gui, %name%:Show, w%width% h%height%, %title%
    }

;   Set UI Color
    __Color(){
        ;* Set the color of the GUI
        ; TODO 
    }

;   Add new Control
    __Add(){
        ;* Add a new element to the GUI
        ; TODO 
    }
}