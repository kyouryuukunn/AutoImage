[iscript]

// eximage マクロ(改良版)

class ImageHandlerPlugin extends KAGPlugin
{
	var warn_anim, warn_province, warn_partial; // 警告メッセージ表示用

	function ImageHandlerPlugin()
	{
		super.KAGPlugin();
	}

	function finalize()
	{
		super.finalize();
	}

	// レイヤの画像を拡大／縮小します
	// (指定できる属性)
	// elm.page : 表 or 裏画面（image タグの page 属性と同じ）
	// elm.layer : レイヤの番号（image タグの layer 属性と同じ）
	// elm.scale : 縦・横方向共通拡大率(%)
	// elm.xscale : 横方向拡大率(%)
	// elm.yscale : 縦方向拡大率(%)
	function scaleImage(layer, elm, ignorePos)
	{
		var tmpLayer = new Layer(kag, layer); // 一時レイヤを作ります
		tmpLayer.assignImages(layer); // 一時レイヤに操作対象のレイヤの画像をコピーします

		// 横方向・縦方向拡大率を計算します
		var xscale = elm.xscale !== void ? +elm.xscale : (elm.scale !== void ? +elm.scale : 100);
		var yscale = elm.yscale !== void ? +elm.yscale : (elm.scale !== void ? +elm.scale : 100);
		var width = (int)(tmpLayer.imageWidth * xscale / 100); // 拡大／縮小後の幅を計算します
		var height = (int)(tmpLayer.imageHeight * yscale / 100); // 拡大／縮小後の高さを計算します
		width = 1 if width < 1; // 幅は必ず 1 ピクセル以上になるようにします
		height = 1 if height < 1; // 高さも必ず 1 ピクセル以上になるようにします

		layer.setImageSize(width, height); // 操作対象のレイヤのサイズを変更します
		layer.setSizeToImageSize(); // 操作対象のレイヤのサイズを画像のサイズに合わせます

		// 一時レイヤの画像を拡大／縮小して操作対象のレイヤにコピーします
		layer.stretchCopy(0, 0, layer.width, layer.height, tmpLayer, 0, 0, tmpLayer.imageWidth, tmpLayer.imageHeight, stLinear);

		invalidate tmpLayer; // 一時レイヤはもう必要ないので無効化します

		// pos 属性が指定されている場合は操作対象のレイヤの位置を調整します
		setPosition(layer, elm.pos) if elm.pos !== void && !ignorePos;
	}

	// レイヤの画像を変形します
	// (指定できる属性)
	// elm.page : 表 or 裏画面（image タグの page 属性と同じ）
	// elm.layer : レイヤの番号（image タグの layer 属性と同じ）
	// elm.x1 : コピー元四角形の左上の点のコピー先レイヤでの x 座標
	// elm.y1 : コピー元四角形の左上の点のコピー先レイヤでの y 座標
	// elm.x2 : コピー元四角形の右上の点のコピー先レイヤでの x 座標
	// elm.y2 : コピー元四角形の右上の点のコピー先レイヤでの y 座標
	// elm.x3 : コピー元四角形の右下の点のコピー先レイヤでの x 座標
	// elm.y3 : コピー元四角形の右下の点のコピー先レイヤでの y 座標
	function transformImage(layer, elm, ignorePos)
	{
		var tmpLayer = new Layer(kag, layer); // 一時レイヤを作ります
		tmpLayer.assignImages(layer); // 一時レイヤに操作対象のレイヤの画像をコピーします

		var x1 = +elm.x1, x2 = +elm.x2, x3 = +elm.x3;
		var y1 = +elm.y1, y2 = +elm.y2, y3 = +elm.y3;
		var left = global.ImageHandlerPlugin.min(x1, x2, x3, x2 - x1 + x3);
		var right = global.ImageHandlerPlugin.max(x1, x2, x3, x2 - x1 + x3);
		var top = global.ImageHandlerPlugin.min(y1, y2, y3, y2 - y1 + y3);
		var bottom = global.ImageHandlerPlugin.max(y1, y2, y3, y2 - y1 + y3);

		// 変形後の画像の幅と高さを計算します
		var width = right - left + 1;
		var height = bottom - top + 1;
		layer.setImageSize(width, height); // 操作対象のレイヤのサイズを変更します
		layer.setSizeToImageSize(); // 操作対象のレイヤのサイズを画像のサイズに合わせます

		// 操作対象のレイヤの中性色を一時的に透明色(0x00000000)に設定します
		var neutralColor = layer.neutralColor;
		layer.neutralColor = 0x00000000;

		// 一時レイヤの画像を変形して操作対象のレイヤにコピーします
		layer.affineCopy(tmpLayer, 0, 0, tmpLayer.imageWidth, tmpLayer.imageHeight, false,
						 x1 - left, y1 - top, x2 - left, y2 - top, x3 - left, y3 - top, stFastLinear, true);

		// 操作対象のレイヤの中性色を元に戻します
		layer.neutralColor = neutralColor;

		invalidate tmpLayer; // 一時レイヤはもう必要ないので無効化します

		// 操作対象のレイヤの位置を調整します
		if(!ignorePos)
		{
			if(elm.pos !== void)
				global.ImageHandlerPlugin.setPosition(layer, elm.pos);
			else
				layer.setPos(left, top);
		}
	}

