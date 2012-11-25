赤恐竜	http://akakyouryuu.blog.fc2.com/

前景画像表示用マクロ

自動でレイヤを管理し、画像を様々な演出で表示、消去が出来る。
色々な墓場のキャラクターレイヤ管理プラグインの動作を参考にしているが、
こっちは立ち絵の整列は行なわない
大部分はkagで書かれており、表示、消去のテンプレートな動作があるなら、
methodに追加すればよい。
eximage2.ks,exmove.ksを組み込んでいるので回転拡大縮小移動も可能
但し上記の2つのプラグインの仕様上背景レイヤには使えない
またレイヤ番号は f.nameID に入っているので、手動で操作も出来る。
同じnameIDの画像を複数同時に表示するときはnameIDを複数つくる

マクロ名が長いのは他と被るのを避けるため、他のマクロに組み込んでつかってくださ
い。

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
first.ksで呼び出した後,
AutoImage_Initで初期化後
AutoImage_nameでnameIDを登録
必要ならAutoImage_name_regでマクロにも登録する
タイトル画面等ではAutoImage_resetで必ず初期化すること

(例)
@call storage=AutoImage2.ks


使えるタグ
AutoImage_im        : 総合操作
AutoImage_dis       : 画像消去
AutoImage_mm        : 同時移動
AutoImage_mt        : 同時トランジション
AutoImage_wmm       : 同時移動待ち
AutoImage_wmt       : 同時トランジション待ち
AutoImage_name_reg  : nameID登録
AutoImage_name      : nameIDとtypeを設定
AutoImage_tempcai   : 一時的に前景画像を消す
AutoImage_untempcai : 前景画像を表示
AutoImage_cai       : 前景画像を消去
AutoImage_getlayer  : 管理レイヤを受け取る
AutoImage_freelayer : 管理レイヤを開放する
AutoImage_Init      : 設定する
AutoImage_reset     : すべてのnameIDを初期化する

---------------------------------------------------------------------------- 
@AutoImage_Init
必須
layer		:この数以上のレイヤを自動管理にまかせる
任意

代替背景レイヤは自動管理に含まないように
AutoImage_tempcai,AutoImage_untempcai,AutoImage_caiで一緒に消えていまうので

(例)
@call storage=AutoImage2.ks
@AutoImage_Init layer=1

必要な設定をする、
laycountでレイヤが増減してもlayerで指定した番号以上のレイヤ
は自動で管理する

---------------------------------------------------------------------------- 
@AutoImage_name
nameIDとtypeタイプの組み合わせに対応するファイルを設定する
以降はこのときの設定に従って表示する画像を決定する

必須
name    : 登録するnameID
type    : 組み合わせるtype
storage : 対応する画像
top     : 表示時の高さ

(例)
@name name=nameID type= storage= top=

必要なら画像を表示するときの高さも指定する
デフォルトでは画像の下端で揃える
---------------------------------------------------------------------------- 
@AutoImage_name_reg

マクロ登録をする設定すれば以後 @nameID と使える
必須
name		:nameIDを登録

内部で次のように動作している
@macro name=%name
@AutoImage_im * name=%name
@endmacro

---------------------------------------------------------------------
@AutoImage_reset
レイヤ選択肢状態などを初期化する。タイトルにおくこと

---------------------------------------------------------------------------- 
@AutoImage_im
状況に合わせて下記をの動作をする

disが真なら画像消去の@AutoImage_dis
指定したnameIDの画像がすでに表示されていたら差分表示の@AutoImage_diff,
表示されていなかったら@AutoImage_appで表示する
(例)
@AutoImage_im name=nameID dis

代替背景として使う場合は次のマクロを設定して使うとよい
本来の背景レイヤと組み合わせることで、演出が広がる。
(注)left,topを指定しないと勝手に空きポジションに表示してしまう。

@macro name=base
@AutoImage_im * name=base layer=0 left=0 top=0
@endmacro
---------------------------------------------------------------------------- 
@AutoImage_app
前景画像表示
自動でレイヤをポジションを管理し、画像の様々な演出で表示が出来る。
またレイヤ番号は f.nameID に入っている。
left,topが指定されていなければ次の順に空いているポジションに
表示する。center,right,left,right_center,left_center
但し表示後に移動しても感知しない

(注意)
一枚絵しか表示できない

必須
name		:nameIDを指定する
type		:type=XXXでもそのままXXXとしてもよい
		 但し空白ははさめない
