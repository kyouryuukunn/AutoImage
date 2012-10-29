

@macro name=AutoImage_image
@eval exp="mp.storage = mp.name + '_' + mp.emotion if mp.emotion !== void"
@eval exp="mp.storage = mp.name if mp.emotion === void"
@eval exp="AutoImage_checklayer(mp)"
@eval exp="AutoImage.char.top=mp.chartop if mp.chartop !== void"
@eval exp="AutoImage.temp.checked=1"
@eval exp="mp.several = false if mp.several === void"
@if exp="f[mp.name] === void || mp.several"
	@AutoImage_app *
@elsif exp="kag.fore.layers[f[mp.name]].width == AutoImage.char.width"
	@AutoImage_emotion *
@else
	@AutoImage_exemotion *
@endif
@eval exp="AutoImage.temp.checked=0"
@endmacro


@macro name=AutoImage_app
@eval exp="AutoImage_ready(mp)"
@eval exp="AutoImage_checklayer(mp) if !AutoImage.temp.checked"
@eval exp="AutoImage.char.top=mp.chartop if !AutoImage.temp.checked"
@if exp="mp.method == 't'"
	@backlay cond="AutoImage.multi.count==0"
	@eval exp="AutoImage.multi.count+=1 if mp.multi"
	@eval exp="AutoImage_setposition(mp)"
	@image * visible=true page=back
	@if exp="!mp.multi"
		@AutoImage_cml *
		@trans method=crossfade time=%time|500
		@wt
		@AutoImage_sml *
	@endif
@elsif exp="mp.method == 'et'"
	@backlay cond="AutoImage.multi.count==0"
	@eval exp="AutoImage.multi.count+=1 if mp.multi"
	@eval exp="AutoImage_setposition(mp)"
	@eximage * page=back visible=true
	@if exp="!mp.multi"
		@AutoImage_cml *
		@trans method=crossfade time=%time|500
		@wt
		@AutoImage_sml *
	@endif
@elsif exp="mp.method == 'm'"
	@eval exp="mp.from = 'r' if mp.from === void"
	@eval exp="AutoImage_setposition(mp)" cond="mp.path === void"
	@image * visible=true
	@if exp="!mp.multi"
		@AutoImage_cml *
		@move * time=%time|500
		@wm
		@AutoImage_sml *
	@else
		@eval exp="mp.time = 500 if mp.time === void"
		@eval exp="Auto_multi_stock(mp)"
		@eval exp="AutoImage.multi.count+=1"
	@endif
@elsif exp="mp.method == 'em'"
	@eval exp="AutoImage_setposition(mp)" cond="mp.from !== void"
	@eval exp="mp.path = '( kag.scWidth/2 ,  kag.scHeight/2  255, 100, 0)' if mp.path === void"
	@eximage * visible=true opacity=%opacity|0
	@if exp="!mp.multi"
		@AutoImage_cml *
		@exmove * time=%time|500
		@wm
		@AutoImage_sml *
	@else
		@eval exp="mp.time = 500 if mp.time === void"
		@eval exp="Auto_multi_stock(mp)"
		@eval exp="AutoImage.multi.count+=1"
	@endif
@elsif exp="mp.method == 'n'"
	@eval exp="AutoImage_setposition(mp)"
	@AutoImage_cml *
	@image * visible=true
	@AutoImage_sml *
@elsif exp="mp.method == 'en'"
	@AutoImage_cml *
	@eximage * visible=true
	@AutoImage_sml *
@endif
@endmacro

;表情を変える、(つまり差分表示)
;一度に複数の画像を変えるときは、multi=trueにしてまとめて@mtをする。
;@em name=nameID emotion= multi=false
@macro name=AutoImage_emotion
@eval exp="AutoImage_checklayer(mp) if !AutoImage.temp.checked"
@eval exp="mp.layer = f[mp.name]"
@eval exp="&'mp.storage = ' + mp.name + '_' + mp.emotion"
@eval exp="mp.multi=false if mp.multi === void"
@backlay cond="AutoImage.multi.count==0"
@eval exp="AutoImage.multi.count+=1 if mp.multi"
@image * page=back visible=true left=&kag.fore.layers[mp.layer].left top=&kag.fore.layers[mp.layer].top
@if exp="!mp.multi"
	@AutoImage_cml *
	@trans method=crossfade time=%time|300
	@wt
	@AutoImage_sml *
