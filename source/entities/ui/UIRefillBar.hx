package entities.ui;

import haxepunk.utils.Color;
import haxepunk.math.MinMaxValue;
import haxepunk.graphics.text.BitmapText;
import haxepunk.math.MathUtil;
import haxepunk.input.Mouse;
import haxepunk.graphics.ui.UIBar;

class UIRefillBar extends UIBar
{
    public var upgradeType:String;
    public var textbitmap:BitmapText;


    public var cost:Int;

    public function new(x:Float, y:Float, upgradeType:String) 
    {
        super("graphics/uiRefillBar.png", 47, 11);
        this.upgradeType = upgradeType;

        

        this.x = x;
        this.y = y;

        setHitbox(barWidth, barHeight);

        if(upgradeType == "Helmet")
        {
            cost = 10;
            fill = Globals.currentHelmetValue;
            textbitmap = new BitmapText("Helmet", -47 , 0, 0, 0, {size: 10});
            addGraphic(textbitmap);
        }

        if(upgradeType == "Hammer")
        {
            cost = 5;
            fill = Globals.currentHammerValue;
            textbitmap = new BitmapText("Hammer", -47 , 0, 0, 0, {size: 10});
            addGraphic(textbitmap);
        }

        if(upgradeType == "GasMask")
        {
            cost = 5;
            fill = Globals.currentGasMaskValue;
            textbitmap = new BitmapText("Gas Mask", -47 , 0, 0, 0, {size: 10});
            addGraphic(textbitmap);
        }

    }

    override function update() 
    {
        super.update();

        graphic.alpha = MathUtil.lerp(graphic.alpha, 0.5, 0.08);
        if(collidePoint(x, y, Mouse.mouseX, Mouse.mouseY) && fill < 100)
        {
            graphic.alpha = MathUtil.lerp(graphic.alpha, 0.7, 0.08);
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
            
           if(upgradeType == "Helmet")
           {
                Globals.currentHelmetValue = 100;
                fill = Globals.currentHelmetValue;
               
           }
    
           if(upgradeType == "Hammer")
           {
                Globals.currentHammerValue = 100;
               fill = Globals.currentHammerValue;
           }
    
           if(upgradeType == "GasMask")
           {
                Globals.currentGasMaskValue = 100;
               fill = Globals.currentGasMaskValue;
           }
            Globals.totalScrap -= cost;
        }
        else
        {
            graphic.color = 0xFF0000;
        }

    }
}