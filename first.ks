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
@name name=t0 type='normal' storage=t0
@name name=t1 type='normal' storage=t1
@name name=t2 type='normal' storage=t2
@name name=t3 type='normal' storage=t3
@name name=t4 type='normal' storage=t4
@name_reg name=t0
@name_reg name=t1
@name_reg name=t2
@name_reg name=t3
@name_reg name=t4

*diff|
�����\�����܂�[lr]
@t0 normal
@wt
[l]
@t0 normal2
@wt
[l]
@t0 normal3
@wt
[l]
�������܂�
@t0 dis
@wt
[l]

*t|
�g�����X�ŕ\�����܂�[lr]
@t0 normal
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

�g�����X�ŏ������܂�[lr]
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

*m|
�ړ��ŕ\�����܂�[lr]
@t0 method=m from=l  pos=l normal
@wm
[l]
@t1 method=m from=t  pos=lc normal
@wm
[l]
@t2 method=m normal
@wm
[l]
@t3 method=m from=bl pos=r normal
@wm
[l]
@t4 method=m from=br pos=rc normal
@wm
[l]

�ړ��ŏ������܂�[lr]
@t0 dis method=m normal
@wm
[l]
@t1 dis method=m to=l normal
@wm
[l]
@t2 dis method=m to=t normal
@wm
[l]
@t3 dis method=m to=br normal
@wm
[l]
@t4 dis  method=m to=bl normal
@wm
[l]

�ړ��ŕ\�����܂�2[lr]
@t0 method=m from=ul  pos=l normal
@wm
[l]
@t1 method=m from=ll  pos=lc normal
@wm
[l]
@t2 method=m from=b normal
@wm
[l]
@t3 method=m from=ur pos=r normal
@wm
[l]
@t4 method=m from=lr pos=rc normal
@wm
[l]

�ړ��ŏ������܂�2[lr]
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
�����Ɉړ��ŕ\��[lr]
@t0 pos=l method=m multi=true from=ul  time=500 normal
@t1 pos=lc method=m multi=true from=ul time=500 normal
@t2 pos=c method=m multi=true from=ul  time=500 normal
@mm
@wmm
�����Ɉړ��ŏ���[lr]
@t0 dis method=m multi=true to=ur time=500 normal
@t1 dis method=m multi=true to=ur time=500 normal
@t2 dis method=m multi=true to=ur time=500 normal
@mm
@wmm
�\���Ə����𓯎���[lr]
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
�����Ƀg�����X�ŕ\��[lr]
@t0 pos=l multi=true normal
@t1 pos=lc multi=true normal
@mt
@wmt

�����Ƀg�����X�ŏ���[lr]
@t2 dis multi=true normal
@t3 dis multi=true normal
@mt
@wmt

�\���Ə����𓯎���[lr]
@t2 pos=r  multi=true normal
@t3 pos=rc multi=true normal
@t0 dis multi=true normal
@t1 dis multi=true normal
@mt
@wmt

*cac|
�ꎞ�I�ɑS�������܂�[lr]
@tempcai
�\�����܂�[lr]
@untempcai
�S�������܂�[lr]
@cai
@wmt
[l]

*et|
�g�����X�ŉ�]�g��k���\�����܂�[lr]
@t0 method=t scale=200 normal
@wt
[l]
@t1 left=400 method=t top=200 scale=50 angle=30 normal
@wt
[l]
�����ɕ\�����܂�[lr]
@t2 multi=true method=t normal
@t3 multi=true method=t left=300 top=20 normal
@mt
@wmt

[l]
@cai
@wmt
[l]
*em|
�ړ��ŉ�]�g��k���\�����܂�[lr]
@t0 method=m time=1000 path=(300,300,255,200,0) normal
[l]
@t1 method=m left=1 top=1 from=l scale=50 time=1000 normal
[l]
�����ɕ\�����܂�[lr]
@t2 multi=true method=m time=1000 scale=200 normal
@t3 multi=true method=m left=300 top=20 from=b time=1000 scale=40 normal
@mm
@wmm

[l]
�ړ��ŉ�]�g��k���������܂�[lr]
@t0 dis method=m time=1000 to=t normal
[l]
@t1 dis method=m path="(300,200,0,50,0)" time=1000 normal
[l]
�����ɏ������܂�[lr]
@t2 dis multi=true method=m time=1000 normal
@t3 dis multi=true method=m path="(800,300,0,30,0)" time=1000 normal
@mm
@wmm
[l]
@AutoImage_reset
