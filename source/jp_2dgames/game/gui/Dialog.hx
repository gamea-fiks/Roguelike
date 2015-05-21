package jp_2dgames.game.gui;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

private enum State {
  Main; // メイン
  Closed;
  // 閉じた
}

/**
 * ダイアログ
 **/
class Dialog extends FlxGroup {
  // ダイアログの種類
  public static inline var OK:Int = 0; // OKダイアログ
  public static inline var YESNO:Int = 1; // Yes/Noダイアログ
  public static inline var SELECT2:Int = 2; // 2択ダイアログ

  private static var _instance:Dialog = null;
  // カーソル番号
  private static var _nCursor:Int = 0;

  public static function getCursor():Int {
    return _nCursor;
  }

  // ダイアログの種類
  private var _type:Int;
  // 状態
  private var _state:State = State.Main;
  public var state(get, null):State;

  private function get_state() {
    return _state;
  }
  // カーソル
  private var _cursor:FlxSprite = null;
  // カーソルの最大
  private var _cursorMax:Int = 0;

  /**
	 * 閉じたかどうか
	 **/

  public static function isClosed():Bool {
    return _instance.state == State.Closed;
  }

  /**
	 * 開く
	 **/

  public static function open(type:Int, msg:String, sels:Array<String>=null):Void {
    _instance = new Dialog(type, msg, sels);
    FlxG.state.add(_instance);
    _nCursor = 0;
  }

  /**
	 * コンストラクタ
	 **/

  private function new(type:Int, msg:String, sels:Array<String>) {
    super();

    var px = Reg.centerX();
    var py = Reg.centerY();
    var height = 64;
    // ウィンドウ
    var spr = new FlxSprite(px, py - height);
    this.add(spr);

    // メッセージ
    var text = new FlxText(px, py - 48, 0, 128);
    text.setFormat(Reg.PATH_FONT, Reg.FONT_SIZE);
    text.text = msg;
    var width = text.textField.width;
    text.x = px - width / 2;
    this.add(text);

    // ウィンドウサイズを設定
    spr.makeGraphic(Std.int(width * 2), height * 2, FlxColor.BLACK);
    spr.x -= width;
    spr.alpha = 0.5;

    // 選択肢
    var py2 = FlxG.height / 2;
    _type = type;
    switch(_type) {
      case OK:
        var txtOk = new FlxText(px, py2, 0, 64);
        txtOk.setFormat(Reg.PATH_FONT, Reg.FONT_SIZE);
        txtOk.text = "OK";
        txtOk.x = px - txtOk.textField.width / 2;
        this.add(txtOk);
        _cursorMax = 1;
      case YESNO:
        var txtYes = new FlxText(px, py2, 0, 64);
        txtYes.setFormat(Reg.PATH_FONT, Reg.FONT_SIZE);
        txtYes.text = "はい";
        txtYes.x = px - 80;
        this.add(txtYes);
        var txtNo = new FlxText(px, py2, 0, 64);
        txtNo.setFormat(Reg.PATH_FONT, Reg.FONT_SIZE);
        txtNo.text = "いいえ";
        txtNo.x = px + 24;
        this.add(txtNo);
        _cursorMax = 2;
      case SELECT2:
        var txtYes = new FlxText(px, py2, 0, 64);
        txtYes.setFormat(Reg.PATH_FONT, Reg.FONT_SIZE);
        txtYes.alignment = "center";
        txtYes.text = sels[0];
        txtYes.x = px - 80;
        this.add(txtYes);
        var txtNo = new FlxText(px, py2, 0, 64);
        txtNo.setFormat(Reg.PATH_FONT, Reg.FONT_SIZE);
        txtNo.text = sels[1];
        txtNo.alignment = "center";
        txtNo.x = px + 12;
        this.add(txtNo);
        _cursorMax = 2;
    }

    // カーソル
    _cursor = new FlxSprite(px - 80, py2);
    _cursor.makeGraphic(84, 32, FlxColor.AQUAMARINE);
    _cursor.alpha = 0.3;
    this.add(_cursor);
  }

  /**
	 * 更新
	 **/

  override public function update():Void {
    super.update();

    switch(_state) {
      case State.Main:
        if(Key.press.LEFT || Key.press.UP) {
          _nCursor--;
          if(_nCursor < 0) {
            _nCursor = _cursorMax - 1;
          }
        }
        else if(Key.press.RIGHT || Key.press.DOWN) {
          _nCursor++;
          if(_nCursor >= _cursorMax) {
            _nCursor = 0;
          }
        }
        _updataeCursor();

        if(Key.press.A) {
          _state = State.Closed;
          FlxG.state.remove(this);
        }

      case State.Closed:

    }
  }

  /**
	 * カーソル位置の更新
	 **/

  private function _updataeCursor():Void {
    var px = Reg.centerX();
    switch(_nCursor) {
      case 0:
        _cursor.x = px - 80;
      case 1:
        _cursor.x = px + 12;
    }
  }
}