	// レイヤの画像を回転・拡大・縮小します
	// (指定できる属性)
	// elm.page : 表 or 裏画面（image タグの page 属性と同じ）
	// elm.layer : レイヤの番号（image タグの layer 属性と同じ）
	// elm.scale : 縦・横方向共通拡大率(%)
	// elm.xscale : 横方向拡大率(%)
	// elm.yscale : 縦方向拡大率(%)
	// elm.angle : 回転する角度
	function rotateImage(layer, elm, ignorePos)
	{
		var tmpLayer = new Layer(kag, layer); // 一時レイヤを作ります
		tmpLayer.assignImages(layer); // 一時レイヤに操作対象のレイヤの画像をコピーします

		// アフィン変換のパラメータを計算します ※詳細は割愛します
		var angle = +elm.angle * Math.PI / 180;
		var xscale = (elm.xscale !== void ? +elm.xscale : (elm.scale !== void ? +elm.scale : 100)) / 100;
		var yscale = (elm.yscale !== void ? +elm.yscale : (elm.scale !== void ? +elm.scale : 100)) / 100;
		var sin = Math.sin(angle), cos = Math.cos(angle);
		var xw = xscale * tmpLayer.imageWidth, xh = xscale * tmpLayer.imageHeight;
		var yw = yscale * tmpLayer.imageWidth, yh = yscale * tmpLayer.imageHeight;
		var ofsx, ofsy;
		if(sin >= 0.0)
		{
			if(cos >= 0.0)
			{
				ofsx = yh * sin;
				ofsy = 0.0;
			}
			else
			{
				ofsx = -xw * cos + yh * sin;
				ofsy = -yh * cos;
			}
		}
		else
		{
			if(cos < 0.0)
			{
				ofsx = -xw * cos;
				ofsy = -xw * sin - yh * cos;
			}
			else
			{
				ofsx = 0.0;
				ofsy = -xw * sin;
			}
		}

		var width = (int)(xw * Math.abs(cos) + yh * Math.abs(sin)); // 変換後の幅を計算します
		var height = (int)(xw * Math.abs(sin) + yh * Math.abs(cos)); // 変換後の高さを計算します
		width = 1 if width < 1; // 幅は必ず 1 ピクセル以上になるようにします
		height = 1 if height < 1; // 高さも必ず 1 ピクセル以上になるようにします

		layer.setImageSize(width, height); // 操作対象のレイヤのサイズを変更します
		layer.setSizeToImageSize(); // 操作対象のレイヤのサイズを画像のサイズに合わせます

		// 操作対象のレイヤの中性色を一時的に透明色(0x00000000)に設定します
		var neutralColor = layer.neutralColor;
		layer.neutralColor = 0x00000000;

		// 一時レイヤの画像を回転・拡大・縮小して操作対象のレイヤにコピーします
		layer.affineCopy(tmpLayer, 0, 0, tmpLayer.imageWidth, tmpLayer.imageHeight, true, xscale * cos, xscale * sin, -yscale * sin, yscale * cos, ofsx, ofsy, stFastLinear, true);

		// 操作対象のレイヤの中性色を元に戻します
		layer.neutralColor = neutralColor;

		invalidate tmpLayer; // 一時レイヤはもう必要ないので無効化します

		// pos 属性が指定されている場合は操作対象のレイヤの位置を調整します
		setPosition(layer, elm.pos) if elm.pos !== void && !ignorePos;
	}

