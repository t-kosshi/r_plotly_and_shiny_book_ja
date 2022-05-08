function(el) {
  el.on("plotly_hover", function(d) {
    var pt = d.points[0];
    var city = pt.customdata[0];

    // マウスオンした都市の売上データの取得
    var cityInfo = pt.data.customdata.filter(function(cd) {
      return cd ? cd[0] == city : false;
    });
    var sales = cityInfo.map(function(cd) { return cd[1] });

    // 現在DOM上に表示されている全グラフのトレースタイプ一覧を取得
    var types = el.data.map(function(trace) { return trace.type; });
    // types配列内で"histogram"のインデックスを取得
    var histogramIndex = types.indexOf("histogram");

    // トレースタイプ"histogram"がグラフ内に存在する場合, 
    // xを新しく有得したsalesに差し替える
    if (histogramIndex > -1) {

      Plotly.restyle(el.id, "x", [sales], histogramIndex);

    } else {

      // トレースタイプ"histogram"が存在しない場合，新たにヒストグラムを作成
      var trace = {
        x: sales,
        type: "histogram",
        marker: {color: "#1f77b4"},
        xaxis: "x2",
        yaxis: "y2"
      };
      Plotly.addTraces(el.id, trace);

      // 新たに追加したトレースの配置場所を指定
      // xaxis2とyaxis2はサブプロットなど複数プロット用の軸
      var x = {
        domain: [0.05, 0.4],
        anchor: "y2"
      };
      var y = {
        domain: [0.6, 0.9],
        anchor: "x2"
      };
      Plotly.relayout(el.id, {xaxis2: x, yaxis2: y});

    }

    // ヒストグラムのタイトルを追加
    var ann = {
      text: "Monthly house sales in " + city + ", TX",
      x: 2003,
      y: 300000,
      xanchor: "middle",
      showarrow: false
    };
    Plotly.relayout(el.id, {annotations: [ann]});

    // マウスオンした月の売上をヒストグラム上に黒の垂直線で表示
    var line = {
      type: "line",
      x0: pt.customdata[1],
      x1: pt.customdata[1],
      y0: 0.6,
      y1: 0.9,
      xref: "x2",
      yref: "paper",
      line: {color: "black"}
    };
    Plotly.relayout(el.id, {'shapes[1]': line});
  });
}
