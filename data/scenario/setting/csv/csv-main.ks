




; loadcsvプラグイン読み込み
@plugin name="loadcsv"





; sf.scv_urlの読み込み
@loadjs storage="../scenario/setting/csv/csv-url.js"





; debug console logを表示するか
[iscript]
tf.debug_console_log = true;
[endscript]





; key-code.csv読み込み
[loadcsv var="tf.key_code" url="&sf.csv_url[sf.line]['key_code']" debug_console="false"]
[iscript]
sf.key_code_list_array = tf.key_code;
if (tf.debug_console_log) console.log(sf.key_code_list_array);
[endscript]




; ステージデータを読み込み
[iscript]
sf.stage_datas = {};  // ステージデータを格納するオブジェクトを先に定義
[endscript]
[loadcsv var="tf.stages" url="&sf.csv_url[sf.line]['stages']" debug_console="false"]
[iscript]
tf.stages.shift();
sf.stages = [];
for (var i=0; i<tf.stages.length; i++) sf.stages[i] = tf.stages[i][0];
if (tf.debug_console_log) console.log(sf.stages);
[endscript]
[call storage="setting/csv/stage-data.ks"]






@return













; -- [chara_data.csv読み込み] ---------------------------------------------------
[iscript]
console.log("==> loading chara_data.csv");
[endscript]
[loadcsv var="tf.chara_data" url="&sf.csv_url[sf.line]['chara_data']" debug_console="false"]
[iscript]
sf.chara_data = {};
for (var i=1; i<tf.chara_data.length; i++) {
  sf.chara_data[tf.chara_data[i][0]] = {};
  for (var j=0; j<tf.chara_data[i].length; j++) {
    sf.chara_data[tf.chara_data[i][0]][tf.chara_data[0][j]] = tf.chara_data[i][j]
  }
  if(tf.debug_console_log){
    console.log('key: ' + tf.chara_data[i][0]);
    console.log(sf.chara_data[tf.chara_data[i][0]]);
  }
}
console.log("-- chara_data.csv loaded <==");
[endscript]
; -----------------------------------------------------------------------------