(例)
@app name=nameID XXX

@AutoImage_nameで設定したnameIDとtypeからファイルを表示する。

layer		:自分でレイヤを指定してもよい
		 背景として使うならここも指定する

multi		:同時実行する。デフォルト値はfalse
		 methodがt,mで指定可能
		 設定後に
		 method=tなら@AutoImage_mt
		 method=mなら@AutoImage_mm
		 で実行する
		 設定後すぐに実行すること、
		 表示と消去を同時におこなう時は、表示してから消去する
		 (消去した時点でレイヤを開放してしまう)
		 
method		:表示方法を指定デフォルト値はt
		 下記参照


method=t
トランジションで表示
回転拡大縮小してトランジションで表示
トランジションのmethodはtmethodで指定する。
その他はeximage,transと同じ属性名を持つ
@AutoImage_app name=nameID type=XXX method=t pos=(center) multi=(false)  time=(500)

method=m
任意の場所から回転拡大縮小しながら任意の場所に表示
pathを設定すると、left,topから、pathに移動して表示
(拡大縮小回転を伴うとき、pathの第一、第二引数は画像の中心を示す)
fromを設定すると、left、top、またはposで指定した位置にfromで指定した方向から移動して表示
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

その他はeximage,exmoveと同じ属性名を持つ

@app name=nameID type= method=m accel= time=(500) from=(left)

method=n
直接表画面に表示
その他はeximageを同じ属性名を持つ
(例)
@AutoImage_app name=nameID type= method=n

---------------------------------------------------------------------------- 
@AutoImage_diff
表情を変える、(つまり差分表示)
scaleによる拡大縮小だけなら自動で調整する
xscale,yscaleや回転をしてたら自分で指定する

必須
nameID		:nameIDを指定する
type		:type=XXXでもそのままXXXとしてもよい
		 但し空白ははさめない
任意
multi		:デフォルト値false
		 methodがtの時指定可能
		 設定後@AutoImage_mtで実行、@AutoImage_wmtで待つ
method		:デフォルト値はt
		 tならトランジション
		 mtならトランジションしながら
		 移動する
tmethod		:transのmethodと同じ


その他はeximage,transと同じ属性名を持つ



---------------------------------------------------------------------------- 
@AutoImage_dis

画像クリア
消去したい画像のnameIDを指定する

必須
nameID		:nameIDを指定する

任意
multi		:同時実行する。デフォルト値はfalse
		 methodがt,mで指定可能
		 設定後にmethod=t,なら@AutoImage_mt
		 設定後にmethod=mなら@AutoImage_mm
		 で実行する
		 設定したら、すぐに実行すること、
		 表示と消去を同時におこなう時は、表示してから消去する
		 (消去した時点でレイヤが開放してしまう

method		:表示方法を指定デフォルト値はt

*下記参照

method=t
トランジション
トランジションのmethodはtmethodで指定する。
その他はtransと同じ属性名を持つ
@dis name=nameID method=(t) multi=(false) time=

method=m
toで指定した方向に移動して消去
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
その他は@exmoveと同じ属性名を持つ

method=n
何もせず消去
@dis name=nameID method=n

---------------------------------------------------------------------------- 
@AutoImage_mm
一度に複数を移動
@wAutoImage_mmで待つ
---------------------------------------------------------------------------- 
@AutoImage_mt
一度に複数をトランジション
@transと同じ属性名を持つ
@AutoImage_wmtで待つ
---------------------------------------------------------------------------- 
@AutoImage_wmm
@AutoImage_mmを待つ
---------------------------------------------------------------------------- 
@AutoImage_wmt
@AutoImage_mtを待つ
---------------------------------------------------------------------------- 
 前景を一時的に消す(あくまで一時的)
@AutoImage_tempcai
---------------------------------------------------------------------------- 
 一時的に消した前景を表示
@AutoImage_untempcai
---------------------------------------------------------------------------- 
前景を全て消す
@AutoImage_cai
tmethod		:transのmethodと同じ
他は@transと同じ属性名を持つ
@AutoImage_wmtで待つ

---------------------------------------------------------------------------- 
レイヤを確保する
@AutoImage_getlayer
name		:f.nameIDに確保されたレイヤ番号が入る
		 ちゃんと開放すること
(例)
@AutoImage_getlayer name=nameID
---------------------------------------------------------------------------- 
レイヤを開放する
@AutoImage_freelayer
name		:nameIDを指定する