	// レイヤの画像をぼかします
	// (指定できる属性)
	// elm.xblur : 横方向のブラーの範囲(ピクセル)
	// elm.yblur : 縦方向のブラーの範囲(ピクセル)
	function boxBlur(layer, elm)
	{
		layer.doBoxBlur(+elm.xblur, +elm.yblur);
	}

	// pos 属性に従ってレイヤの位置を設定します
	function setPosition(layer, pos)
	{
		var left = kag.scPositionX[pos]; // pos 属性の値に相当する画像の水平方向中心位置を取得します
		if(left !== void)
		{
			// pos 属性の値に従って位置を設定します
			layer.setOptions(%["left" => left - layer.width \ 2, "top" => kag.scHeight - layer.height]);
		}
	}

	// 引数に指定されている値のうち最大の値を返します
	function max(value*)
	{
		var maxval = value[0]; // 第１引数を現在の最大値とします
		for(var i=1;i<value.count;i++)
		{
			// 第(i+1)引数の値が現在の最大値(maxval)より大きければ maxval の値を更新します
			if(value[i] > maxval)
				maxval = value[i];
		}
		return maxval; // 引数のうち最大の値を返します
	}

	// 引数に指定されている値のうち最小の値を返します
	function min(value*)
	{
		var minval = value[0]; // 第１引数の値を現在の最小値とします
		for(var i=1;i<value.count;i++)
		{
			// 第(i+1)引数の値が現在の最小値(minval)より小さければ minval の値を更新します
			if(value[i] < minval)
				minval = value[i];
		}
		return minval; // 引数のうち最小の値を返します
	}

	// layer が前景レイヤなら true、それ以外のレイヤなら false を返します
	function isCharacterLayer(layer)
	{
		// 表画面の前景レイヤ配列に layer が含まれているかどうかチェックします
		var index = kag.fore.layers.find(layer);
		if(index != -1)
			return true; // 表画面の前景レイヤ配列の中に該当するレイヤがあれば true を返します

		// 裏画面の前景レイヤ配列に layer が含まれているかどうかチェックします
		index = kag.back.layers.find(layer);
		if(index != -1)
			return true; // 裏画面の前景レイヤ配列の中に該当するレイヤがあれば true を返します

		// 該当するレイヤがなければ前景レイヤではないので false を返します
		return false;
	}

