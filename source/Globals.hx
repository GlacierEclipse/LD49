import haxepunk.Scene;
import scenes.GameScene;
import scenes.UpgradeScene;

class Globals
{
    public static var gameScene:GameScene;
    public static var upgradeScene:UpgradeScene;

    public static var totalScrap:Int = 0;

    public static var currentHelmetUpgrade:Int = 0;
    public static var currentHammerUpgrade:Int = 0;
    public static var currentGasMaskUpgrade:Int = 0;

    public static var currentHelmetValue:Float = 0;
    public static var currentHammerValue:Float = 0;
    public static var currentGasMaskValue:Float = 0;

    public static var currentBuilding:Int = 0;
}