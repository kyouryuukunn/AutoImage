@return cond="typeof(global.AutoImage_obj) !== 'undefined'"
@call storage=TJSFunctions.ks

@macro name=AutoImage_name        
@eval exp="AutoImage_obj.setname(mp)"
@endmacro


@macro name=AutoImage_im
@if exp="mp.dis"
	@trace exp="'[dis]'"
	@AutoImage_dis *
@elsif exp="AutoImage_obj.names[mp.name].nowcount > 0"
	@trace exp="'[diff]'"
	@AutoImage_diff *
@else
	@trace exp="'[app]'"
	@AutoImage_app *
@endif
@endmacro


@macro name=AutoImage_app
@eval exp="mp.layer = AutoImage_obj.getlayer(mp)"
@eval exp="mp.type = AutoImage_obj.gettype(mp) if mp.type === void"
@eval exp="mp.storage = AutoImage_obj.namedata[mp.name][mp.type].storage"
@eval exp="AutoImage_obj.names[mp.name].nowtype = mp.type"
@eval exp="AutoImage_obj.names[mp.name].nowcount += 1"
@eval exp="AutoImage_obj.names[mp.name].nowlayer = mp.layer"
@eval exp="f[mp.name] = mp.layer"
@eval exp="mp.method = 't' if mp.method === void"
@eval exp="mp.time = 500 if mp.time === void"

@if exp="mp.method == 't'"
	@trace exp="'method=t'"
	@backlay cond="AutoImage_obj.count==0"
	@eval exp="AutoImage_obj.count+=1 if mp.multi"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * page=back visible=true opacity=%opacity|255
	@if exp="!mp.multi"
		@eval exp="delete mp.layer"
		@trans * method=%tmethod|crossfade
	@endif
@elsif exp="mp.method == 'm'"
	@trace exp="'method=m'"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * visible=true 
	@if exp="!mp.multi"
		@exmove *
	@else
		@eval exp="AutoImage_obj.multistock(mp)"
		@eval exp="AutoImage_obj.count+=1"
	@endif
@elsif exp="mp.method == 'n'"
	@trace exp="'method=n'"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * page=fore visible=true opacity=%opacity|255
@endif
@endmacro

;表情を変える、(つまり差分表示)回転してたら自分でscale, angleを指定する
;一度に複数の画像を変えるときは、multi=trueにしてまとめて@mtをする。
;@diff name=nameID type= multi=false angle= scale=
@macro name=AutoImage_diff
@eval exp="mp.layer = AutoImage_obj.names[mp.name].nowlayer"
@eval exp="mp.type = AutoImage_obj.gettype(mp) if mp.type === void"
@eval exp="mp.storage = AutoImage_obj.namedata[mp.name][mp.type].storage"
@eval exp="mp.time = 500 if mp.time === void"

@eval exp="mp.method = 't' if mp.method === void"
@if exp="mp.method == 't'"
	@backlay cond="AutoImage_obj.count==0"
	@eval exp="AutoImage_obj.count+=1 if mp.multi"
	@eximage * page=back visible=true left="&kag.fore.layers[mp.layer].left" top="&kag.fore.layers[mp.layer].top" scale="&AutoImage_obj.names[mp.name].nowscale"
	@if exp="!mp.multi"
		@eval exp="delete mp.layer"
		@trans * method=%tmethod|crossfade
	@endif
@elsif exp="mp.method == 'mt'"
	@backlay
	@eximage * page=back visible=true left="&kag.fore.layers[mp.layer].left" top="&kag.fore.layers[mp.layer].top" scale="&AutoImage_obj.names[mp.name].nowscale"
	@trans * method=%tmethod|crossfade
	@exmove *
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
@macro name=AutoImage_dis
@eval exp="mp.layer = AutoImage_obj.names[mp.name].nowlayer"
@eval exp="mp.method = 't' if mp.method === void"
@eval exp="mp.time = 500 if mp.time === void"

@if exp="mp.method == 't'"
	@backlay cond="AutoImage_obj.count==0"
	@eval exp="AutoImage_obj.count+=1 if mp.multi"
	@freeimage * page=back
	@if exp="!mp.multi"
		@eval exp="mp.temp_layer = mp.layer"
		@eval exp="delete mp.layer"
		@trans * method=%tmethod|crossfade
		@eval exp="mp.layer = mp.temp_layer"
	@endif
@elsif exp="mp.method == 'm'"
	@eval exp="AutoImage_obj.set_dis_position(mp)"
	@if exp="!mp.multi"
		@exmove *
	@else
		@eval exp="AutoImage_obj.multistock(mp)"
		@eval exp="AutoImage_obj.count+=1"
	@endif
@elsif exp="mp.method == 'n'"
	@freeimage * page=fore
@endif
@eval exp="AutoImage_obj.freelayer(mp)"
@endmacro

