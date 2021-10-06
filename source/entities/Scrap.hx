package entities;

import haxepunk.HXP;
import haxepunk.math.MathUtil;

class Scrap extends GameEntity
{
    public function new(x:Float, y:Float) 
    {
        super(x, y, "graphics/Scrap.png", 16, 16);

        setHitbox(4,4);
        centerOrigin();
        graphic.centerOrigin();
    }

    override function update() 
    {
        super.update();
        
        
        
    }

    override function handleMovement() 
    {
        super.handleMovement();

        var distanceToPlayer:Float = distanceToPoint(Player.playerInstance.x, Player.playerInstance.y);
        if(distanceToPlayer < 15.0)
        {
            x = MathUtil.lerp(x, Player.playerInstance.x, 0.08);
            y = MathUtil.lerp(y, Player.playerInstance.y, 0.08);
        }

        velocity.y += gravity;
    }

    override function handleCollision() 
    {
        super.handleCollision();
        if(collideWith(Player.playerInstance, x, y) != null)
        {
            Player.playerInstance.addScrap();
            HXP.scene.remove(this);
        }

        var collidedEntity = collide("tiles", x + velocity.x, y);
        if(collidedEntity != null)
        {
            if(velocity.x > 0)
            {
                x = collidedEntity.x - halfWidth;
            }

            else if(velocity.x < 0)
            {
                x = collidedEntity.right + halfWidth;
            }
            velocity.x = 0;
        }

        collidedEntity = collide("tiles", x, y + velocity.y);
        if(collidedEntity != null)
        {
            if(velocity.y >= 0)
            {
                // Destroy scrap if fell too high
                //if(velocity.y > 1.0)
                //{
                //    HXP.scene.remove(this);
                //}
                velocity.y = 0;
                
                y = collidedEntity.y - halfHeight;

            }
            else if(velocity.y < 0)
            {
                velocity.y = 0.1;
                y = collidedEntity.bottom + halfHeight;
            }
        }
    }
}