package entities;

import haxepunk.math.MinMaxValue;
import haxepunk.Entity;

class GasMask extends Entity
{
    public var filterValue:MinMaxValue;
    public function new() 
    {
        super(0, 0);
        filterValue = new MinMaxValue(0.0, 100.0, 100.0, 10 / 60.0);
    }

    public function canUseMask() : Bool
    {
        return filterValue.currentValue > 0;
    }

    public function useMask() 
    {
        filterValue.currentValue -= filterValue.rate;
        filterValue.clamp();
    }
}