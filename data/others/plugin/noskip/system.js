tyrano.plugin.kag.stat.no_skip = {
  si: {},
  startNoSkip: function() {
    const INTERVAL = 0.1;
    const onGet = function() {
      return tyrano.plugin.kag.stat.is_skip;
    };
    const onChanged	= function() {
      //console.log("skipstart --> false");
      tyrano.plugin.kag.stat.is_skip = false;
      tyrano.plugin.kag.stat.is_stop = true;  // nextOder対策
      tyrano.plugin.kag.ftag.startTag("skipstop");  // スキップ停止関数１
      tyrano.plugin.kag.ftag.startTag("cancelskip");  // スキップ停止関数２
      tyrano.plugin.kag.stat.is_stop = false;
    };
    observe( INTERVAL, onGet, onChanged );
  },
  endNoSkip: function() {
    clearInterval(tyrano.plugin.kag.stat.no_skip.si);
  }
}
function observe( interval, onGet, onChanged ) {
    let previousValue = onGet();
    const onObserve = function() {
      const VALUE = onGet();
      if ( previousValue === VALUE ) return;
        onChanged( VALUE );
        previousValue = VALUE;
    };
    tyrano.plugin.kag.stat.no_skip.si = setInterval( onObserve, interval );
}







tyrano.plugin.kag.stat.no_skip = false;

const noSkip = function() { tyrano.plugin.kag.stat.no_skip = true; }
const endnoSkip = function() { tyrano.plugin.kag.stat.no_skip = false; }


if (tyrano.plugin.kag.version < 500) {
  /* -- [V4用] -- */
  tyrano.plugin.kag.tag.skipstart = {
      pm : {
      },
      start : function(pm) {
          if (this.kag.stat.no_skip || this.kag.stat.is_skip == true || this.kag.stat.is_adding_text) {
              return false;
          }
          this.kag.readyAudio();
          this.kag.stat.is_skip = true;  // no_skip追加
          this.kag.ftag.nextOrder();
      }
  }
} else if (tyrano.plugin.kag.version >= 500) {
  /* -- [V5用] -- */
  tyrano.plugin.kag.tag.skipstart = {
    pm : {},
    start : function(a) {
      if (this.kag.stat.no_skip || 1 == this.kag.stat.is_skip || this.kag.stat.is_adding_text ) return ! 1;
      this.kag.readyAudio(),
      this.kag.stat.is_skip =! 0,
      this.kag.ftag.nextOrder()
    }
  }
}