@endif
@endmacro

;表情を変える、(つまり差分表示)回転してたら自分で指定する
;設定した以外の大きさの画像を使って回転拡大縮小してたらそれも自分で指定する
;一度に複数の画像を変えるときは、multi=trueにしてまとめて@mtをする。
;@eem name=nameID emotion= multi=false angle= scale=
@macro name=AutoImage_exemotion
@eval exp="AutoImage_checklayer(mp) if !AutoImage.temp.checked"
@eval exp="mp.layer = f[mp.name]"
@eval exp="&'mp.storage = ' + mp.name + '_' + mp.emotion"
@eval exp="mp.multi=false if mp.multi === void"
@backlay cond="AutoImage.multi.count==0"
@eval exp="AutoImage.multi.count+=1 if mp.multi"
@eval exp="mp.scale = (kag.fore.layers[mp.layer].width / AutoImage.char.width) * 100" cond="mp.scale === void"
@eximage * page=back visible=true left=&kag.fore.layers[mp.layer].left top=&kag.fore.layers[mp.layer].top
@if exp="!mp.multi"
	@AutoImage_cml *
	@trans method=crossfade time=%time|300
	@wt
	@AutoImage_sml *
@endif
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
;@ci name=nameID layer= method=n
@macro name=AutoImage_clearimage
@eval exp="mp.layer = f[mp.name]" cond="mp.name !== void"
@eval exp="mp.method = 't' if mp.method === void"
@if exp="mp.method == 't'"
	@eval exp="mp.multi = false if mp.multi === void"
	@backlay cond="AutoImage.multi.count==0"
	@eval exp="AutoImage.multi.count+=1 if mp.multi"
	@freeimage * page=back
	@if exp="!mp.multi"
		@AutoImage_cml *
		@trans method=crossfade time=%time|100
		@wt
		@AutoImage_sml *
	@endif
@elsif exp="mp.method == 'm'"
	@eval exp="mp.method = 'cm'"
	@eval exp="mp.to = 'r' if mp.to === void"
	@eval exp="AutoImage_setposition(mp)" cond="mp.path === void"
	@if exp="!mp.multi"
		@AutoImage_cml *
		@move  * time=%time|500
		@wm
		@AutoImage_sml *
		@freeimage * page=fore
	@else
		@eval exp="mp.time = 500 if mp.time === void"
		@eval exp="Auto_multi_stock(mp)"
		@eval exp="AutoImage.multi.count+=1 if mp.multi"
	@endif
@elsif exp="mp.method == 'em'"
	@if exp="!mp.multi"
		@AutoImage_cml *
		@exmove * time=%time|500
		@wm
		@AutoImage_sml *
		@freeimage * page=fore
	@else
		@eval exp="mp.time = 500 if mp.time === void"
		@eval exp="Auto_multi_stock(mp)"
		@eval exp="AutoImage.multi.count+=1 if mp.multi"
	@endif
@elsif exp="mp.method == 'n'"
	@AutoImage_cml *
	@freeimage * page=fore
	@AutoImage_sml *
@endif
@eval exp="AutoImage_delnameIDs(mp)"
@endmacro

;一度に複数を移動
@macro name=AutoImage_multi_move
@AutoImage_cml *
@call storage="AutoImageMacros.ks" target="*AutoImage_multi_move"
@AutoImage_sml *
@endmacro

;一度に複数を移動
@macro name=AutoImage_multi_exmove
@AutoImage_cml *
@call storage="AutoImageMacros.ks" target="*AutoImage_multi_exmove"
@AutoImage_sml *
@endmacro

;一度に複数をトランジション
@macro name=AutoImage_multi_trans
@eval exp="AutoImage.multi.count = 0"
@AutoImage_cml *
@trans * method=%method|crossfade time=%time|100
@wt
@AutoImage_sml *
@endmacro

;nameID登録
;name_reg name=nameIDとすれば、
;@nameID と使える
@macro name=AutoImage_name_reg
@call storage=AutoImageMacros.ks target=*name_reg
@endmacro

