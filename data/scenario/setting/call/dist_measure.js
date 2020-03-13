/**
 * マップ配列からできるノード
 * value: (0,1,2)
 * x,y: 座標
 * nodes: 親ノードリスト
 * isWall: 壁(2)である
 * isVertex: 頂点(1)である
 * isEdge: 辺(0)である
 * isClosed: 移動不可．壁とか探査済みとか
 * cost: 道は0, 移動点は1
 * dist: 基準点までの距離．measureで計測
 * nbrVetex: 隣接頂点の集合．measureで計測
 *
 * @param {*} value
 * @param {*} x
 * @param {*} y
 * @param {*} nodes
 */
const MapNode = class {
  constructor(value, x, y, nodes) {
    this.value = value;
    this.x = x;
    this.y = y;
    this.nodes = nodes;
    this.isWall = value === 2;
    this.isVertex = value === 1;
    this.isEdge = value === 0;
    this.isClosed = false;
    this.cost = +(value === 1);
    this.dist = 0;
    this.nbrVertexs = new Set();
  }
  get up() { return this.nodes.get(this.x, this.y - 1); }
  get down() { return this.nodes.get(this.x, this.y + 1); }
  get left() { return this.nodes.get(this.x - 1, this.y); }
  get right() { return this.nodes.get(this.x + 1, this.y); }
  get neighbors() { return [this.up, this.down, this.left, this.right]; }
}

/**
 * マップ配列からできるノードリスト
 * flattenして一次元配列にする(ループしやすいので)
 * getで対応座標のノードを取得
 * @param {*} matrix
 */
const MapNodeList = class {
  constructor(matrix) {
    this.matrix = matrix;
    this.height = matrix.length;
    this.width = matrix[0].length;
    this.array = matrix.flat().map(
      (e, i) => new MapNode(e, i % this.width, Math.floor(i / this.width), this));
  }
  get(x, y) { return this.inRange(x, y) ? this.array[x+y*this.width] : null; }
  inRange(x, y) { return (0 <= x && x < this.width && 0 <= y && y < this.height) }
}


/**
 * 二次元配列のマップからMapNodeListを生成し，
 * 各頂点と基準点(tgtX,tgtY)との距離をノードの dist に格納する．
 * 各頂点の隣接頂点も調査する．
 * @param {*} matrix マップ配列(0:道,1:点,2:壁)
 * @param {*} tgtX 基準点のX座標
 * @param {*} tgtY 基準点のY座標
 */
const measure = (matrix, tgtX, tgtY) => {
  const nodes = new MapNodeList(matrix);
  const target = nodes.get(tgtX, tgtY);

  if (!target.isVertex) throw `TargetPointException`;

  const openList = [];
  const delayList = [target];
  target.isClosed = true;

  const chain = (child, parent) => {
    if (child === null || child.isWall || child === parent) return;
    const chainBack = (vtxNode, edgeNode) => {
      edgeNode.nbrVertexs.add(vtxNode);
      for (const nbrvtx of edgeNode.nbrVertexs) chain(nbrvtx, vtxNode);
    }
    if (parent.isVertex && child.isVertex) {
      parent.nbrVertexs.add(child);
      child.nbrVertexs.add(parent);
    } else if (parent.isVertex && child.isEdge) {
      chainBack(parent, child);
    } else if (parent.isEdge && child.isVertex) {
      chainBack(child, parent);
    } else if (parent.isEdge && child.isEdge) {
      child.nbrVertexs = parent.nbrVertexs;
    }
    return;
  }

  const open = (child, parent) => {
    chain(child, parent);
    if (child === null || child.isWall || child.isClosed) return;
    child.isClosed = true;
    (child.isVertex ? delayList : openList).push(child);
    child.dist = child.cost + parent.dist;
    return;
  }

  while (openList.length > 0 || delayList.length > 0) {
    while (openList.length > 0) {
      const head = openList.shift();
      for (const nbr of head.neighbors)
        if (nbr != null && !nbr.isClosed) open(nbr, head);
    }
    if (delayList.length > 0) {
      const head = delayList.shift();
      for (const nbr of head.neighbors)
        open(nbr, head);
    }
  }
  return nodes;
}

/**
 * 動作確認
 * 基準点(2,2)までの距離を計測してから，
 * filterで移動点(1)を抽出して座標と基準点までの距離を出力
 * 各頂点の隣接頂点を出力
 */
/*
{
  const map_ = [
    [1, 0, 0, 0, 1],
    [0, 2, 1, 2, 0],
    [1, 0, 2, 0, 0],
    [0, 2, 0, 2, 1],
    [1, 0, 1, 0, 1]
  ];

  const dists = measure(map_, 2, 1);
  console.log("[2,1]から各頂点(1のマス)までの距離");
  console.log(dists.array.filter(node=>node.isVertex).map(
    node=>`[${node.x},${node.y}]:${node.dist}`));
  console.log("各頂点の隣接頂点");
  console.log(dists.array.filter(node=>node.isVertex).map(
    node=>`[${node.x},${node.y}]:{${[...node.nbrVertexs].map(node=>`[${node.x},${node.y}]`).join(";")}}`));
}
*/
