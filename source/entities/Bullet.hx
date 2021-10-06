package entities;

import haxepunk.HXP;
import haxepunk.math.MathUtil;
import haxepunk.math.Vector2;

class Bullet extends GameEntity
{
    public var shotByEnemy:Bool;
    public function new(x:Float, y:Float, dir:Vector2, shotByEnemy:Bool = false) 
    {
        super(x, y, "graphics/Bullet.png", 16, 16);
        speed = 12;
        velocity.x = dir.x * speed;
        velocity.y = dir.y * speed;

        setHitbox(6, 2);
        centerOrigin();
        graphic.centerOrigin();

        spriteMap.angle = MathUtil.angle(0, 0, dir.x, dir.y);

        this.shotByEnemy = shotByEnemy;
        if(shotByEnemy)
        {
            type = "bulletEnemy";
        }
        else
            type = "bulletPlayer";
    }

    override function handleCollision() 
    {
        super.handleCollision();
        if(collide("tiles", x + velocity.x, y + velocity.y) != null)
        {
            HXP.scene.remove(this);
        }
    }
}