; メッセージレイヤを表示
@macro name=AutoImage_sml
@eval exp="AutoImage.tempdeletemsg = AutoImage.deletemsg"
@eval exp="AutoImage.tempdeletemsg = mp.dm if mp.dm !== void"
@eval exp="AutoImage.tempbaftertime = AutoImage.aftertime"
@eval exp="AutoImage.tempbaftertime = mp.at if mp.at !== void"
@if exp="AutoImage.tempdeletemsg"
	@wait time=&AutoImage.tempaftertime
	@layopt layer=&AutoImage.messagelayer page=fore visible=true cond="AutoImage.messagelayer !== void"
	@layopt layer=&AutoImage.messagelayer page=back visible=true cond="AutoImage.messagelayer !== void"
	@layopt layer=message0 page=fore visible=true
	@layopt layer=message0 page=back visible=true
@endif
@endmacro
; メッセージレイヤを消す
@macro name=AutoImage_cml
@eval exp="AutoImage.tempdeletemsg = AutoImage.deletemsg"
@eval exp="AutoImage.tempdeletemsg = mp.dm if mp.dm !== void"
@eval exp="AutoImage.tempbeforetime = AutoImage.beforetime"
@eval exp="AutoImage.tempbeforetime = mp.bt if mp.bt !== void"
@if exp="AutoImage.tempdeletemsg"
	@layopt layer=&AutoImage.messagelayer page=fore visible=false cond="AutoImage.messagelayer !== void"
	@layopt layer=&AutoImage.messagelayer page=back visible=false cond="AutoImage.messagelayer !== void"
	@layopt layer=message0 page=fore visible=false
	@layopt layer=message0 page=back visible=false
	@wait time=&AutoImage.tempbeforetime
@endif
@endmacro

; 前景を一時的に消す(あくまで一時的)
@macro name=AutoImage_tempClearAllImage
@eval exp="AutoImage_tempcac()"
@endmacro

; 一時的に消した前景を表示
@macro name=AutoImage_untempClearAllImage
@eval exp="AutoImage_untempcac()"
@endmacro

;;前景クリア
@macro name=AutoImage_ClearAllImage
@backlay
@eval exp="AutoImage_ClearAllImage()"
@AutoImage_multi_trans
@endmacro

;レイヤを確保する
;@getlayer layer=nameID //f.nameIDにレイヤが確保される
;ちゃんと開放すること
@macro name=AutoImage_getlayer
@eval exp="f[mp.layer] = AutoImage_getlayer()"
@eval exp="AutoImage_setnameIDs(mp.layer)"
@endmacro

;レイヤを開放する
;@freelayer layer=name
@macro name=AutoImage_freelayer        
@eval exp="mp.name=mp.layer"
@eval exp="mp.layer=f[mp.layer]"
@eval exp="AutoImage_delnameIDs(mp)"
@endmacro

;設定用
@macro name=AutoImage_Init
@eval exp="AutoImage_Init(mp)"
@endmacro

;nameID初期化
@macro name=AutoImage_reset
@eval exp="delAllnameIDs()"
@endmacro

