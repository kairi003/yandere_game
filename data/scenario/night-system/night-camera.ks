; == [camera] ==================================================================
*camera
;[eval exp="console.log('cameraView:'+tf.camera_num)"]



; キーイベント初期化
[clear_key_event]



; sf.camera_timer起動
[iscript]
tf.check_enemy_move = f.enemy_place;
tf.check_if = false;
var camera_time = function(){
  f.stage.player.battery--;
  if (f.stage.player.battery<=0) f.stage.player.battery = 0;
  // 敵が移動していたら敵を削除する（カメラ難易度を実装する時はここも書き換える）
  if (tf.check_enemy_move != f.enemy_place && tf.check_if == false) {
    tyrano.plugin.kag.stat.is_stop = true;
    tyrano.plugin.kag.ftag.startTag("free",{
      layer: 2,
      name: 'enemy',
      time: 1
    });
    tyrano.plugin.kag.stat.is_stop = false;
    tf.check_if = true;
  }
}
sf.camera_timer = setInterval(camera_time, f.stage.player.battery_decrease_time);
[endscript]



; debug用
;[iscript]
;for ( i=0; i<sf.key_code_list_array.length; i++ ) {
;  if (sf.key_code_list_array[i][2] == tf.camera_num) {
;    console.log(">>> camera-" + sf.key_code_list_array[i][1] +  " view");
;  }
;}
;[endscript]



; レイヤーオプション
[layopt layer="message0" visible="false"]
[layopt layer="fix" visible="false"]
[layopt layer="0" visible="false"]
[layopt layer="1" visible="false"]
[layopt layer="2" visible="true"]



; レイヤー乗算
[layermode time="1" graphic="layer_line_black.png" opacity="120" name="camera"]



; 色々表示
[bg storage="&f.stage.bg[tf.camera_num][1]" time="1"]
[eval exp="tf.text = 'Camera-' + sf.key_code_list_array[tf.camera_num-1][1]"]
[ptext layer="2" text="&tf.text" x="20" y="20" size="50" color="white" time="1"]



; 敵がそのエリアにいた場合の処理
[if exp="f.enemy_place == tf.camera_num"]
  [iscript]
  tf.width = 300*1.5;
  tf.height = 400*1.5;
  tf.x = (1280-tf.width)/2;
  tf.y = 720-tf.height;
  [endscript]
  [image name="enemy" layer="2" storage="sample.png" x="&tf.x" y="&tf.y" width="&tf.width" height="&tf.height" time="1" wait="false"]
[endif]



; リターン処理
[if exp="sf.getDevice == 'sp' || sf.getDevice == 'tab'"]
  [l]
  [jump storage="&f.stage.var.storage" target="return_camera"]
[else]
  [key_event method="keyup" key_code="&sf.key_code_list_array[tf.camera_num-1][0]" storage="&f.stage.var.storage" target="return_camera"]
  [s]
[endif]
; ==============================================================================
