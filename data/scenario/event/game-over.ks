[iscript]
// timer停止
clearTimers();
console.log("==> game over");
[endscript]
[clear_key_event]

[mask time="500"]
[reset_all]
[clearstack]
[layopt layer="0" visible="true"]
[layopt layer="message0" visible="true"]
[bg storage="&f.stage.bg[f.player_place][1]" time="10"]
#
[mask_off time="500"]

; テスト用
[iscript]
tf.width = 300*1.5;
tf.height = 400*1.5;
tf.x = (1280-tf.width)/2;
tf.y = 720-tf.height;
[endscript]
[image layer="0" storage="sample.png" x="&tf.x" y="&tf.y" width="&tf.width" height="&tf.height" time="5000"]
[camera layer="0" zoom="5" time="5000" wait="false" ease_type="linear"]
#？？？
「んな～～～～～」
[wait time="2500"]
[mask time="2500"]
[wait_camera]

[reset_all]
#
[layopt layer="message0" visible="true"]
[mask_off]

[cm]
#
あなたはヤンデレ銀髪美少女に刺されて死亡しました……。[p]


やりなおしますか？[r]
⇒[link target="yes"]【はい】[endlink][r]
⇒[link target="no" ]【いいえ】[endlink][s]


*yes
[reset_all]
[clearstack]
[eval exp="tf.re_clear=true"]
[jump storage="first.ks"]



*no
[close ask="false"]
