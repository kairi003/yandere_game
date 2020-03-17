var enemy_ai = function(){

  var data = { map: [] , pp: [], ep: [] };

  // 分かりやすくするために列挙書き
  data.map = TYRANO.kag.stat.f.stage.map;  // マップデータ
  data.pp[0] = TYRANO.kag.stat.f.stage.area_data[TYRANO.kag.stat.f.player_place][0];  // 自機の現在位置（Y座標）
  data.pp[1] = TYRANO.kag.stat.f.stage.area_data[TYRANO.kag.stat.f.player_place][1];  // 自機の現在位置（X座標）
  data.ep[0] = TYRANO.kag.stat.f.stage.area_data[TYRANO.kag.stat.f.enemy_place][0];  // 自機の現在位置（Y座標）
  data.ep[1] = TYRANO.kag.stat.f.stage.area_data[TYRANO.kag.stat.f.enemy_place][1];  // 自機の現在位置（X座標）

  // debug
  //for(key in data){console.log(data[key])};

  // kairiパワー
  var node_list = TYRANO.kag.stat.f.stage.node_list;
  var pn = node_list.get(data.pp[1],data.pp[0]);
  var en = node_list.get(data.ep[1],data.ep[0]);
  var nbrv = [...en.nbrVertexs].sort((n1, n2)=>n1.dist.get(pn)-n2.dist.get(pn));
  var move_area = [...en.nbrVertexs].map(nbrv=>{
    if (nbrv.dist.get(pn) <= en.dist.get(pn)) return [nbrv, nbrv.dist.get(pn) - en.dist.get(pn)];
    var nnvs = new Set(nbrv.nbrVertexs);
    nnvs.delete(en);
    return [nbrv,  Math.min(...[...nnvs].map(nnv=>nnv.dist.get(pn))) + 1 - en.dist.get(pn)];
  });

  // -- [move_area配列をdistance順にソート] ----------------------------------------
  var tmp = [];
  var count = null;
  while (count != 0) {
    count = 0;
    for (var i=1; i<move_area.length; i++) {
      if (move_area[i][1] < move_area[i-1][1]) {
        tmp = move_area[i];
        move_area[i] = move_area[i-1];
        move_area[i-1] = tmp;
        count++;
      }
    }
  }
  console.log("--> enemy can move blow area");
  for (var i=0; i<move_area.length; i++) {
    console.log(i+1 + ': [' + move_area[i][0].x + ', ' + move_area[i][0].y + '] distance: ' + Number(move_area[i][1] + 2));
  }
  // -----------------------------------------------------------------------------


  // -- [敵移動] ---------------------------------------------------------------

  var for_break = false;
  var to_move = { x:0, y:0 };  // 敵が移動するマスの情報

  for (var i=0; i<move_area.length&&for_break==false; i++) {
    if (i != move_area.length-1) {  // 最後の移動候補マスでない場合

      // max〜minまでの乱数を吐き出す
      var max = 100;
      var min = 0;
      var rand = Math.floor(Math.random()*(max-min)+min);
      console.log('rand: ' + rand);

      // 敵が効率的なルートを選択
      if (rand <= TYRANO.kag.stat.f.stage.enemy.fast_move_per) {
        console.log(Number(i+1)+"番目効率的なルートを選んだよ。")
        to_move.x = move_area[i][0].x;
        to_move.y = move_area[i][0].y;
        for (num in TYRANO.kag.stat.f.stage.area_data) {
          if (TYRANO.kag.stat.f.stage.area_data[num][0] == to_move.y && TYRANO.kag.stat.f.stage.area_data[num][1] == to_move.x){
            if (num != TYRANO.kag.stat.f.pre_enemy_prace) {  // 直前と同じ位置ではないか調べる
              TYRANO.kag.stat.f.pre_enemy_prace = TYRANO.kag.stat.f.enemy_place;  // 敵が直前にいた位置を更新
              TYRANO.kag.stat.f.enemy_place = num; // 現在の敵の位置を更新
              for_break = true;
            }
          }
        }
      }
    } else {  // 最後の移動候補マスである場合

      console.log("移動候補最後のマスだよ。運がいいね。");
      to_move.x = move_area[i][0].x;
      to_move.y = move_area[i][0].y;

      for (num in TYRANO.kag.stat.f.stage.area_data) {
        if (TYRANO.kag.stat.f.stage.area_data[num][0] == to_move.y && TYRANO.kag.stat.f.stage.area_data[num][1] == to_move.x){

          if (num != TYRANO.kag.stat.f.pre_enemy_prace) {  // 直前と同じ位置ではないか調べる
            TYRANO.kag.stat.f.pre_enemy_prace = TYRANO.kag.stat.f.enemy_place;  // 敵が直前にいた位置を更新
            TYRANO.kag.stat.f.enemy_place = num; // 現在の敵の位置を更新
            for_break = true;
          } else {  // 直前と同じ位置の場合、一個上の位置へ移動する
            console.log("移動候補最後のマスは直前にいたマスを同じなので一つ上のマスに行くよ");
            to_move.x = move_area[i-1][0].x;
            to_move.y = move_area[i-1][0].y;
            for (num2 in TYRANO.kag.stat.f.stage.area_data) {
              if (TYRANO.kag.stat.f.stage.area_data[num2][0] == to_move.y && TYRANO.kag.stat.f.stage.area_data[num2][1] == to_move.x){
                TYRANO.kag.stat.f.pre_enemy_prace = TYRANO.kag.stat.f.enemy_place;  // 敵が直前にいた位置を更新
                TYRANO.kag.stat.f.enemy_place = num2; // 現在の敵の位置を更新
                for_break = true;
              }
            }
          }
        }
      }
    }
  }

  console.log("--> moved enemy: from " + TYRANO.kag.stat.f.pre_enemy_prace + ' to ' + TYRANO.kag.stat.f.enemy_place );

  // エンカウント判定
  if (TYRANO.kag.stat.f.player_place == TYRANO.kag.stat.f.enemy_place) {
    TYRANO.kag.ftag.startTag("jump",{storage:TYRANO.kag.stat.f.stage.var.game_over_storage})
  }

  // debug
  //clearInterval(ai_interval);

}

var ai_interval = setInterval(enemy_ai, TYRANO.kag.stat.f.stage.enemy.interval_time);
