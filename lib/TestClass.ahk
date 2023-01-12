class TestClass extends Object {
    mymsg := ""
    test := "returns string?"

    saysomething() {
        MsgBox(this.mymsg)
    }

    set_mymsg(mymsg) {
        this.mymsg := mymsg
    }
}