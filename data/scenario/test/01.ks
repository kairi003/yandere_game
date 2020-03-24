; プラグイン読み込み
[plugin name="noskip"]

; レイヤー設定
[layopt layer="message0" visible="true"]
[add_theme_button]

スキップ開始[p]

; スキップ禁止
[noskip]

; スキップ開始（これでスキップしなければ成功）
;[skipstart]
[eval exp="tyrano.plugin.kag.ftag.startTag('skipstart')"]

テスト1[p]
テスト2[p]
テスト3[p]
テスト4[p]
テスト5[p]

; スキップを停止
[skipstop]

; スキップ禁止を解除
[endnoskip]

終了[s]





[iscript]
tf.obj = {
  map: {
    array: [],
    cdn: [],
  },
  player: {
    place: { x: 0, y: 0 }
  },
  system: {
    px: 80,
  },
  method: {}
}

// mapをセット
var yc = 0;
var yloop = true;
while (yloop) {
  tf.obj.map.array[yc] = [];
  tf.obj.map.cdn[yc] = [];
  var xc = 0;
  var xloop = true;
  while (xloop) {
    tf.obj.map.array[yc][xc] = 0;
    tf.obj.map.cdn[yc][xc] = { x: tf.obj.system.px*xc, y: tf.obj.system.px*yc };
    if (tf.obj.system.px*(xc+1) >= system.width) xloop = false;
    else xc++;
  }
  if (tf.obj.system.px*(yc+1) >= system.height) yloop = false;
  else yc++;
}

tf.obj.method = {
  action: function(player_to) {
    tf.obj.method.move('player',player_to);
    var dir = ["up","left","down","right"];
    var rand = randNum(0,3);
    tf.obj.method.move('enemy0',dir[rand]);
    if (tf.obj.player.place.x == tf.obj.enemy0.place.x && tf.obj.player.place.y == tf.obj.enemy0.place.y) {
      tyrano.plugin.kag.stat.is_stop = true;
      tyrano.plugin.kag.ftag.startTag("free",{ name: "player", layer: 0, time: 1, });
      alert("gameover");
      tyrano.plugin.kag.ftag.startTag("close",{ ask:false });
      tyrano.plugin.kag.stat.is_stop = false;
    }
  },
  move: function(name,to) {
    var anim = true;
    switch (to) {
      case "up": tf.obj[name].place.y--; break;
      case "left": tf.obj[name].place.x--; break;
      case "down": tf.obj[name].place.y++; break;
      case "right": tf.obj[name].place.x++; break;
    }
    if (tf.obj[name].place.y >= tf.obj.map.array.length) {
      tf.obj[name].place.y--;
      anim = false;
    } else if (tf.obj[name].place.y < 0) {
      tf.obj[name].place.y++;
      anim = false;
    }
    if (tf.obj[name].place.x >= tf.obj.map.array[0].length) {
      tf.obj[name].place.x--;
      anim = false;
    } else if (tf.obj[name].place.x < 0) {
      tf.obj[name].place.x++;
      anim = false;
    }
    console.log("name: " + name + "\nto: " + to + "\nanim: " + anim);
    if (anim) {
      var x = tf.obj.map.cdn[tf.obj[name].place.y][tf.obj[name].place.x].x;
      var y = tf.obj.map.cdn[tf.obj[name].place.y][tf.obj[name].place.x].y;
      tyrano.plugin.kag.stat.is_stop = true;
      tyrano.plugin.kag.ftag.startTag("anim",{ name: name, left: x, top: y, time: 1, });
      tyrano.plugin.kag.stat.is_stop = false;
    }
  }
}

console.log(tf.obj);
[endscript]


[layopt layer="0" visible="true"]
[iscript]
tf.obj.player.place.x = 0;
tf.obj.player.place.y = 0;
[endscript]
[image name="player" layer="0" storage="../fgimage/color/col1.png" x="&tf.obj.map.cdn[tf.obj.player.place.y][tf.obj.player.place.x].x" y="&tf.obj.map.cdn[tf.obj.player.place.y][tf.obj.player.place.x].y" width="&tf.obj.system.px" height="&tf.obj.system.px" time="1"]

[iscript]
tf.obj.enemy0 = { place: {} };
tf.obj.enemy0.place.x = tf.obj.map.array[0].length-1;
tf.obj.enemy0.place.y = tf.obj.map.array.length-1;
[endscript]
[image name="enemy0" layer="0" storage="../fgimage/color/col3.png" x="&tf.obj.map.cdn[tf.obj.enemy0.place.y][tf.obj.enemy0.place.x].x" y="&tf.obj.map.cdn[tf.obj.enemy0.place.y][tf.obj.enemy0.place.x].y" width="&tf.obj.system.px" height="&tf.obj.system.px" time="1"]


; up
[key_event method="keydown" key_code="38" exp="tf.obj.method.action('up')"]
[key_event method="keydown" key_code="87" exp="tf.obj.method.action('up')"]

; left
[key_event method="keydown" key_code="37" exp="tf.obj.method.action('left')"]
[key_event method="keydown" key_code="65" exp="tf.obj.method.action('left')"]

; down
[key_event method="keydown" key_code="40" exp="tf.obj.method.action('down')"]
[key_event method="keydown" key_code="80" exp="tf.obj.method.action('down')"]

; right
[key_event method="keydown" key_code="39" exp="tf.obj.method.action('right')"]
[key_event method="keydown" key_code="68" exp="tf.obj.method.action('right')"]


[s]



*end
[clear_key_event]
[close ask="false"]





; 実質[freeimage layer="base"]と同じだがこれだけだとTimeの指定が出来ない（一瞬で真っ黒に）
[macro name="delete_bg"]
  [iscript]
    $(".base_fore").empty();
  [endscript]
[endmacro]

; time [ms]を指定できる・fadeOut（もっと良い方法があるかも）
[macro name="delete_bg_fadeout"]
  [iscript]
    mp.time = mp.time || 700;
    $(".base_fore").fadeOut(mp.time).queue(function() {
      $(".base_fore").empty();
    });
  [endscript]
[endmacro]

; ----------------------------------------------

; bg2で画像を表示
[bg2 storage="school/room1/room1-1.jpg"]

; クリック待ち
[l]

; 背景を削除
;[delete_bg]
; or
[delete_bg_fadeout time="1000"]

[iscript]
console.log("baseレイヤーの中身を空にしました");
[endscript]

[s]

[close]
[s]
