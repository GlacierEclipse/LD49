import scenes.WinScene;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.math.Vector2;
import haxepunk.Tween.TweenType;
import entities.FadeScreen;
import haxepunk.utils.Ease;
import haxepunk.tweens.misc.Alarm;
import haxepunk.tweens.misc.MultiVarTween;
import scenes.DefeatScene;
import scenes.UpgradeScene;
import haxepunk.HXP;
import haxepunk.input.Input;
import haxepunk.graphics.TextEntity;
import entities.Civilian;
import haxepunk.ParticleManager;
import haxepunk.Entity;
import haxepunk.math.MathUtil;
import haxepunk.math.Random;
import entities.Scrap;
import entities.SmokeRegion;
import haxepunk.Scene;
import entities.Player;
import entities.Tile;

class World 
{
    public var player:Player;
    public var currentLevel:Int;

    public static var mapWidth:Int;
    public static var mapHeight:Int;
    public static var tileSize:Int = 16;

    public var worldCivilians:Array<Civilian>;

    public static var world:World;

    public var worldBeginAlarm:MultiVarTween;


    public var failedText:TextEntity;

    public var beginBuildingText:TextEntity;
    public var beginCiviliansText:TextEntity;
    public var beginInputText:TextEntity;
    public var canBeginGame:Bool = false;

    public var fadeScreen:FadeScreen;

    public var currentCiviliansText:TextEntity;
    public var currentScrapText:TextEntity;
    public var exitBuildingText:TextEntity;

    public var exitTheBuildingTween:MultiVarTween;

    public var tutorialEntity:Entity;

    public function new() 
    {
        worldCivilians = new Array<Civilian>();
        currentLevel = 1;

        ParticleManager.initParticleEmitter("graphics/Particles.png", 16, 16);

		var tileBreakParticle = ParticleManager.addType("tileBreak", [0]);
		tileBreakParticle.setScale(0.5, 0.0, 1.0);
		tileBreakParticle.setMotion(0, 100, 1.0, 180, 50, 1.5);
		tileBreakParticle.setAlpha(1.0, 1.0);
		tileBreakParticle.setGravity(17.0, 2.5);
		tileBreakParticle.setRotation(0.0, 360.0, 360.0, 720.0);

        world = this;

        Globals.totalScrap = 0;
        Globals.currentHelmetUpgrade = 0;
        Globals.currentHammerUpgrade = 0;
        Globals.currentGasMaskUpgrade = 0;
        
        Globals.currentHelmetValue = 100;
        Globals.currentHammerValue = 100;
        Globals.currentGasMaskValue = 100;
        
        

    }

    public function generateWorld(level:Int) : Void
    {
        
        
            generateLevel(currentLevel);
    } 

