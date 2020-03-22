




; =============================================================================
; alertマクロ
[macro name="alert"]
[iscript]
alert(mp.val);
[endscript]
[endmacro]

; ============================================================================
; console.logマクロ
[macro name="console_log"]
[iscript]
console.log(mp.val);
[endscript]
[endmacro]

[macro name="clog"]
[eval exp="console.log(mp.val)"]
[endmacro]





; =============================================================================
; [destroy]
; すべてのレイヤーの画像やテキスト、ボタンなどを破壊し、
; ゲーム画面を更地に戻します。
[macro name="destroy"]

; メニューボタンを隠す
[hidemenubutton]
; メッセージの削除およびフリーレイヤーの解放
; (フリーレイヤー＝ボタンやHTMLなどが挿入されるレイヤー)
[cm]
; fixレイヤーの解放
[clearfix]
; 合成レイヤーの解放
[free_layermode time="0"]
; フィルターの解放
[free_filter]
; レイヤーの解放
[freeimage layer="base"]
[freeimage layer="0"]
[freeimage layer="1"]
[freeimage layer="2"]
[freeimage layer="base" page="back"]
[freeimage layer="0"    page="back"]
[freeimage layer="1"    page="back"]
[freeimage layer="2"    page="back"]
; メッセージウィンドウの非表示
[layopt layer="message0" visible="false"]
[layopt layer="message1" visible="false"]
[endmacro]

; ------------------------------------------------------------

[macro name="reset_all"]
[endnowait]
[endnolog]
[destroy]
[resetfont]
[reset_camera time="5"]
[layopt layer="base" visible="true"]
[layopt layer="0" visible="false"]
[layopt layer="1" visible="false"]
[layopt layer="2" visible="false"]
[layopt layer="0" page="back" visible="false"]
[layopt layer="1" page="back" visible="false"]
[layopt layer="2" page="back" visible="false"]
[layopt layer="message0" visible="false"]
[layopt layer="message1" visible="false"]
[layopt layer="fix" visible="false"]
[bg storage="../fgimage/color/black.png" time="5"]
[endmacro]





; =============================================================================
; ゲーム変数の削除
[macro name="deletef"]
[if exp="mp.var == 'tf'"]
  [eval exp="tf={}"]
[elsif exp="mp.var == 'f'"]
  [eval exp="f={}"]
[else]
  [eval exp="sf={}"]
[endif]
[endmacro]





; =============================================================================
; 乱数マクロ

; [getrand var="XXX" min="XXX" max="XXX"]
; 一時変数 tf.rand に min 以上 max 以下の乱数(整数)をセットするマクロです。
; var には変数の名前を指定できます（var="f.a"のように）。
; 指定すると、tf.rand の内容をその変数にコピーします。
[macro name="getrand"]
  [iscript]
  var max = mp.max || '10'
  var min = mp.min || '1'
  max = Number(max)
  min = Number(min)
  tf.rand = min + Math.floor(Math.random() * (max - min + 1))
  if (mp['var']) eval(mp['var'] + ' = ' + tf.rand)
  [endscript]
[endmacro]

; [getrandname var="XXX" name="XXX" min="XXX" max="XXX"]
; 文字列 name の{R}部分を「min 以上 max 以下のランダムな整数」で置き換えた文字列を生成し、
; 一時変数 tf.randname にセットします。
; var には変数の名前を指定できます（var="f.a"のように）。
; 指定すると、tf.randname の内容をその変数にコピーします。
[macro name="getrandname"]
  [iscript]
  var name  = mp.name || '*Label{R}'
  var max   = mp.max  || '10'
  var min   = mp.min  || '1'
  max = Number(max)
  min = Number(min)
  var rand    = min + Math.floor(Math.random() * (max - min + 1))
  tf.randname = name.replace('{R}', rand)
  if (mp['var']) eval(mp['var'] + ' = "' + tf.randname + '"')
  [endscript]
[endmacro]





; =============================================================================





[return]