@iscript
//初期設定
function AutoImage_Init(elm)
{
	AutoImage.temp.checked=0;
	with(elm)
	{
		AutoImage.autolayer = .layer;
		//背景の追加
		if (.baselayer !== void)	{AutoImage.baselayer		= .baselayer; f.base = .baselayer;}	else {AutoImage.baselayer = '空';}
		//メッセージ枠の追加
		if (.messagelayer !== void)	{AutoImage.messagelayer		= .messagelayer;}	else {AutoImage.messagelayer = '空';}
		if (.deletemsg !== void)	{AutoImage.deletemsg		= .deletemsg;}		else {AutoImage.deletemsg		= true;}
		if (.aftertime !== void)	{AutoImage.aftertime		= .aftertime;}		else {AutoImage.aftertime		= 300;}
		if (.beforetime !== void)	{AutoImage.beforetime		= .beforetime;}		else {AutoImage.beforetime		= 300;}
	}
}
//立ち絵の幅と高さから立ち位置を設定
function AutoImage_setImage(elm)
{
	with(elm)
	{
		AutoImage.char.width  		= .width;
		AutoImage.char.height 		= .height;
		
		//if (.left !== void)		{AutoImage.char.left		= .left;}		else {AutoImage.char.left		= kag.scPositionX.left - AutoImage.char.width/2;}
		//if (.left_center !== void)	{AutoImage.char.left_center 	= .left_center;} 	else {AutoImage.char.left_center	= kag.scPositionX.left_center - AutoImage.char.width/2;}
		//if (.center !== void)		{AutoImage.char.center		= .center;}		else {AutoImage.char.center		= kag.scPositionX.center - AutoImage.char.width/2;}
		//if (.right_center !== void)	{AutoImage.char.right_center    = .right_center;}	else {AutoImage.char.right_center	= kag.scPositionX.right_center - AutoImage.char.width/2;}
		//if (.right !== void)		{AutoImage.char.right		= .right;} 		else {AutoImage.char.right		= kag.scPositionX.right - AutoImage.char.width/2;}
		
		AutoImage.char.top 		= kag.scHeight - AutoImage.char.height;
		AutoImage.char.left		= kag.scPositionX.left - AutoImage.char.width/2;
		AutoImage.char.left_center	= kag.scPositionX.left_center - AutoImage.char.width/2;
		AutoImage.char.center		= kag.scPositionX.center - AutoImage.char.width/2;
		AutoImage.char.right_center	= kag.scPositionX.right_center - AutoImage.char.width/2;
		AutoImage.char.right		= kag.scPositionX.right - AutoImage.char.width/2;
	}
}
//画像の幅と高さを得る
function AutoImage_checklayer(elm)
{
	var templayer = new Layer(kag, kag.back.base);
	templayer.loadImages(elm.storage);
	templayer.setSizeToImageSize();
	AutoImage_setImage(%['width'=> templayer.width, 'height'=> templayer.height]);
	invalidate templayer;
}
//空きレイヤーを確保
function AutoImage_getlayer()
{
	for ( var i=AutoImage.autolayer; i<kag.numCharacterLayers; i++ )
	{
		if ( f.AutoImage_chosedlayer[i] == 0 )
		{
			f.AutoImage_chosedlayer[i] = 1;
			return (string) i;
		}
	}
	System.inform("前景レイヤーが確保できませんでした。");
}
//methoに合わせてposからleft,top(ついでにpath)を設定し、posを削除
function AutoImage_setposition(elm)
{
	with(elm)
	{
		if (.method == 't' || .method == 'n' || .method == 'et')
		{
			if (.left === void && .top === void)
			{
				if (.pos == 'left' || .pos == 'l') 		.left=AutoImage.char.left;
				if (.pos == 'left_center' || .pos == 'lc')	.left=AutoImage.char.left_center;
				if (.pos == 'center' || .pos == 'c') 		.left=AutoImage.char.center;
				if (.pos == 'right_center'  || .pos == 'rc')	.left=AutoImage.char.right_center;
				if (.pos == 'right' || .pos == 'r') 		.left=AutoImage.char.right;
				.top = AutoImage.char.top;
				.opacity = 255;
			}
			.top = AutoImage.char.top if .top === void;
		}
		else if (.method == 'm')
		{
			if (.left !== void || .top !== void)
			{
				.path = '(' + .left + ', ' + .top + ', 255)';
				if (.from == 'l' || .from == 'left')		{.left = .left - 30; .opacity = 0; }
				if (.from == 'r' || .from == 'right')		{.left = .left + 30; .opacity = 0; }
				if (.from == 'bl' || .from =='bigleft')		{.left = 0 - AutoImage.char.width;}
				if (.from == 'br' || .from == 'bigright')	{.left = kag.scWidth;}
				if (.from == 't' || .from == 'top')		{.top  = 0 - AutoImage.char.height;}
				if (.from == 'b' || .from == 'bottom')		{.top  = kag.scHeight;}
				if (.from == 'ul' || .from == 'upper left')	{.left = 0 - AutoImage.char.width; .top = 0 - AutoImage.char.height;}
				if (.from == 'll' || .from == 'lower left')	{.left = 0 - AutoImage.char.width; .top = 0;}
				if (.from == 'ur' || .from =='upper right')	{.left = kag.scWidth; .top = 0 - AutoImage.char.height;}
				if (.from == 'lr' || .from == 'lower right')	{.left = kag.scWidth; .top = 0;}
			}
			else if (.pos=='left' || .pos=='l')
			{
				if (.from == 'l' || .from == 'left')
				{
					.left=AutoImage.char.left - 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'r' || .from == 'right')
				{
					.left=AutoImage.char.left + 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'bl' || .from =='bigleft')
				{
					.left=-AutoImage.char.width;
					.top=AutoImage.char.top;
				}
				else if (.from == 'br' || .from == 'bigright')
				{
					.left=kag.scWidth;
					.top=AutoImage.char.top;
				}
				else if (.from == 't' || .from == 'top')
				{
					.left=AutoImage.char.left;
					.top=0 - AutoImage.char.height;
				}
				else if (.from == 'b' || .from == 'bottom')
				{
					.left=AutoImage.char.left;
					.top=kag.scHeight;
				}
				else if (.from == 'ul' || .from == 'upper left')
				{
					.left=0 - AutoImage.char.width;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'll' || .from == 'lower left')
				{
					.left=0 - AutoImage.char.width;
					.top=kag.scHeight;
				}
				else if (.from == 'ur' || .from == 'upper right')
				{
					.left=kag.scWidth;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'lr' || .from == 'lower right')
				{
					.left=kag.scWidth;
					.top=kag.scHeight;
				}
				.path = '(' + AutoImage.char.left + ', ' + AutoImage.char.top +', 255)';
			}
			else if (.pos=='left_center' || .pos=='lc')
			{
				if (.from == 'l' || .from == 'left')
				{
					.left=AutoImage.char.left_center - 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'r' || .from == 'right')
				{
					.left=AutoImage.char.left_center + 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'bl' || .from =='bigleft')
				{
					.left=-AutoImage.char.width;
					.top=AutoImage.char.top;
				}
				else if (.from == 'br' || .from == 'bigright')
				{
					.left=kag.scWidth;
					.top=AutoImage.char.top;
				}
				else if (.from == 't' || .from == 'top')
				{
					.left=AutoImage.char.left_center;
					.top=0 - AutoImage.char.height;
				}
				else if (.from == 'b' || .from == 'bottom')
				{
					.left=AutoImage.char.left_center;
					.top=kag.scHeight;
				}
				else if (.from == 'ul' || .from == 'upper left')
				{
					.left=0 - AutoImage.char.width;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'll' || .from == 'lower left')
				{
					.left=0 - AutoImage.char.width;
					.top=kag.scHeight;
				}
				else if (.from == 'ur' || .from == 'upper right')
				{
					.left=kag.scWidth;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'lr' || .from == 'lower right')
				{
					.left=kag.scWidth;
					.top=kag.scHeight;
				}
				.path = '(' + AutoImage.char.left_center + ', ' + AutoImage.char.top +', 255)';
			}
			else if (.pos=='center' || .pos=='c')
			{
				if (.from == 'l' || .from == 'left')
				{
					.left=AutoImage.char.center - 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'r' || .from == 'right')
				{
					.left=AutoImage.char.center + 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'bl' || .from =='bigleft')
				{
					.left=-AutoImage.char.width;
					.top=AutoImage.char.top;
				}
				else if (.from == 'br' || .from == 'bigright')
				{
					.left=kag.scWidth;
					.top=AutoImage.char.top;
				}
				else if (.from == 't' || .from == 'top')
				{
					.left=AutoImage.char.center;
					.top=0 - AutoImage.char.height;
				}
				else if (.from == 'b' || .from == 'bottom')
				{
					.left=AutoImage.char.center;
					.top=kag.scHeight;
				}
				else if (.from == 'ul' || .from == 'upper left')
				{
					.left=0 - AutoImage.char.width;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'll' || .from == 'lower left')
				{
					.left=0 - AutoImage.char.width;
					.top=kag.scHeight;
				}
				else if (.from == 'ur' || .from == 'upper right')
				{
					.left=kag.scWidth;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'lr' || .from == 'lower right')
				{
					.left=kag.scWidth;
					.top=kag.scHeight;
				}
				.path = '(' + AutoImage.char.center + ', ' + AutoImage.char.top +', 255)';
			}
			else if (.pos=='right_center' || .pos=='rc')
			{
				if (.from == 'l' || .from == 'left')
				{
					.left=AutoImage.char.right_center - 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'r' || .from == 'right')
				{
					.left=AutoImage.char.right_center + 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'bl' || .from =='bigleft')
				{
					.left=-AutoImage.char.width;
					.top=AutoImage.char.top;
				}
				else if (.from == 'br' || .from == 'bigright')
				{
					.left=kag.scWidth;
					.top=AutoImage.char.top;
				}
				else if (.from == 't' || .from == 'top')
				{
					.left=AutoImage.char.right_center;
					  .top=0 - AutoImage.char.height;
				}
				else if (.from == 'b' || .from == 'bottom')
				{
					.left=AutoImage.char.right_center;
					.top=kag.scHeight;
				}
				else if (.from == 'ul' || .from == 'upper left')
				{
					.left=0 - AutoImage.char.width;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'll' || .from == 'lower left')
				{
					.left=0 - AutoImage.char.width;
					.top=kag.scHeight;
				}
				else if (.from == 'ur' || .from == 'upper right')
				{
					.left=kag.scWidth;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'lr' || .from == 'lower right')
				{
					.left=kag.scWidth;
					.top=kag.scHeight;
				}
				.path = '(' + AutoImage.char.right_center + ', ' + AutoImage.char.top +', 255)';
			}
			else if (.pos=='right' || .pos=='r')
			{
				if (.from == 'l' || .from == 'left')
				{
					.left=AutoImage.char.right - 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'r' || .from == 'right')
				{
					.left=AutoImage.char.right + 30;
					.top=AutoImage.char.top;
					.opacity = 0;
				}
				else if (.from == 'bl' || .from =='bigleft')
				{
					.left=-AutoImage.char.width;
					.top=AutoImage.char.top;
				}
				else if (.from == 'br' || .from == 'bigright')
				{
					.left=kag.scWidth;
					.top=AutoImage.char.top;
				}
				else if (.from == 't' || .from == 'top')
				{
					.left=AutoImage.char.right;
					.top=0 - AutoImage.char.height;
				}
				else if (.from == 'b' || .from == 'bottom')
				{
					.left=AutoImage.char.right;
					.top=kag.scHeight;
				}
				else if (.from == 'ul' || .from == 'upper left')
				{
					.left=0 - AutoImage.char.width;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'll' || .from == 'lower left')
				{
					.left=0 - AutoImage.char.width;
					.top=kag.scHeight;
				}
				else if (.from == 'ur' || .from == 'upper right')
				{
					.left=kag.scWidth;
					.top= 0 - AutoImage.char.height;
				}
				else if (.from == 'lr' || .from == 'lower right')
				{
					.left=kag.scWidth;
					.top=kag.scHeight;
				}
				.path = '(' + AutoImage.char.right + ', ' + AutoImage.char.top +', 255)';
			}
		}
		else if ( .method == 'em')
		{
			if ( .scale === void)
			{
				System.inform('scaleを指定してくれ');
			}
			else 
			{
				.path = '(' + .left + ', ' + .top + ', 255, ' +  .scale + ', 0)';
			}
			if (.from == 'l' || .from == 'left')		{.left = .left - 30; .opacity = 0; }
			if (.from == 'r' || .from == 'right')		{.left = .left + 30; .opacity = 0; }
			if (.from == 'bl' || .from =='bigleft')		{.left = 0 - AutoImage.char.width*(.scale/100);}
			if (.from == 'br' || .from == 'bigright')	{.left = kag.scWidth;}
			if (.from == 't' || .from == 'top')		{.top  = 0 - AutoImage.char.height*(.scale/100);}
			if (.from == 'b' || .from == 'bottom')		{.top  = kag.scHeight;}
			if (.from == 'ul' || .from == 'upper left')	{.left = 0 - AutoImage.char.width*(.scale/100); .top = 0 - AutoImage.char.height*(.scale/100);}
			if (.from == 'll' || .from == 'lower left')	{.left = 0 - AutoImage.char.width*(.scale/100); .top = 0;}
			if (.from == 'ur' || .from =='upper right')	{.left = kag.scWidth; .top = 0 - AutoImage.char.height*(.scale/100);}
			if (.from == 'lr' || .from == 'lower right')	{.left = kag.scWidth; .top = 0;}
		}
		else if ( .method == 'cm' )
		{
			.path = '( ' + (kag.fore.layers[.layer].left - 30) + ',  ' + kag.fore.layers[.layer].top 	+ ',0)'   if ( .to=='l'  || .to=='left');
			.path = '( ' + (kag.fore.layers[.layer].left + 30) + ',  ' + kag.fore.layers[.layer].top 	+ ',0)'   if ( .to=='r'  || .to=='right');
			.path = '(-' + kag.fore.layers[.layer].width	   + ',  ' + kag.fore.layers[.layer].top 	+ ',0)'   if ( .to=='bl' || .to=='bigleft');
			.path = '( ' + kag.scWidth 			   + ',  ' + kag.fore.layers[.layer].top 	+ ',0)'   if ( .to=='br' || .to=='bigright');
			.path = '( ' + kag.fore.layers[.layer].left 	   + ', -' + kag.fore.layers[.layer].height	+ ',255)'	if ( .to=='t'  || .to=='top');
			.path = '( ' + kag.fore.layers[.layer].left 	   + ',  ' + kag.scHeight 		  	+ ',255)'	if ( .to=='b'  || .to=='bottom');
			.path = '(-' + kag.fore.layers[.layer].width 	   + ', -' + kag.fore.layers[.layer].height 	+ ',255)'	if ( .to=='ul' || .to=='upper left');
			.path = '(-' + kag.fore.layers[.layer].width 	   + ',  ' + kag.scHeight 		  	+ ',255)'	if ( .to=='ll' || .to=='lower left');
			.path = '( ' + kag.scWidth 			   + ', -' + kag.fore.layers[.layer].height	+ ',255)'	if ( .to=='ur' || .to=='upper right');
			.path = '( ' + kag.scWidth 			   + ',  ' + kag.scHeight 			+ ',255)'	if ( .to=='lr' || .to=='lower right');
		}
		delete .pos if (.pos !== void);
	}
}
//imの前準備
function AutoImage_ready(elm)
{
	with(elm)
	{
		if (.layer != AutoImage.baselayer)
		{
			if (.layer === void)
			{
				if ( f[.name] === void )
				{
					f[.name] = AutoImage_getlayer();
					.layer = (string) f[.name];
					AutoImage_setnameIDs(.name);
				}
				else
				{
					var i = 0;
					while(1)
					{
						if ( Scripts.eval('f.' + .name + '_n' + i ) === void) break;
						i += 1;
					}
					Scripts.eval('f.' + .name + '_n' + i + ' = AutoImage_getlayer()');
					.layer = Scripts.eval('f.' + .name + '_n' + i);
					AutoImage_setnameIDs(.name + '_n' + i);
				}
			}
			else
			{
				if ( f[.name] === void)
				{
					f[.name] = (string) .layer;
					AutoImage_setnameIDs(.name);
					f.AutoImage_chosedlayer[.layer] = 1;
				}
				else
				{
					var i = 0;
					while(1)
					{
						if ( Scripts.eval('f.' + .name + '_n' + i ) === void) break;
						i += 1;
					}
						Scripts.eval('f.' + .name + '_n' + i + ' = \'' + .layer + '\'');
						AutoImage_setnameIDs(.name + '_n' + i);
				}
			}
		}
		else
		{
			.top  = 0 if (.top  === void);
			.left = 0 if (.left === void);
			f[.name] = AutoImage.baselayer;
			AutoImage_setnameIDs(.name);
		}
			if (.emotion === void)
			{
				.storage = .name;
			}
			else
			{
				.storage = .name + '_' + .emotion;
			}
		.method = 't' if .method === void;
		.pos = 'c' if ( .pos === void && .left === void && .top === void);
		.multi = false if .multi === void;
	}
}
function AutoImage_setnameIDs(str)
{
	if (f.AutoImage_nameIDs.find(str) == -1)
	{
		f.AutoImage_nameIDs.add(str);
	}
}
function AutoImage_delnameIDs(elm)
{
	f.AutoImage_chosedlayer[elm.layer]=0;
	delete f[elm.name];
	f.AutoImage_nameIDs.remove(elm.name);
}
function delAllnameIDs()
{
	for (var i = 0; i < f.AutoImage_nameIDs.count; i++)
	{
		delete f[f.AutoImage_nameIDs[i]];
	}
	f.AutoImage_nameIDs.clear();
	for (var i = 0; i < kag.numCharacterLayers; i++)
	{
		f.AutoImage_chosedlayer[i] = 0;
	}
}
function AutoImage_tempcac()
{
	for ( var i=AutoImage.autolayer; i<kag.numCharacterLayers; i++ )
	{
		if ( f.AutoImage_chosedlayer[i] == 1 )
		{
			kag.fore.layers[i].visible=false;
		}
	}
}
function AutoImage_untempcac()
{
	for ( var i=AutoImage.autolayer; i<kag.numCharacterLayers; i++ )
	{
		if ( f.AutoImage_chosedlayer[i] == 1 && kag.fore.layers[i].visible == false)
		{
			kag.fore.layers[i].visible=true;
		}
	}
}
function AutoImage_ClearAllImage()
{
	for (var i = 0; i < f.AutoImage_nameIDs.count; i++)
	{
		if (f[f.AutoImage_nameIDs[i]] !== AutoImage.baselayer)
		{
			kag.back.layers[f[f.AutoImage_nameIDs[i]]].visible=false;
			f.AutoImage_chosedlayer[f[f.AutoImage_nameIDs[i]]]=0;
			delete f[f.AutoImage_nameIDs[i]];
		}
	}
	f.AutoImage_nameIDs.clear();
}
function Auto_multi_stock(elm)
{
	AutoImage.multi.elm[AutoImage.multi.count] = %[];
	AutoImage.multi.elm[AutoImage.multi.count].path = elm.path;
	AutoImage.multi.elm[AutoImage.multi.count].layer = elm.layer;
	AutoImage.multi.elm[AutoImage.multi.count].accel = elm.accel;
	AutoImage.multi.elm[AutoImage.multi.count].page = elm.page;
	AutoImage.multi.elm[AutoImage.multi.count].spline = elm.spline;
	AutoImage.multi.elm[AutoImage.multi.count].time = elm.time;
	AutoImage.multi.elm[AutoImage.multi.count].delay = elm.delay;
	AutoImage.multi.elm[AutoImage.multi.count].cx = elm.cx if elm.cx !== void;
	AutoImage.multi.elm[AutoImage.multi.count].cy = elm.cy if elm.cy !== void;
}
var AutoImage = %[];
AutoImage.char = %[];
AutoImage.multi = %[];
AutoImage.multi.count = 0;
AutoImage.multi.elm = %[];
AutoImage.temp = %[];
f.AutoImage_chosedlayer = %[];
f.AutoImage_nameIDs = [];
@endscript


