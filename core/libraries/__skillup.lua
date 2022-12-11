local library = {}
function library:new(bp)
    local bp = bp
    local pm = {}
  
    -- Private Variables.
    local __skills = {
        
        ['Divine Magic']        = {spells={'Banish','Flash','Banish II','Enlight','Repose'}, target='t'},
        ['Enhancing Magic']     = {spells={'Barfire','Barfira','Barblizzard','Barblizzara','Baraero','Baraera','Barstone','Barstonra','Barthunder','Barthundra','Barwater','Barwatera'}, target='me'},
        ['Enfeebling Magic']    = {spells={'Bind','Blind','Dia','Poison','Gravity','Slow','Silence'}, target='t'},
        ['Elemental Magic']     = {spells={'Stone'}, target='t'},
        ['Dark Magic']          = {spells={'Aspir','Aspir II','Bio','Bio II','Drain','Drain II'}, target='t'},
        ['Singing']             = {spells={"Mage's Ballad","Mage's Ballad II","Mage's Ballad III"}, target='me'},
        ['Summoning']           = {spells={'Carbuncle'}, target='me'},
        ['Blue Magic']          = {spells={'Cocoon','Pollen'}, target='me'},
        ['Geomancy']            = {spells={'Indi-Refresh'}, target='me'},        
        
    }

    -- Public Methods.
    self.get = function(skill) return (skill and __tools[skill]) and __tools[skill] or __skills end

    return self

end
return library