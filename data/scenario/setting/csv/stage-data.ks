




; == [プロジェクト専用csv読み込みプラグイン] =====================================
; @stage: stageの名前を記載

[macro name="yandere_loadcsv"]

[iscript]

// ２重マクロにしているので、親マクロのmp変数はtfに変換する
tf.stage = mp.stage;

// コンソールでログを取る
console.log("==> loading " + tf.stage + " data");

// stage1の中にさらにオブジェクトを生成
sf.stage_datas[tf.stage] = {
  map: {},
  data: {},
  obj: {}
};
[endscript]

; map.csv
[iscript]
tf.url = sf.csv_url[sf.line]['stage_data'] + tf.stage + '/map.csv';
[endscript]
[loadcsv var="tf.map" url="&tf.url" debug_console="false"]
[iscript]
sf.stage_datas[tf.stage]['map'] = tf.map;
[endscript]

; data.csv
[iscript]
tf.url = sf.csv_url[sf.line]['stage_data'] + tf.stage + '/data.csv';
[endscript]
[loadcsv var="tf.data" url="&tf.url" debug_console="false"]
[iscript]
sf.stage_datas[tf.stage]['data'] = tf.data;
[endscript]

; obj.csv
[iscript]
tf.url = sf.csv_url[sf.line]['stage_data'] + tf.stage + '/obj.csv';
[endscript]
[loadcsv var="tf.obj" url="&tf.url" debug_console="false"]
[iscript]
sf.stage_datas[tf.stage]['obj'] = tf.obj;
[endscript]

[endmacro]
; =============================================================================





; 各stage読み込み
[eval exp="tf.i = 0"]
*return_for
[if exp="tf.i < sf.stages.length"]
  [yandere_loadcsv stage="&sf.stages[tf.i]"]
  [eval exp="tf.i++"]
[else]
  [jump target="nextfor"]
[endif]
[jump target="return_for"]
*nextfor





; -- [debug用] ----------------------------------------------------------------
[iscript]
if (tf.debug_console_log == true) {
  for (var key in sf.stage_datas) {
    console.log("~~> " + key + " data");
    console.log(sf.stage_datas[key]);
  }
}
[endscript]
; -----------------------------------------------------------------------------





@return