@return

;サブルーチン用
*name_reg
@macro name=%name
@AutoImage_image * name=%tagname
@endmacro
@return

*AutoImage_multi_move
@eval exp="AutoImage.multi.count2 = 0"
*step1
@iscript
mp.path = AutoImage.multi.elm[AutoImage.multi.count2].path;
mp.layer = AutoImage.multi.elm[AutoImage.multi.count2].layer;
mp.accel = AutoImage.multi.elm[AutoImage.multi.count2].accel;
mp.page = AutoImage.multi.elm[AutoImage.multi.count2].page;
mp.spline = AutoImage.multi.elm[AutoImage.multi.count2].spline;
mp.time = AutoImage.multi.elm[AutoImage.multi.count2].time;
mp.delay = AutoImage.multi.elm[AutoImage.multi.count2].delay;
@endscript
@move *
@eval exp="AutoImage.multi.count2 += 1"
@jump storage=AutoImageMacros.ks target=*step1 cond="AutoImage.multi.count2 < AutoImage.multi.count"
@eval exp="AutoImage.multi.count2 = 0"
*step2
@wm
@eval exp="AutoImage.multi.count2 += 1"
@jump storage=AutoImageMacros.ks target=*step2 cond="AutoImage.multi.count2 < AutoImage.multi.count"
@return

