[iscript]

// exmove マクロ (2009/08/25 修正版)

// (注意)
// ・ExtendedMover クラスは内部で ImageHandlerPlugin クラスのメソッドを呼び出しているので
// 　使用するときは必ず ImageHandlerPlugin クラスの定義(eximage.ks)を読み込んでください
// ・KAG3 version 3.26 (吉里吉里２ version 2.26) 以降の環境で使用してください

// move タグを拡張するためのクラス
class ExtendedMover
{
	var layer; // 操作対象のレイヤへの参照
	var refLayer; // 一時レイヤ
	var currentScale; // 現在の拡大率(%)
	var currentAngle; // 現在の回転角(°)
	var _path = [], pathex = []; // 移動位置・不透明度の変化, 拡大率・回転角の変化
	var _time; // １区間あたりの移動時間(ms)
	var centerX, centerY; // 拡大・縮小・回転の中心位置
	var moveFunc; // 画像を拡大・縮小・回転するためのメソッド(rotate or resize)
	var rect = %[]; // クリッピングのための矩形情報
	var prevClip = true; // 前回のハンドラ呼び出しでクリッピングしたか
	var prevOX, prevOY; // 前回のハンドラ呼び出し時の(DefaultMoverにより設定された)レイヤの座標
	var prevX, prevY; // 前回のハンドラ呼び出し時の(ExtendedMoverにより設定された)レイヤの座標
	var scaleX, scaleY; // X, Y 方向初期拡大率
	var transformParams; // 初期状態での(x1, y1, x2, y2, x3, y3 属性指定による)アフィン変換パラメータ
	var regInit = new RegExp("[@]", "g"); // path 属性に @ (初期値)を指定可能にするための正規表現オブジェクト
	var regPrev = new RegExp("[$]", "g"); // path 属性に $ (前区間での値)を指定可能にするための正規表現オブジェクト
	// 以下アフィン変換に使用する変数・定数
	var r, theta;
	var rotateParams = %[];
	var radConst = Math.PI / 180;

	// コンストラクタ
	function ExtendedMover(layer, elm)
	{
		// 引数をメンバ変数に保存しておきます
		this.layer = layer;
		// time 属性に指定されている値を保存しておきます
		_time = +elm.time;
		// layer に画像が読み込まれた時に指定されていた属性値を取得します
		var loadParams = getLoadParams(layer);
		if(loadParams !== void) // レイヤに画像が読み込まれていれば以下のブロックを実行します
		{
			//  eximage マクロで x1, y1, x2, y2, x3, y3 属性を指定して
			// 画像が読み込まれている場合は各属性値を保存しておきます
			with(loadParams)
			{
				if(.x1 !== void && .y1 !== void && .x2 !== void && .y2 !== void && .x3 !== void && .y3 !== void)
					transformParams = %["x1" => +.x1, "y1" => +.y1, "x2" => +.x2, "y2" => +.y2, "x3" => +.x3, "y3" => +.y3];
			}
		}
		// path 属性を解析します
		// また、(必要なら)一時レイヤ等を作成します
		parsePath(elm, loadParams);
		// 現在の拡大率・回転角を初期拡大率・初期回転角とします
		currentScale = pathex[0];
		currentAngle = pathex[1];
	}

	// デストラクタ
	function finalize()
	{
		// レイヤの移動を止めます
		stopMove();
		// 一時レイヤを使っていれば無効化します
		invalidate refLayer if refLayer !== void;
	}

