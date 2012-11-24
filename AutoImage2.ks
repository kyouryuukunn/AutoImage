@return cond="typeof(global.AutoImage_obj) !== 'undefined'"

@call storage=AutoImage2.ks
@call storage=eximage2.ks
@call storage=exmove.ks

@macro name=name        
@eval exp="AutoImage_obj.setname(mp)"
@endmacro


@macro name=im
@if exp="AutoImage_obj.names[mp.name].nowcount > 0"
	@diff *
@else
	@app *
@endif
@endmacro


@macro name=app
@eval exp="mp.layer = AutoImage_obj.getlayer()"
@eval exp="mp.type = AutoImage_obj.gettype() if mp.type === void"
@eval exp="mp.storage = AutoImage_obj.namedata[mp.name][mp.type].storage"
@eval exp="AutoImage_obj.names[mp.name].nowtype = mp.type"
@eval exp="AutoImage_obj.names[mp.name].nowcount += 1"
@eval exp="AutoImage_obj.names[mp.name].nowlayer = mp.layer"
@eval exp="f[mp.name] = mp.layer"

@eval exp="mp.method = 't' if mp.method === void"
@if exp="mp.method == 't'"
	@backlay cond="AutoImag_obj.count==0"
	@eval exp="AutoImag_obj.count+=1 if mp.multi"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * page=back visible=true
	@if exp="!mp.multi"
		@trans method=%tmethod|crossfade time=%time|500
	@endif
@elsif exp="mp.method == 'm'"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * visible=true
	@if exp="!mp.multi"
		@exmove * time=%time|500
	@else
		@eval exp="mp.time = 500 if mp.time === void"
		@eval exp="AutoImage_obj.multistock(mp)"
		@eval exp="AutoImage_obj.count+=1"
	@endif
@elsif exp="mp.method == 'n'"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * page=fore visible=true
@endif
@endmacro

;表情を変える、(つまり差分表示)回転してたら自分でscale, angleを指定する
;一度に複数の画像を変えるときは、multi=trueにしてまとめて@mtをする。
;@diff name=nameID type= multi=false angle= scale=
@macro name=diff
@eval exp="mp.layer = AutoImage_obj.names[mp.name].nowlayer"
@eval exp="mp.type = AutoImage_obj.gettype(mp) if mp.type === void"
@eval exp="mp.storage = AutoImage_obj.namedata[mp.name][mp.type].storage"

@backlay cond="AutoImage_obj.count==0"
@eval exp="AutoImage_obj.count+=1 if mp.multi"
@eximage * page=back visible=true left=&kag.fore.layers[mp.layer].left top=&kag.fore.layers[mp.layer].top yscale="&(kag.fore.layer[mp.layer].height/AutoImage_obj.namedata[mp.name][AutoImag_obj.names[mp.name].nowtype].height)*100" xscale="&(kag.fore.layer[mp.layer].width/AutoImage_obj.namedata[mp.name][AutoImag_obj.names[mp.name].nowtype].width)*100"
@if exp="!mp.multi"
	@trans method=%tmethod|crossfade time=%time|300
@endif
@eval exp="AutoImage_obj.names[mp.name].nowtype = mp.type"
@endmacro

;画像クリア
;消去したい画像のnameIDを指定

;トランジション
;一度に複数の画像を消去するときは、multi=trueにしてまとめて@mtをする。
;@ci name=nameID layer= method=(t) multi=(false) time=

;toに移動して消去
;一度に複数の画像を消去するときは、multi=trueにしてまとめて@mmをする。
;pathを設定すると任意の場所に移動して消去
;@ci name=nameID layer= method=m path= to=(right) time= accel=

;任意の場所に回転拡大縮小しながら移動して消去
;toを設定すると,移動して消去
;pathを設定すると,任意の場所に回転拡大縮小しながら移動,
;一度に複数の画像を消去するときは、multi=trueにしてまとめて@mmをする。
;@ci name=nameID layer= method=em path= time= accel= spline= cx= cy=

