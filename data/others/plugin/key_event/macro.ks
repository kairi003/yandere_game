




; =============================================================================


[macro name="key_event"]
[iscript]

mp.method = mp.method || 'click';
mp.call = mp.call || 'false';
mp.storage = mp.storage || null;
mp.target = mp.target || null;
mp.key_code = Number(mp.key_code) || 13;

// オリジナルメソッドを追加した場合は以下のswitch分に追加する
switch (mp.method) {

  case "click" :
    key_event.click.func(mp.call, mp.storage, mp.target, mp.exp, mp.preexp);
    break;

  case "keydown" :
    key_event.keydown.func(mp.call, mp.storage, mp.target, mp.key_code, mp.exp, mp.preexp);
    break;

  case "keyup" :
    key_event.keyup.func(mp.call, mp.storage, mp.target, mp.key_code, mp.exp, mp.preexp);
    break;

  case "esc" :  // オリジナルメソッド ESCキー強制終了
    key_event.esc.func();
    break;

  case "screen_full" :  // オリジナルメソッド Spaceキー全画面モード切替え
    key_event.screen_full.func();
    break;

}

[endscript]
[endmacro]


; =============================================================================





; =============================================================================


[macro name="clear_key_event"]
[iscript]

$(window).off('keydown');
$(window).off('keyup');
$(window).off('click');

for (var key in sf.key_event) {
  if (sf.key_event[key]['off_key'] == 'false') {
    sf.key_event[key]['func']();
  }
}

[endscript]
[endmacro]


; =============================================================================





[return]