	// path 属性を解析します
	function parsePath(elm, loadParams = %[])
	{
		// pathex[0], pathex[2], pathex[4], ... : 初期拡大率, 1区間目移動後の拡大率, 2区間目移動後の拡大率, ...
		// pathex[1], pathex[3], pathex[5], ... : 初期回転角, 1区間目移動後の回転角, 2区間目移動後の回転角, ...
		scaleX = loadParams.xscale !== void ? +loadParams.xscale : (loadParams.scale !== void ? +loadParams.scale : 100);
		scaleY = loadParams.yscale !== void ? +loadParams.yscale : (loadParams.scale !== void ? +loadParams.scale : 100);
		pathex[0] = scaleX == scaleY ? scaleX : int Math.sqrt(scaleX * scaleY); // 初期拡大率
		pathex[1] = loadParams.angle !== void ? (int +loadParams.angle) : 0; // 初期回転角

		// 区間ごとに path を分解し、pathex に拡大率・回転角の値を代入していきます
		var paths = [].split("()", elm.path, , true);
		var args = [], a, i = 0, n;
		while(i < paths.count)
		{
			if((paths[i] = paths[i].trim()) == "")
				paths.erase(i);
			else
				i++;
		}
		var initScale = pathex[0], initAngle = pathex[1];
		for(i=0,n=2;i<paths.count;i++,n+=2)
		{
			args.add(a = [].split(",", paths[i], , false));
			pathex[n] = getPathValue(a[3], initScale, pathex[n-2]);
			pathex[n+1] = getPathValue(a[4], initAngle, pathex[n-1]);
		}

		// path[0], path[3], path[6], ... : 初期 left, 1区間目移動後の left, 2区間目移動後の left, ...
		// path[1], path[4], path[7], ... : 初期 top, 1区間目移動後の top, 2区間目移動後の top, ...
		// path[2], path[5], path[8], ... : 初期 opacity, 1区間目移動後の opacity, 2区間目移動後の opacity, ...
		var path = _path;
		path[0] = layer.left; // 初期 left
		path[1] = layer.top; // 初期 top
		path[2] = layer.opacity; // 初期 opacity
		for(var i=2;i<pathex.count;i+=2)
		{
			if(pathex[i+1] != initAngle)
			{
				moveFunc = rotate; // 回転する場合は rotate メソッドを使用します
				break;
			}
			if(pathex[i] != initScale)
			{
				if(initAngle != 0)
				{
					moveFunc = rotate; // 回転しない場合でも初期回転角が 0°でなければ回転するものとみなして rotate メソッドを使用します
					break;
				}
				moveFunc = resize; // 拡大・縮小はするが回転しない場合は resize メソッドを使用します
			}
		}
		if(moveFunc !== void && loadParams.storage !== void) // 拡大・縮小・回転する場合は以下のブロックを実行します
		{
			// 一時レイヤを作成して元々の画像を読み込みます
			refLayer = new Layer(layer.window, layer);
			refLayer.loadImages(loadParams.storage);
			if(transformParams !== void)
			{
				// x1, y1, x2, y2, x3, y3 属性を指定してアフィン変換が行われている場合は
				// ImageHandlerPlugin クラスの transformImage メソッドを使って一時レイヤを変形します
				ImageHandlerPlugin.transformImage(refLayer, transformParams, true);
			}
			if(scaleX != scaleY)
			{
				// ExtendedMover クラスでは X 方向 Y 方向別々の拡大率での拡大・縮小をサポートしていないため
				// 初期状態で X 方向と Y 方向の拡大率が異なっている場合(xscale 属性と yscale 属性に
				// 異なる値を指定して eximage マクロで画像を読み込んだ状態で exmove マクロを実行した場合等)には
				// X 方向と Y 方向の拡大率の比を保った状態で画像を拡大・縮小します
				// そのためにここで一時レイヤの X 方向と Y 方向の拡大率を変更しています
				var ratio = Math.sqrt(scaleX / scaleY);
				var tmpLayer = new Layer(refLayer.window, refLayer);
				tmpLayer.setImageSize(int Math.round(refLayer.imageWidth * ratio), int Math.round(refLayer.imageHeight / ratio));
				tmpLayer.stretchCopy(0, 0, tmpLayer.imageWidth, tmpLayer.imageHeight, refLayer, 0, 0, refLayer.imageWidth, refLayer.imageHeight, stFastLinear);
				refLayer.assignImages(tmpLayer);
				invalidate tmpLayer;
			}
			// 拡大・縮小・回転の中心座標を計算します
			var sc = pathex[0] / 100;
			var centerPos = getCenterPos(elm, refLayer, sc);
			centerX = centerPos.cx;
			centerY = centerPos.cy;
			// 画像の位置調整に必要な値を計算します
			r = Math.sqrt(centerX * centerX + centerY * centerY);
			theta = ((centerX != 0. || centerY != 0.) ? Math.atan2(centerY, centerX) : 0.);
			// path の初期位置を調整します(path はレイヤの左上の座標ではなく拡大・縮小・回転の中心座標を表すので)
			var params = %[];
			calcRotateParams(params, refLayer, pathex[1] * radConst, pathex[0] / 100);
			var angle = pathex[1] * radConst;
			sc *= r;
			path[0] += params.ofsX + sc * Math.cos(theta + angle);
			path[1] += params.ofsY + sc * Math.sin(theta + angle);
		}

		// path の値を設定していきます
		var initLeft = path[0], initTop = path[1], initOpacity  = path[2];
		for(i=0,n=3;i<paths.count;i++,n+=3)
		{
			a = args[i];
			path[n] = getPathValue(a[0], initLeft, path[n-3]);
			path[n+1] = getPathValue(a[1], initTop, path[n-2]);
			path[n+2] = getPathValue(a[2], initOpacity, path[n-1]);
		}
	}

