// マップ読み込み
MAP_LOAD,001.tmx
// プレイヤー生成
NPC_CREATE,0,player,12,5,down
// ネコ生成
NPC_CREATE,1,cat,6,4,random
NPC_CREATE,2,cat,18,5,random
NPC_CREATE,3,cat,8,7,random
NPC_CREATE,4,cat,14,6,random
// ネコの色設定
NPC_COLOR,1,0xfffa8072
NPC_COLOR,2,0xFF80A0FF
NPC_COLOR,3,0xffffffff
NPC_COLOR,4,0xffbfff00
// ランダム移動
NPC_RANDOM,1
NPC_RANDOM,2
NPC_RANDOM,3
NPC_RANDOM,4
FADE_IN,black
// メッセージ表示
MSG,1
FADE_OUT,white
WAIT,0.5
// ネコを消す
NPC_DESTROY,1
NPC_DESTROY,2
NPC_DESTROY,3
NPC_DESTROY,4
FADE_IN,white
MSG,2
MSG,3
MSG,4
MSG,5