;何もせず消去
;@dis name=nameID method=n
@macro name=dis
@eval exp="mp.layer = AutoImage_obj.names[mp.name].nowlayer"
@eval exp="mp.method = 't' if mp.method === void"
@if exp="mp.method == 't'"
	@backlay cond="AutoImage_obj.count==0"
	@eval exp="AutoImage_obj.count+=1 if mp.multi"
	@freeimage * page=back
	@if exp="!mp.multi"
		@trans method=%tmethod|crossfade time=%time|100
	@endif
@elsif exp="mp.method == 'm'"
	@eval exp="AutoImag_obj.set_dis_position(mp)"
	@if exp="!mp.multi"
		@exmove * time=%time|500
		@freeimage * page=fore
	@else
		@eval exp="mp.time = 500 if mp.time === void"
		@eval exp="AutoImage_obj.multistock(mp)"
		@eval exp="AutoImage_obj.count+=1"
	@endif
@elsif exp="mp.method == 'n'"
	@freeimage * page=fore
@endif
@eval exp="AutoImage_obj.freelayer(mp)"
@endmacro

;一度に複数を移動
@macro name=mm
;待ちのためにバックアップ
@eval exp="AutoImag_obj.pre_count = AutoImag_obj.count"
@call storage="AutoImageMacros.ks" target="*multi_move"
@eval exp="AutoImag_obj.count = 0"
@endmacro

@macro name=wmm
@call storage=AutoImageMacros.ks target=*multi_wm
@endmacro

;一度に複数をトランジション
@macro name=mt
;待ちのためにバックアップ
@eval exp="AutoImag_obj.pre_count = AutoImag_obj.count"
@trans * method=%tmethod|crossfade time=%time|100
@eval exp="AutoImag_obj.count = 0"
@endmacro

@macro name=wmt
@call storage=AutoImageMacros.ks target=*multi_wt
@endmacro

;nameID登録
;name_reg name=nameIDとすれば、
;@nameID と使える
@macro name=name_reg
@call storage=AutoImage2.ks target=*name_reg
@endmacro

; 前景を一時的に消す(あくまで一時的)
@macro name=tempcai
@eval exp="AutoImage_obj.tempcac()"
@endmacro

; 一時的に消した前景を表示
@macro name=untempcai
@eval exp="AutoImage_obj.untempcac()"
@endmacro

;;前景クリア
@macro name=cai
@backlay
@eval exp="AutoImage_obj.clearall()"
@mt
@endmacro

;レイヤを確保する
;@getlayer name=nameID //f.nameIDにレイヤが確保される
;ちゃんと開放すること
@macro name=getlayer
@eval exp="f[mp.name] = AutoImage_obj.getlayer(mp)"
@endmacro

;レイヤを開放する
;@freelayer name=nameID
@macro name=freelayer
@eval exp="mp.layer=f[mp.name]"
@eval exp="AutoImage_obj.freelayer(mp)"
@endmacro

;設定用
@macro name=AutoImage_Init
@eval exp="AutoImage_obj.autolayer = mp.layer"
@endmacro

;nameID初期化
@macro name=AutoImage_reset
@eval exp="reset()"
@endmacro


@iscript

class AutoImage() extends KAGPlugin
{

var multi = [];
var names = %[]; // type
                 // nowtype
                 // nowlayer
                 // nowcount
var namedata = %[];
                 // type
			 // storage
			 // width
			 // height
var autolayer; //プラグインが管理するレイヤ
var chosedlayer = %[]; //使用済レイヤ
var count = 0; //マルチトランス、ムーブのためのカウンｔ
var pre_count = 0; //マルチトランス、ムーブのためのカウント

	function onStore(f, elm)
	{
		var dic = f.AutoImage_dic = %[];
			// f.exSystemButtons に辞書配列を作成
		dic.names = names;
		dic.multi = multi;
		dic.chosedlayer = chosedlayer;
		dic.count = count;
		dic.pre_count = pre_count;
	}

