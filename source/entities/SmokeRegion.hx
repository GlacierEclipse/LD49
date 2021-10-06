package entities;

import haxepunk.HXP;
import haxepunk.utils.Ease;
import haxepunk.graphics.emitter.Emitter;
import haxepunk.tweens.misc.NumTween;
import haxepunk.tweens.misc.VarTween;
import haxepunk.Entity;

class SmokeRegion extends Entity
{
    public var smokeMaxSize:Float;
    public var smokeEmitter:Emitter;

    
    public var startY:Float;

    public var tileLanded:Bool;

    public function new(x:Float, y:Float, width:Int) 
    {
        super(x, y);
        type = "smokeRegion";
        setHitbox(width, 0);
        startY = y;

        smokeEmitter = new Emitter("graphics/Smoke.png", 16, 16);
        
        smokeEmitter.newType("smokeTrail", [0]);
        smokeEmitter.setMotion("smokeTrail", -90, height, 0.2, 0, 0, 1.5);
        smokeEmitter.setScale("smokeTrail", 0.4, 0.0);
        smokeEmitter.setAlpha("smokeTrail");

        smokeEmitter.newType("smokeRegion", [0]);
        smokeEmitter.setMotion("smokeRegion", 0, 2.0, 2.0, 360.0, 5.0, 15.0);
        smokeEmitter.setScale("smokeRegion", 0.0, 1.0);
        smokeEmitter.setAlpha("smokeRegion", 0.8, 0.0, Ease.quadInOut);
        //smokeEmitter.emitInRectangle("smokeTrail", x, y, 16, 1);

        graphic = smokeEmitter;
    }

    public function setNewSmokeY(newY:Float) 
    {
        if(newY > y + height)
        {
            setHitbox(width, Std.int(newY - y));
            smokeEmitter.setMotion("smokeTrail", -90, height, 2.0, 0, 0, 4.0);
            if(smokeEmitter.particleCount < 5)
                smokeEmitter.emitInRectangle("smokeTrail", 0, 0, width, 1);
        }
    }

    public function setTileLanded(val:Bool) 
    {
        tileLanded = true;
    }

    override function update() 
    {
        super.update();
        if(World.world.canBeginGame && y < HXP.camera.y - 100)
            HXP.scene.remove(this);

        if(tileLanded)
        {
            if(smokeEmitter.particleCount < 10)
                smokeEmitter.emitInRectangle("smokeRegion", 0, 0, width, height);
        }
    }
}