*AutoImage_multi_exmove
@eval exp="var AutoImage.multi.count2 = 0"
*exstep1
@iscript
mp.path = AutoImage.multi.elm[AutoImage.multi.count2].path;
mp.layer = AutoImage.multi.elm[AutoImage.multi.count2].layer;
mp.accel = AutoImage.multi.elm[AutoImage.multi.count2].accel;
mp.page = AutoImage.multi.elm[AutoImage.multi.count2].page;
mp.spline = AutoImage.multi.elm[AutoImage.multi.count2].spline;
mp.time = AutoImage.multi.elm[AutoImage.multi.count2].time;
mp.delay = AutoImage.multi.elm[AutoImage.multi.count2].delay;
mp.cx = AutoImage.multi.elm[AutoImage.multi.count2].cx;
mp.cy = AutoImage.multi.elm[AutoImage.multi.count2].cy;
@endscript
@exmove *
@eval exp="AutoImage.multi.count2 += 1"
@jump storage=AutoImageMacros.ks target=*exstep1 cond="AutoImage.multi.count2 < AutoImage.multi.count"
@eval exp="AutoImage.multi.count2 = 0"
*exstep2
@wm
@eval exp="AutoImage.multi.count2 += 1"
@jump storage=AutoImageMacros.ks target=*exstep2 cond="AutoImage.multi.count2 < AutoImage.multi.count"
@return
