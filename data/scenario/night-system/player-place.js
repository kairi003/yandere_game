
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
var nbrv = [...pn.nbrVertexs].sort((n1, n2)=>n1.dist.get(en)-n2.dist.get(en));
TYRANO.kag.stat.f.chara_move_area = [...pn.nbrVertexs].map(nbrv=>{
  if (nbrv.dist.get(en) <= pn.dist.get(en)) return [nbrv, nbrv.dist.get(en) - pn.dist.get(en)];
  var nnvs = new Set(nbrv.nbrVertexs);
  nnvs.delete(pn);
  return [nbrv,  Math.min(...[...nnvs].map(nnv=>nnv.dist.get(en))) + 1 - pn.dist.get(en)];
});

console.log("--> player can move blow area");
for (var i=0; i<TYRANO.kag.stat.f.chara_move_area.length; i++) {
  console.log(i+1 + ': [' + TYRANO.kag.stat.f.chara_move_area[i][0].x + ', ' + TYRANO.kag.stat.f.chara_move_area[i][0].y + ']');
}