;一度に複数を移動
@macro name=AutoImage_mm
;待ちのためにバックアップ
@eval exp="AutoImage_obj.pre_count = AutoImage_obj.count"
@call storage="AutoImage2.ks" target="*multi_move"
@eval exp="AutoImage_obj.count = 0"
@eval exp="AutoImage_obj.multi.clear()"
@endmacro

@macro name=AutoImage_wmm
@call storage=AutoImage2.ks target=*multi_wm
@endmacro

;一度に複数をトランジション
@macro name=AutoImage_mt
;待ちのためにバックアップ
@eval exp="AutoImage_obj.pre_count = AutoImage_obj.count"
@trans * method=%tmethod|crossfade time=%time|500
@eval exp="AutoImage_obj.count = 0"
@endmacro

@macro name=AutoImage_wmt
@call storage=AutoImage2.ks target=*multi_wt
@endmacro

;nameID登録
;name_reg name=nameIDとすれば、
;@nameID と使える
@macro name=AutoImage_name_reg
@call storage=AutoImage2.ks target=*name_reg
@endmacro

; 前景を一時的に消す(あくまで一時的)
@macro name=AutoImage_tempcai
@eval exp="AutoImage_obj.tempcac()"
@endmacro

; 一時的に消した前景を表示
@macro name=AutoImage_untempcai
@eval exp="AutoImage_obj.untempcac()"
@endmacro

;;前景クリア
@macro name=AutoImage_cai
@backlay
@eval exp="AutoImage_obj.clearall()"
@AutoImage_mt
@endmacro

;レイヤを確保する
;@getlayer name=nameID //f.nameIDにレイヤが確保される
;ちゃんと開放すること
@macro name=AutoImage_getlayer
@eval exp="f[mp.name] = AutoImage_obj.getlayer(mp)"
@endmacro

;レイヤを開放する
;@freelayer name=nameID
@macro name=AutoImage_freelayer
@eval exp="mp.layer=f[mp.name]"
@eval exp="AutoImage_obj.freelayer(mp)"
@endmacro

;設定用
@macro name=AutoImage_Init
@eval exp="AutoImage_obj.autolayer = mp.layer"
@endmacro

;nameID初期化
@macro name=AutoImage_reset
@eval exp="AutoImage_obj.reset()"
@endmacro


@iscript

class AutoImage extends KAGPlugin
{

var multi = [];
var names = %[]; //name
			 // nowtype
			 // nowlayer
			 // nowcount
			 // nowscale
var namedata = %[];
                 //name   type
				 // storage
				 // width
				 // height
var autolayer; //プラグインが管理するレイヤ
var chosedlayer = %[]; //使用済レイヤ
var count = 0; //マルチトランス、ムーブのためのカウンｔ
var pre_count = 0; //マルチトランス、ムーブのためのカウント
f.AutoImage_dic = %[];

	function onStore(f, elm)
	{
		var dic = f.AutoImage_dic = %[];
		dic.names = %[];
		var namekeys = keys(names);
		for (var i = 0; i < namekeys.count; i++)
		{
			dic.names[namekeys[i]] = %[];
			(Dictionary.assign incontextof dic.names[namekeys[i]])(names[namekeys[i]]);
		}
		dic.multi = [];
		dic.multi.assign(multi);
		dic.chosedlayer = %[];
		(Dictionary.assign incontextof dic.chosedlayer)(chosedlayer);
		dic.count = count;
		dic.pre_count = pre_count;
	}

