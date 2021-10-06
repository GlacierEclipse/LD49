package entities;

import haxepunk.HXP;

class TileIndicator extends GameEntity
{
    override function update() 
    {
        super.update();
        if(World.world.canBeginGame && y < HXP.camera.y - 100)
            HXP.scene.remove(this);
    }
}