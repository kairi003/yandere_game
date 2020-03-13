
var clearTimers = function(){
  clearInterval(ai_interval);  // 敵移動タイマー
  clearInterval(night_timer);  // ナイトタイマー
  clearInterval(stamina_recovery_timer);  // スタミナ回復タイマー
  clearInterval(TYRANO.kag.variable.sf.camera_timer);  // カメラタイマー
  console.log('stoped timers');
}
