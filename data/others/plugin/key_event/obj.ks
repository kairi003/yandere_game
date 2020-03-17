[iscript]



// == ここでメソッドの定義 ======================================================



sf.key_event = {


  // クリック時のメソッド
  'click' : {

    // [clear_key_event]時に機能を停止するか
    off_key : 'true',

    // 実行されるメソッド
    func : function(call, storage, target) {

      var call = call || 'false';
      var storage = storage || null;
      var target = target || '*key_event_target';

      if (call == 'false') {
        $(window).on('click',function() {
          jump_func(storage,target);
        });
      } else if (call == 'true') {
        $(window).on('click',function() {
          call_func(storage,target);
        });
      }
    }

  },


  // keydown操作時のメソッド
  'keydown' : {

    // [clear_key_event]時に機能を停止するか
    off_key : 'true',

    // 実行されるメソッド
    func : function(call, storage, target, key_code) {

      var call = call || 'false';
      var storage = storage || null;
      var target = target || '*key_event_target';
      var key_code = Number(key_code) || 13;

      if (call == 'false') {
        $(window).on('keydown',function(kdj){
          if (kdj.keyCode == key_code) jump_func(storage,target);
        });
      } else if (call == 'true') {
        $(window).on('keydown',function(kdc){
          if (kdc.keyCode == key_code) call_func(storage,target);
        });
      }
    }

  },


  // keyup操作時のメソッド
  'keyup' : {

    // [clear_key_event]時に機能を停止するか
    off_key : 'true',

    // 実行されるメソッド
    func : function(call, storage, target, key_code) {

      var call = call || 'false';
      var storage = storage || null;
      var target = target || '*key_event_target';
      var key_code = Number(key_code) || 13;

      if (call == 'false') {
        $(window).on('keyup',function(kuj){
          if (kuj.keyCode == key_code) jump_func(storage,target);
        });
      } else if (call == 'true') {
        $(window).on('keydown',function(kuc){
          if (kuc.keyCode == key_code) call_func(storage,target);
        });
      }
    }

  },


  // オリジナルメソッド ESCキー強制終了
  'esc' : {

    // [clear_key_event]時に機能を停止するか
    off_key : 'false',

    // 実行されるメソッド
    func : function() {
      $(window).on('keydown', function(esc) {
        if (esc.keyCode == 27) tyrano.plugin.kag.ftag.startTag("close", {ask:"false"});
      });
    }

  },


  // オリジナルメソッド F11キー全画面モード切替え
  'screen_full' : {

    // [clear_key_event]時に機能を停止するか
    off_key : 'false',

    // 実行されるメソッド
    func : function() {
      $(window).on('keydown', function(sfull) {
        if (sfull.keyCode == 122) tyrano.plugin.kag.ftag.startTag("screen_full");
      });
    }

  },


}



// ============================================================================



function jump_func(strg,trgt) {
  var strg = strg || null;
  var trgt = trgt || '*key_event_target';
  if (strg != null) {
    tyrano.plugin.kag.ftag.startTag('jump', {
      storage : strg,
      target : trgt
    });
  } else if (strg == null) {
    tyrano.plugin.kag.ftag.startTag('jump', {
      target : trgt
    });
  }
}

function call_func(strg,trgt) {
  var strg = strg || null;
  var trgt = trgt || '*key_event_target';
  if (strg != null) {
    tyrano.plugin.kag.ftag.startTag('call', {
      storage : strg,
      target : trgt
    });
  } else if (strg == null) {
    tyrano.plugin.kag.ftag.startTag('call', {
      target : trgt
    });
  }
}



[endscript]





[return]
