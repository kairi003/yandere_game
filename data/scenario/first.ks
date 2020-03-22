

; setting
[title name="ピザ屋バイト式鬼ごっこ"]
[stop_keyconfig]
[hidemenubutton]
[layopt layer="message" visible=false]


; デバッグ用（パッケージ時には絶対にfalseに指定）
; 起動時にシステム変数を初期化
[iscript]
sf.start_clear_system = true;
[endscript]


; system file
@call storage="setting/system/system-main.ks"

; csv file
@call storage="setting/csv/csv-main.ks"

; param file
@call storage="setting/param/param-main.ks"

; call file
@call storage="setting/call/call-main.ks"

; character file
@call storage="setting/character/character-main.ks"

; ESC, F11
@key_event method="esc"
@key_event method="screen_full"



[iscript]
console.log("↓");
console.log("↓");
console.log("↓");
console.log("↓");
console.log("↓");
[endscript]



[reset_all]
[layopt layer="message" visible=false]
[layopt layer="fix" visible="true"]
[layopt layer="0" visible="true"]
[layopt layer="1" visible="false"]
[layopt layer="2" visible="false"]


; ローディング画面を削除
[wait time="500"]
[iscript]
$('.loadingWrap').css({'display':'none'});
[endscript]



; -- test --
;@jump storage="test/01.ks"
; ----------



;main.ksへ移動
@jump storage="main.ks"

[s]
