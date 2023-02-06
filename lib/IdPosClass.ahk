; #Include SettingsClass.ahk
class IdPosClass extends Object {
    settings := SettingsClass()
    expertise := this.mapCoords(settings.expertise)
    fleet := this.mapCoords(settings.fleet)
    glass := this.mapCoords(settings.glassCheck)

    mapCoords(section) {
        result := Map()
        coords := getCoords(settings.expertise)
        i := 1
        while (i <= coords.Length) {
            tempArr := StrSplit(coords[i], "=")
            result.Set(tempArr[1], tempArr[2])
            i += 1
        }
        return result
    }

    /*
    TODO refactor set_pos() to use map
    TODO use camel case naming
    */
    setPos(maped) {

    }

}
getCoords(section, key := "") {

    if (StrLen(key) > 0) {
        result := IniRead("data/settings.ini", section, key)
    } else {
        result := Array()
        source := StrSplit(IniRead("data/settings.ini", section), "`n")

        ; i := 1
        ; while i <= source.Length {
        ;     tempArray := StrSplit(source[i], "=")
        ;     result.Push(tempArray[2])
        ;     i += 1
        ; }
    }
    return source
}