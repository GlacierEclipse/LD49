package entities;

import haxepunk.utils.Draw;
import haxepunk.tweens.misc.Alarm;
import haxepunk.math.MinMaxValue;
import haxepunk.input.Mouse;
import haxepunk.math.Vector2;
import haxepunk.graphics.ui.UIBar;
import haxepunk.math.MathUtil;
import haxepunk.HXP;
import haxepunk.Camera;
import haxepunk.Entity;
import haxepunk.input.Input;

class Player extends GameEntity
{
    public static var playerInstance:Player;
    public var jumpSpeed:Float;
    public var canJump:Bool;
    public var onGround:Bool;
    public var hammer:Hammer;
    public var gasMask:GasMask;
    public var mouseDir:Vector2 = new Vector2();

    //public var gun:Gun;

    public var scrapAmount:Int;

    public var uiGasMaskStatus:UIBar;
    public var uiHelmetStatus:UIBar;

    public var helmet:MinMaxValue;

    public var vulnerabilityAlarm:Alarm;

    public var canInput:Bool = true;

    public var lastCollidedTile:Tile = null;
    

    public function new(x:Float, y:Float) 
    {
        super(x, y, "graphics/Player.png", 16, 16);

        
        Player.playerInstance = this;
        setHitbox(8, 16, 0, 0);

        centerOrigin();
        graphic.centerOrigin();

        hammer = new Hammer();
        gasMask = new GasMask();
        //gun = new Gun();

        scrapAmount = 0;

        uiGasMaskStatus = new UIBar("graphics/uiGasBar.png", 16, 4);
        Globals.gameScene.add(uiGasMaskStatus);

        uiHelmetStatus = new UIBar("graphics/uiHelmetBar.png", 16, 4);
        Globals.gameScene.add(uiHelmetStatus);
        
        helmet = new MinMaxValue(0, 100, 100.0, 50.0);

        vulnerabilityAlarm = new Alarm(0.4);
        addTween(vulnerabilityAlarm, false);

        canInput = true;

        initVars();

        layer = -1;
    }

    override function initVars() 
    {
        super.initVars();

        speed = 2.7;
        jumpSpeed = 3.7;
        canJump = false;
        scrapAmount = 0;
        canInput = true;


        // Update from upgrades
        helmet.currentValue = Globals.currentHelmetValue;
        hammer.durability.currentValue = Globals.currentHammerValue;
        gasMask.filterValue.currentValue = Globals.currentGasMaskValue;

        switch (Globals.currentHelmetUpgrade)
        {
            case 0:
            {
                helmet.rate = 100.0;
            }
            
            case 1:
            {
                helmet.rate = 100.0 / 2.0;
            }
            
            case 2:
            {
                helmet.rate = 100.0 / 3.0;
            }
            
            case 3:
            {
                helmet.rate = 100.0 / 4.0;
            }
        }

        switch (Globals.currentHammerUpgrade)
        {
            case 0:
            {
                hammer.durability.rate = 100 / 10;
            }
            
            case 1:
            {
                hammer.durability.rate = 100 / 7;
            }
            
            case 2:
            {
                hammer.durability.rate = 100 / 5;
            }
            
            case 3:
            {
                hammer.durability.rate = 100 / 2;
            }
        }

        switch (Globals.currentGasMaskUpgrade)
        {
            case 0:
            {
                gasMask.filterValue.rate = 5 / 60.0;
            }
            
            case 1:
            {
                gasMask.filterValue.rate = 10 / 60.0;
            }
            
            case 2:
            {
                gasMask.filterValue.rate = 15 / 60.0;
            }
            
            case 3:
            {
                gasMask.filterValue.rate = 30 / 60.0;
            }
        }
      
        
            

        
    }