	function onRestore(f, clear, elm)
	{
		// 栞を読み出すとき
		var dic = f.AutoImage_dic;
		if(dic === void)
		{
			reset();
		}
		else
		{
			(Dictionary.assign incontextof names)(dic.names);
			multi.assign(dic.multi);
			(Dictionary.assign incontextof chosedlayer)(dic.chosedlayer);
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
			names[.name] = %[] if names[.name] === void;
			namedata[.name] = %[] if namedata[.name] === void;
			namedata[.name][.type] = %[];
			namedata[.name][.type].width = templayer.width;
			namedata[.name][.type].height = templayer.height;
			invalidate templayer;
			
			namedata[.name][.type].top     = .top === void ? kag.scHeight - namedata[.name][.type].height : .top;
			namedata[.name][.type].storage = .storage;
		}
	}
	function pos_to_LeftTop(elm)
	{
		with(elm)
		{
			.top  = namedata[.name][.type].top;
			.left = kag.scPositionX.left         - namedata[.name][.type].width * .scale / 100 / 2 if .pos ==  'l'  || .pos == 'left';
			.left = kag.scPositionX.left_center  - namedata[.name][.type].width * .scale / 100 / 2 if .pos ==  'lc' || .pos == 'left_center';
			.left = kag.scPositionX.center       - namedata[.name][.type].width * .scale / 100 / 2 if .pos ==  'c'  || .pos == 'center';
			.left = kag.scPositionX.right_center - namedata[.name][.type].width * .scale / 100 / 2 if .pos ==  'rc' || .pos == 'right_center';
			.left = kag.scPositionX.right        - namedata[.name][.type].width * .scale / 100 / 2 if .pos ==  'r'  || .pos == 'right';
		}
	}
	//レイヤーを開放
	function freelayer(elm)
	{
		chosedlayer[elm.layer] = false;
		names[elm.name].nowcount -= 1;
		delete names[elm.name].nowtype;
		delete names[elm.name].nowscale;
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
				var namekeys = keys(names);
				for (var n = 0; n < namekeys.count; n++)
				{
					freelayer(%[name:namekeys[n], layer:names[namekeys[n]].nowlayer]) if (names[namekeys[n]].nowcount > 0);
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
				kag.back.layers[i].visible=false;
		}
		var namekeys = keys(names);
		for (var n = 0; n < namekeys.count; n++)
			freelayer(%[name:namekeys[n], layer:names[namekeys[n]].nowlayer]) if (names[namekeys[n]].nowcount > 0);
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
			if (.left === void && .top === void && .pos === void) .pos = 'center'; //未指定ならposをcenterに
			.scale = 100 if .scale === void;
			.angle = 0 if .angle === void;
			
			if (.method == 't' || .method == 'n')
			{
				if (.left === void && .top === void) //left, topが未指定ならposであわせる
				{
					//topを設定するためにposを設定しなおす
					if (.pos == void) .pos = 'center'; //posが未指定ならcenterに
					pos_to_LeftTop(elm);
				}
			}
			else if (.method == 'm')
			{
				if (.from === void && .path === void) .from = 'left'; //未指定ならfromをleftに
				if (.from !== void)
				{
					if (.left === void && .top === void)
						pos_to_LeftTop(elm);
					set_position(elm, .left, .top); //left, topが指定されていたら
				}
				else if (.path !== void)
				{
					.opacity = 0 if .opacity === void;
				}
			}
			names[.name].nowscale = .scale;
			delete .pos; //元のposを消す
		}
	}
	function set_position(elm, left, top) //指定された座標にfromから移動する
	{
		with(elm)
		{
			.path = '(' + left + ', ' + top + ', 255, ' + .scale + ', ' + .angle + ')';
			if (.from == 'l'  || .from == 'left')		{.opacity =   0; .top = top;                                            .left = left - 30; }
			if (.from == 'r'  || .from == 'right')		{.opacity =   0; .top = top;                                            .left = left + 30; }
			if (.from == 'bl' || .from =='bigleft')		{.opacity = 255; .top = top;                                            .left = 0 - namedata[.name][.type].width*(.scale/100);}
			if (.from == 'br' || .from == 'bigright')	{.opacity = 255; .top = top;                                            .left = kag.scWidth;}
			if (.from == 't'  || .from == 'top')		{.opacity =   0; .top = top - 30;                                       .left = left;}
			if (.from == 'b'  || .from == 'bottom')		{.opacity =   0; .top = top + 30;                                       .left = left;}
			if (.from == 'bt' || .from == 'bigtop')		{.opacity = 255; .top = 0 - namedata[.name][.type].height*(.scale/100); .left = left;}
			if (.from == 'bb' || .from == 'bigbottom')	{.opacity = 255; .top = kag.scHeight;                                   .left = left;}
			if (.from == 'ul' || .from == 'upper left')	{.opacity = 255; .top = 0 - namedata[.name][.type].height*(.scale/100); .left = 0 - namedata[.name][.type].width*(.scale/100);}
			if (.from == 'll' || .from == 'lower left')	{.opacity = 255; .top = kag.scHeight;                                   .left = 0 - namedata[.name][.type].width*(.scale/100);}
			if (.from == 'ur' || .from =='upper right')	{.opacity = 255; .top = 0 - namedata[.name][.type].height*(.scale/100); .left = kag.scWidth;}
			if (.from == 'lr' || .from == 'lower right')	{.opacity = 255; .top = kag.scHeight;                                   .left = kag.scWidth;}
		}
	}
	function set_dis_position(elm)
	{
		with(elm)
		{
			.to = 'left' if .to === void;
			if (.path === void)
			{
				.path = '( ' + (kag.fore.layers[.layer].left - 30) + ',  ' + kag.fore.layers[.layer].top 	    + ',0,   ' + names[.name].nowscale + ', 0)' if ( .to=='l'  || .to=='left');
				.path = '( ' + (kag.fore.layers[.layer].left + 30) + ',  ' + kag.fore.layers[.layer].top 	    + ',0,   ' + names[.name].nowscale + ', 0)' if ( .to=='r'  || .to=='right');
				.path = '(-' + kag.fore.layers[.layer].width	   + ',  ' + kag.fore.layers[.layer].top 	    + ',0,   ' + names[.name].nowscale + ', 0)' if ( .to=='bl' || .to=='bigleft');
				.path = '( ' + kag.scWidth 			   + ',  ' + kag.fore.layers[.layer].top 	    + ',0,   ' + names[.name].nowscale + ', 0)' if ( .to=='br' || .to=='bigright');
				.path = '( ' + kag.fore.layers[.layer].left 	   + ',  ' + (kag.fore.layers[.layer].top - 30)     + ',0,   ' + names[.name].nowscale + ', 0)' if ( .to=='t'  || .to=='top');
				.path = '( ' + kag.fore.layers[.layer].left 	   + ',  ' + (kag.fore.layers[.layer].top + 30)     + ',0,   ' + names[.name].nowscale + ', 0)' if ( .to=='b'  || .to=='bottom');
				.path = '( ' + kag.fore.layers[.layer].left 	   + ', -' + kag.fore.layers[.layer].height	    + ',255, ' + names[.name].nowscale + ', 0)' if ( .to=='bt'  || .to=='bigtop');
				.path = '( ' + kag.fore.layers[.layer].left 	   + ',  ' + kag.scHeight 		  	    + ',255, ' + names[.name].nowscale + ', 0)' if ( .to=='bb'  || .to=='bigbottom');
				.path = '(-' + kag.fore.layers[.layer].width 	   + ', -' + kag.fore.layers[.layer].height 	    + ',255, ' + names[.name].nowscale + ', 0)' if ( .to=='ul' || .to=='upper left');
				.path = '(-' + kag.fore.layers[.layer].width 	   + ',  ' + kag.scHeight 		  	    + ',255, ' + names[.name].nowscale + ', 0)' if ( .to=='ll' || .to=='lower left');
				.path = '( ' + kag.scWidth 			   + ', -' + kag.fore.layers[.layer].height	    + ',255, ' + names[.name].nowscale + ', 0)' if ( .to=='ur' || .to=='upper right');
				.path = '( ' + kag.scWidth 			   + ',  ' + kag.scHeight 			    + ',255, ' + names[.name].nowscale + ', 0)' if ( .to=='lr' || .to=='lower right');
			}
		}
	}
	function multistock(elm)
	{
		multi.add(%[]);
		multi[multi.count - 1].path   = elm.path;
		multi[multi.count - 1].layer  = elm.layer;
		multi[multi.count - 1].accel  = elm.accel;
		multi[multi.count - 1].page   = elm.page;
		multi[multi.count - 1].spline = elm.spline;
		multi[multi.count - 1].time   = elm.time;
		multi[multi.count - 1].delay  = elm.delay;
		multi[multi.count - 1].cx     = elm.cx;
		multi[multi.count - 1].cy     = elm.cy;
	}
	function gettype(elm)
	{
		var typekeys = keys(namedata[elm.name]);
		for (var i = 0; i < typekeys.count; i++)
		{
			if (elm[typekeys[i]])
			{
				return typekeys[i];
			}
		}
		System.inform('typeを発見出来ず');
	}
}
kag.addPlugin(global.AutoImage_obj = new AutoImage());
@endscript