	// path 属性の各区間に指定されている値を返します
	function getPathValue(val, init, prev)
	{
		if(val == "")
			return prev; // 何も指定されていない(値が省略されている)場合は前区間の値を返します
		try
		{
			// @ は初期値(init), $ は前区間での値(prev)に置き換えた後全体を TJS 式として評価した値を返します
			val = Scripts.eval(val.replace(regInit, string init).replace(regPrev, string prev));
		}
		catch(e)
		{
			// path 属性解析中に例外が発生した場合は詳細を表示します
			System.inform("exmove マクロの path 属性解析中にエラーが発生しました。\n"
			"ファイル：" + kag.conductor.curStorage + "\n"
			"　　位置：" + kag.conductor.curLine + "行目付近\n"
			"　　要素：" + val + "\n"
			"　　内容：" + e.message);
			throw e;	// 後の処理は KAG システムにお任せします
		}
		return val;
	}

	// layer に画像が読み込まれた時
	// image タグ(または eximage タグ)に指定されていた属性値を取得します
	function getLoadParams(layer)
	{
		// layer が表画面 or 裏画面の前景レイヤなら
		// 当該レイヤの Anim_loadParams を返します
		var index = kag.fore.layers.find(layer);
		if(index != -1)
			return kag.fore.layers[index].Anim_loadParams;
		index = kag.back.layers.find(layer);
		if(index != -1)
			return kag.back.layers[index].Anim_loadParams;
		// layer が前景レイヤでなければ void を返します
		return void;
	}

	// レイヤの移動を停止します
	function stopMove()
	{
		// 一時レイヤが使われていれば(＝拡大・縮小・回転が行われていれば)
		// 画像を最終倍率・最終回転角に拡大・縮小・回転します
		if(refLayer !== void && refLayer isvalid)
		{
			var finalScale = pathex[-2]; // 最終拡大率
			var finalAngle = (int pathex[-1]) % 360; // 最終回転角(-359°～359°の範囲になるように調整します)
			var fs = finalScale / 100;
			var fa = finalAngle * radConst;
			calcRotateParams(rotateParams, refLayer, fa, fs); // アフィン変換のパラメータを計算します
			if(finalAngle != 0)
			{
				// 最終回転角が 0°でない場合はアフィン変換します
				calcRotateParams(rotateParams, refLayer, fa, fs); // アフィン変換のパラメータを計算します
				rotateImage(stFastLinear, false); // 移動が終わったのでクリッピングなし＆線形補間でアフィン変換します
			}
			else if(finalScale != 100)
			{
				// 最終拡大率が 100% (等倍)でない場合は拡大・縮小します
				scaleImage(fs, stFastLinear, false); // 移動が終わったのでクリッピングなし＆線形補間で拡大・縮小します
			}
			else
			{
				// 最終的に拡大・縮小・回転していない状態になる場合は
				// 一時レイヤの画像(＝元々の画像)をコピーします
				layer.assignImages(refLayer);
				layer.setSizeToImageSize();
			}
			layer.setPos(layer.left - rotateParams.dspX, layer.top - rotateParams.dspY); // 位置調整します
			// 移動後の画像が拡大・縮小・回転していてもロード時に復元できるように
			// Anim_loadParams に scale 属性(または xscale, yscale 属性)と angle 属性の値を
			// 書き込みます(書き込んだ値は ImageHandlerPlugin クラス(eximage マクロ)で使用します)
			if(layer.Anim_loadParams !== void)
			{
				if(scaleX == scaleY)
				{
					// X 方向と Y 方向の初期拡大率が等しい場合は scale を設定します
					layer.Anim_loadParams.scale = finalScale != 100 ? finalScale : void;
				}
				else
				{
					// X 方向と Y 方向の初期拡大率が異なっていた場合には xscale, yscale をそれぞれ設定します
					var ratio = Math.sqrt(scaleX / scaleY);
					layer.Anim_loadParams.xscale = int Math.round(finalScale * ratio);
					layer.Anim_loadParams.yscale = int Math.round(finalScale / ratio);
				}
				layer.Anim_loadParams.angle = finalAngle != 0 ? finalAngle : void;
			}
		}
	}

