package entities;

import haxepunk.utils.Color;
import haxepunk.ParticleManager;
import haxepunk.Camera;
import haxepunk.Entity;
import haxepunk.Tween.TweenType;
import haxepunk.tweens.misc.MultiVarTween;
import haxepunk.math.MathUtil;
import haxepunk.math.Random;
import haxepunk.tweens.misc.Alarm;
import haxepunk.HXP;


enum TileType
{
    STATIC;
    DYNAMIC;
    DESTROYED;
}

class Tile extends GameEntity
{
    public var tileStartingToFall:Bool;
    public var tileFalling:Bool;
    public var tileLanded:Bool;

    public var tileStartFallAlarm:Alarm;
    public var tileFallAlarm:Alarm;
    

    public var tileStartFallTween:MultiVarTween;

    public var renderXOffset:Float;
    public var renderYOffset:Float;

    public var smokeRegion:SmokeRegion;

    public var tileType:TileType;

    public var destroyed:Bool;

    public var floorTile:Bool;

    public function new(x:Float, y:Float, chanceToSmoke:Float, tileType:TileType, tilegid:Int = 0, floorTile:Bool = false) 
    {
        super(x, y, "graphics/Tiles.png", 16, 16);

        type="tiles";

        this.tileType = tileType;

        tileStartFallAlarm = new Alarm(0.0, initTileFall);
        tileFallAlarm = new Alarm(0.0, startTileFall);

        tileStartFallTween = new MultiVarTween(TweenType.PingPong);
        tileFalling = false;


        addTween(tileStartFallAlarm, false);
        addTween(tileFallAlarm, false);
        addTween(tileStartFallTween, false);

        tileLanded = false;

        renderXOffset = 0;
        renderYOffset = 0;

        this.hp = 100;

        this.smokeRegion = null;

        this.floorTile = floorTile;
        if(tileType == TileType.DYNAMIC)
        {
            var smokeRegionChance = Random.randInt(101);
            //if(smokeRegionChance <= chanceToSmoke)
            {
                smokeRegion = new SmokeRegion(x, y, 16);
            }
        }

        if(tileType == TileType.DESTROYED)
        {
            type = "destroyedTile";
            active = false;
            visible = false;
        }

        destroyed = false;

        spriteMap.frame = tilegid;

    }

    override function initVars() 
    {
        super.initVars();
    }

    override function update() 
    {
        super.update();

        if(World.world.canBeginGame && y < HXP.camera.y - 100)
            HXP.scene.remove(this);
        if(isDynamicTile() && HXP.camera.onCamera(this))
        {
            
            if(!tileStartingToFall)
            {
                // Check neighbors for fall
                var tileUp = cast(collide("destroyedTile", x, y - World.tileSize, false), Tile);
                var tileDown = cast(collide("destroyedTile", x, y + World.tileSize, false), Tile);
                var tileRight = cast(collide("destroyedTile", x + World.tileSize, y, false), Tile);
                var tileLeft = cast(collide("destroyedTile", x - World.tileSize, y, false), Tile);
                
                var shouldFall:Bool = false;
                if(checkTileConnectiviy(tileUp))
                {
                    shouldFall = true;
                }
                
                if(checkTileConnectiviy(tileDown))
                {
                    shouldFall = true;
                }
                
                if(checkTileConnectiviy(tileLeft))
                {
                    shouldFall = true;
                }
                
                if(checkTileConnectiviy(tileRight))
                {
                    shouldFall = true;
                }


                if(shouldFall && !tileStartingToFall)
                {
                    graphicColorMask.startMask(0.2);
                    setUpStartFall();
                }
                //setUpStartFall();
            }
        }
    }

    override function damage(damage:Float) 
    {
        super.damage(damage);
        graphicColorMask.startMask(0.2);
        graphic.color = Color.colorLerp(0xffffff, 0xff0000, hp / 100);
        graphic.alpha = MathUtil.max(hp / 100, 0.5);
    }

    private function checkTileConnectiviy(tile:Tile) : Bool
    {
        if(tile != null)
        {
            return true;
        }
        return false;
    }

    public function isStaticTile() : Bool
    {
        return tileType == TileType.STATIC;
    }

    public function isDynamicTile() : Bool
    {
        return tileType == TileType.DYNAMIC;
    }

    public function setUpStartFall() 
    {
        tileStartingToFall = true;
        tileStartFallAlarm.initTween(Random.random * 5.0);
        tileStartFallAlarm.start();
    }

    public function initTileFall() 
    {
        tileFallAlarm.initTween(Random.random * 2.0);
        tileFallAlarm.start();

        renderXOffset = -2.0;
        
        tileStartFallTween.tween(this, {renderXOffset : 4}, 0.2);
        tileStartFallTween.start();

        HXP.scene.add(new Tile(x, y, 1, TileType.DESTROYED));
    }

    public function startTileFall() 
    {
        if(smokeRegion != null)
            Globals.gameScene.add(smokeRegion);
        graphicColorMask.startMask(0.2, 0xFFFFFF);
        tileFalling = true;
        
    }

    override function startDestroy() 
    {
        super.startDestroy();

        graphicColorMask.startMask(0.1, 0xFF0000);
        startDestroyAlarm.initTween(0.1);
        startDestroyAlarm.start();
    }

    override function destroy() 
    {
        super.destroy();

        HXP.scene.remove(this);

        ParticleManager.particleEmitter.emitInRectangleAmount("tileBreak", x, y, width, height, 8);

        HXP.scene.camera.shake(0.2, 2);

        visible = false;
        destroyed = true;
        
        HXP.scene.add(new Tile(x, y, 1, TileType.DESTROYED));

        //type="tileDestroyed";
    }

    override function handleMovement() 
    {
        super.handleMovement();


        if(tileFalling)
        {
            velocity.y += gravity;
            if(smokeRegion != null)
                smokeRegion.setNewSmokeY(bottom + 15);
        }
    }

    override function handleCollision() 
    {
        super.handleCollision();

        if(tileFalling)
        {
            var collidedEntities:Array<Entity> = new Array<Entity>();
            collideInto("tiles", x, y + velocity.y, collidedEntities);
            if(collidedEntities.length > 0)
            {
                for (entity in collidedEntities)
                {
                    if(entity != this)
                    {
                        tileFalling = false;
                        tileLanded = true;
                        velocity.y=0;
                        tileStartFallTween.cancel();
                        y = entity.y - height;
                        renderXOffset = 0;
                        if(smokeRegion != null)
                        {
                            smokeRegion.setNewSmokeY(bottom + 15);
                            smokeRegion.setTileLanded(true);
                        }


                        ParticleManager.particleEmitter.emitInRectangleAmount("tileBreak", x, y, width, height, 8);

                        HXP.scene.camera.shake(0.2, 2);
                        
                        Globals.gameScene.add(new Scrap(x, y));

                        HXP.scene.remove(this);
                        destroyed = true;
                        visible = false;


                        break;
                    }
                }
            }
        }
    }

    override function render(camera:Camera) 
    {
        var tempX:Float = x;
        x += renderXOffset;
        super.render(camera);
        x = tempX;
    }
}