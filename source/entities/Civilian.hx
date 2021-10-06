package entities;

import haxepunk.tweens.misc.MultiVarTween;
import haxepunk.math.MinMaxValue;
import haxepunk.HXP;
import haxepunk.math.Vector2;
import haxepunk.math.Random;
import haxepunk.tweens.misc.Alarm;
import haxepunk.math.MathUtil;
import haxepunk.Entity;

class Civilian extends GameEntity
{
    public var onGround:Bool;

    public var followingPlayer:Bool;

    public var coolDown:MinMaxValue;

    public var dirToPlayer:Vector2;

    public var destroyedTween:MultiVarTween;

    public var pickUpTween:MultiVarTween;

    public var destroyed:Bool;

    public var saved:Bool;

    public function new(x:Float, y:Float, cooldownDuration:Float) 
    {
        super(x, y, "graphics/Civilian.png", 16, 16);

        setHitbox(8, 16, 0, 0);

        centerOrigin();
        graphic.centerOrigin();

        speed = 1.2;

        coolDown = new MinMaxValue(0.0, cooldownDuration + Random.random * 2.0, 0.0, 0.0);
        coolDown.initToMax();

        dirToPlayer = new Vector2();

        type = "civilian";

        destroyedTween = new MultiVarTween();
        pickUpTween = new MultiVarTween();
        
        addTween(destroyedTween, false);
        addTween(pickUpTween, false);
    }

    override function update() 
    {
        super.update();

        
        if(Player.playerInstance.y > y - 16)
        {
            followingPlayer = true;
        }
    }

    override function handleMovement() 
    {
        super.handleMovement();

        if(!destroyed && followingPlayer)
        {
            /*
            var distanceToPlayer:Float = distanceToPoint(Player.playerInstance.x, Player.playerInstance.y);
            if(distanceToPlayer > 50.0)
            {
                var dirX:Float = Player.playerInstance.x - x;
                if(dirX > 0)
                {
                    velocity.x = MathUtil.lerp(velocity.x, speed, 0.2);
                }
                else
                {
                    velocity.x = MathUtil.lerp(velocity.x, -speed, 0.2);
                }
            }
            else
                velocity.x = MathUtil.lerp(velocity.x, 0.0, 0.2);
            
            coolDown.currentValue -= HXP.elapsed;
            coolDown.clamp();
            if(coolDown.currentValue <= 0.5 && coolDown.currentValue > 0.4)
            {
                graphicColorMask.startMask(0.2, 0xFFFFFF);
                dirToPlayer.setTo(Player.playerInstance.x - x, Player.playerInstance.y - y);
                dirToPlayer.normalize();
            }

            if(coolDown.currentValue <= 0.0)
            {
                shoot();
            }
            */


        }
        //if(destroyed)
        //    velocity.x = MathUtil.lerp(velocity.x, 0.0, 0.08);


        if(!saved && !destroyed)
        {
            var distanceToPlayer:Float = distanceToPoint(Player.playerInstance.x, Player.playerInstance.y);
            if(distanceToPlayer < 15.0)
            {
                var randAngle:Float = 25.0 + (Random.random * 65.0);
                randAngle *= (Random.randInt(2) == 0 ? -1 : 1);
                spriteMap.scaleX = 0.5;
                destroyedTween.tween(spriteMap, {angle: randAngle}, 0.2);
                destroyedTween.start();

                pickUpTween.tween(spriteMap, {scaleX: 1.0}, 0.2);
                pickUpTween.start();
                graphicColorMask.startMask(0.2, 0xffffff);
                saved = true;
            }
            velocity.y += gravity;
        }
        else if(saved)
        {
            var distanceToPlayer:Float = distanceToPoint(Player.playerInstance.x, Player.playerInstance.y);
            if(distanceToPlayer > 8.0)
            {
                x = MathUtil.lerp(x, Player.playerInstance.x, 0.3);
                y = MathUtil.lerp(y, Player.playerInstance.y, 0.3);
            }
            else
            {
                x = MathUtil.lerp(x, Player.playerInstance.x, 0.09);
                y = MathUtil.lerp(y, Player.playerInstance.y, 0.09);
            }
        }

        if(destroyed)
            velocity.y += gravity;

        
    }

    public function shoot() 
    {

        HXP.scene.add(new Bullet(x, y, dirToPlayer, true));
        coolDown.initToMax();
    }
    
    override function handleCollision() 
    {
        super.handleCollision();

        if(saved)
            return;
        onGround = false;

        var collidedEntity:Entity = null;
        
        collidedEntity = collide("tiles", x, y);
        if(collidedEntity != null)
        {
            if(cast(collidedEntity, Tile).tileFalling)
            {
                //velocity.setTo(-0.5, -0.5);
                //velocity.normalize();
                //velocity.scale(4.0);
        //
                destroyedTween.tween(spriteMap, {angle: 90}, 0.4);
                destroyedTween.start();
                //
    //
                setHitbox(height, width);
                centerOrigin();
                graphic.centerOrigin();
                destroyed = true;
            }
        }

        collidedEntity = collide("tiles", x + velocity.x, y);
        if(collidedEntity != null)
        {
            if(velocity.x > 0)
            {
                x = collidedEntity.x - halfWidth;

                //if(onGround)
                //    velocity.y = -3.7;
            }

            else
            {
                x = collidedEntity.right + halfWidth;

                //if(onGround)
                //    velocity.y = -3.7;
            }
            velocity.x = 0;
        }

        collidedEntity = collide("tiles", x, y + velocity.y);
        if(collidedEntity != null)
        {
            if(velocity.y >= 0)
            {
                onGround = true;
                velocity.y = 0;
                
                y = collidedEntity.y - halfHeight;

            }
            else if(velocity.y < 0)
            {
                velocity.y = 0.1;
                y = collidedEntity.bottom + halfHeight;
            }



        }
/*
        collidedEntity = collide("civilian", x, y);
        if(collidedEntity != null)
        {
            //if()
            {
                //x += 0.1;
                //collidedEntity.x-=0.1;
            }
        }*/



        /*
        collidedEntity = collide("bulletPlayer", x + velocity.x, y + velocity.y);
        if(collidedEntity != null)
        {
            damageByBullet(1.0, cast collidedEntity);
            HXP.scene.remove(collidedEntity);
        }
        */
    }

    public function damageByBullet(damage:Float, bullet:Bullet) 
    {
        super.damage(damage);
        graphicColorMask.startMask(0.3, 0xFF0000);

        if(hp <= 0)
        {
            destroyed = true;
            if(bullet.velocity.x > 0)
            {
                velocity.setTo(0.5, -0.5);
                velocity.normalize();
                velocity.scale(4.0);

                destroyedTween.tween(spriteMap, {angle: -90}, 0.4);
                destroyedTween.start();
            }
            else 
            {
                velocity.setTo(-0.5, -0.5);
                velocity.normalize();
                velocity.scale(4.0);
    
                destroyedTween.tween(spriteMap, {angle: 90}, 0.4);
                destroyedTween.start();
            }

            setHitbox(height, width);
            centerOrigin();
            graphic.centerOrigin();
        }
    }

    override function startDestroy() 
    {
        super.startDestroy();
        startDestroyAlarm.initTween(0.2);
        startDestroyAlarm.start();
    }

    override function destroy() 
    {
        super.destroy();
    }
}