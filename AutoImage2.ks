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
@eval exp="mp.time = 500 if mp.time === void"

@if exp="AutoImage_obj.getmethod(mp) == 'tr'"
	@trace exp="'method=t'"
	@backlay cond="AutoImage_obj.count==0"
	@eval exp="AutoImage_obj.count+=1 if mp.multi"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * page=back visible=true opacity=%opacity|255
	@if exp="!mp.multi"
		@eval exp="delete mp.layer"
		@trans * method=%method|crossfade
	@endif
@elsif exp="AutoImage_obj.getmethod(mp) == 'mv'"
	@trace exp="'method=m'"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * visible=true 
	@if exp="!mp.multi"
		@exmove *
	@else
		@eval exp="AutoImage_obj.multistock(mp)"
		@eval exp="AutoImage_obj.count+=1"
	@endif
@elsif exp="AutoImage_obj.getmethod(mp) == 'no'"
	@trace exp="'method=n'"
	@eval exp="AutoImage_obj.set_app_position(mp)"
	@eximage * page=fore visible=true opacity=%opacity|255
@endif
@endmacro

;�\���ς���A(�܂荷���\��)��]���Ă��玩����scale, angle���w�肷��
;��x�ɕ����̉摜��ς���Ƃ��́Amulti=true�ɂ��Ă܂Ƃ߂�@mt������B
;@diff name=nameID type= multi=false angle= scale=
@macro name=AutoImage_diff
@eval exp="mp.layer = AutoImage_obj.names[mp.name].nowlayer"
@eval exp="mp.type = AutoImage_obj.gettype(mp) if mp.type === void"
@eval exp="mp.storage = AutoImage_obj.namedata[mp.name][mp.type].storage"
@eval exp="mp.time = 500 if mp.time === void"

@if exp="AutoImage_obj.getmethod(mp) == 'tr'"
	@backlay cond="AutoImage_obj.count==0"
	@eval exp="AutoImage_obj.count+=1 if mp.multi"
	@eximage * page=back visible=true left="&kag.fore.layers[mp.layer].left" top="&kag.fore.layers[mp.layer].top" scale="&AutoImage_obj.names[mp.name].nowscale"
	@if exp="!mp.multi"
		@eval exp="delete mp.layer"
		@trans * method=%method|crossfade
	@endif
@elsif exp="AutoImage_obj.getmethod(mp) == 'mt'"
	@backlay
	@eximage * page=back visible=true left="&kag.fore.layers[mp.layer].left" top="&kag.fore.layers[mp.layer].top" scale="&AutoImage_obj.names[mp.name].nowscale"
	@trans * method=%method|crossfade
	@exmove *
@endif
@eval exp="AutoImage_obj.names[mp.name].nowtype = mp.type"
@endmacro

;�摜�N���A
@macro name=AutoImage_dis
@eval exp="mp.layer = AutoImage_obj.names[mp.name].nowlayer"
@eval exp="mp.time = 500 if mp.time === void"

@if exp="AutoImage_obj.getmethod(mp) == 'tr'"
	@backlay cond="AutoImage_obj.count==0"
	@eval exp="AutoImage_obj.count+=1 if mp.multi"
	@freeimage * page=back
	@if exp="!mp.multi"
		@eval exp="mp.temp_layer = mp.layer"
		@eval exp="delete mp.layer"
		@trans * method=%method|crossfade
		@eval exp="mp.layer = mp.temp_layer"
	@endif
@elsif exp="AutoImage_obj.getmethod(mp) == 'mv'"
	@eval exp="AutoImage_obj.set_dis_position(mp)"
	@if exp="!mp.multi"
		@exmove *
	@else
		@eval exp="AutoImage_obj.multistock(mp)"
		@eval exp="AutoImage_obj.count+=1"
	@endif
@elsif exp="AutoImage_obj.getmethod(mp) == 'no'"
	@freeimage * page=fore
@endif
@eval exp="AutoImage_obj.freelayer(mp)"
@endmacro

;��x�ɕ������ړ�
@macro name=AutoImage_mm
;�҂��̂��߂Ƀo�b�N�A�b�v
@eval exp="AutoImage_obj.pre_count = AutoImage_obj.count"
@call storage="AutoImage2.ks" target="*multi_move"
@eval exp="AutoImage_obj.count = 0"
@eval exp="AutoImage_obj.multi.clear()"
@endmacro