	// コンティニュアスハンドラから呼び出されるメソッド
	function move(tickCount)
	{
		// 一時レイヤがある場合は拡大・縮小・回転処理します
		if(refLayer !== void && refLayer isvalid)
		{
			var index = tickCount \ time * 2; // 現在の区間を計算します
			var ratio = tickCount % time / time; // 現在の区間内の位置を計算します
			var ss = pathex[index]; // 現在の区間での初期拡大率
			var sa = pathex[index+1]; // 現在の区間での初期回転角
			var es = pathex[index+2]; // 現在の区間での最終拡大率
			var ea = pathex[index+3]; // 現在の区間での最終回転角

			// 線形補間法で現在の拡大率(scale)と回転角(angle)を計算します
			var scale = int(real(es - ss) * ratio + real ss);
			var angle = int(real(ea - sa) * ratio + real sa);

			// 画像を拡大・縮小・回転します
			moveFunc(angle, scale);

			// 現在の拡大率と回転角の値を更新します
			currentScale = scale;
			currentAngle = angle;
		}
	}

	// 画像を拡大・縮小するためにコンティニュアスハンドラから呼び出されるメソッド
	function resize(angle, scale)
	{
		var left = layer.left, top = layer.top;
		if(scale == currentScale && left === prevOX && top === prevOY)
		{
			// 前回呼び出された時から拡大率・回転角・位置が変わっていない場合は
			// 前回呼び出された時の位置にレイヤを移動します
			layer.setPos(prevX, prevY);
			return;
		}
		do
		{
			// 表示位置調整のためにパラメータを計算します
			calcRotateParams(rotateParams, refLayer, 0., scale / 100);
			// レイヤの位置を調整します
			layer.setPos(layer.left - rotateParams.dspX, layer.top - rotateParams.dspY);

			if(scale == 100)
			{
				// 拡大率が 100% の場合は一時レイヤの画像をコピーします
				layer.assignImages(refLayer);
				layer.setSizeToImageSize();
				prevClip = false;
				break;
			}
			// 拡大・縮小後のレイヤと画面の矩形の共通領域を計算します
			if(intersectRect(rect, layer, rotateParams.width, rotateParams.height))
			{
				if(!rect.clip && scale == currentScale && !prevClip)
				{
					// 上記の条件が成立した場合はレイヤの位置を移動するだけでOK
					layer.setPos(layer.left + left - prevOX, layer.top + top - prevOY);
				}
				else
				{
					// 画像を拡大・縮小します
					scaleImage(scale / 100);
					prevClip = rect.clip;
				}
			}
			else
			{
				// 共通領域がない場合はレイヤを画面外に出します(見えないようにします)
				// レイヤは見えないので拡大・縮小・回転する(funcを呼び出す)必要はありません
				layer.left = -layer.width;
				prevClip = true;
			}
		}while(false);
		prevX = layer.left;
		prevY = layer.top;
		prevOX = left;
		prevOY = top;
	}

	// 画像を拡大・縮小します
	function scaleImage(scale, type = stNearest, clip = true)
	{
		var width = int(refLayer.imageWidth * scale); // 拡大・縮小後の幅を計算します
		var height = int(refLayer.imageHeight * scale); // 拡大・縮小後の高さを計算します
		width = 1 if width < 1; // 幅は必ず 1 ピクセル以上になるようにします
		height = 1 if height < 1; // 高さも必ず 1 ピクセル以上になるようにします

		var sleft, stop, swidth, sheight;
		do
		{
			if(clip)
			{
				if(layer.left != rect.left || layer.top != rect.top)
				{
					// クリッピングする必要がある場合はレイヤの位置調整等を行います
					if(scale != 0.)
					{
						sleft = layer.left < 0 ? int(-layer.left / scale) : 0;
						swidth = int(rect.width / scale);
						stop = layer.top < 0 ? int(-layer.top / scale) : 0;
						sheight = int(rect.height / scale);
					}
					else
					{
						sleft = stop = 0;
						swidth = sheight = 1;
					}
					width = rect.width;
					height = rect.height;
					layer.setPos(rect.left, rect.top);
					break;
				}
			}
			// クリッピングしない(or する必要がない)場合は普通に画像を拡大・縮小します
			sleft = stop = 0;
			swidth = refLayer.imageWidth;
			sheight = refLayer.imageHeight;
		}while(false);

		layer.setImageSize(width, height); // レイヤのサイズを変更します
		layer.setSizeToImageSize(); // レイヤのサイズを画像のサイズに合わせます

		// 一時レイヤの画像を拡大・縮小コピーします
		layer.stretchCopy(0, 0, width, height, refLayer, sleft, stop, swidth, sheight, type);
	}

