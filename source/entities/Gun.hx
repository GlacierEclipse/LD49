package entities;

import haxepunk.math.MinMaxValue;
import haxepunk.HXP;
import haxepunk.utils.Draw;
import haxepunk.Camera;
import haxepunk.math.Vector2;
import haxepunk.input.Mouse;
import haxepunk.input.Input;
import haxepunk.Entity;

class Gun extends Entity
{
    public var ammo:MinMaxValue;
    public var mouseDir:Vector2 = new Vector2();

    public var canShoot:Bool;

    public function new() 
    {
        super(0,0);
        ammo = new MinMaxValue(0.0, 5.0, 5.0, 1.0);
        canShoot = true;
    }

    public function handleInput()
    {
        mouseDir.x = Mouse.mouseX + HXP.camera.x - Player.playerInstance.x;
        mouseDir.y = Mouse.mouseY + HXP.camera.y - Player.playerInstance.y;
        mouseDir.normalize();

        if(Mouse.mousePressed && canShoot)
            fire(mouseDir);
        
    }

    public function fire(mouseDir:Vector2) : Void
    {
        ammo.currentValue -= ammo.rate;
        HXP.scene.add(new Bullet(Player.playerInstance.x, Player.playerInstance.y, mouseDir));

        ammo.clamp();

        if(ammo.currentValue <= 0)
            canShoot = false;
    }

    override function render(camera:Camera) 
    {
        super.render(camera);
        Draw.setColor();
        
        var lineParts:Int = 5;
        var lineLen:Int = 10;
        var lineSpacing:Int = 20;
        var currentLineX:Float = Player.playerInstance.x * 2 - HXP.camera.x * 2 + mouseDir.x * lineLen;
        var currentLineY:Float = Player.playerInstance.y * 2 - HXP.camera.y * 2 + mouseDir.y * lineLen;

        for (i in 0...lineParts)
        {
            Draw.line(currentLineX, currentLineY, currentLineX + mouseDir.x * lineLen, currentLineY + mouseDir.y * lineLen);
            currentLineX += mouseDir.x * (lineLen + lineSpacing) ;
            currentLineY += mouseDir.y * (lineLen + lineSpacing) ;
        }
        
        
    }

}