    function generateLevel(level:Int) 
    {
        

        // bg
        for (i in 0...20)
        {
            for (j in 0...15)
            {
                var tempSpriteMap:Spritemap = new Spritemap("graphics/Tiles.png", 16, 16);
                tempSpriteMap.frame = 2;
                tempSpriteMap.scrollX = tempSpriteMap.scrollY = 0;
                addEntity(new Entity(i * 16.0, j * 16.0, tempSpriteMap));
            }
        }




        var difficultyLevel:Float = (level / 20);
        difficultyLevel = MathUtil.min(difficultyLevel, 1.0);

        // This generates the buildings/player/enemies everything in a level.


        // Generate the building
        var buildingMinWidth:Int = 20;
        var buildingMaxWidth:Int = 20;

        var buildingMinFloors:Int = 5;
        var buildingMaxAdditionFloors:Int = 15;
        var buildingMinFloorSpacing:Int = 5;
        var buildingMaxFloorSpacing:Int = 10 - buildingMinFloorSpacing;


        var civilianMinAmount:Int = 4 + Std.int(difficultyLevel * 10);
        var civilianMaxAddAmount:Int = 16;


        var difficultyInv = 1.0 - difficultyLevel;

        var buildingWidth:Int = buildingMinWidth;
        var buildingFloors:Int = buildingMinFloors + Std.int(Random.randInt(buildingMaxAdditionFloors) * difficultyLevel);
        var buildingFloorSpacing:Int = buildingMinFloorSpacing + Std.int(Random.randInt(buildingMaxFloorSpacing) * difficultyInv);

        var civilianAmount:Int = civilianMinAmount + Std.int(Random.randInt(civilianMaxAddAmount) * difficultyLevel);

        World.mapWidth = Std.int(buildingWidth * tileSize);
        

        var startingY:Float = tileSize * 1;

        if(currentLevel == 1)
            buildingFloorSpacing = 7;
            

        var floorY:Float = startingY + (buildingFloorSpacing * tileSize);

        // Now generate the floors
        /*
        for (floor in 1...buildingFloors-2)
        {
            var floorX:Int = Random.randInt(10);
            var floorWidth:Int = 7 + Random.randInt(10);
            for (i in (floorX)...floorX + floorWidth)
            {
                var smokeChance:Float = 10 + (difficultyLevel * 90);
                currentScene.add(new Tile(i * tileSize, floorY, 50, smokeChance, TileType.DYNAMIC));
            }

            floorY += buildingFloorSpacing * tileSize;
        }
        */
        // Start building the floors 
        // |
        // |

        // Build the floor 1 time a half one 1 time a full one
        // Build the column at a random position 
        // Build the next floor 

        var potentialCivPosition:Array<Vector2> = new Array<Vector2>();
        var tilePositions:Array<Vector2> = new Array<Vector2>();

        var fullFloor:Bool = true;
        var columnSize:Int = 2;
        var currentColumnTile:Int = 5;

        var civsPosYStart:Int = 0;
        
        for (floor in 1...buildingFloors+1)
        {
            if(floor == 1)
            {
                player = new Player(50, floorY - tileSize / 2.0);
                addEntity(player);
            }
            if(floor == 2)
            {
                civsPosYStart = Std.int(floorY / tileSize);
            }
            // Build the floor
            if(fullFloor)
            {
                for (i in 1...(buildingWidth-1))
                {
                    var smokeChance:Float = 10 + (difficultyLevel * 90);
                    addEntity(new Tile(i * tileSize, floorY, smokeChance, TileType.DYNAMIC));
                    tilePositions.push(new Vector2(i, floorY / 16.0));
                }


                
                var prevColumnTile:Int = currentColumnTile;
                currentColumnTile = 4 + Random.randInt(buildingWidth - 8);
                
            }
            else
            {
                var smokeChance:Float = 10 + (difficultyLevel * 90);
                var dir:Int = currentColumnTile > 9 ? -1 : 1;
                var xTile:Int = currentColumnTile;
                if(dir < 0)
                {
                    for (i in 1...xTile+1)
                    {
                        
                        addEntity(new Tile(i * tileSize, floorY, smokeChance, TileType.DYNAMIC));
                        tilePositions.push(new Vector2(i, floorY / 16.0));

                    }
                    currentColumnTile = 2 + Random.randInt(xTile);
                }
                else
                {
                    for (i in xTile...(buildingWidth - 1))
                    {
                        addEntity(new Tile(i * tileSize, floorY, smokeChance, TileType.DYNAMIC));
                        tilePositions.push(new Vector2(i, floorY / 16.0));
                    }

                    currentColumnTile = xTile + Random.randInt(buildingWidth - xTile - 3);
                }

            }
    
            floorY += tileSize;
            // Build the column
            for (i in 0...columnSize)
            {
                var smokeChance:Float = 10 + (difficultyLevel * 90);
                addEntity(new Tile(currentColumnTile * tileSize, floorY, smokeChance, TileType.DYNAMIC, 1));
                tilePositions.push(new Vector2(currentColumnTile, floorY / 16.0));
                floorY += tileSize;
            }

            fullFloor = !fullFloor;

            
        }
        


        World.mapHeight = Std.int(floorY + tileSize);

        // Build the first layer of the building, 
        // Top / bottom
        for (i in 0...buildingWidth)
        {
            addEntity(new Tile(i * tileSize, startingY, 50.0, TileType.STATIC));
            addEntity(new Tile(i * tileSize, (World.mapHeight - tileSize), 50.0, TileType.STATIC, 0, true));
        }
    
        // Left / Right
        for (i in 0...Std.int(World.mapHeight / 16.0))
        {
            addEntity(new Tile(0, startingY + i * tileSize, 50.0, TileType.STATIC, 1));
            addEntity(new Tile((buildingWidth - 1) * tileSize, startingY + i * tileSize, 50.0, TileType.STATIC, 1));
        }


        // Populate potential civ positions
        for (floorXTile in 1...(buildingWidth-1))
        {
            for (floorYTile in civsPosYStart...Std.int(floorY / 16.0))
            {
                // If you have a tile below you and you are not on a tile it's a valid position.
                var tileBelow:Bool = false;
                var onTile:Bool = false;
                for (tilePos in tilePositions)
                {
                    if(Std.int(tilePos.x) == Std.int(floorXTile) && Std.int(tilePos.y) == Std.int(floorYTile))
                    {
                        onTile = true;
                        break;
                    }
                    if(Std.int(tilePos.x) == Std.int(floorXTile) && Std.int(tilePos.y) == Std.int(floorYTile + 1))
                    {
                        tileBelow = true;
                    }
                }

                if(!onTile && tileBelow)
                {
                    potentialCivPosition.push(new Vector2(floorXTile * tileSize + (-5.0 + (Random.random * 10.0)) , floorYTile * tileSize));
                }
            }
        }


        // Place civs
        for (i in 0...civilianAmount)
        {
            var randPosInd:Int = Random.randInt(potentialCivPosition.length);
            addCivilian(new Civilian(potentialCivPosition[randPosInd].x + 8.0, potentialCivPosition[randPosInd].y + 8.0, 0.0));
            
        }


        Globals.gameScene.camera.x = MathUtil.lerp(Globals.gameScene.camera.x, player.x - HXP.halfWidth , 1.0);
        // The posiiton of the camera should be more down
        Globals.gameScene.camera.y = MathUtil.lerp(Globals.gameScene.camera.y, player.y - HXP.halfHeight , 1.0);

        Globals.gameScene.camera.x = MathUtil.clamp(Globals.gameScene.camera.x, 0, World.mapWidth - HXP.width);
        Globals.gameScene.camera.y = World.mapHeight - HXP.height;
        
        postGenerateWorld();
        
    }