	// 画像を拡大・縮小・回転するためにコンティニュアスハンドラから呼び出されるメソッド
	function rotate(angle, scale)
	{
		var func, arg;
		var left = layer.left, top = layer.top;
		if(angle == currentAngle && scale == currentScale && left === prevOX && top === prevOY)
		{
			// 前回呼び出された時から拡大率・回転角・位置が変わっていない場合は
			// 前回呼び出された時の位置にレイヤを移動します
			layer.setPos(prevX, prevY);
			return;
		}
		do
		{
			// アフィン変換のパラメータを計算します
			calcRotateParams(rotateParams, refLayer, angle * radConst, scale / 100);
			// レイヤの位置を調整します
			layer.setPos(layer.left - rotateParams.dspX, layer.top - rotateParams.dspY);

			if(angle != 0)
			{
				// 回転角が 0°でなければアフィン変換します
				func = rotateImage;
			}
			else if(scale != 100)
			{
				// 回転角が 0°で拡大率が 100% (等倍)でなければ拡大・縮小します
				arg = scale / 100;
				func = scaleImage;
			}
			else
			{
				// 回転角が 0°で拡大率が 100% の場合は一時レイヤの画像をコピーします
				layer.assignImages(refLayer);
				layer.setSizeToImageSize();
				prevClip = false;
				break;
			}
			// 拡大・縮小・回転後のレイヤと画面の矩形の共通領域を計算します
			if(intersectRect(rect, layer, rotateParams.width, rotateParams.height))
			{
				if(!rect.clip && angle == currentAngle && scale == currentScale && !prevClip)
				{
					// 上記の条件が成立した場合はレイヤの位置を移動するだけでOK
					layer.setPos(layer.left + left - prevOX, layer.top + top - prevOY);
				}
				else
				{
					// 画像を拡大・縮小・回転します
					func(arg);
					prevClip = rect.clip;
				}
			}
			else
			{
				// 共通領域がない場合はレイヤを画面外に出します(見えないようにします)
				// レイヤは見えないので拡大・縮小・回転する(funcを呼び出す)必要はありません
				layer.left = -layer.width;
				prevClip = true;
			}
		}while(false);
		prevX = layer.left;
		prevY = layer.top;
		prevOX = left;
		prevOY = top;
	}

	// 画像を拡大・縮小・回転します
	function rotateImage(type = stNearest, clip = true)
	{
		var width, height;
		if(clip)
		{
			if(layer.left != rect.left || layer.top != rect.top)
			{
				// クリッピングする必要がある場合はレイヤの位置調整等を行います
				rotateParams.ofsX += layer.left if layer.left < 0;
				rotateParams.ofsY += layer.top if layer.top < 0;
				layer.setPos(rect.left, rect.top);
			}
			// 共通領域の幅と高さがレイヤの幅と高さになります
			width = rect.width;
			height = rect.height;
		}
		else
		{
			// クリッピングしない場合は rotateParams の width, height がレイヤの幅と高さになります
			width = rotateParams.width;
			height = rotateParams.height;
		}

		layer.setImageSize(width, height); // レイヤのサイズを変更します
		layer.setSizeToImageSize(); // レイヤのサイズを画像のサイズに合わせます

		// 操作対象のレイヤの中性色を一時的に透明色(0x00000000)に設定します
		var neutralColor = layer.neutralColor;
		layer.neutralColor = 0x00000000;

		// 一時レイヤの画像を拡大・縮小・回転コピー(アフィン変換)します
		with(rotateParams)
		{
			layer.affineCopy(refLayer, 0, 0, refLayer.imageWidth, refLayer.imageHeight, true,
			                 .scos, .ssin, -.ssin, .scos, .ofsX, .ofsY, type, true);
		}

		// 操作対象のレイヤの中性色を元に戻します
		layer.neutralColor = neutralColor;
	}

