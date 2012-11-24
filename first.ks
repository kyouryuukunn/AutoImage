@call storage=AutoImage2.ks
@call storage=eximage2.ks
@call storage=exmove.ks
@laycount layers= 20
@macro name=lr
@l
@r
@endmacro

@AutoImage_Init layer=0
@name name=t0 type='normal' storage=t0
@name name=t0 type='normal2' storage=t0_1
@name name=t0 type='normal3' storage=t0_2
@name name=t0 type='normal'  storage=t0
@name name=t1 type='normal'  storage=t1
@name name=t2 type='normal'  storage=t2
@name name=t3 type='normal'  storage=t3
@name name=t4 type='normal'  storage=t4
@name name=t5 type='normal'  storage=t5
@name name=t6 type='normal'  storage=t6
@name name=t7 type='normal'  storage=t7
@name name=t8 type='normal'  storage=t8
@name name=t9 type='normal'  storage=t9
@name name=t10 type='normal' storage=t10
@name name=t11 type='normal' storage=t11
@name name=t12 type='normal' storage=t12
@name_reg name=t0
@name_reg name=t1
@name_reg name=t2
@name_reg name=t3
@name_reg name=t4
@name_reg name=t5
@name_reg name=t6
@name_reg name=t7
@name_reg name=t8
@name_reg name=t9
@name_reg name=t10
@name_reg name=t11
@name_reg name=t12

*diff1|
差分表示します1[lr]
@t0 normal
@wt
[l]
@t0 normal2
@wt
[l]
@t0 normal3
@wt
[l]
消去します[lr]
@t0 dis
@wt
[l]

*diff2|
差分表示します2[lr]
@t0 normal scale=200
@wt
[l]
@t0 normal2
@wt
[l]
@t0 normal3
@wt
[l]
消去します[lr]
@t0 dis
@wt
[l]

*diff2|
移動しながらトランジション[lr]
@t0 normal scale=200
@wt
@wm
[l]
@t0 normal2 method='mt' path="(0, 0, 255, 200, 0)"
@wt
@wm
[l]
@t0 normal3
@wt
[l]
消去します[lr]
@t0 dis
@wt
[l]

*t|
トランスで表示します[lr]
@t0 pos=c normal
@wt
[l]
@t1 pos=l normal
@wt
[l]
@t2 pos=lc normal
@wt
[l]
@t3 pos=rc normal
@wt
[l]
@t4 method=t pos=r normal
@wt

*tdis|
トランスで消去します[lr]
@t0 dis normal
@wt
[l]
@t1 dis normal
@wt
[l]
@t2 dis normal
@wt
[l]
@t3 dis normal
@wt
[l]
@t4 dis normal
@wt
[l]

*ml|
移動で表示, 消去します1[lr]
@t0 method=m from=l  pos=l normal
@wm
[l]
@t1 method=m from=t  pos=lc normal
@wm
[l]
@t2 method=m from=r pos=c normal
@wm
[l]
@t3 method=m from=b pos=rc normal
@wm
[l]
@t4 method=m from=bl pos=r normal
@wm
[l]

*mdis|
@t0 dis method=m to=l normal
@wm
[l]
@t1 dis method=m to=t normal
@wm
[l]
@t2 dis method=m to=r normal
@wm
[l]
@t3 dis method=m to=b normal
@wm
[l]
@t4 dis  method=m to=bl normal
@wm
[l]

@t5 method=m from=bt pos=l normal
@wm
[l]
@t6 method=m from=br pos=lc normal
@wm
[l]
@t7 method=m from=bb pos=c normal
@wm
[l]

*mdis2|
@t5 dis  method=m to=bt normal
@wm
[l]
@t6 dis  method=m to=br normal
@wm
[l]
@t7 dis  method=m to=bb normal
@wm
[l]

移動で表示します2[lr]
@t0 method=m from=ul  pos=l normal
@wm
[l]
@t1 method=m from=ll  pos=lc normal
@wm
[l]
@t2 method=m from=b pos=c normal
@wm
[l]
@t3 method=m from=ur pos=rc normal
@wm
[l]
@t4 method=m from=lr pos=r normal
@wm
[l]

*mdis3|
移動で消去します2[lr]
@t0 dis method=m to=ul normal
@wm
[l]
@t1 dis method=m to=ll normal
@wm
[l]
@t2 dis method=m to=ur normal
@wm
[l]
@t3 dis method=m to=lr normal
@wm
[l]
@t4 dis  method=m to=b normal
@wm
[l]

*mm|
同時に移動で表示[lr]
@t0 pos=l method=m multi=true from=ul  time=500 normal
@t1 pos=lc method=m multi=true from=ul time=500 normal
@t2 pos=c method=m multi=true from=ul  time=500 normal
@mm
@wmm
同時に移動で消去[lr]
@t0 dis method=m multi=true to=ur time=500 normal
@t1 dis method=m multi=true to=ur time=500 normal
@t2 dis method=m multi=true to=ur time=500 normal
@mm
@wmm
表示と消去を同時に[lr]
@t0 pos=l method=m multi=true from=ul  time=500 normal
@t1 pos=lc method=m multi=true from=ul time=500 normal
@mm
@wmm
[lr]

@t2 pos=c method=m multi=true time=500 from=ll normal
@t3 pos=rc method=m multi=true time=500 from=r normal
@t0 dis method=m multi=true time=500 from=br normal
@t1 dis method=m multi=true time=500 from=ur normal
@mm
@wmm
[lr]

*mt|
同時にトランスで表示[lr]
@t0 pos=l multi=true normal
@t1 pos=lc multi=true normal
@mt
@wmt

同時にトランスで消去[lr]
@t2 dis multi=true normal
@t3 dis multi=true normal
@mt
@wmt

表示と消去を同時に[lr]
@t2 pos=r  multi=true normal
@t3 pos=rc multi=true normal
@t0 dis multi=true normal
@t1 dis multi=true normal
@mt
@wmt

*cac|
一時的に全部消します[lr]
@tempcai
表示します[lr]
@untempcai
全部消します[lr]
@cai
@wmt
[l]

*et|
トランスで回転拡大縮小表示します[lr]
@t0 method=t scale=200 normal
@wt
[l]
@t1 left=400 method=t top=200 scale=50 angle=30 normal
@wt
[l]
同時に表示します[lr]
@t2 multi=true method=t normal
@t3 multi=true method=t left=300 top=20 normal
@mt
@wmt

[l]
@cai
@wmt
[l]
*em|
移動で回転拡大縮小表示します[lr]
@t0 method=m time=1000 path=(300,300,255,200,0) normal
[l]
@t1 method=m left=1 top=1 from=l scale=50 time=1000 normal
[l]
同時に表示します[lr]
@t2 multi=true method=m time=1000 scale=200 normal
@t3 multi=true method=m left=300 top=20 from=b time=1000 scale=40 normal
@mm
@wmm

[l]
移動で回転拡大縮小消去します[lr]
@t0 dis method=m time=1000 to=t normal
[l]
@t1 dis method=m path="(300,200,0,50,0)" time=1000 normal
[l]
同時に消去します[lr]
@t2 dis multi=true method=m time=1000 normal
@t3 dis multi=true method=m path="(800,300,0,30,0)" time=1000 normal
@mm
@wmm
[l]
@AutoImage_reset
