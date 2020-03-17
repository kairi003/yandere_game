


var stamina_recovery_time = function(){

  // 最初にテキストを表示
  if (TYRANO.kag.stat.f.stage.player.stamina < TYRANO.kag.stat.f.stamina_max) {
    TYRANO.kag.stat.is_stop = true;
    TYRANO.kag.ftag.startTag("cm");
    TYRANO.kag.ftag.startTag("chara_ptext",{ name:TYRANO.kag.stat.f.stage.bg[TYRANO.kag.stat.f.player_place][3] });
    TYRANO.kag.ftag.startTag("text",{ val:'体力が少し回復した。' });
    TYRANO.kag.stat.is_stop = false;
  }

  // スタミナを１回復
  TYRANO.kag.stat.f.stage.player.stamina++;
  // スタミナが最大値を超えていた場合は最大値に合わせる
  if (TYRANO.kag.stat.f.stage.player.stamina >= TYRANO.kag.stat.f.stamina_max) {
    TYRANO.kag.stat.f.stage.player.stamina = TYRANO.kag.stat.f.stamina_max;
  }

  // f.ui.stamina.valを更新
  var per = TYRANO.kag.stat.f.stage.player.stamina/TYRANO.kag.stat.f.stamina_max;
  TYRANO.kag.stat.f.ui.stamina.val = Math.floor(100 * per);

  // 表示するテキストを更新
  TYRANO.kag.stat.f.ui.stamina.text = 'Stamina: ' + TYRANO.kag.stat.f.ui.stamina.val + '%';

  // スクリプトを停止 [s]
  TYRANO.kag.stat.is_stop = true;

  // テキストを削除
  TYRANO.kag.ftag.startTag("free",{
    layer: 0,
    name: 'stamina_text',
    time: 1
  });

  // テキストを表示
  if (TYRANO.kag.variable.sf.getDevice == 'sp' || TYRANO.kag.variable.sf.getDevice == 'tab') {
    TYRANO.kag.ftag.startTag("ptext",{
      name: 'stamina_text',
      text: TYRANO.kag.stat.f.ui.stamina.text,
      time: 1,
      x: 0,
      y: 155,
      width: 1090,
      align: 'right',
      size: 60,
      color: 'white'
    });
  } else {
    TYRANO.kag.ftag.startTag("ptext",{
      name: 'stamina_text',
      text: TYRANO.kag.stat.f.ui.stamina.text,
      time: 1,
      x: 0,
      y: 155,
      width: 1265,
      align: 'right',
      size: 60,
      color: 'white'
    });
  }

  // スクリプト停止を解除
  TYRANO.kag.stat.is_stop = false;
  console.log("==> Recoveried Stamina");
}


// 初期化処理：スタミナの最大値を保存
TYRANO.kag.stat.f.stamina_max = TYRANO.kag.stat.f.stage.player.stamina;


var stamina_recovery_timer = setInterval(stamina_recovery_time, TYRANO.kag.stat.f.stage.player.stamina_recovery_time);