	// アフィン変換のパラメータを計算します(詳細は割愛します)
	function calcRotateParams(params, layer, angle, scale)
	{
		var sin = Math.sin(angle), cos = Math.cos(angle);
		var xw = scale * layer.imageWidth;
		var yh = scale * layer.imageHeight;
		if(sin >= 0.)
		{
			if(cos >= 0.)
			{
				params.ofsX = yh * sin;
				params.ofsY = 0.;
			}
			else
			{
				params.ofsX = -xw * cos + yh * sin;
				params.ofsY = -yh * cos;
			}
		}
		else
		{
			if(cos < 0.)
			{
				params.ofsX = -xw * cos;
				params.ofsY = -xw * sin - yh * cos;
			}
			else
			{
				params.ofsX = 0.;
				params.ofsY = -xw * sin;
			}
		}

		with(params)
		{
			.ssin = scale * sin;
			.scos = scale * cos;
			var as = Math.abs(sin), ac = Math.abs(cos);
			.width = int Math.round(xw * ac + yh * as);
			.height = int Math.round(xw * as + yh * ac);
			.width = 1 if .width < 1;
			.height = 1 if .height < 1;
			var rs = r * scale;
			.dspX = int Math.round(.ofsX + rs * Math.cos(theta + angle));
			.dspY = int Math.round(.ofsY + rs * Math.sin(theta + angle));
		}
	}

	// 以下２つのメソッドで cx, cy 属性をチェックして拡大・縮小・回転の中心点を取得します
	function getCenterPos(elm, layer, mag)
	{
		var centerPos = %[];
		centerPos.cx = internalGetCenterPos(elm.cx, layer.imageWidth, mag); // cx 属性の値をチェックします
		centerPos.cy = internalGetCenterPos(elm.cy, layer.imageHeight, mag); // cy 属性の値をチェックします
		return centerPos;
	}
	function internalGetCenterPos(val, length, mag)
	{
		if(val !== void)
		{
			if(val.charAt(val.length - 1) == '%') // パーセント表記の場合は以下の式で中心点の座標を計算します
				return length * +val.substring(0, val.length - 1) / 100;
			return real +val / mag;
		}
		return length * .5; // 値が省略されている場合は 50% とみなします
	}

	// left, top, width, height で表される矩形領域と画面(ウィンドウ内の描画可能領域)の
	// 共通部分を計算して rect に共通部分の矩形情報を格納します
	// 共通部分があれば true, なければ false を返します
	function intersectRect(rect, layer, width, height)
	{
		var left = layer.left, top = layer.top;
		var l = left > 0 ? left : 0;
		var r = left + width;
		r = kag.scWidth if r > kag.scWidth;
		var t = top > 0 ? top : 0;
		var b = top + height;
		b = kag.scHeight if b > kag.scHeight;
		if(l >= r || t >= b)
			return false;
		rect.left = l;
		rect.top = t;
		rect.width = r - l;
		rect.height = b - t;
		rect.clip = rect.left != left || rect.top != top || rect.width != layer.width || rect.height != layer.height;
		return true;
	}

	// レイヤの移動を開始します
	function beginMove(elm)
	// このメソッドは KAGLayer クラスの beginMove メソッドの定義に依存した構造になっているので
	// KAG のバージョンが変わると書き換えないといけなくなるかも...
	{
		// exmove マクロに指定されている layer, page 属性からレイヤへの参照を取得します
		var layer = kag.getLayerFromElm(elm);

		// レイヤの移動を停止します
		layer.stopMove();

		// 移動用オブジェクトを作成します
		if(elm.spline !== void && +elm.spline)
		{
			// スプライン補間の場合は SplineMoverEx クラスのオブジェクトを作成します
			layer.moveObject = new SplineMoverEx(layer, elm, layer.moveFinalFunction);
		}
		else
		{
			// 線形補間の場合は LinearMoverEx クラスのオブジェクトを作成します
			layer.moveObject = new LinearMoverEx(layer, elm, layer.moveFinalFunction);
		}
		layer.window.moveCount++; // 動いているレイヤの数を１つ増やします(この値は kag オブジェクトがレイヤの移動を管理するために使用します)
		layer.moveObject.startMove(+elm.delay); // レイヤの移動を開始します
	}
}

// レイヤの線形移動を行うクラス(LinearMover クラス)の拡張版
class LinearMoverEx extends LinearMover, ExtendedMover
{
	var stopped = false; // レイヤの移動が既に停止しているか

