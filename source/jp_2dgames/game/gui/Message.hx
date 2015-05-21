package jp_2dgames.game.gui;
import jp_2dgames.lib.CsvLoader;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

/**
 * メッセージウィンドウ
 **/
class Message extends FlxGroup {

  // メッセージの最大
  private static inline var MESSAGE_MAX = 5;
  // ウィンドウ座標
  private static inline var POS_X = 8;
  private static inline var POS_Y = 320 + 8;
  private static inline var POS_Y2 = 8;
  // ウィンドウサイズ
  private static inline var WIDTH = 640 - 8 * 2;
  private static inline var HEIGHT = 160 - 8 * 2;
  private static inline var MSG_POS_X = 8;
  private static inline var MSG_POS_Y = 8;
  // メッセージ表示間隔
  private static inline var DY = 26;

  // ウィンドウが消えるまでの時間 (3sec)
  private static inline var TIMER_DISAPPEAR:Float = 3;

  // インスタンス
  public static var instance:Message = null;

  // メッセージの追加

  public static function push(msg:String) {
    Message.instance.pushMsg(msg);
  }

  public static function push2(msgId:Int, args:Array<Dynamic>) {
    Message.instance.pushMsg2(msgId, args);
  }

  private var _window:FlxSprite;
  private var _msgList:List<FlxText>;

  // ウィンドウが消えるまでの時間
  private var _timer:Float;

  // メッセージCSV
  private var _csv:CsvLoader;

  /**
	 * コンストラクタ
	 **/

  public function new(csv:CsvLoader) {
    super();
    // 背景枠
    _window = new FlxSprite(POS_X, POS_Y).makeGraphic(WIDTH, HEIGHT, FlxColor.BLACK);
    _window.alpha = 0.5;
    this.add(_window);
    _msgList = new List<FlxText>();

    // CSVメッセージ
    _csv = csv;

    // 非表示
    visible = false;
  }

  private var ofsY(get_ofsY, null):Float;

  private function get_ofsY() {
    var player = cast(FlxG.state, PlayState).player;
    var y = (player.ychip + 2) * Field.GRID_SIZE;
    if(y > POS_Y) {
      // 上にする
      return POS_Y2;
    }
    else {
      // 下にする
      return POS_Y;
    }
  }

  /**
	 * 更新
	 **/

  override public function update():Void {
    super.update();

    if(visible) {
      _timer -= FlxG.elapsed;
      if(_timer < 0) {
        // 一定時間で消える
        visible = false;
        // メッセージを消す
        while(_msgList.length > 0) {
          pop();
        }
      }
    }

    // 座標更新
    _window.y = ofsY;
    var idx = 0;
    for(text in _msgList) {
      text.y = ofsY + MSG_POS_Y + idx * DY;
      idx++;
    }
  }

  /**
	 * メッセージを末尾に追加
	 **/

  public function pushMsg(msg:String) {
    var text = new FlxText(POS_X + MSG_POS_X, 0, 480);
    text.setFormat(Reg.PATH_FONT, Reg.FONT_SIZE);
    text.text = msg;
    if(_msgList.length >= MESSAGE_MAX) {
      // 最大を超えたので先頭のメッセージを削除
      pop();
    }
    _msgList.add(text);

    // 座標を更新
    var idx = 0;
    for(t in _msgList) {
      t.y = ofsY + MSG_POS_Y + idx * DY;
      idx++;
    }
    this.add(text);

    // 表示する
    visible = true;
    _timer = TIMER_DISAPPEAR;
  }

  public function pushMsg2(msgId:Int, args:Array<Dynamic>):Void {
    var msg = _csv.searchItem("id", '${msgId}', "msg");
    var idx:Int = 1;
    for(val in args) {
      msg = StringTools.replace(msg, '<val${idx}>', '${val}');
      idx++;
    }
    pushMsg(msg);
  }

  /**
	 * 先頭のメッセージを削除
	 **/

  public function pop() {
    var t = _msgList.pop();
    this.remove(t);
  }
}