@return

;サブルーチン用
*name_reg
@macro name=%name
@AutoImage_im * name=%tagname
@endmacro
@return

*multi_move
@eval exp="var AutoImage_count = 0"
*loop1
@iscript
mp.path   = AutoImage_obj.multi[AutoImage_count].path;
mp.layer  = AutoImage_obj.multi[AutoImage_count].layer;
mp.accel  = AutoImage_obj.multi[AutoImage_count].accel;
mp.page   = AutoImage_obj.multi[AutoImage_count].page;
mp.spline = AutoImage_obj.multi[AutoImage_count].spline;
mp.time   = AutoImage_obj.multi[AutoImage_count].time;
mp.delay  = AutoImage_obj.multi[AutoImage_count].delay;
mp.cx     = AutoImage_obj.multi[AutoImage_count].cx;
mp.cy     = AutoImage_obj.multi[AutoImage_count].cy;
@endscript
@exmove *
@jump storage=AutoImage2.ks target=*loop1 cond="++AutoImage_count < AutoImage_obj.count"
@return

*multi_wm
@eval exp="var AutoImage_count = 0"
*loop2
@wm
@jump storage=AutoImage2.ks target=*loop2 cond="++AutoImage_count < AutoImage_obj.pre_count"
@return

*multi_wt
@eval exp="var AutoImage_count = 0"
*loop3
@wt
@jump storage=AutoImage2.ks target=*loop3 cond="++AutoImage_count < AutoImage_obj.pre_count"
@return