	// 属性値に応じて画像の拡大・縮小・回転・変形・ぼかし処理を行います
	function processImage(elm, layer = void, ignorePos = false)
	{
		// 操作対象のレイヤが指定されていない場合は操作対象のレイヤへの参照を layer に代入します
		if(layer === void)
			layer = kag.getLayerFromElm(elm);

		// layer が前景レイヤでない場合は何もしません
		if(!isCharacterLayer(layer))
			return;

		// layer の情報（画像の元々の幅と高さ）を更新します
		var loadParams = layer.Anim_loadParams;
		loadParams._original = (layer.imageWidth << 31) | (layer.imageHeight & 0x7FFFFFFF);

		var processed = false; // 画像処理が実行された場合 true になります

		// x1, y1, x2, y2, x3, y3 属性が全て指定されていれば画像を変形します
		if(elm.x1 !== void && elm.y1 !== void && elm.x2 !== void && elm.y2 !== void && elm.x3 !== void && elm.y3 !== void)
			transformImage(layer, elm, ignorePos), processed = true;

		// angle 属性が指定されていれば画像を回転します
		if(elm.angle !== void && (int +elm.angle) % 360)
			rotateImage(layer, elm, ignorePos), processed = true;
		// scale, xscale, yscale のいずれかの属性が指定されていれば画像を拡大／縮小します
		else if((elm.scale !== void && +elm.scale != 100) || (elm.xscale !== void && +elm.xscale != 100) || (elm.yscale !== void && +elm.yscale != 100))
			scaleImage(layer, elm, ignorePos), processed = true;

		// xblur 属性と yblur 属性が指定されていれば画像をぼかします
		if(elm.xblur !== void && elm.yblur !== void)
			boxBlur(layer, elm), processed = true;

		if(processed)
		{
			// 画像処理を行った場合は基本的にアニメーション・クリッカブルマップは正しく動作しません
			if(layer.Anim_cellLayer !== void && layer.comp != warn_anim)
			{
				warn(layer, "eximage マクロでアニメーション情報を持つ画像を読み込むと正しく動作しない可能性があります。");
				warn_anim = layer;
			}
			else
				warn_anim = void;
			if(layer.provinceActions !== void && layer.comp != warn_province)
			{
				warn(layer, "eximage マクロで領域アクション定義をもつ画像(クリッカブルマップ)を読み込むと正しく動作しない可能性があります。");
				warn_province = layer;
			}
			else
				warn_province = void;
		}

		// 画像読み込み時のパラメータ整合性チェック用
		loadParams._processed = (layer.imageWidth << 31) | (layer.imageHeight & 0x7FFFFFFF);
		loadParams._scale = elm.scale if elm.scale !== void;
		loadParams._xscale = elm.xscale if elm.xscale !== void;
		loadParams._yscale = elm.yscale if elm.yscale !== void;
		loadParams._angle = elm.angle if elm.angle !== void;
	}

	// eximage マクロで画像が読み込まれているかの判定を行います(詳細は省略します)
	function isConsistent(loadParams, layer, mode)
	{
		if(loadParams === void)
			return false;
		var size = loadParams[mode];
		if(size === void)
			return false;
		var width = size >> 31, height = size & 0x7FFFFFFF;
		if(layer.width != width || layer.imageWidth != width || layer.height != height || layer.imageHeight != height)
		{
			with(loadParams)
			{
				if(.scale === ._scale && .xscale === ._xscale && .yscale === ._yscale && .angle === ._angle)
				{
					warn(layer, "eximage マクロで画像を読み込んだ後に image タグまたは exmove マクロ以外でレイヤの画像を変更すると正しく動作しない可能性があります。", false);
					return false;
				}
			}
		}
		if(layer.Anim_partialImageInfo !== void && layer.comp != warn_partial)
		{
			warn(layer, "eximage マクロで読み込んだ画像に pimage タグで部分画像を読み込んだり ptext タグで文字列を書き込むと正しく動作しない可能性があります。", false);
			warn_partial = layer;
		}
		else
			warn_partial = void;
		return true;
	}

	// eximage マクロでレイヤに画像が読み込まれている場合は画像の幅と高さの情報を修正します
	function modifyFlags(flags, layer)
	{
		if(isConsistent(flags.loadParams, layer, "_processed"))
		{
			var size = flags.loadParams._original;
			flags.width = flags.imageWidth = size >> 31;
			flags.height = flags.imageHeight = size & 0x7FFFFFFF;
		}
	}

	// eximage マクロでレイヤに画像が読み込まれていた場合は画像を復元します
	function restoreImage(loadParams, layer)
	{
		if(isConsistent(loadParams, layer, "_original"))
			processImage(loadParams, layer, true);
	}

