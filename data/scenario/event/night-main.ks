

; 最初にマスクだけ
[mask time="500"]
[cm][clearstack]


; == 初期設定 ==================================================================
[iscript]

// ステージ選択
var stage = f.select_stage;

// オブジェクトを初期化
f.stage = {
  map: [],
  bg: [],
  var: {
    area_sum: 0,
    storage: null,
    game_over_storage: null,
    clear_storage: null,
  },
  player: {
    night_time: 0,
    stamina: 0,
    stamina_recovery_time: 0,
    battery: 0,
    battery_max: 0,
    battery_decrease_time: 0,
  },
  enemy: {
    interval_time: 0,
    fast_move_per: 0,
    camera_difficulty: 0,
  },
  area_data: {},
};


// -- [CSVのデータからナイトゲームのデータに落とす] ------------------------------
f.stage.map = sf.stage_datas[stage]['map'];  // マップの二次配列データ
f.stage.bg = sf.stage_datas[stage]['data'];  // ナイトの背景データ

f.stage.var.storage = sf.stage_datas[stage]['obj'][1][0];  // ナイトのメインファイル
f.stage.var.game_over_storage = sf.stage_datas[stage]['obj'][1][1];  // ゲームオーバー時のファイル
f.stage.var.clear_storage = sf.stage_datas[stage]['obj'][1][2];  // ゲームオーバー時のファイル

f.stage.player.night_time = Number(sf.stage_datas[stage]['obj'][1][3]*1000*60);  // ナイトの時間（だいたい固定）×1000*60[min]（f.stamina_maxという変数があるが、stamina-recovery.jsで定義している）
f.stage.player.stamina = sf.stage_datas[stage]['obj'][1][4];  // 自機のスタミナ（１回移動するごとに１消費する・表示はパーセントで）
f.stage.player.stamina_recovery_time = Number(sf.stage_datas[stage]['obj'][1][5]*1000);  // スタミナが回復する時間 ×1000[s]
f.stage.player.battery = Number(sf.stage_datas[stage]['obj'][1][6]);  // 現在のカメラのバッテリー（表示はパーセントで）
f.stage.player.battery_max = f.stage.player.battery;  // バッテリーの最大値（ナイト中不変）
f.stage.player.battery_decrease_time = Number(sf.stage_datas[stage]['obj'][1][7]);  // カメラを見ている時、バッテリーが１消費される秒数[ms]

f.stage.enemy.interval_time = Number(sf.stage_datas[stage]['obj'][1][8]*1000);  // 敵が移動する時間 ×1000[s]
f.stage.enemy.fast_move_per = sf.stage_datas[stage]['obj'][1][9];  // 敵が効率的なルートを選択する確率 [%]
f.stage.enemy.camera_difficulty = sf.stage_datas[stage]['obj'][1][10];  // カメラ難易度

f.player_place = sf.stage_datas[stage]['obj'][1][11];  // 自機の初期位置
f.enemy_place = sf.stage_datas[stage]['obj'][1][12];  // 敵の初期位置
f.pre_enemy_prace = f.enemy_place;  // 敵の現在位置を保存

// マップを解析
console.log("~~~~~~~~~~~~~~~~~~~~~~")
var num = 1;
for( i=0; i<f.stage.map.length; i++ ){
  for( j=0; j<f.stage.map[i].length; j++ ){
    if( f.stage.map[i][j] == 1 ) {
      f.stage.area_data[num] = [];
      f.stage.area_data[num][0] = i;  // y
      f.stage.area_data[num][1] = j;  // x
      console.log("Area Number: " + num + ', place: ' + f.stage.area_data[num][0] + ", " + f.stage.area_data[num][1]);
      num++;
    }
  }
}
console.log("~~~~~~~~~~~~~~~~~~~~~~");
delete num;

f.stage.var.area_sum = Object.keys(f.stage.area_data).length; // 移動可能エリア総数

