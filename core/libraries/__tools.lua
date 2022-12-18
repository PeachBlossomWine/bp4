local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}

    -- Private Variables.
    local __tools = {
        
        ["Mono"] = {cast={"Shikanofuda","Sanjaku-Tenugui"}, toolbags={"Toolbag (Shika)","Toolbag (Sanja)"}},
        ["Aish"] = {cast={"Chonofuda","Soshi"}, toolbags={"Toolbag (Cho)","Toolbag (Soshi)"}},
        ["Kato"] = {cast={"Inoshishinofuda","Uchitake"}, toolbags={"Toolbag (Ino)","Toolbag (Uchi)"}},
        ["Hyot"] = {cast={"Inoshishinofuda","Tsurara"}, toolbags={"Toolbag (Ino)","Toolbag (Tsura)"}},
        ["Huto"] = {cast={"Inoshishinofuda","Kawahori-Ogi"}, toolbags={"Toolbag (Ino)","Toolbag (Kawa)"}},
        ["Doto"] = {cast={"Inoshishinofuda","Makibishi"}, toolbags={"Toolbag (Ino)","Toolbag (Maki)"}},
        ["Rait"] = {cast={"Inoshishinofuda","Hiraishin"}, toolbags={"Toolbag (Ino)","Toolbag (Hira)"}},
        ["Suit"] = {cast={"Inoshishinofuda","Mizu-Deppo"}, toolbags={"Toolbag (Ino)","Toolbag (Mizu)"}},
        ["Utsu"] = {cast={"Shikanofuda","Shihei"}, toolbags={"Toolbag (Shika)","Toolbag (Shihe)"}},
        ["Juba"] = {cast={"Chonofuda","Jusatsu"}, toolbags={"Toolbag (Cho)","Toolbag (Jusa)"}},
        ["Hojo"] = {cast={"Chonofuda","Kaginawa"}, toolbags={"Toolbag (Cho)","Toolbag (Kagi)"}},
        ["Kura"] = {cast={"Chonofuda","Sairui-Ran"}, toolbags={"Toolbag (Cho)","Toolbag (Sai)"}},
        ["Doku"] = {cast={"Chonofuda","Kodoku"}, toolbags={"Toolbag (Cho)","Toolbag (Kodo)"}},
        ["Tonk"] = {cast={"Shikanofuda","Shinobi-Tabi"}, toolbags={"Toolbag (Shika)","Toolbag (Shino)"}},
        ["Gekk"] = {cast={"Shikanofuda","Ranka"}, toolbags={"Toolbag (Shika)","Toolbag (Ranka)"}},
        ["Yain"] = {cast={"Shikanofuda","Furusumi"}, toolbags={"Toolbag (Shika)","Toolbag (Furu)"}},
        ["Myos"] = {cast={"Shikanofuda","Kabenro"}, toolbags={"Toolbag (Shika)","Toolbag (Kaben)"}},
        ["Yuri"] = {cast={"Chonofuda","Jinko"}, toolbags={"Toolbag (Cho)","Toolbag (Jinko)"}},
        ["Kakk"] = {cast={"Shikanofuda","Ryuno"}, toolbags={"Toolbag (Shika)","Toolbag (Ryuno)"}},
        ["Miga"] = {cast={"Shikanofuda","Mokujin"}, toolbags={"Toolbag (Shika)","Toolbag (Moku)"}},
    
    }
  
    -- Public Methods.
    self.get = function(spell) return (spell and __tools[spell:sub(1,4)]) and __tools[spell:sub(1,4)] or __tools end

    return self

end
return library