package scenes;

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

class UpgradeScene extends Scene
{
    public var startSceneTween:VarTween;
    public var endSceneTween:VarTween;

    public var totalScrapText:TextEntity;
    public var costText:TextEntity;

    public function new() 
    {
        super();

        Globals.upgradeScene = this;

        this.bgColor = 0x000000;
        bgAlpha = 0.0;

        startSceneTween = new VarTween();
        startSceneTween.tween(this, "bgAlpha", 0.9, 1.0);
        addTween(startSceneTween, true);

        endSceneTween = new VarTween();

        endSceneTween.onComplete.bind(function () 
        {
            HXP.resetCamera();
            World.world.loadNextLevel();
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
        }
        );
        addTween(endSceneTween, false);

        add(new TextEntity(HXP.halfWidth - 60, HXP.height - 70, "Enter to continue"));


        totalScrapText = new TextEntity(HXP.halfWidth - 30, 5, "Scrap: ", 12);
        add(totalScrapText);

        costText = new TextEntity(HXP.halfWidth - 30, 25, "Cost: ", 12);
        add(costText);

        var xMenu:Float = 10;
        var yMenu:Float = 30;
        add(new TextEntity(xMenu + 35, yMenu - 20, "Upgrades"));
        add(new GameEntity(xMenu, yMenu, "graphics/uiUpgradeMenu.png", 101, 64));

        add(new UIUpgradeBar(xMenu + 101 - 47 - 3, yMenu + 4, "Helmet"));
        yMenu += 20;
        add(new UIUpgradeBar(xMenu + 101 - 47 - 3, yMenu + 4, "Hammer"));
        yMenu += 20;
        add(new UIUpgradeBar(xMenu + 101 - 47 - 3, yMenu + 4, "GasMask"));

        
        yMenu = 30;
        xMenu = 210;
        add(new TextEntity(xMenu + 35, yMenu - 20, "Refill"));
        
        add(new GameEntity(xMenu, yMenu, "graphics/uiUpgradeMenu2.png", 101, 43));

        add(new UIRefillBar(xMenu + 101 - 47 - 3, yMenu + 4, "Helmet"));
        yMenu += 20;
        add(new UIRefillBar(xMenu + 101 - 47 - 3, yMenu + 4, "GasMask"));

        
    }

    override function update() 
    {
        Globals.upgradeScene.costText.currentText = "Cost: ";
        super.update();

        totalScrapText.currentText = "Scrap: " + Globals.totalScrap;
        if(Input.pressed("enter") && !endSceneTween.active)
        {
            endSceneTween.tween(this, "bgAlpha", 1.0, 0.8);
        }
        if(endSceneTween.active)
        {
            var arrEnt:Array<Entity> = new Array<Entity>();
            getAll(arrEnt);
            for (entity in arrEnt)
            {
                entity.active = false;
                entity.graphic.alpha = MathUtil.lerp(entity.graphic.alpha, 0.0, 0.08);
            }
        }
    }


}