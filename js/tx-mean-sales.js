function(el) {
  el.on("plotly_hover", function(d) {
    var pt = d.points[0];
    var city = pt.customdata[0];

    // マウスオンした都市の売上を取得
    var cityInfo = pt.data.customdata.filter(function(cd) {
      return cd ? cd[0] == city : false;
    });
    var sales = cityInfo.map(function(cd) { return cd[1] });
    var avgsales = Math.round(d3.mean(sales));

    // マウスオンした都市の平均売上を表示
    var ann = {
      text: "Mean monthly sales for " + city + " is " + avgsales,
      x: 0.5,
      y: 1,
      xref: "paper",
      yref: "paper",
      xanchor: "middle",
      showarrow: false
    };
    Plotly.relayout(el.id, {annotations: [ann]});
  });
}
