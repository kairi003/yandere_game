


/* ----------------------------------------------------------------------------
ローカル・オンライン判定（パッケージ時に必ず確認）
判定関係なしにofflineにするときは[line_judge]をfalseにする
sf.lineに["local","online"]が格納される
 ---------------------------------------------------------------------------- */

var line_judge = false;

var line = null
if (line_judge) {
  if ('onLine' in navigator) {
      if (navigator.onLine) line = 'local';
      else line = 'online';
      tyrano.plugin.kag.variable.sf.line = line;
      console.log('sf.line: ' + tyrano.plugin.kag.variable.sf.line);
  } else {
      console.log('navigator.onLineプロパティに対応していません');
  }
} else {
  tyrano.plugin.kag.variable.sf.line = 'local';
  console.log('sf.line: ' + tyrano.plugin.kag.variable.sf.line);
}




/* == デバイス判定 ========================================================== */
var getDevice = (function() {
    var ua = navigator.userAgent;
    if(ua.indexOf('iPhone') > 0 || ua.indexOf('iPod') > 0 || ua.indexOf('Android') > 0 && ua.indexOf('Mobile') > 0){
        return 'sp';
    }else if(ua.indexOf('iPad') > 0 || ua.indexOf('Android') > 0){
        return 'tab';
    }else{
        return 'other';
    }
  }
)();

if( getDevice == 'sp' ){
    //スマホ
    //alert("使用端末：スマホ");
    tyrano.plugin.kag.variable.sf.getDevice = "sp";
}else if( getDevice == 'tab' ){
    //タブレット
    //alert("使用端末：タブレット");
    tyrano.plugin.kag.variable.sf.getDevice = "tab";
}else if( getDevice == 'other' ){
    //その他
    //alert("使用端末：PC・その他");
    tyrano.plugin.kag.variable.sf.getDevice = "other";
}


// デバッグ用
//tyrano.plugin.kag.variable.sf.getDevice = "sp";
console.log("Device: " + tyrano.plugin.kag.variable.sf.getDevice);
/* ========================================================================= */
