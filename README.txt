赤恐竜	http://akakyouryuu.blog.fc2.com/

前景画像表示用マクロ

自動でレイヤを管理し、画像を様々な演出で表示、消去が出来る。
色々な墓場のキャラクターレイヤ管理プラグインの動作を参考にしているが、
こっちは立ち絵の整列や位置の自動管理は行なわない
大部分はkagで書かれており、表示、消去のテンプレートな動作があるなら、
methodに追加すればよい。
eximage2.ks,exmove.ksを組み込んでいるので回転拡大縮小移動も可能
但し上記の2つのプラグインの仕様上背景レイヤには使えない
またレイヤ番号は f.nameID に入っているので、手動で操作も出来る。
同じnameIDの画像を複数同時に表示するときは,nameIDを複数つくる

もしも使いたい人がいたなら好きに使っていい
改変、再配布は自由
使用を明記する必要も報告する必要もない
けど報告をくれるとうれしい


(注意)
上記の2つのプラグインの仕様上一枚絵しか表示できない、pimageとかはできない
当然nameIDは変数名に出来るものしか指定出来ない。
AutoImage2で表示したものは必ずAutoImage2で消去するか、
freelayerで開放する。
タイトル画面などでは変数を初期化するために必ず@AutoImage_resetを使う
pathの指定はexmove.ksを参照

必要なもの
色々な墓場のTJSFunctions.ks
TJSに挑戦！のeximage2.ks,exmove.ks
を落としてくる

使い方
first.ksで呼び出した後とする
初期化する

(例)
@call storage=AutoImage2.ks
@AutoImage_Init layer=1


使えるタグ
im		: 総合操作
dis             : 画像消去
mm              : 同時移動
mt              : 同時トランジション
wmm             : 同時移動待ち
wmt             : 同時トランジション待ち
name_reg        : nameID登録
name            : nameIDとtypeを設定
tempcai         : 一時的に前景画像を消す
untempcai       : 前景画像を表示
cai             : 前景画像を消去
getlayer        : 管理レイヤを受け取る
freelayer       : 管理レイヤを開放する
AutoImage_Init  : 設定する
AutoImage_reset : すべてのnameIDを初期化する

---------------------------------------------------------------------
@AutoImage_reset
nameIDを初期化する。タイトルにおくこと

---------------------------------------------------------------------------- 
@AutoImage_Init
必須
layer		:この数以上のレイヤを自動管理にまかせる
任意

代替背景レイヤは自動管理に含まないように

(例)
@call storage=AutoImage2.ks
@AutoImage_Init layer=1

必要な設定をする、
laycountでレイヤが増減してもlayerで指定した番号以上のレイヤ
は自動で管理する

---------------------------------------------------------------------------- 
マクロ登録
@name_reg
必須
name		:nameIDを登録

内部で次のように動作している
@macro name=%name
@im * name=%name
@endmacro

設定すれば以後 @nameID と使える
---------------------------------------------------------------------------- 
@name
nameIDとtypeに対応するファイルを設定する
@name name=nameID type= storage= top=
必要なら画像を表示するときの高さも指定する
デフォルトでは画像の下端で揃える
---------------------------------------------------------------------------- 
@im

*下記を参照

disが真なら@dis
nameIDで指定した画像がすでに表示されていたら@diff,
表示されていなかったら@appを実行する。
@im name=nameID dis

代替背景として使う場合は次のマクロを設定して使うとよい
本来の背景レイヤと組み合わせることで、演出が広がる。
@macro name=base
@im * name=base layer=0
@endmacro
---------------------------------------------------------------------------- 
@app
必須
name		:nameIDを指定する
type		:type=XXXでもそのままXXXとしてもよい
		 但し空白ははさめない
@app name=nameID XXX

@nameで設定したnameIDとtypeからファイルを表示する。

layer		:自分でレイヤを指定してもよい
		 背景として使うならここも指定する

multi		:同時実行する。デフォルト値はfalse
		 methodがt,mで指定可能
		 設定後に
		 method=tなら@mt
		 method=mなら@mm
		 で実行する
		 設定後すぐに実行すること、
		 表示と消去を同時におこなう時は、表示してから消去する
		 (消去した時点でレイヤを開放してしまう)
		 
