# Rによるインタラクティブなデータビジュアライゼーション-探索的データ解析のためのplotlyとshiny-

本リポジトリは[『Rによるインタラクティブなデータビジュアライゼーション-探索的データ解析のためのplotlyとshiny-』 ](https://www.kyoritsu-pub.co.jp/bookdetail/9784320124868)のサポートサイトです。

## サンプルコード

本書を実行するためのコードは、[原著WEBサイト](https://plotly-r.com/)から利用できます。
本サポートサイトでは、以下のコンテンツを公開します。

### 原著から変更を加えたコード

plotlyやplotly.js、書籍内で利用しているRパッケージのバージョンアップなどに対応するために、一部コードに原著から修正を加えています。修正を加えたコードは各章ごとに本サポートサイトで公開しています。

### 必要なパッケージのインストールをサポートするコード

本書のコードを実行するためには、多くのRパッケージが必要です。ローカル環境に必要なRパーケージを一度にインストールできるように、本書専用パッケージをインストールする方法を用意しています。

```
if (!require(remotes)) install.packages("remotes")
remotes::install_github("cpsievert/plotly_book")
```

本サポートサイトでは、少しずつ本書を読み進めることをサポートするために、各章ごと個別に必要なパッケージをインストールするコードを公開しています。

なお、より手軽に実行環境を整える方法として、専用のクラウド環境を用意しています。(http://bit.ly/plotly-book-cloud)[http://bit.ly/plotly-book-cloud]から、必要なパッケージがインストールされたRstudio Cloud上の実行環境にアクセスできます。（Rstudio Cloudのアカウントが必要です。）


### コードの実行に必要な外部ファイル
第V部で使用する画像ファイルとJavaScriptファイルを公開しています。Rコードと同様に、JavaScriptのコードにも原著から修正を加えた箇所があります。