    override function update() 
    {
        super.update();

        uiGasMaskStatus.x = x - uiGasMaskStatus.barWidth / 2.0;
        uiGasMaskStatus.y = y - halfHeight - 6;
        uiGasMaskStatus.fill = gasMask.filterValue.currentValue;
       

        uiHelmetStatus.x = x - uiHelmetStatus.barWidth / 2.0;
        uiHelmetStatus.y = y - halfHeight - 14;
        uiHelmetStatus.fill = helmet.currentValue;


        var cameraLerp:Float = 0.03;
        mouseDir.x = Mouse.mouseX + HXP.camera.x - x;
        mouseDir.y = Mouse.mouseY + HXP.camera.y - y;
        mouseDir.normalize();
        
        if(canInput)
        {
            HXP.camera.x = MathUtil.lerp(HXP.camera.x, x - HXP.halfWidth , cameraLerp);
            // The posiiton of the camera should be more down
            HXP.camera.y = MathUtil.lerp(HXP.camera.y, y - HXP.halfHeight , cameraLerp);
            
            HXP.camera.x = MathUtil.clamp(HXP.camera.x, 0, World.mapWidth - HXP.width);
            HXP.camera.y = MathUtil.clamp(HXP.camera.y, 0, World.mapHeight - HXP.height);

        }

        Globals.currentHelmetValue = helmet.currentValue;
        //Globals.currentHammerValue = hammer.durability.currentValue;
        Globals.currentGasMaskValue = gasMask.filterValue.currentValue;
        
    }
    
    public function handleInput() 
    {
        velocity.x = 0;

        if(canInput)
        {
            if(Input.check("left"))
            {
                velocity.x = -speed;
                spriteMap.flipX = true;
            }

            if(Input.check("right"))
            {
                velocity.x = speed;
                spriteMap.flipX = false;
            }

            if(canJump && onGround && Input.pressed("jump"))
            {
                velocity.y -= jumpSpeed;
                canJump = false;
            }
        

            var collidedEntity:Entity = null;
            var collidedTile:Tile = null;
            if(Input.check("left") && (collidedEntity = collide("tiles", x - 5, y)) != null)
            {
                if(collidedEntity != null)
                {
                    collidedTile = cast collidedEntity;
                }
            }
            else if(Input.check("right") && (collidedEntity = collide("tiles", x + 5, y)) != null)
            {
                if(collidedEntity != null)
                {
                    collidedTile = cast collidedEntity;
                }
            }
            else
            {
                collidedEntity = collide("tiles", x, y + 5);
                if(collidedEntity != null)
                {
                    collidedTile = cast collidedEntity;
                }
            }
            lastCollidedTile = collidedTile;

            if(onGround && Input.pressed("hammer"))
            {
                // Before use check if we have a tile on top/left/right

                if(collidedTile != null && !collidedTile.isDestroying() && !collidedTile.floorTile)
                {
                    if(!collidedTile.isStaticTile() || World.world.checkAllCiviliansSaved())
                        hammer.hit(collidedTile);
                }
                    

            }
        }

        //gun.handleInput();
    }

    override function handleCollision() 
    {
        super.handleCollision();

        onGround = false;

        var collidedEntity:Entity = null;

        // Tile landed hit
        collidedEntity = collide("tiles", x, y);
        if(collidedEntity != null && cast(collidedEntity, Tile).tileFalling)
        {
            if(canDamage())
            {
                helmet.currentValue -= helmet.rate;
                helmet.clamp();
    
                damage(0);
            }
        }
        
        collidedEntity = collide("tiles", x + velocity.x, y);
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
                canJump = true;
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



        if(collide("smokeRegion", x, y + velocity.y) != null)
        {
            gasMask.useMask();
            if(!gasMask.canUseMask() && canDamage())
            {
                // Start to remove hp.
                damage(1);
            }
        }
    }

    public function canDamage() : Bool
    {
        return !vulnerabilityAlarm.active;
    }

    override function damage(damage:Float) 
    {
        super.damage(damage);
        graphicColorMask.startMask(0.2);
        vulnerabilityAlarm.start();
    }

    public function addScrap() 
    {
        Globals.totalScrap++;
    }

    override function handleMovement() 
    {
        super.handleMovement();
        handleInput();

        velocity.y += gravity;
    }

    override function render(camera:Camera) 
    {
        super.render(camera);
       // gun.render(camera);

       if(lastCollidedTile != null)
            Draw.rect((lastCollidedTile.x - camera.x) * 2.0 , (lastCollidedTile.y - camera.y) * 2.0, 16 * 2.0, 16 * 2.0);
    }
}