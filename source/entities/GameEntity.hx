package entities;

import haxepunk.tweens.misc.Alarm;
import haxepunk.graphics.GraphicColorMask.GraphicTypes;
import haxepunk.graphics.Spritemap;
import haxepunk.math.Vector2;
import haxepunk.Entity;

class GameEntity extends Entity
{
    public var gravity:Float;
    public var speed:Float;
    public var spriteMap:Spritemap;

    public var startDestroyAlarm:Alarm;
    public var hp:Float;

    public function new(x:Float, y:Float, sourceImage:String, width:Int, height:Int) 
    {
        super(x, y);

        spriteMap = new Spritemap(sourceImage, width, height);
        graphic = spriteMap;

        initGraphicColorMask(GraphicTypes.Spritemap, sourceImage, Globals.gameScene);

        setHitbox(width, height);


        gravity = 0.17;

        startDestroyAlarm = new Alarm(0.0, destroy);

        addTween(startDestroyAlarm);
        hp = 1;

    }

    public function initVars() 
    {
        
    }

    public function damage(damage:Float) 
    {
        hp -= damage;
        if(hp <= 0)
            startDestroy();
    }

    public function isDestroying() 
    {
        return startDestroyAlarm.active;
    }

    override function update() 
    {
        super.update();
        handleMovement();
        handleCollision();
        applyVelocity();
    }

    public function handleMovement() 
    {
        
    }

    public function handleCollision()
    {

    }

    public function startDestroy() 
    {
        
    }

    public function destroy() 
    {

    }

    public function applyVelocity() 
    {
        x += velocity.x;    
        y += velocity.y;    
    }
}