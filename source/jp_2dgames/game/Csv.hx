package jp_2dgames.game;
import jp_2dgames.lib.CsvLoader;

/**
 * CSV読み込みモジュール
 **/
class Csv {
  // プレイヤー情報
  private var _player:CsvLoader = null;
  public var player(get, null):CsvLoader;
  private function get_player() {
    return _player;
  }
  // 敵情報
  private var _enemy:CsvLoader = null;
  public var enemy(get, null):CsvLoader;
  private function get_enemy() {
    return _enemy;
  }
  // 敵出現
  private var _enemy_appear:CsvLoader = null;
  public var enemy_appear(get, null):CsvLoader;
  private function get_enemy_appear() {
    return _enemy_appear;
  }
  // 消費アイテム
  private var _itemConsumable:CsvLoader = null;
  public var itemConsumable(get, null):CsvLoader;

  private function get_itemConsumable() {
    return _itemConsumable;
  }
  // 装備アイテム
  private var _itemEquipment:CsvLoader = null;
  public var itemEquipment(get, null):CsvLoader;

  private function get_itemEquipment() {
    return _itemEquipment;
  }
  // メッセージ
  private var _message:CsvLoader = null;
  public var message(get, null):CsvLoader;

  private function get_message() {
    return _message;
  }

  public function new() {
    _player = new CsvLoader("assets/levels/player.csv");
    _enemy = new CsvLoader("assets/levels/enemy.csv");
    _enemy_appear = new CsvLoader("assets/levels/enemy_appear.csv");
    _itemConsumable = new CsvLoader("assets/levels/item_consumable.csv");
    _itemEquipment = new CsvLoader("assets/levels/item_equipment.csv");
    _message = new CsvLoader("assets/data/message.csv");
  }

  /**
   * 敵出現テーブルを参照する番号を取得する
   **/
  public function getEnemyAppearId(floor:Int):Int {
    // 参照するデータ番号を調べる
    return _enemy_appear.foreachSearchID(function(data) {
      var start = Std.parseInt(data["start"]);
      var end = Std.parseInt(data["end"]);
      if(start <= floor && floor <= end) {
        return true;
      }
      return false;
    });
  }
}
