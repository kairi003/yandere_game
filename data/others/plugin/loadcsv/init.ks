[macro name="loadcsv"]
[iscript]





if (mp.debug_console == 'true') console.log("==> CSV LOADING");





// == [CSV読み込み] ===========================================================
$.get(mp.url, function(data){
// 読み込まれたファイル
    tf.list = [];
    tf.list = data.split("\n");  // 改行で分割し、配列に入れる
    // ↑終えたらラベルの位置までジャンプ（よく分からんバグの対策）
    TG.kag.stat.is_stop = false;
    TG.kag.ftag.startTag("jump",{target:"*complete_load_csv"});
});
[endscript]
[s]

*complete_load_csv
[iscript]
tf.list_array = [];
for( var i = 0 , l = tf.list.length ; i < l ; i++ ){
    tf.list_array[i] = tf.list[i].split(",");
    for( var j = 0 , m = tf.list_array[i].length ; j < m ; j++ ){  //文字列の最初と最後に入った空白を除去
        tf.list_array[i][j] = tf.list_array[i][j].replace( /(^\s+)|(\s+$)/g , ""  );
    }
}
// ===========================================================================





// mp.varが指定されていたら初期化
if (mp['var']) {
  if (mp.debug_console == 'true') console.log('指定したティラノ変数：' + mp['var']);
  eval(mp['var'] + ' = []');
} else {
  console.log('csvを格納した変数： tf.list_array');
}





for (var i=0; i<tf.list_array.length; i++) {
  if (mp['var']) eval(mp['var'] + '[i] = []');
  for (var j=0; j<tf.list_array[i].length; j++) {
    //数字の場合はperseFlort()
    var s = tf.list_array[i][j];
    if(typeof s === 'string' && !!s && !Number.isNaN(+s)) tf.list_array[i][j] = parseFloat(s);
    // 'TRUE','FALSE'を直す
    if(tf.list_array[i][j] == 'TRUE'){
      tf.list_array[i][j] = true;
    } else if (tf.list_array[i][j] == 'FALSE') {
      tf.list_array[i][j] = false;
    }
    // mp.varが指定されていたら代入
    if (mp['var']) {
      var tmp = tf.list_array[i][j];
      eval(mp['var'] + '[i][j] = tmp');
    }
  }
}





// debug console log
if (mp.debug_console == 'true') {
  if (mp['var']) console.log( eval(mp['var']) );
  else console.log(tf.list_array);
}





if (mp.debug_console == 'true') console.log("CSV LOADED ==;");





[endscript]
[endmacro]
[return]
