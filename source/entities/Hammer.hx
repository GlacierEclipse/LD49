package entities;

import haxepunk.math.MathUtil;
import haxepunk.HXP;
import haxepunk.math.MinMaxValue;
import haxepunk.Entity;

class Hammer extends Entity
{
    public var durability:MinMaxValue;

    public function new() 
    {
        super(0, 0);
        visible = false;
        durability = new MinMaxValue(0.0, 100, 100, 10);
    }

    public function canUse() : Bool
    {
        return durability.currentValue - durability.rate > 0;
    }

    public function hit(tileToHit:Tile) : Bool
    {
        //if()
        {
            HXP.scene.camera.shake(0.1, 1);
            durability.clamp();
            var damageDurability = durability.rate;
            tileToHit.damage(damageDurability);
            return true;
        }
        return false;
    }
}