    public function update() 
    {
        var amountCivSaved = getAmountCiviliansSaved();
        currentCiviliansText.currentText = "Civilians Saved " + amountCivSaved + "/" + (worldCivilians.length);
        currentScrapText.currentText = "Scrap: " + Globals.totalScrap;

        if(amountCivSaved == worldCivilians.length && !exitTheBuildingTween.active)
        {
            exitBuildingText.graphic.alpha = 0.5;
            exitTheBuildingTween.tween(exitBuildingText.graphic, {scale: 0.9, alpha: 1.0}, 0.8);
            exitTheBuildingTween.start();
        }

        //if(worldBeginAlarm.active)
        //{
        //    .y =  MathUtil.lerp(400, player.y - HXP.halfHeight, worldBeginAlarm.percent);
        //}

        if(!canBeginGame && !worldBeginAlarm.active && Input.pressed("enter"))
        {
            fadeScreen.targetFadeVal = 0.0;
            var beginBuildingTween:MultiVarTween = new MultiVarTween();
            beginBuildingTween.tween(beginBuildingText, {y: 350}, 1.0, Ease.circIn);
            Globals.gameScene.addTween(beginBuildingTween, true);


            var beginCivilianTween:MultiVarTween = new MultiVarTween();
            beginCivilianTween.tween(beginCiviliansText, {y: 350}, 1.0, Ease.circIn);
            Globals.gameScene.addTween(beginCivilianTween, true);


            var beginTextTween:MultiVarTween = new MultiVarTween();
            beginTextTween.tween(beginInputText, {y: 350}, 1.0, Ease.circIn);
            Globals.gameScene.addTween(beginTextTween, true);

            canBeginGame = true;
        }

        if(canBeginGame)
        {
            if(currentLevel == 1)
            {
                tutorialEntity.graphic.alpha = MathUtil.lerp(tutorialEntity.graphic.alpha, 1.0 , 0.07);
            }
        }
        
        player.canInput = canBeginGame;

        if(player.canInput)
        {

            if(player.hp <= 0 || player.helmet.currentValue <= 0 || checkAnyCivilianDestroyed())
            {
                HXP.engine.pushScene(new DefeatScene());
            }

            // Win condition - Check all civilians saved
            if(checkAllCiviliansSaved())
            {
                // Check building exited 
                if(player.right <= 0 || player.x >= mapWidth)
                {
                    // First push the upgrade scene
                    if(currentLevel + 1 == 20)
                        HXP.engine.pushScene(new WinScene());
                    else
                        HXP.engine.pushScene(new UpgradeScene());
                }
            }
        }
    }