	// コンストラクタ
	function LinearMoverEx(layer, elm, finalfunction)
	{
		// 各スーパークラス(ExtendedMover, LinearMover クラス)のコンストラクタを呼び出します
		ExtendedMover(layer, elm);
		LinearMover(layer, _path, _time, elm.accel !== void ? +elm.accel : 0, finalfunction);
	}

	// デストラクタ
	function finalize()
	{
		// 各スーパークラスのデストラクタを呼び出します
		global.LinearMover.finalize();
		global.ExtendedMover.finalize();
	}

	// レイヤの移動を停止します
	function stopMove()
	{
		if(moving)
		{
			// レイヤが移動している場合は各スーパークラスの stopMove メソッドを呼び出します
			global.LinearMover.stopMove();
			global.ExtendedMover.stopMove();
		}
	}

	// コンティニュアスハンドラ(handler メソッド)から呼び出されるメソッド
	function move(tickCount)
	{
		// 各スーパークラスの move メソッドを呼び出します
		global.LinearMover.move(...); // 位置と不透明度を設定します
		global.ExtendedMover.move(...); // 拡大・縮小・回転を行います
	}

	// コンティニュアスハンドラ(LinearMover クラスの handler メソッドをオーバーライド)
	function handler(tickCount)
	{
		try
		{
			global.LinearMover.handler(...);
			// レイヤの移動が停止する直前に一瞬レイヤが変な位置に表示されるのを防ぐスクリプト
			if(nextStop && !stopped)
			{
				global.ExtendedMover.move(totalTime);
				stopped = true;
			}
		}
		catch(e)
		{
			stopMove(); // 例外が発生したら移動を停止します
			throw e; // 後は吉里吉里システムにお任せします
		}
	}
}

// スプライン補間を使用したレイヤの移動を行うクラス(SplineMover クラス)の拡張版
// スプライン補間はレイヤの位置のみに適用します(拡大率・回転角はスプライン補間しません)ので
// LinearMoverEx クラスと中身はほとんど同じです
class SplineMoverEx extends SplineMover, ExtendedMover
{
	var stopped = false;

	function SplineMoverEx(layer, elm, finalfunction)
	{
		ExtendedMover(layer, elm);
		SplineMover(layer, _path, _time, elm.accel !== void ? +elm.accel : 0, finalfunction);
	}

	function finalize()
	{
		global.SplineMover.finalize();
		global.ExtendedMover.finalize();
	}

	function stopMove()
	{
		if(moving)
		{
			global.SplineMover.stopMove();
			global.ExtendedMover.stopMove();
		}
	}

	function move(tickCount)
	{
		global.SplineMover.move(...);
		global.ExtendedMover.move(...);
	}

	function handler(tickCount)
	{
		try
		{
			global.SplineMover.handler(...);
			if(nextStop && !stopped)
			{
				global.ExtendedMover.move(totalTime);
				stopped = true;
			}
		}
		catch(e)
		{
			stopMove();
			throw e;
		}
	}
}

[endscript]

; レイヤの移動を開始する exmove マクロ
;
; (属性)
; path : レイヤの位置・不透明度・拡大率・回転角の変化(省略不可)
; cx : 拡大・縮小・回転の x 方向中心位置(省略可：デフォルトは 50%)
; cy : 拡大・縮小・回転の y 方向中心位置(省略可：デフォルトは 50%)
;
; これ以外の属性(layer, page, spline, time, delay, accel 属性)は move タグと同じように指定します
;
; ただし layer 属性には前景レイヤのみ指定できます
; 前景レイヤ以外のレイヤを指定しても拡大・縮小・回転しません(位置と不透明度のみ変化します)
;
; また spline 属性を true にしてもスプライン補間の対象となるのはレイヤの位置(left, top)変化のみであり
; 拡大率・回転角の変化にスプライン補間は適用されません(常に線形補間が使われます)
; 不透明度(opacity)の変化には元々(move タグでも)スプライン補間は適用されません
;
; 移動を待つ時には wm タグ、移動を止める時には stopmove タグを使います
;
; exmove マクロでレイヤの拡大率や回転角が変更されると変更内容がセーブデータに記録されますので
; セーブデータ読み込み時に exmove マクロ実行後の状態を復元できます
;
[macro name=exmove]
[eval exp="ExtendedMover.beginMove(mp)"]
[endmacro]

[return]
