package jp_2dgames.game.state;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

/**
 * エンディング画面
 **/
class EndingState extends FlxState{

  private var _txt:FlxText;
  /**
   * 生成
   **/
  override public function create():Void {
    super.create();

    _txt = new FlxText(32, 32, 128);
    _txt.setFormat(Reg.PATH_FONT, Reg.FONT_SIZE);
    _txt.text = "エンディング画面";
    this.add(_txt);
  }

  /**
   * 破棄
   **/
  override public function destroy():Void {
    super.destroy();
  }

  /**
   * 更新
   **/
  override public function update():Void {
    super.update();

    if(Key.press.A) {
      // タイトル画面に進む
      FlxG.switchState(new TitleState());
    }
  }
}