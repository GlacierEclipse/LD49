package entities;

import haxepunk.math.MathUtil;
import haxepunk.HXP;
import haxepunk.graphics.Image;
import haxepunk.Entity;

class FadeScreen extends Entity
{
    public var targetFadeVal:Float;
    public function new() 
    {
        super(0, 0, Image.createRect(HXP.width, HXP.height, 0x000000, 1.0));

        graphic.scrollX = graphic.scrollY = 0;
        graphic.alpha = 0;
        targetFadeVal = 0;
    }

    override function update() 
    {
        super.update();
        graphic.alpha = MathUtil.lerp(graphic.alpha, targetFadeVal, 0.08);
    }
}