@macro name=AutoImage_wmm
@call storage=AutoImage2.ks target=*multi_wm
@endmacro

;��x�ɕ������g�����W�V����
@macro name=AutoImage_mt
;�҂��̂��߂Ƀo�b�N�A�b�v
@eval exp="AutoImage_obj.pre_count = AutoImage_obj.count"
@trans * method=%method|crossfade time=%time|500
@eval exp="AutoImage_obj.count = 0"
@endmacro

@macro name=AutoImage_wmt
@call storage=AutoImage2.ks target=*multi_wt
@endmacro

;nameID�o�^
;name_reg name=nameID�Ƃ���΁A
;@nameID �Ǝg����
@macro name=AutoImage_name_reg
@call storage=AutoImage2.ks target=*name_reg
@endmacro

; �O�i���ꎞ�I�ɏ���(�����܂ňꎞ�I)
@macro name=AutoImage_tempcai
@eval exp="AutoImage_obj.tempcac()"
@endmacro

; �ꎞ�I�ɏ������O�i��\��
@macro name=AutoImage_untempcai
@eval exp="AutoImage_obj.untempcac()"
@endmacro

;;�O�i�N���A
@macro name=AutoImage_cai
@backlay
@eval exp="AutoImage_obj.clearall()"
@AutoImage_mt
@endmacro

;���C�����m�ۂ���
;@getlayer name=nameID //f.nameID�Ƀ��C�����m�ۂ����
;�����ƊJ�����邱��
@macro name=AutoImage_getlayer
@eval exp="f[mp.name] = AutoImage_obj.getlayer(mp)"
@endmacro

;���C�����J������
;@freelayer name=nameID
@macro name=AutoImage_freelayer
@eval exp="mp.layer=f[mp.name]"
@eval exp="AutoImage_obj.freelayer(mp)"
@endmacro

;�ݒ�p
@macro name=AutoImage_Init
@eval exp="AutoImage_obj.autolayer = mp.layer"
@endmacro

;nameID������
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
			 // nowpos
var namedata = %[];
                 //name   type
				 // storage
				 // width
				 // height
