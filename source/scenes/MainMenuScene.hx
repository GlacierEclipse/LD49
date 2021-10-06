package scenes;

import entities.Player;
import haxepunk.math.MathUtil;
import haxepunk.Entity;
import entities.ui.UIRefillBar;
import entities.ui.UIUpgradeBar;
import entities.GameEntity;
import haxepunk.HXP;
import haxepunk.input.Input;
import haxepunk.tweens.misc.VarTween;
import haxepunk.Scene;
import haxepunk.graphics.TextEntity;

class MainMenuScene extends Scene
{
	public var startSceneTween:VarTween;
	public var endSceneTween:VarTween;

	public var failedText:TextEntity;

	public var statsText:TextEntity;

	public function new()
	{
		super();

		startSceneTween = new VarTween();
		startSceneTween.tween(this, "bgAlpha", 0.7, 1.0);
		addTween(startSceneTween, true);

		endSceneTween = new VarTween();
		endSceneTween.onComplete.bind(function()
		{
			World.world.restartGame();
			Globals.gameScene.update();
			Globals.gameScene.updateLists();
			Globals.gameScene.render();

			endSceneTween.tween(this, "bgAlpha", 0.0, 0.8);
			endSceneTween.onComplete.clear();
			endSceneTween.onComplete.bind(function()
			{
				HXP.engine.popScene();
			});
			endSceneTween.start();
		});
		addTween(endSceneTween, false);



		var textDefeat:String = "You failed saving the civilians.";

		if (Player.playerInstance.hp <= 0)
		{
			textDefeat = "Huh apperenatly those gas areas are toxic..";
		}
		else if (Player.playerInstance.helmet.currentValue <= 0)
		{
			textDefeat = "Well a helmet would've been useful.";
		}
		else
		{
			textDefeat = "Civilian didn't survive.";
		}

		failedText = new TextEntity(50, 50, textDefeat);
		failedText.x = HXP.halfWidth - failedText.textBitmap.textWidth / 2.0;
		add(failedText);


		statsText = new TextEntity(50, 150, "Cleared " + (World.world.currentLevel - 1) + "/20 Buildings.");
		statsText.textBitmap.size = 10;
		statsText.x = HXP.halfWidth - statsText.textBitmap.textWidth / 2.0;
		add(statsText);

		this.bgColor = 0x000000;
	}

	override function update()
	{
		super.update();

		if (Input.pressed("enter") && !endSceneTween.active)
		{
			endSceneTween.tween(this, "bgAlpha", 1.0, 0.8);
		}
		if (endSceneTween.active)
		{
			var arrEnt:Array<Entity> = new Array<Entity>();
			getAll(arrEnt);
			for (entity in arrEnt)
			{
				entity.graphic.alpha = MathUtil.lerp(entity.graphic.alpha, 0.0, 0.08);
			}
		}
	}
}