    public function checkAllCiviliansSaved() : Bool
    {
        var civilianSaved = true;
        
        for (civilian in worldCivilians)
        {
            if(!civilian.saved)
            {
                civilianSaved = false;
                break;
            }
        }
        return civilianSaved;
    }

    public function checkAnyCivilianDestroyed() : Bool
    {
        var civilianSaved = true;
        
        for (civilian in worldCivilians)
        {
            if(civilian.destroyed)
            {
                return true;
            }
        }
        return false;
    }

    public function getAmountCiviliansSaved() : Int
    {
        var civilianSaved = 0;
        
        for (civilian in worldCivilians)
        {
            if(civilian.saved)
            {
                civilianSaved++;
            }
        }
        return civilianSaved;
    }

    function postGenerateWorld()
    {
        canBeginGame = false;
        addEntity(new ParticleManager());



        worldBeginAlarm = new MultiVarTween();
        worldBeginAlarm.tween(Globals.gameScene.camera, {y: player.y - HXP.halfHeight}, 2.0, Ease.circInOut);

        Globals.gameScene.addTween(worldBeginAlarm, true);


        currentCiviliansText = new TextEntity(50, 50, "Civilians Saved 0/" + (worldCivilians.length));
        currentCiviliansText.textBitmap.size = 10;
        currentCiviliansText.graphic.scrollX = currentCiviliansText.graphic.scrollY = 0;
        //beginBuildingText.graphic.alpha = 0;
        currentCiviliansText.x = HXP.halfWidth - currentCiviliansText.textBitmap.textWidth / 2.0;
        currentCiviliansText.y = 10;
        
        addEntity(currentCiviliansText);

        
        currentScrapText = new TextEntity(50, 50, "Scrap ");
        currentScrapText.textBitmap.size = 8;
        currentScrapText.graphic.scrollX = currentScrapText.graphic.scrollY = 0;
        //beginBuildingText.graphic.alpha = 0;
        currentScrapText.x = 5;
        currentScrapText.y = 10;
        currentScrapText.graphic.alpha = 0.7;
        
        addEntity(currentScrapText);

        exitTheBuildingTween = new MultiVarTween(TweenType.PingPong);
        exitBuildingText = new TextEntity(50, 50, "     Escape the building!\nBreak the left or right walls!");
        exitBuildingText.textBitmap.size = 10;
        exitBuildingText.graphic.scrollX = exitBuildingText.graphic.scrollY = 0;
        exitBuildingText.x = HXP.halfWidth;
        exitBuildingText.y = 40;
        exitBuildingText.graphic.centerOrigin();
        exitBuildingText.graphic.alpha = 0.0;
        addEntity(exitBuildingText);
        Globals.gameScene.addTween(exitTheBuildingTween, false);

        if(currentLevel == 1)
        {
            var tempGraphic:Image = new Image("graphics/uiTutorial.png");
            
            tutorialEntity = new Entity(0, 0, tempGraphic);
            tutorialEntity.graphic.alpha = 0.0;
            addEntity(tutorialEntity);
        }

        fadeScreen = new FadeScreen();
        fadeScreen.targetFadeVal = 0.7;
        addEntity(fadeScreen);

        beginBuildingText = new TextEntity(50, 50, "Building: " + (currentLevel));
        beginBuildingText.graphic.scrollX = beginBuildingText.graphic.scrollY = 0;
        //beginBuildingText.graphic.alpha = 0;
        beginBuildingText.x = 10;
        beginBuildingText.y = -20;
        addEntity(beginBuildingText);

        beginCiviliansText = new TextEntity(50, 50, "Civilians to save: " + (worldCivilians.length));
        beginCiviliansText.graphic.scrollX = beginCiviliansText.graphic.scrollY = 0;
        //beginBuildingText.graphic.alpha = 0;
        beginCiviliansText.x = 10;
        beginCiviliansText.y = -20;
        addEntity(beginCiviliansText);

        beginInputText = new TextEntity(50, 50, "Press Enter to Start");
        beginInputText.graphic.scrollX = beginInputText.graphic.scrollY = 0;
        //beginBuildingText.graphic.alpha = 0;
        beginInputText.x = 10;
        beginInputText.y = -20;
        addEntity(beginInputText);


        var beginBuildingTween:MultiVarTween = new MultiVarTween();
        beginBuildingTween.tween(beginBuildingText, {y: 20}, 0.5, Ease.bounceOut);
        Globals.gameScene.addTween(beginBuildingTween, true);


        var beginCivilianTween:MultiVarTween = new MultiVarTween();
        beginCivilianTween.tween(beginCiviliansText, {y: 40}, 0.5, Ease.bounceOut);
        Globals.gameScene.addTween(beginCivilianTween, true);


        var beginTextTween:MultiVarTween = new MultiVarTween();
        beginTextTween.tween(beginInputText, {y: 60}, 2.0, Ease.bounceOut);
        Globals.gameScene.addTween(beginTextTween, true);
        
        
        //successText = new TextEntity(50, 50, "You Escaped with the civilians!\n        Enter to continue.");
        //successText.visible = false;
        //successText.graphic.scrollX = successText.graphic.scrollY = 0;
        //addEntity(successText);



    }

    function addEntity(e:Entity) 
    {
        Globals.gameScene.add(e);
    }

    function addCivilian(e:Civilian) 
    {
        worldCivilians.push(e);
        addEntity(e);
    }

    function cleanWorld() 
    {
        // Remove all the world entities. 
        Globals.gameScene.removeAll();
        
        worldCivilians.splice(0, worldCivilians.length);

    }

    public function loadNextLevel()
    {
        cleanWorld();
        currentLevel++;
        generateWorld(currentLevel);
    } 

    public function restartGame() 
    {
        Globals.totalScrap = 0;
        Globals.currentHelmetUpgrade = 0;
        Globals.currentHammerUpgrade = 0;
        Globals.currentGasMaskUpgrade = 0;

        Globals.currentHelmetValue = 100;
        Globals.currentHammerValue = 100;
        Globals.currentGasMaskValue = 100;

        currentLevel = 1;
        // Remove all the world entities. 
        cleanWorld();
        generateWorld(1);
        
    }
}