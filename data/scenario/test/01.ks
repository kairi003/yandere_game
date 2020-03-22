
[layopt layer="message0"  visible="true"]
[bg storage="school/room1/room1-1.jpg" time="10"]
[l]
[iscript]
$(".current_span").fadeTo(0, 0.5);
[endscript]
テストテストテスト






[s]


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
      (".base_fore").empty();
    });
  [endscript]
[endmacro]

; ----------------------------------------------

; bg2で画像を表示
[bg2 storage="school/room1/room1-1.jpg"]

; クリック待ち
[l]

; 背景を削除
[delete_bg]
; or
[delete_bg_fadeout time="1000"]

[iscript]
console.log("baseレイヤーの中身を空にしました");
[endscript]

[s]

[close]
[s]