	// 警告メッセージを表示します(eximage マクロの使い方に問題があった場合に呼び出されます)
	function warn(layer, message, page = true)
	{
		var index = kag.fore.layers.find(layer);
		if(index != -1)
			message = (page ? "表画面の " : "") + index + " 番のレイヤについて\n" + message;
		else
			message = (page ? "裏画面の " : "") + kag.back.layers.find(layer) + " 番のレイヤについて\n" + message;
		System.inform(message, "警告"); // 警告メッセージボックスを表示する場合
		//dm("警告：" + message); // コンソールに警告メッセージを出力する場合
	}

	function onStore(f, elm)
	{
		// kag オブジェクトが持っている前景レイヤの情報を修正します
		var foreFlags = f.foreCharacterLayers; // 表画面の前景レイヤの情報が記録されている配列
		var backFlags = f.backCharacterLayers; // 裏画面の前景レイヤの情報が記録されている配列
		for(var i=0;i<foreFlags.count;i++)
		{
			// 表画面・裏画面の i 番目のレイヤに eximage マクロで画像が読み込まれている場合は
			// 前景レイヤの情報を修正します
			modifyFlags(foreFlags[i], kag.fore.layers[i]);
			modifyFlags(backFlags[i], kag.back.layers[i]);
		}
	}

	function onRestore(f, clear, elm)
	{
		// セーブ時の前景レイヤの状態を復元します
		var foreFlags = f.foreCharacterLayers;
		var backFlags = f.backCharacterLayers;
		for(var i=0;i<foreFlags.count;i++)
		{
			// 表画面・裏画面の i 番目の前景レイヤに eximage マクロで画像が読み込まれている場合は
			// セーブ時の状態を復元します
			restoreImage(foreFlags[i].loadParams, kag.fore.layers[i]);
			restoreImage(backFlags[i].loadParams, kag.back.layers[i]);
		}
	}
}

kag.addPlugin(global.image_handler_plugin = new ImageHandlerPlugin());

[endscript]

; レイヤに画像を読み込む eximage マクロ(image タグの拡張版)
;
; (属性)
;  scale : 縦・横方向共通拡大率(％)
; xscale : 横方向拡大率(％)
; yscale : 縦方向拡大率(％)
;          ※scale 属性と xscale, yscale 属性が同時に指定されている場合は xscale, yscale 属性が優先されます
;  angle : 回転する角度(°)
;     x1 : コピー元四角形の左上の点のコピー先レイヤでの x 座標(画像を変形する場合に指定)
;     y1 : コピー元四角形の左上の点のコピー先レイヤでの y 座標(画像を変形する場合に指定)
;     x2 : コピー元四角形の右上の点のコピー先レイヤでの x 座標(画像を変形する場合に指定)
;     y2 : コピー元四角形の右上の点のコピー先レイヤでの y 座標(画像を変形する場合に指定)
;     x3 : コピー元四角形の右下の点のコピー先レイヤでの x 座標(画像を変形する場合に指定)
;     y3 : コピー元四角形の右下の点のコピー先レイヤでの y 座標(画像を変形する場合に指定)
;  xblur : 横方向のブラーの範囲(ピクセル)(画像をぼかす場合に指定)
;  yblur : 縦方向のブラーの範囲(ピクセル)(画像をぼかす場合に指定)
;
; これ以外の属性(layer, page, storage 属性など)は image タグと同じように指定します
;
; ただし layer 属性には前景レイヤのみ指定できます
; 前景レイヤ以外のレイヤを指定しても拡張機能は使用できません(eximage マクロの属性指定は無視されます)
;
; また、eximage マクロでアニメーションを持つ画像やクリッカブルマップを読み込んだり、
; eximage マクロで画像を読み込んだレイヤに対して pimage タグで部分画像を読み込んだり、
; ptext タグで文字列を書き込んだりすると
; 正しく動作しない可能性があります(警告メッセージが表示されます)
[macro name=eximage]
[image *]
[eval exp="image_handler_plugin.processImage(mp)"]
[endmacro]

[return]
