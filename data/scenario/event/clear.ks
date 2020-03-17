
[clearstack]
[iscript]
// timer停止
clearTimers();
console.log("==> game clear");
[endscript]
[clear_key_event]

[mask time="500"]
[reset_all]
[clearstack]
[layopt layer="0" visible="true"]
[layopt layer="message0" visible="true"]
[bg storage="school/gate/gate1.jpg" time="10"]
#
[mask_off time="500"]

; テスト用
#デバッグ
６時になりました。[r]
ゲームクリアです。[p]

やりなおしますか？[r]
⇒[link target="yes"]【はい】[endlink][r]
⇒[link target="no" ]【いいえ】[endlink][s]


*yes
[jump storage="first.ks"]



*no
[close ask="false"]