method		:表示方法を指定デフォルト値はt
		 下記参照

前景画像表示
自動でレイヤを管理し、画像の様々な演出で表示が出来る。
またレイヤ番号は f.nameID に入っている。
(注意)
一枚絵しか表示できない


method=t
トランジションで表示
回転拡大縮小してトランジションで表示
left,topを設定しておけば、任意の場所における,
トランジションのmethodはtmethodで指定する。
その他はeximage,transを同じ
@app name=nameID type=XXX method=t pos=(center) multi=(false)  time=(500)

method=m
任意の場所から回転拡大縮小しながら任意の場所に表示
pathを設定すると、left,topから、pathに移動して表示
(拡大縮小回転を伴うとき、pathの第一、第二引数は画像の中心を示す)
fromを設定すると、left,topで指定した位置にfromで指定した方向から移動して表示
fromには
	left
	right
	bigleft
	bigright
	top
	bottom
	bigtop
	bigbottom
	upper left
	lower left
	upper right
	lower right
またその省略の
	l
	r
	bl
	br
	t
	b
	bt
	bb
	ul
	ll
	ur
	lr
を指定可能、それぞれの動作はサンプルを参照

その他はeximage,exmoveを同じ

@app name=nameID type= method=m accel= time=(500) from=(left)

method=n
直接表画面に表示
その他はeximageを同じ
@app name=nameID type= method=n

---------------------------------------------------------------------------- 
@diff
必須
nameID		:nameIDを指定する
type		:type=XXXでもそのままXXXとしてもよい
		 但し空白ははさめない
任意
multi		:デフォルト値false
		 methodがtの時指定可能
		 設定後@mtで実行、@wmtで待つ
method		:デフォルト値はt
		 tならトランジション
		 mtならトランジションしながら
		 移動する
tmethod		:transのmethodと同じ


その他はeximageを同じ

表情を変える、(つまり差分表示)
scaleによる拡大縮小だけなら自動で調整する
xscale,yscaleや回転をしてたら自分で指定する
@wtで待つ


---------------------------------------------------------------------------- 
@dis
必須
nameID		:nameIDを指定する

任意
multi		:同時実行する。デフォルト値はfalse
		 methodがt,mで指定可能
		 設定後にmethod=t,なら@mt
		 設定後にmethod=mなら@mm
		 で実行する
		 設定したら、すぐに実行すること、
		 表示と消去を同時におこなう時は、表示してから消去する
		 (消去した時点でレイヤが開放してしまう

method		:表示方法を指定デフォルト値はt

*下記参照

画像クリア
消去したい画像のnameIDを指定

method=t
トランジション
トランジションのmethodはtmethodで指定する。
@dis name=nameID method=(t) multi=(false) time=

method=m
toに移動して消去
pathを設定すると任意の場所に移動して消去
@dis name=nameID method=m path= to=(right) time= accel=
toの引数には
	left
	right
	bigleft
	bigright
	top
	bottom
	bigtop
	bigbottom
	upper left
	lower left
	upper right
	lower right
またその省略の
	l
	r
	bl
	br
	t
	b
	bt
	bb
	ul
	ll
	ur
	lr
を指定可能、それぞれの動作はサンプルを参照

method=n
何もせず消去
@dis name=nameID method=n

---------------------------------------------------------------------------- 
@mm
一度に複数を移動
@wmmで待つ
---------------------------------------------------------------------------- 
@mt
一度に複数をトランジション
@wmtで待つ
---------------------------------------------------------------------------- 
@wmm
---------------------------------------------------------------------------- 
@wmt
---------------------------------------------------------------------------- 
 前景を一時的に消す(あくまで一時的)
@tempcai
---------------------------------------------------------------------------- 
 一時的に消した前景を表示
@untempcai
---------------------------------------------------------------------------- 
前景を全て消す
@cai
tmethod		:transのmethodと同じ
他は@transと同じ
@wmtで待つ

---------------------------------------------------------------------------- 
レイヤを確保する
@getlayer
name		:f.nameIDにレイヤが確保される
		 ちゃんと開放すること
---------------------------------------------------------------------------- 
レイヤを開放する
@freelayer
name		:nameIDを指定する
