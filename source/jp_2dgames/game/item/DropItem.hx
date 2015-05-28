package jp_2dgames.game.item;
import jp_2dgames.game.item.ItemUtil.IType;
import jp_2dgames.game.gui.Message;
import jp_2dgames.game.gui.Inventory;
import jp_2dgames.game.item.ItemUtil.IType;
import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;

/**
 * アイテム
 **/
class DropItem extends FlxSprite {

  // 管理クラス
  public static var parent:FlxTypedGroup<DropItem> = null;
  // チップ座標
  public var xchip(default, null):Int;
  public var ychip(default, null):Int;
  // ID
  public var id(default, null):Int;
  // アイテム種別
  public var type(default, null):IType;
  // 名前
  public var name(default, null):String;
  // 拡張パラメータ
  public var value(default, null):Int;

  /**
   * アイテムを配置する
   **/
  public static function add(i:Int, j:Int, itemid:Int, value:Int=0):DropItem {
    var item:DropItem = parent.recycle();
    if(item == null) {
      return null;
    }
    var type = ItemUtil.getType(itemid);
    item.init(i, j, type, itemid, value);

    return item;
  }

  /**
   * お金を配置する
   **/
  public static function addMoney(i:Int, j:Int, value:Int):DropItem {
    var item:DropItem = parent.recycle();
    if(item == null) {
      return null;
    }
    item.init(i, j, IType.Money, 0, value);
    return item;
  }

  /**
   * 指定の座標にあるアイテム情報を取得する
   * @return 何もなかったらnull
   **/
  public static function getFromChipPosition(xchip:Int, ychip:Int):ItemData {
    var data:ItemData = null;
    parent.forEachAlive(function(item:DropItem) {
      if(xchip == item.xchip && ychip == item.ychip) {
        data = new ItemData(item.id);
      }
    });

    return data;
  }

  /**
	 * 指定座標にあるアイテムを拾う
	 * @return アイテムを拾えたらtrue
	 **/
  public static function pickup(xchip:Int, ychip:Int):Bool {
    var bFind = false;
    parent.forEachAlive(function(item:DropItem) {
      if(xchip == item.xchip && ychip == item.ychip) {
        // 拾える
        bFind = true;
        if(item.type == IType.Money) {
          // お金はインベントリに入れない
          Message.push2(Msg.ITEM_PICKUP, [item.name]);
          // お金はIDが金額
          Global.addMoney(item.value);
          item.kill();
        }
        else {
          // アイテム所持数をチェック
          if(Inventory.isFull()) {
            // 拾えない
            Message.push2(Msg.ITEM_FULL);
            Message.push2(Msg.ITEM_STEPON, [item.name]);
          }
          else {
            // アイテムを拾えた
            Message.push2(Msg.ITEM_PICKUP, [item.name]);
            Inventory.push(item.id);
            item.kill();
          }
        }
      }
    });

    if(bFind) {
      // アイテムを拾った
      return true;
    }

    // 拾えなかった
    return false;
  }
  /**
	 * コンストラクタ
	 **/

  public function new() {
    super();

    // 画像読み込み
    loadGraphic("assets/images/item.png", true);

    // アニメーションを登録
    _registAnim();

    // 中心を基準に描画
    offset.set(width / 2, height / 2);

    // 消しておく
    kill();
  }

  /**
	 * 初期化
	 **/

  public function init(X:Int, Y:Int, type:IType, itemid:Int, value:Int) {
    id = itemid;
    this.type = type;
    this.value = value;
    xchip = X;
    ychip = Y;
    x = Field.toWorldX(X);
    y = Field.toWorldY(Y);

    // 名前
    if(type == IType.Money) {
      name = '${itemid}円';
    }
    else {
      name = ItemUtil.getName(id);
    }

    // アニメーション再生
    animation.play(ItemUtil.toString(type));
  }

  /**
	 * アニメーションを登録
	 **/

  private function _registAnim():Void {
    animation.add(ItemUtil.toString(ItemUtil.IType.Weapon), [0], 1);
    animation.add(ItemUtil.toString(ItemUtil.IType.Armor), [1], 1);
    animation.add(ItemUtil.toString(ItemUtil.IType.Scroll), [2], 1);
    animation.add(ItemUtil.toString(ItemUtil.IType.Wand), [3], 1);
    animation.add(ItemUtil.toString(ItemUtil.IType.Portion), [4], 1);
    animation.add(ItemUtil.toString(ItemUtil.IType.Ring), [5], 1);
    animation.add(ItemUtil.toString(ItemUtil.IType.Money), [6], 1);
    animation.add(ItemUtil.toString(ItemUtil.IType.Food), [7], 1);
  }
}
