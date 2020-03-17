

; イベント展示用ksメインファイル

[mask time="10"]
[bg storage="school/courtyard/courtyard1.jpg" time="10"]
[layopt layer="message0" visible="true"]
[layopt layer="fix" visible="true"]
[add_theme_button]
[mask_off]


#デバッグ
[font color="skyblue"]ステージを選択してください。[resetfont]


; stage選択
;[eval exp="tf.max = sf.stages.length-1"]
;[getrand max="&tf.max" min="0"]
;[eval exp="f.select_stage = sf.stages[tf.rand]"]
[glink text="stage-1" x="160" y=" 50" width="640" exp="f.select_stage = 'stage1'" target="*selected_stage"]
[glink text="stage-2" x="160" y="150" width="640" exp="f.select_stage = 'stage2'" target="*selected_stage"]
[glink text="stage-3" x="160" y="250" width="640" exp="f.select_stage = 'stage3'" target="*selected_stage"]
[glink text="stage-やれるもんならやってみろ" x="160" y="350" width="640" exp="f.select_stage = 'stage4'" target="*selected_stage"]
[s]

*selected_stage
; debug用
;[eval exp="f.select_stage = 'stage4'"]
[iscript]
console.log('==> selected stage is ' + f.select_stage);
[endscript]


@jump storage="event/night-main.ks"


[s]
