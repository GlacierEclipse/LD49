package entities.ui;

import haxepunk.utils.Color;
import haxepunk.math.MinMaxValue;
import haxepunk.graphics.text.BitmapText;
import haxepunk.math.MathUtil;
import haxepunk.input.Mouse;
import haxepunk.graphics.ui.UIBar;

class UIUpgradeBar extends UIBar
{
    public var upgradeType:String;
    public var textbitmap:BitmapText;


    public var cost:Int;

    public function new(x:Float, y:Float, upgradeType:String) 
    {
        super("graphics/uiUpgradeBar.png", 47, 11);
        this.upgradeType = upgradeType;

        fill = 0;

        this.x = x;
        this.y = y;

        setHitbox(barWidth, barHeight);

        

        if(upgradeType == "Helmet")
        {
            fill = Globals.currentHelmetUpgrade * 25;
            cost = 20;
            textbitmap = new BitmapText("Helmet", -47 , 0, 0, 0, {size: 10});
            addGraphic(textbitmap);
        }

        if(upgradeType == "Hammer")
        {
            fill = Globals.currentHammerUpgrade * 25;
            cost = 15;
            textbitmap = new BitmapText("Hammer", -47 , 0, 0, 0, {size: 10});
            addGraphic(textbitmap);
        }

        if(upgradeType == "GasMask")
        {
            fill = Globals.currentGasMaskUpgrade * 25;
            cost = 15;
            textbitmap = new BitmapText("Gas Mask", -47 , 0, 0, 0, {size: 10});
            addGraphic(textbitmap);
        }

    }

    override function update() 
    {
        super.update();

        graphic.alpha = MathUtil.lerp(graphic.alpha, 0.3, 0.08);
        if(collidePoint(x, y, Mouse.mouseX, Mouse.mouseY) && fill < 100)
        {
            graphic.alpha = MathUtil.lerp(graphic.alpha, 0.8, 0.08);
            if(Mouse.mousePressed)
            {

                click();
            }

            Globals.upgradeScene.costText.currentText = "Cost: " + cost;
        }

        textbitmap.alpha = 1.0;

        graphic.color = Color.colorLerp(graphic.color, 0xFFFFFF, 0.08);
    }

    public function click() 
    {
        if(Globals.totalScrap >= cost)
        {
            graphic.alpha = 1;
            fill+=25;
            Globals.totalScrap -= cost;

            if(upgradeType == "Helmet")
            {
                Globals.currentHelmetUpgrade++;
            }
        
            if(upgradeType == "Hammer")
            {
                Globals.currentHammerUpgrade++;
            }
        
            if(upgradeType == "GasMask")
            {
                Globals.currentGasMaskUpgrade++;
            }
        }
        else
        {
            graphic.color = 0xFF0000;
        }

    }
}