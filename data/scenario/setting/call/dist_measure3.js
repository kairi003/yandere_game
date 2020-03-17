/**
 * MapNode抽象クラス
 * createメソッドでEgdeNode, VertexNode, WallNodeを生成する．
 *
 * [int] value: mapの値(0,1,2)
 * [int] x: x座標
 * [int] y: y座標
 * [MapNodeList] nodeList: 親MapNodeList
 * [bool] isEdge: 辺(0)である
 * [bool] isVertex: 頂点(1)である
 * [bool] isWall: 壁(2)である
 * [bool] isClosed: 探査済み(_chainNodesで利用)
 * [Set] nbrVertexs: [MapNode] 隣接する頂点ノードの集合(Set)
 *
 * [MapNode] create(value, x, y): EgdeNode, VertexNode, WallNodeを生成
 *
 * [MapNode] up: 上のノード(無ければnull)
 * [MapNode] down: 下のノード(無ければnull)
 * [MapNode] left: 左のノード(無ければnull)
 * [MapNode] right: 右のノード(無ければnull)
 * [Array<MapNode>] neighbors: 上下左右ノードの配列(Array)
 */
class MapNode {
  constructor(value, x, y, nodeList) {
    this.value = +value;
    this.x = x;
    this.y = y;
    this.nodeList = nodeList;
    this.isEdge = false;
    this.isVertex = false;
    this.isWall = false;
    this.isClosed = false;
    this.nbrVertexs = new Set();
  }
  static create(value, x, y, nodeList) {
    if (value == 0) return new EdgeNode(value, x, y, nodeList);
    if (value == 1) return new VertexNode(value, x, y, nodeList);
    if (value == 2) return new WallNode(value, x, y, nodeList);
  }
  get up() { return this.nodeList.get(this.x, this.y - 1); }
  get down() { return this.nodeList.get(this.x, this.y + 1); }
  get left() { return this.nodeList.get(this.x - 1, this.y); }
  get right() { return this.nodeList.get(this.x + 1, this.y); }
  get neighbors() { return [this.up, this.down, this.left, this.right]; }
}

/**
 * EdgeNode(辺,0)クラス
 * [Set<EdgeNode>] unitEges: 連続したEdgeNodeの集合
 */
class EdgeNode extends MapNode {
  constructor(value, x, y, nodeList) {
    super(value, x, y, nodeList);
    this.isEdge = true;
    this.unitEdges = new Set([this]);
  }
}

/**
 * VaetexNode(頂点,1)クラス
 * [Map<VaetexNode:int>] dist: 任意のVertexNodeまでの距離を格納する写像型(Map)
 */
class VertexNode extends MapNode {
  constructor(value, x, y, nodeList) {
    super(value, x, y, nodeList);
    this.isVertex = true;
    this.dist = new Map([[this, 0]]);
  }
}

/**
 * WallNode(壁,2)クラス
 */
class WallNode extends MapNode {
  constructor(value, x, y, nodeList) {
    super(value, x, y, nodeList);
    this.isWall = true;
  }
}

/**
 * MapNodeをまとめるクラス
 *
 * [Array<int>] map: map二次元配列
 * [int] heihgt: mapの高さ
 * [int] width: mapの横幅
 * [Array<MapNode>] array MapNodeの1次元配列
 * [Array<VertexNode>] vertexs VertexNode(value==1)の1次元配列
 *
 * [MapNode] get(x,y): x,yのMapNodeを得る
 * [bool] inRange(x,y): x,yがwidth,heihtの範囲内である
 */
class MapNodeList {
  constructor(map) {
    this.map = map;
    this.height = map.length;
    this.width = map[0].length;
    this.array = Array(this.height * this.width);
    this.vertexs = [];
    for (let y=0; y<this.height; y++) for (let x=0; x<this.width; x++) {
      const node = MapNode.create(+this.map[y][x], x, y, this);
      this.array[x+y*this.width] = node;
      if (node.isVertex) this.vertexs.push(node);
    }
    this.vertexs.forEach(this._chainNodes, this);
    this.vertexs.forEach(this._measure, this);
  }

  get(x, y) { return this.inRange(x, y) ? this.array[x+y*this.width] : null; }
  inRange(x, y) { return (0 <= x && x < this.width && 0 <= y && y < this.height) }

  _chainNodes(base) {
    if (base.isClosed) return;
    const openList = [base];
    base.isClosed = true;
    while (openList.length > 0) {
      const head = openList.shift();
      for (const nbr of head.neighbors) {
        if (nbr === null || nbr.isWall) continue;
        this._chain(nbr, head);
        if (!nbr.isClosed) {
          nbr.isClosed = true;
          openList.push(nbr);
        }
      }
    }
  }

  _chain(child, parent) {
    if (child === parent) return;
    const chainBack = (vtxNode, edgeNode) => {
      edgeNode.nbrVertexs.add(vtxNode);
      for (const nbrvtx of edgeNode.nbrVertexs) this._chain(nbrvtx, vtxNode);
    }
    if (parent.isVertex && child.isVertex) {
      parent.nbrVertexs.add(child);
      child.nbrVertexs.add(parent);
      return;
    } else if (parent.isVertex && child.isEdge) {
      chainBack(parent, child);
      return;
    } else if (parent.isEdge && child.isVertex) {
      chainBack(child, parent);
      return;
    } else if (parent.isEdge && child.isEdge) {
      if (parent.nbrVertexs.size < child.nbrVertexs.size) [parent, child] = [child, parent];
      child.nbrVertexs.forEach(vtx=>parent.nbrVertexs.add(vtx));
      child.unitEdges.forEach(uniegde=>{
        parent.unitEdges.add(uniegde);
        uniegde.unitEdges = parent.unitEdges;
        uniegde.nbrVertexs = parent.nbrVertexs;
      });
      return;
    }
  }
  _measure(base) {
    const que = [base];
    while (que.length > 0) {
      const head = que.shift();
      for (const vtx of head.nbrVertexs) {
        if (!vtx.dist.has(base) || vtx.dist.get(base) > head.dist.get(base)) {
          vtx.dist.set(base, head.dist.get(base) + 1);
          que.push(vtx);
        }
      }
    }
  }
}





/* debug用
const map_ = [
  [1, 0, 0, 0, 1],
  [0, 2, 1, 2, 0],
  [0, 0, 0, 0, 0],
  [0, 2, 0, 2, 1],
  [1, 0, 1, 0, 1]
];

const map = new MapNodeList(map_);
console.log(dists.array.filter(node => node.isVertex).map(
  node => `[${node.x},${node.y}]:{${[...node.nbrVertexs].map(node=>`[${node.x},${node.y}]`).join(";")}}`));
*/