// MapNodeListインスタンス
console.log('==> instance MapNodeList');
f.stage.node_list = new MapNodeList(f.stage.map);
console.log(f.stage.node_list);

// ステージデータ読み込みデバッグ
console.log('==> loaded stage data');
console.log(f.stage);
console.log('player_place: ' + f.player_place);
console.log('enemy_place: ' + f.enemy_place);
// ---------------------------------------------------------------------------------------------------
[endscript]

[layopt layer="message0" visible="true"]
[layopt layer="fix" visible="true"]
[layopt layer="0" visible="true"]
[layopt layer="1" visible="true"]
[layopt layer="2" visible="false"]


; -- [動的UI表示] --------------------------------------------------------------------


[iscript]
// uiの各値を初期化
f.ui = {
  time: { val: 0, text: null },  // タイマー（0am,1am,2am,3am,4am,5am）・6amになった瞬間にゲームクリア
  battery: { val: 100, text: null },  // バッテリー（Max:100%）
  stamina: { val: 100, text: null }  // スタミナ（Max:100%）
};
f.ui.time.text = f.ui.time.val + ' AM';
f.ui.battery.text = 'Battery: ' + f.ui.battery.val + '%';
f.ui.stamina.text = 'Stamina: ' + f.ui.stamina.val + '%';
[endscript]

[if exp="sf.getDevice == 'sp' || sf.getDevice == 'tab'"]
  [ptext name="time_text" layer="0" text="&f.ui.time.text" color="white" size="60" x="0" y="15" width="1090" align="right"]
  [ptext name="battery_text" layer="0" text="&f.ui.battery.text" color="white" size="60" x="0" y="85" width="1090" align="right"]
  [ptext name="stamina_text" layer="0" text="&f.ui.stamina.text" color="white" size="60" x="0" y="155" width="1090" align="right"]
[else]
  [ptext name="time_text" layer="0" text="&f.ui.time.text" color="white" size="60" x="0" y="15" width="1265" align="right"]
  [ptext name="battery_text" layer="0" text="&f.ui.battery.text" color="white" size="60" x="0" y="85" width="1265" align="right"]
  [ptext name="stamina_text" layer="0" text="&f.ui.stamina.text" color="white" size="60" x="0" y="155" width="1265" align="right"]
[endif]


; ---------------------------------------------------------------------------


; -- [システム起動] -----------------------------------------------------------


; 色々関数を定義
[loadjs storage="../scenario/night-system/function.js"]


; 敵のAI
[loadjs storage="../scenario/night-system/enemy.js"]


; ナイトタイマー
[loadjs storage="../scenario/night-system/night-time.js"]


; スタミナ回復タイマー
[loadjs storage="../scenario/night-system/stamina-recovery.js"]


; 初期化処理：このあとでスタミナが減るので対策としてここで１増やしとく
[eval exp="f.stage.player.stamina++"]


; =============================================================================



*return_area
[clearstack]
[clear_key_event]
[iscript]
console.log("==> move Area " + f.player_place);
[endscript]



; 移動したのでStaminaを１減らす
[iscript]
f.stage.player.stamina--;
if (f.stage.player.stamina<=0) f.stage.player.stamina=0;
var per = f.stage.player.stamina/f.stamina_max;
f.ui.stamina.val = Math.floor(100 * per);
f.ui.stamina.text = 'Stamina: ' + f.ui.stamina.val + '%';
[endscript]
[free layer="0" name="stamina_text" time="1" wait="true"]
[if exp="sf.getDevice == 'sp' || sf.getDevice == 'tab'"]
  [ptext name="stamina_text" layer="0" text="&f.ui.stamina.text" color="white" size="60" x="0" y="155" width="1090" align="right"]
[else]
  [ptext name="stamina_text" layer="0" text="&f.ui.stamina.text" color="white" size="60" x="0" y="155" width="1265" align="right"]
[endif]
[if exp="f.stage.player.stamina == 0"]
  [jump storage="&f.stage.var.game_over_storage"]
[endif]