	function onRestore(f, clear, elm)
	{
		// 栞を読み出すとき
		var dic = f.AutoImage_dic;
		if(dic === void)
		{
			reset()
		}
		else
		{
			names = dic.names;
			multi = dic.multi;
			chosedlayer = dic.chosedlayer;
			count = dic.count;
			pre_count = dic.pre_count;
		}
	}
	//画像の幅と高さを得る
	function setname(elm)
	{
		//立ち絵の幅と高さから立ち位置を設定
		with(elm)
		{
			var templayer = new Layer(kag, kag.back.base);
			templayer.loadImages(.storage);
			templayer.setSizeToImageSize();
			namedate[.name][.type].width = templayer.width;
			namedate[.name][.type].height = templayer.height;
			invalidate templayer;
			
			//if (.left !== void)		{AutoImage.char.left		= .left;}		else {AutoImage.char.left		= kag.scPositionX.left - AutoImage.char.width/2;}
			//if (.left_center !== void)	{AutoImage.char.left_center 	= .left_center;} 	else {AutoImage.char.left_center	= kag.scPositionX.left_center - AutoImage.char.width/2;}
			//if (.center !== void)		{AutoImage.char.center		= .center;}		else {AutoImage.char.center		= kag.scPositionX.center - AutoImage.char.width/2;}
			//if (.right_center !== void)	{AutoImage.char.right_center    = .right_center;}	else {AutoImage.char.right_center	= kag.scPositionX.right_center - AutoImage.char.width/2;}
			//if (.right !== void)		{AutoImage.char.right		= .right;} 		else {AutoImage.char.right		= kag.scPositionX.right - AutoImage.char.width/2;}
			
			namedate[.name][.type].top          = .top === void ? kag.scHeight - namedate[.name][.type].height : .top;
			namedate[.name][.type].left         = kag.scPositionX.left         - namedate[.name][.type].width/2;
			namedate[.name][.type].left_center  = kag.scPositionX.left_center  - namedate[.name][.type].width/2;
			namedate[.name][.type].center       = kag.scPositionX.center       - namedate[.name][.type].width/2;
			namedate[.name][.type].right_center = kag.scPositionX.right_center - namedate[.name][.type].width/2;
			namedate[.name][.type].right        = kag.scPositionX.right        - namedate[.name][.type].width/2;
			
			namedate[.name][.type].storage = .storage;
		}
	}
	//レイヤーを開放
	function freelayer(elm)
	{
		chosedlayer[elm.layer] = false;
		names[elm.name].nowcount -= 1;
		delete names[elm.name].nowtype;
		delete names[elm.name].nowlayer;
		delete f[elm.name];
	}
	//空きレイヤーを確保
	function getlayer(elm)
	{
		if (elm.layer === void)
		{
			for ( var i=autolayer; i<kag.numCharacterLayers; i++ )
			{
				if (!chosedlayer[i])
				{
					chosedlayer[i] = true;
					return (string) i;
				}
			}
			System.inform("前景レイヤーが確保できませんでした。");
		}
		else
		{
			if (chosedlayer[elm.layer])
				System.inform("そのレイヤは既に使われたいます。");
			else
				return elm.layer;
		}
	}
	function reset()
	{
		for ( var i=0; i<kag.numCharacterLayers; i++ )
		{
			if (chosedlayer[i])
			{
				var keys = keys(names);
				for (var n = 0; n < keys.count; n++)
				{
					freelayer(%[name:keys[n], layer:names[keys[n]].nowlayer]) if (names[keys[n]][nowcount] > 0);
				}
			}
		}
		count = 0;
		pre_count = 0;
	}
	function clearall()
	{
		for ( var i=autolayer; i<kag.numCharacterLayers; i++ )
		{
			if (chosedlayer[i])
			{
				kag.back.layers[i].visible=false;
				var keys = keys(names);
				for (var n = 0; n < keys.count; n++)
				{
					freelayer(%[name:keys[n], layer:names[keys[n]].nowlayer]) if (names[keys[n]][nowcount] > 0);
				}
			}
		}
	}
	function tempcac()
	{
		for ( var i=autolayer; i<kag.numCharacterLayers; i++ )
		{
			kag.fore.layers[i].visible=false;
		}
	}
	function untempcac()
	{
		for ( var i=autolayer; i<kag.numCharacterLayers; i++ )
		{
			if ( chosedlayer[i])
				kag.fore.layers[i].visible=true;
		}
	}
	function set_app_position(elm)
	{
		with(elm)
		{
			if (.left === void && .top === void) .pos = 'center'; //未指定ならposをcenterに
			
			if (.method == 't' || .method == 'n')
			{
				if (.left === void && .top === void) //left, topが未指定ならposであわせる
				{
					//topを設定するためにposを設定しなおす
					if (.pos == void) .pos = 'center' //posが未指定ならcenterに
					if (.pos == 'left' || .pos == 'l') 		.left = namedate[.name][.type].left;
					if (.pos == 'left_center' || .pos == 'lc')	.left = namedate[.name][.type].left_center;
					if (.pos == 'center' || .pos == 'c') 		.left = namedate[.name][.type].center;
					if (.pos == 'right_center'  || .pos == 'rc')	.left = namedate[.name][.type].right_center;
					if (.pos == 'right' || .pos == 'r') 		.left = namedate[.name][.type].right;
											.top  = namedate[.name][.type].top;
					delete .pos //元のposを消す
				}
			}
			else if (.method == 'm')
			{
				if (.from === void && .path === void) .from = 'left'; //未指定ならfromをleftに
				if (.from !== void)
				{
					.scale = 100 if .scale === void;
					.angle = 0 if .angle === void;
					if (.left !== void || .top !== void)		set_position(elm, .left, .top); //left, topが指定されていたら
					if (.pos == 'left' || .pos == 'l') 		set_position(elm, namedate[.name][.type].left, namedate[.name][.type].top); 
					if (.pos == 'left_center' || .pos == 'lc')	set_position(elm, namedate[.name][.type].left_center, namedate[.name][.type].top); 
					if (.pos == 'center' || .pos == 'c') 		set_position(elm, namedate[.name][.type].center, namedate[.name][.type].top); 
					if (.pos == 'right_center'  || .pos == 'rc')	set_position(elm, namedate[.name][.type].right_center, namedate[.name][.type].top); 
					if (.pos == 'right' || .pos == 'r') 		set_position(elm, namedate[.name][.type].right, namedate[.name][.type].top); 
				}
				else if (.path !== void)
				{
					.opacity = 0 if .opacity === void;
				}
			}
		}
	}
	function set_position(elm, left, top) //指定された座標にfromから移動する
	{
		with(elm)
		{
			.path = '(' + left + ', ' + top + ', 255, ' + .scale + ', ' + .angle + ')';
			if (.from == 'l' || .from == 'left')		{.opacity =   0; .left = left - 30; }
			if (.from == 'r' || .from == 'right')		{.opacity =   0; .left = left + 30; }
			if (.from == 'bl' || .from =='bigleft')		{.opacity = 255; .left = 0 - namedate[.name][.type].width*(.scale/100);}
			if (.from == 'br' || .from == 'bigright')	{.opacity = 255; .left = kag.scWidth;}
			if (.from == 't' || .from == 'top')		{.opacity =   0; .top  = top - 30;}
			if (.from == 'b' || .from == 'bottom')		{.opacity =   0; .top  = top + 30;}
			if (.from == 'bt' || .from == 'bigtop')		{.opacity = 255; .top  = 0 - namedate[.name][.type].height;}
			if (.from == 'bb' || .from == 'bigbottom')	{.opacity = 255; .top  = kag.scHeight;}
			if (.from == 'ul' || .from == 'upper left')	{.opacity = 255; .left = 0 - namedate[.name][.type].width*(.scale/100); .top = 0 - namedate[.name][.type].height*(.scale/100);}
			if (.from == 'll' || .from == 'lower left')	{.opacity = 255; .left = 0 - namedate[.name][.type].width*(.scale/100); .top = 0;}
			if (.from == 'ur' || .from =='upper right')	{.opacity = 255; .left = kag.scWidth; .top = 0 - namedate[.name][.type].height*(.scale/100);}
			if (.from == 'lr' || .from == 'lower right')	{.opacity = 255; .left = kag.scWidth; .top = 0;}
		}
	}
	function set_dis_position(elm)
	{
		with(elm)
		{
			.to = 'left' if .to === void;
			if (.path !== void)
			{
				.path = '( ' + (kag.fore.layers[.layer].left - 30) + ',  ' + kag.fore.layers[.layer].top 	 + ',0, 100, 0)'        if ( .to=='l'  || .to=='left');
				.path = '( ' + (kag.fore.layers[.layer].left + 30) + ',  ' + kag.fore.layers[.layer].top 	 + ',0, 100, 0)'        if ( .to=='r'  || .to=='right');
				.path = '(-' + kag.fore.layers[.layer].width	   + ',  ' + kag.fore.layers[.layer].top 	 + ',0, 100, 0)'        if ( .to=='bl' || .to=='bigleft');
				.path = '( ' + kag.scWidth 			   + ',  ' + kag.fore.layers[.layer].top 	 + ',0, 100, 0)'        if ( .to=='br' || .to=='bigright');
				.path = '( ' + kag.fore.layers[.layer].left 	   + ',  ' + kag.fore.layers[.layer].height - 30 + ',0, 100, 0)'	if ( .to=='t'  || .to=='top');
				.path = '( ' + kag.fore.layers[.layer].left 	   + ',  ' + kag.fore.layers[.layer].height + 30 + ',0, 100, 0)'	if ( .to=='b'  || .to=='bottom');
				.path = '( ' + kag.fore.layers[.layer].left 	   + ', -' + kag.fore.layers[.layer].height	 + ',255, 100, 0)'	if ( .to=='bt'  || .to=='bigtop');
				.path = '( ' + kag.fore.layers[.layer].left 	   + ',  ' + kag.scHeight 		  	 + ',255, 100, 0)'	if ( .to=='bb'  || .to=='bigbottom');
				.path = '(-' + kag.fore.layers[.layer].width 	   + ', -' + kag.fore.layers[.layer].height 	 + ',255, 100, 0)'	if ( .to=='ul' || .to=='upper left');
				.path = '(-' + kag.fore.layers[.layer].width 	   + ',  ' + kag.scHeight 		  	 + ',255, 100, 0)'	if ( .to=='ll' || .to=='lower left');
				.path = '( ' + kag.scWidth 			   + ', -' + kag.fore.layers[.layer].height	 + ',255, 100, 0)'	if ( .to=='ur' || .to=='upper right');
				.path = '( ' + kag.scWidth 			   + ',  ' + kag.scHeight 			 + ',255, 100, 0)'	if ( .to=='lr' || .to=='lower right');
			}
		}
	}
	function multistock(elm)
	{
		multi.add(%[]);
		(Dictionary.assign incontextof multi[multi.count-1])(elm);
	}
	function gettype(elm)
	{
		
	}
}
kag.addPlugin(global.AutoImage_obj = new AutoImage());
@endscript


@return

;サブルーチン用
*name_reg
@macro name=%name
@im * name=%tagname
@endmacro
@return

*multi_move
@eval exp="var AutoImage_count = 0"
*loop1
@iscript
mp = AutoImage_obj.multi.pop();
@endscript
@exmove *
@jump storage=AutoImageMacros.ks target=*loop1 cond="AutoImage_count++ < AutoImage_obj.count"
@return

*multi_wm
@eval exp="var AutoImage_count = 0"
*loop2
@wm
@jump storage=AutoImageMacros.ks target=*loop2 cond="AutoImage_count++ < AutoImage_obj.pre_count"
@return

*multi_wt
@eval exp="var AutoImage_count = 0"
*loop3
@wt
@jump storage=AutoImageMacros.ks target=*loop3 cond="AutoImage_count++ < AutoImage_obj.pre_count"
@return
