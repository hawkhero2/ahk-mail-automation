class GUI{
    Destroy(name){
        ;* Destroy the GUI
        ; TODO 
        global

        Gui, %name%:Destroy

        Gui%name% := ""
        Gui%name%_Controls := ""
        Gui%name%_Submit := ""
        
    }

    New(){
        ;* Create a new GUI
        ; TODO 

    }

    Color(){
        ;* Set the color of the GUI
        ; TODO 
    }

    Add(){
        ;* Add a new element to the GUI
        ; TODO 
    }
}