; エンカウント判定
[if exp="f.player_place == f.enemy_place"]
  [jump storage="&f.stage['var']['game_over_storage']"]
[endif]



[mask time="500"]
[cm][clearfix]
[free layer="1" name="map_ui" time="10"]
; スタート地点の背景表示
[bg storage="&f.stage.bg[f.player_place][1]" time="10"]
; マップ表示（400px×400px）
[jump storage="night-system/map-set.ks"]
*return_map_set
[iscript]
delete f.x;
delete f.y;
delete f.width;
delete f.height;
delete f.player_box;
delete f.graphic;
[endscript]
[mask_off time="500"]



*return_camera
[clearstack]



[clear_key_event]
[iscript]
clearInterval(sf.camera_timer);
[endscript]
[free_layermode time="1" name="camera"]
[layopt layer="message0" visible="true"]
[layopt layer="fix" visible="true"]
[layopt layer="0" visible="true"]
[layopt layer="1" visible="true"]
[layopt layer="2" visible="false"]
[freeimage layer="2" time="1"]
[bg storage="&f.stage.bg[f.player_place][1]" time="1"]



; バッテリーのUIの値とテキストを更新
[iscript]
var per = f.stage.player.battery/f.stage.player.battery_max;
f.ui.battery.val = Math.floor(100 * per);
f.ui.battery.text = 'Battery: ' + f.ui.battery.val + '%';
[endscript]
[free layer="0" name="battery_text" time="1" wait="true"]
[if exp="sf.getDevice == 'sp' || sf.getDevice == 'tab'"]
  [ptext name="battery_text" layer="0" text="&f.ui.battery.text" color="white" size="60" x="0" y="85" width="1090" align="right"]
[else]
  [ptext name="battery_text" layer="0" text="&f.ui.battery.text" color="white" size="60" x="0" y="85" width="1265" align="right"]
[endif]



[ignore exp="f.ui.battery.val <= 0"]
  [for name="tf.i" from="0" len="&f.stage.var.area_sum"]
    [iscript]
    var num = tf.i + 1;
    tf.break = false;
    if (f.player_place == num) tf.break = true;
    //else console.log(f.camera_target + " is ready");
    [endscript]
    [if exp="sf.getDevice == 'sp' || sf.getDevice == 'tab'"]
      [if exp="tf.break == false"]
        [iscript]
        tf.graphic = "camera-button/" + Number(tf.i+1) + ".png";
        [endscript]
        [locate x="&sf.camera_button[tf.i][0]" y="&sf.camera_button[tf.i][1]"]
        [button fix="true" graphic="&tf.graphic" width="&sf.camera_size" height="&sf.camera_size" storage="night-system/night-camera.ks" target="camera"]
      [else]
        [image name="map_ui" layer="1" storage="../image/camera-button/0.png" x="&sf.camera_button[tf.i][0]" y="&sf.camera_button[tf.i][1]" width="&sf.camera_size" height="&sf.camera_size"]
      [endif]
      [else]
    [ignore exp="tf.break == true"]
      [eval exp="tf.num = tf.i + 1"]
      [key_event method="keydown" key_code="&sf.key_code_list_array[tf.i][0]" storage="night-system/night-camera.ks" target="camera" preexp="&tf.num" exp="tf.camera_num = preexp"]
    [endignore]
    [endif]
  [nextfor]
  [iscript]
  console.log('all camera is ready');
  [endscript]
[endignore]





; スマホ・タブレットの時はボタン背景を表示する
[if exp="sf.getDevice == 'sp' || sf.getDevice == 'tab'"]
  [image layer="0" storage="box.png" x="1105" y="-47.5" width="175" height="595" time="10"]
[endif]





; ここにテキスト
[cm]
#
[if exp="f.stage.bg[f.player_place][3] == 'no data'"]
  [jump target="notext"]
[endif]

[nowait]
[chara_ptext name="&f.stage.bg[f.player_place][3]"]
[emb exp="f.stage.bg[f.player_place][4]"]
[endnowait]

*notext
[s]
