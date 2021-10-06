package scenes;

import haxepunk.HXP;
import haxepunk.debug.Console;
import haxepunk.input.Input;
import haxepunk.ParticleManager;
import haxepunk.Scene;

class GameScene extends Scene
{
	var world:World;

	override public function begin()
	{
		Globals.gameScene = this;
		// Insert your scene code here...
		world = new World();
		world.generateWorld(1);


	}

	override function update() 
	{
		super.update();
		world.update();
		if(Input.pressed("debugConsole"))
		{
			Console.enabled = !Console.enabled;
		}


	}
}
