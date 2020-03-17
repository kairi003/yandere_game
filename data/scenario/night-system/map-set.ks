
; プレイヤーが次に進むことが出来るマスを取得
; f.chara_move_areaに格納
[loadjs storage="../scenario/night-system/player-place.js"]

[iscript]
tyrano.plugin.kag.stat.is_stop = true;
var image = function( x, y, width, height ){
  tyrano.plugin.kag.ftag.startTag("image",{
    name: "map_ui",
    layer: 1,
    zindex: 1,
    page: "fore",
    storage: "color/white.png",
    x: x,
    y: y,
    width: width,
    height: height,
    time: 1
  });
}
var num = 1;
f.button_param = {};
for ( i=0; i<f.stage.map.length; i++ ) {
  for ( j=0; j<f.stage.map[i].length; j++ ) {
    if ( f.stage.map[i][j] == 1 ) { // 座標取得
      f.button_param[num] = {};
      f.button_param[num]['width'] = (sf.game.map_size/f.stage.map[i].length);
      f.button_param[num]['height'] = (sf.game.map_size/f.stage.map.length);
      f.button_param[num]['x'] = 20 + (f.button_param[num]['width']*j);
      f.button_param[num]['y'] = 20 + (f.button_param[num]['height']*i);
      //デバッグ用
      //for(keyi in f.button_param) console.log("-->number" + keyi); for(keyj in f.button_param[keyi]) console.log(keyj+": "+f.button_param[keyi][keyj]);
      num++;
    }
    if ( f.stage.map[i][j] != 2 ) { // ライン表示
      // 上に０か１があるか解析
      if (i>0) {
        if (f.stage.map[i-1][j] == 0 || f.stage.map[i-1][j] == 1) {
          var width = (sf.game.map_size/f.stage.map[i].length)/5;
          var height = (sf.game.map_size/f.stage.map.length)/2;
          var x = (width*2) + 20 + ((sf.game.map_size/f.stage.map[i].length)*j);
          var y = 20 + ((sf.game.map_size/f.stage.map.length)*i);
          image(x,y,width,height);
        }
      }
      // 下に０か１があるか解析
      if (i+1<f.stage.map.length) {
        if (f.stage.map[i+1][j] == 0 || f.stage.map[i+1][j] == 1) {
          var width = (sf.game.map_size/f.stage.map[i].length)/5;
          var height = (sf.game.map_size/f.stage.map.length)/2;
          var x = (width*2) + 20 + ((sf.game.map_size/f.stage.map[i].length)*j);
          var y = (height) + 20 + ((sf.game.map_size/f.stage.map.length)*i);
          image(x,y,width,height);
        }
      }
      // 左に０か１があるか解析
      if (j>0) {
        if (f.stage.map[i][j-1] == 0 || f.stage.map[i][j-1] == 1) {
          var width = (sf.game.map_size/f.stage.map[i].length)/2;
          var height = (sf.game.map_size/f.stage.map.length)/5;
          var x = 20 + ((sf.game.map_size/f.stage.map[i].length)*j);
          var y = ((sf.game.map_size/f.stage.map.length)/2) - (height/2) + 20 + ((sf.game.map_size/f.stage.map.length)*i);
          image(x,y,width,height);
        }
      }
      // 右に０か１があるか解析
      if (j+1<f.stage.map[i].length) {
        if (f.stage.map[i][j+1] == 0 || f.stage.map[i][j+1] == 1) {
          var width = (sf.game.map_size/f.stage.map[i].length)/2;
          var height = (sf.game.map_size/f.stage.map.length)/5;
          var x = ((sf.game.map_size/f.stage.map[i].length)/2) + 20 + ((sf.game.map_size/f.stage.map[i].length)*j);
          var y = ((sf.game.map_size/f.stage.map.length)/2) - (height/2) + 20 + ((sf.game.map_size/f.stage.map.length)*i);
          image(x,y,width,height);
        }
      }
      delete width;
      delete height;
      delete x;
      delete y;
    }
  }
}
delete num;
tyrano.plugin.kag.stat.is_stop = false;
[endscript]


[eval exp="f.i = 1"]
*return_for
[clearstack]
[iscript]
//console.log("loop-->"+f.i);
[endscript]
[if exp="f.i<=f.stage.var.area_sum"]
  [iscript]
  f.x = f.button_param[f.i]['x'];
  f.y = f.button_param[f.i]['y'];
  f.width = f.button_param[f.i]['width'];
  f.height = f.button_param[f.i]['height'];
  f.player_box = false;
  if (f.player_place == f.i) {
    f.player_box = true;
  } else {
    f.able_box = false;
    for (var j=0; j<f.chara_move_area.length; j++) {
      if (f.stage.area_data[f.i][0] == f.chara_move_area[j][0].y && f.stage.area_data[f.i][1] == f.chara_move_area[j][0].x) {
        f.able_box = true;
      }
    }
  }
  [endscript]
; ボックスを表示
  [if exp="f.player_box == false"]
    [if exp="f.able_box == true"]
      [iscript]
      f.graphic = "../fgimage/map-box/2/" + sf.key_code_list_array[f.i-1][1] + ".png";
      [endscript]
      [locate x="&f.x" y="&f.y"]
      [button fix="true" graphic="&f.graphic" width="&f.width" height="&f.width" hint="&f.stage.bg[f.i][2]" storage="&f.stage.var.storage" target="return_area" preexp="f.i" exp="f.player_place=preexp"]
    [elsif exp="f.able_box == false"]
      [iscript]
      f.graphic = "../fgimage/map-box/3/" + sf.key_code_list_array[f.i-1][1] + ".png";
      [endscript]
      [image name="map_ui" layer="1" zindex="10" storage="&f.graphic" x="&f.x" y="&f.y" width="&f.width" height="&f.width" time="10" wait="false"]
    [endif]
  [elsif exp="f.player_box == true"]
    [iscript]
    f.graphic = "../fgimage/map-box/1/" + sf.key_code_list_array[f.i-1][1] + ".png";
    [endscript]
    [image name="map_ui" layer="1" zindex="10" storage="&f.graphic" x="&f.x" y="&f.y" width="&f.width" height="&f.width" time="10" wait="false"]
  [endif]
  [iscript]
  //console.log("area key code-->"+sf.key_code_list_array[f.i-1][1]);
  f.i=f.i+1;
  //console.log("next-->"+f.i);
  [endscript]
  [jump storage="night-system/map-set.ks" target="return_for"]
[elsif exp="f.i>f.stage.var.area_sum"]
[endif]
*endfor
[clearstack]


[jump storage="&f.stage.var.storage" target="return_map_set"]
