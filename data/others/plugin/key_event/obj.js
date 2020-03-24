var key_event = {


  // クリック時のメソッド
  'click' : {

    // [clear_key_event]時に機能を停止するか
    off_key : 'true',

    // 実行されるメソッド
    func : function(call, storage, target, exp, preexp) {

      var call = call || 'false';
      var storage = storage || null;
      var target = target || null;

      if (call == 'false') {
        $(window).on('click',function() {
          if (exp) tyrano.plugin.kag.embScript(exp, preexp);  //スクリプト実行
          jump_func(storage,target);
        });
      } else if (call == 'true') {
        $(window).on('click',function() {
          if (exp) tyrano.plugin.kag.embScript(exp, preexp);  //スクリプト実行
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
    func : function(call, storage, target, key_code, exp, preexp) {

      var call = call || 'false';
      var storage = storage || null;
      var target = target || null;
      var key_code = Number(key_code) || 13;

      if (call == 'false') {
        $(window).on('keydown',function(kdj){
          if (kdj.keyCode == key_code) {
            if (exp) tyrano.plugin.kag.embScript(exp, preexp);  //スクリプト実行
            jump_func(storage,target);
          }
        });
      } else if (call == 'true') {
        $(window).on('keydown',function(kdc){
          if (kdc.keyCode == key_code) {
            if (exp) tyrano.plugin.kag.embScript(exp, preexp);  //スクリプト実行
            call_func(storage,target);
          }
        });
      }
    }

  },


  // keyup操作時のメソッド
  'keyup' : {

    // [clear_key_event]時に機能を停止するか
    off_key : 'true',

    // 実行されるメソッド
    func : function(call, storage, target, key_code, exp, preexp) {

      var call = call || 'false';
      var storage = storage || null;
      var target = target || null;
      var key_code = Number(key_code) || 13;

      if (call == 'false') {
        $(window).on('keyup',function(kuj){
          if (kuj.keyCode == key_code) {
            if (exp) tyrano.plugin.kag.embScript(exp, preexp);  //スクリプト実行
            jump_func(storage,target);
          }
        });
      } else if (call == 'true') {
        $(window).on('keydown',function(kuc){
          if (kuc.keyCode == key_code) {
            if (exp) tyrano.plugin.kag.embScript(exp, preexp);  //スクリプト実行
            call_func(storage,target);
          }
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
        if (sfull.keyCode == 122) {
          console.log("screenfull");
          tyrano.plugin.kag.stat.is_stop = true;
          tyrano.plugin.kag.ftag.startTag("screen_full");
          tyrano.plugin.kag.stat.is_stop = false;
        }
      });
    }

  },


}



// ============================================================================



function jump_func(strg,trgt) {
  if (strg) {
    if (trgt) {
      tyrano.plugin.kag.ftag.startTag('jump', {
        storage : strg,
        target : trgt
      });
    } else {
      tyrano.plugin.kag.ftag.startTag('jump', {
        storage : strg
      });
    }
  } else if (trgt) {
    if (strg) {
      tyrano.plugin.kag.ftag.startTag('jump', {
        storage : strg,
        target : trgt
      });
    } else {
      tyrano.plugin.kag.ftag.startTag('jump', {
        target : trgt
      });
    }
  }
}

function call_func(strg,trgt) {
  if (strg != null) {
    if (trgt != null) {
      tyrano.plugin.kag.ftag.startTag('call', {
        storage : strg,
        target : trgt
      });
    } else {
      tyrano.plugin.kag.ftag.startTag('call', {
        storage : strg
      });
    }
  } else if (trgt != null) {
    if (strg != null) {
      tyrano.plugin.kag.ftag.startTag('call', {
        storage : strg,
        target : trgt
      });
    } else {
      tyrano.plugin.kag.ftag.startTag('call', {
        target : trgt
      });
    }
  }
}
