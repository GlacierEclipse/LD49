import haxepunk.debug.Console;
import haxepunk.Graphic;
import haxepunk.input.Key;
import haxepunk.input.Input;
import haxepunk.Engine;
import haxepunk.HXP;
import scenes.GameScene;

class Main extends Engine
{

	static function main()
	{
		Graphic.smoothDefault = false;

		new Main(320, 240, 60, true);
#if debug
		Console.enable();
#end
	}

	override public function init()
	{
		Key.define("left", [Key.A, Key.LEFT]);
		Key.define("right", [Key.D, Key.RIGHT]);
		Key.define("jump", [Key.W, Key.UP]);
		Key.define("down", [Key.S, Key.DOWN]);
		Key.define("hammer", [Key.SPACE, Key.Z]);
		#if debug
		Key.define("debugConsole", [Key.C]);
		#end
		Key.define("enter", [Key.ENTER]);

		HXP.scene = new GameScene();
	}
}
/*
Snippets/Examples/Usages/Tips: 

===============================
		    Tweens 
===============================

- A tween can be added to an entity. If you use it as is, you'll need to update it manually.

- To use callbacks and chain them together (creating timelines) use it like so:
-----------------
Timeline Example
-----------------

var tween:Tween = new Tween(1.0);
tween.onComplete.bind(function()
{
	someCode;
    tween.onComplete.clear();
    tween.onComplete.bind(function() 
    {
        someCode;
    });
    tween.start();
});

-------------------------------------------
MultiVarTween Example, fade out/in graphic.
-------------------------------------------

var tween:MultiVarTween = new MultiVarTween();
tween.tween(graphic, {alpha: 0.0}, 2.0);
tween.onComplete.bind(function()
{
    tween.tween(graphic, {alpha: 1.0}, 2.0);
    tween.start();
});

===============================
		   Particles 
===============================

-----------------------
Init particles manager
-----------------------

ParticleManager.initParticleEmitter("graphics/particles.png", 1, 1);
add(new ParticleManager());

-----------------------------------
Define new particle - Smoke example
-----------------------------------

var testParticle = ParticleManager.addType("test", [0]);
testParticle.setScale(0.5, 1.0, 3.0, Ease.quadOut);
testParticle.setMotion(0, 2, 0.5, 360, 2, 1.0);
testParticle.setAlpha();

-------------------------
Emit a particle
-------------------------
ParticleManager.particleEmitter.emitInRectangleAmount("test", x + 2, bottom-2, width-7, 2, 9);

=================================
	Tiled parsing  and reading
=================================

var tiledParser:TiledParser = new TiledParser("maps/test.tmx");

-------------------
Tile Layers
-------------------

for (layer in tiledParser.map2DTileLayers)
{
    for (row in 0...layer.rows)
    {
        for (col in 0...layer.columns)
        {
        	var tileInd:Int = layer.arr2DTileLayer[row][col];
			var xWorld:Float = col * tileWidth;
        	var yWorld:Float = row * tileHeight;
		}
	}
}


-------------------
  Object Layers
-------------------

for (objectgroup in tiledParser.mapObjectLayers)
{
    for (object in objectgroup.arrTiledObjects)
    {
        if(object.name == "Test")
        {
			for (property in object.properties)
            {
                
			}
			
			var propertyTest = object.properties.get("propertyTest");
		}
	}
}



*/