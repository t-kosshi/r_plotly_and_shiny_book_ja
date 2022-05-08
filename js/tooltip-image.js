

function(el) {
  var tooltip = d3.select('#' + el.id + ' .svg-container')
    .append("div")
    .attr("class", "my-custom-tooltip");

  el.on('plotly_hover', function(d) {
    var pt = d.points[0];
    // x軸とy軸のスケール上での画像の配置場所を取得
    // ここではグラフの左上に画像を表示
    var x = pt.xaxis.range[0];
    var y = pt.yaxis.range[1];
    // x軸とy軸での位置をpixelでの位置に変換する
    var xPixel = pt.xaxis.l2p(x) + pt.xaxis._offset;
    var yPixel = pt.yaxis.l2p(y) + pt.yaxis._offset;
    // Base64にエンコードした画像を挿入する
    var img = "<img src='" +  pt.customdata + "' width=100>";
    tooltip.html(img)
      .style("position", "absolute")
      .style("left", xPixel + "px")
      .style("top", yPixel + "px");
    // 画像がフェードインするように設定
    tooltip.transition()
      .duration(300)
      .style("opacity", 1);
  });

  el.on('plotly_unhover', function(d) {
    // 画像がフェードアウトするように設定
    tooltip.transition()
      .duration(500)
      .style("opacity", 0);
  });
}