var autolayer; //�v���O�C�����Ǘ����郌�C��
var chosedlayer = %[]; //�g�p�σ��C��
var chosedpos = %[]; //�g�p�σ|�W�V����
var count = 0; //�}���`�g�����X�A���[�u�̂��߂̃J�E����
var pre_count = 0; //�}���`�g�����X�A���[�u�̂��߂̃J�E���g
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
		dic.chosedpos = %[];
		(Dictionary.assign incontextof dic.chosedpos)(chosedpos);
		dic.count = count;
		dic.pre_count = pre_count;
	}

	function onRestore(f, clear, elm)
	{
		// �x��ǂݏo���Ƃ�
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
			(Dictionary.assign incontextof chosedpos)(dic.chosedpos);
			count = dic.count;
			pre_count = dic.pre_count;
		}
	}
	//�摜�̕��ƍ����𓾂�
	function setname(elm)
	{
		//�����G�̕��ƍ������痧���ʒu��ݒ�
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
	function pos_to_LeftTop(elm) //pos����left, top��ݒ肷��, ������ݒ肵�Ȃ������߂� ������pos�̑I����Ԃ��L�^����
	{
		with(elm)
		{
			.top  = namedata[.name][.type].top;
			names[.name].nowpos = 'left'         ,chosedpos.left         = 1, .left = kag.scPositionX.left         - namedata[.name][.type].width * .scale / 100 / 2 if .pos == 'l'  || .pos == 'left';
			names[.name].nowpos = 'left_center'  ,chosedpos.left_center  = 1, .left = kag.scPositionX.left_center  - namedata[.name][.type].width * .scale / 100 / 2 if .pos == 'lc' || .pos == 'left_center';
			names[.name].nowpos = 'center'       ,chosedpos.center       = 1, .left = kag.scPositionX.center       - namedata[.name][.type].width * .scale / 100 / 2 if .pos == 'c'  || .pos == 'center';
			names[.name].nowpos = 'right_center' ,chosedpos.right_center = 1, .left = kag.scPositionX.right_center - namedata[.name][.type].width * .scale / 100 / 2 if .pos == 'rc' || .pos == 'right_center';
			names[.name].nowpos = 'right'        ,chosedpos.right        = 1, .left = kag.scPositionX.right        - namedata[.name][.type].width * .scale / 100 / 2 if .pos == 'r'  || .pos == 'right';
		}
	}
	//���C���[���J��
	function freelayer(elm)
	{
		chosedlayer[elm.layer] = false;
		names[elm.name].nowcount -= 1;
		chosedpos.left         = 1 if names[elm.name].nowpos == 'left';
		chosedpos.left_center  = 1 if names[elm.name].nowpos == 'left_center';
		chosedpos.center       = 1 if names[elm.name].nowpos == 'center';
		chosedpos.right_center = 1 if names[elm.name].nowpos == 'right_center';
		chosedpos.right        = 1 if names[elm.name].nowpos == 'right';
		delete names[elm.name].nowpos;
		delete names[elm.name].nowtype;
		delete names[elm.name].nowscale;
		delete names[elm.name].nowlayer;
		delete f[elm.name];
	}
	//�󂫃��C���[���m��
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
			System.inform("�O�i���C���[���m�ۂł��܂���ł����B");
		}
		else
		{
			if (chosedlayer[elm.layer])
				System.inform("���̃��C���͊��Ɏg��ꂽ���܂��B");
			else
				return elm.layer;
		}
	}
	function getpos() //�󂢂Ă���|�W�V������Ԃ�
	{
		if (!chosedpos.center)       return 'center';
		if (!chosedpos.right)        return 'right';
		if (!chosedpos.left)         return 'left';
		if (!chosedpos.right_center) return 'right_center';
		if (!chosedpos.left_center)  return 'left_center';
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
		chosedpos.left         = 0;
		chosedpos.left_center  = 0;
		chosedpos.center       = 0;
		chosedpos.right_center = 0;
		chosedpos.right        = 0;
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
			if (.left === void && .top === void && findpos(elm) === void) .pos = getpos(); //���w��Ȃ�pos����������
			.scale = 100 if .scale === void;
			.angle = 0 if .angle === void;
			
			if (.method2 == 'tr' || .method2 == 'no')
			{
				if (.left === void && .top === void) //left, top�����w��Ȃ�pos�ł��킹��
				{
					//top��ݒ肷�邽�߂�pos��ݒ肵�Ȃ���
					if (.pos == void) .pos = 'center'; //pos�����w��Ȃ�center��
					pos_to_LeftTop(elm);
				}
			}
			else if (.method2 == 'mv')
			{
				if (.from === void && .path === void) .from = 'left'; //���w��Ȃ�from��left��
				if (.from !== void)
				{
					if (.left === void && .top === void)
						pos_to_LeftTop(elm);
					set_position(elm, .left, .top);
				}
				else if (.path !== void)
				{
					.opacity = 0 if .opacity === void;
				}
			}
			names[.name].nowscale = .scale;
			delete .pos; //����pos������
		}
	}
	function set_position(elm, left, top) //�w�肳�ꂽ���W��from����ړ�����
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
	function findpos(elm)
	{
		if (elm.pos !== void)
			return elm.pos;
		var poskeys = ['left', 'left_center', 'center', 'right_center', 'right'];
		var shortposkeys = ['l', 'lc', 'c', 'rc', 'r'];
		for (var i = 0; i < 5; i++)
		{
			if (elm[poskeys[i]] !== void || elm[shortposkeys[i]])
			{
				return elm.pos = poskeys[i];
			}
		}
		return void;
	}
	function getmethod(elm)
	{
		if (elm.method2 !== void)
			return elm.method2;
		var methodkeys = ['tr', 'mv', 'mt', 'no'];
		for (var i = 0; i < 4; i++)
		{
			if (elm[methodkeys[i]] !== void)
			{
				return elm.method2 = methodkeys[i];
			}
		}
		return elm.method2 = 'tr';
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
		System.inform('type�𔭌��o����');
	}
}
kag.addPlugin(global.AutoImage_obj = new AutoImage());
@endscript


@return

;�T�u���[�`���p
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
