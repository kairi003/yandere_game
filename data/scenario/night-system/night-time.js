 var night_time = function(){

   // 時間を進める
   //if (TYRANO.kag.stat.f.ui.time.val == 0) {
     TYRANO.kag.stat.f.ui.time.val++;
   //}

   // テキストを表示
   if (TYRANO.kag.stat.f.ui.time.val != 6) {  // 6時はクリアした瞬間なのでmessage表記しない
     var message_text = TYRANO.kag.stat.f.ui.time.val + '時になった。'
     TYRANO.kag.stat.is_stop = true;
     TYRANO.kag.ftag.startTag("cm");
     TYRANO.kag.ftag.startTag("chara_ptext",{ name:TYRANO.kag.stat.f.stage.bg[TYRANO.kag.stat.f.player_place][3] });
     TYRANO.kag.ftag.startTag("text",{ val:message_text });
     TYRANO.kag.stat.is_stop = false;
   }

   // 表示するテキストを更新
   TYRANO.kag.stat.f.ui.time.text = TYRANO.kag.stat.f.ui.time.val + ' AM';

   // スクリプトを停止 [s]
   TYRANO.kag.stat.is_stop = true;

   // テキストを削除
   TYRANO.kag.ftag.startTag("free",{
     layer: 0,
     name: 'time_text',
     time: 1
   });

   // テキストを表示
   if (TYRANO.kag.variable.sf.getDevice == 'sp' || TYRANO.kag.variable.sf.getDevice == 'tab') {
     TYRANO.kag.ftag.startTag("ptext",{
       name: 'time_text',
       text: TYRANO.kag.stat.f.ui.time.text,
       time: 1,
       x: 0,
       y: 15,
       width: 1090,
       align: 'right',
       size: 60,
       color: 'white'
     });
   } else {
     TYRANO.kag.ftag.startTag("ptext",{
       name: 'time_text',
       text: TYRANO.kag.stat.f.ui.time.text,
       time: 1,
       x: 0,
       y: 15,
       width: 1265,
       align: 'right',
       size: 60,
       color: 'white'
     });
   }

   // スクリプト停止を解除
   TYRANO.kag.stat.is_stop = false;
   console.log("==> Time has advanced: " + TYRANO.kag.stat.f.ui.time.text);

   // クリア判定
   if (TYRANO.kag.stat.f.ui.time.val == 6) {
     TYRANO.kag.ftag.startTag("jump",{ storage: TYRANO.kag.stat.f.stage.var.clear_storage });
   }
 }





var night_timer = setInterval(night_time, TYRANO.kag.stat.f.stage.player.night_time/6);

// debug用
//var night_timer = setInterval(night_time, 5000);
