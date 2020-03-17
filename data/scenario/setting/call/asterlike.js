class Node {
  constructor(num, x, y) {
    this.canEnter = num != 2;
    this.isVertex = num === 1;
    this.state = 'None';
    this.parentNode = null;
    this.x = x;
    this.y = y;
  }
}


class Map {
  constructor(matrix) {
    this.height = matrix.length;
    this.width = matrix[0].length;
    this.nodes = matrix.map((row, y) => row.map((cell, x) => new Node(cell, x, y)));
  }
  get(x, y) {
    return this.inner(x, y) ? this.nodes[y][x] : {
      canEnter: false
    };
  }
  inner(x, y) {
    return (0 <= x && x < this.width && 0 <= y && y < this.height)
  }
}

class Seach {
  constructor(map) {
    this.map = new Map(map);
    this.startNode;
    this.goalNode;
    this.head;
    this.openlist;
    this.nextlist;
  }

  search(start, goal) {
    // スタート，ゴールノードを取得
    this.startNode = this.map.get(...start);
    this.goalNode = this.map.get(...goal);
    if (!this.startNode.isVertex) throw "StartPointException";
    if (!this.goalNode.isVertex) throw "GoalPointException";
    // headにスタートノードを入れる
    this.head = this.startNode;
    this.openlist = [];
    this.nextlist = [this.startNode];
    while (this.head != this.goalNode) {
      // ゴールノードが見つかるまでループ
      while (this.openlist.length > 0 && this.head != this.goalNode) {
        // 頂点ノード以外を探索
        this.head = this.openlist.shift();
        this.openNeighbour();
      }
      // 頂点の隣接ノードをOpen
      if (this.head != this.goalNode) {
        this.head = this.nextlist.shift();
        this.openNeighbour();
      }
    }
    // ゴールノードからparentNodeをたどって最短ルートを得る
    const route = [];
    while (this.head !== null) {
      route.unshift(this.head);
      this.head = this.head.parentNode;
    }
    return route;
  }

  openNeighbour() {
    // headをClose
    this.head.canEnter=false;
    // 隣接ノード
    for (const [dx, dy] of [[1, 0],[-1, 0],[0, 1],[0, -1]]) {
      const neighbour = this.map.get(this.head.x + dx, this.head.y + dy);
      // 開けない(壁or範囲外orClose済み)ならスキップ
      if (!(neighbour.canEnter)) continue;
      // parentNodeにheadを入れる
      neighbour.parentNode = this.head;
      // 隣接ノードにゴールが見つかったらreturn
      if (neighbour == this.goalNode) {
        this.head = neighbour;
        return;
      }
      if (neighbour.isVertex) {
        // 頂点ノードはnextlistに入れとく
        this.nextlist.push(neighbour);
      } else {
        // それ以外はopenlistに入れとく
        this.openlist.push(neighbour);
      }
    }
  }
}


/* ----------------------------------------------------------------------------

let map_ = [
  [1, 0, 0, 0, 1],
  [0, 2, 1, 2, 0],
  [1, 0, 1, 0, 0],
  [0, 2, 2, 2, 1],
  [1, 0, 0, 0, 1]
];

let search = new Seach(map_);
let route = search.search([0, 0], [4, 4]);
console.log(route.filter(node => node.isVertex).map(node => [node.x, node.y]));

 --------------------------------------------------------------------------- */
