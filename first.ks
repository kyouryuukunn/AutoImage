@call storage=AutoImage2.ks
@call storage=eximage2.ks
@call storage=exmove.ks
@laycount layers= 20
@macro name=lr
@l
@r
@endmacro

@AutoImage_Init layer=0
@AutoImage_name name=t0 type='smile' storage=t0
@AutoImage_name name=t0 type='cry'   storage=t0_1
@AutoImage_name name=t0 type='surprise' storage=t0_2
@AutoImage_name name=t1 type='smile'  storage=t1
@AutoImage_name name=t2 type='smile'  storage=t2
@AutoImage_name name=t3 type='smile'  storage=t3
@AutoImage_name name=t4 type='smile'  storage=t4
@AutoImage_name name=t5 type='smile'  storage=t5
@AutoImage_name name=t6 type='smile'  storage=t6
@AutoImage_name name=t7 type='smile'  storage=t7
@AutoImage_name_reg name=t0
@AutoImage_name_reg name=t1
@AutoImage_name_reg name=t2
@AutoImage_name_reg name=t3
@AutoImage_name_reg name=t4
@AutoImage_name_reg name=t5
@AutoImage_name_reg name=t6
@AutoImage_name_reg name=t7

*pos|
�����Ń|�W�V���������߂܂��B[lr]
@t0 smile
@wt
[l]
@t1 smile
@wt
[l]
@t2 smile
@wt
[l]
@t3 smile
@wt
[l]
@t4 smile
@wt

�������܂�[lr]
@t0 dis
@wt
[l]
@t1 dis
@wt
[l]
@t2 dis
@wt
[l]
@t3 dis
@wt
[l]
@t4 dis
@wt
[l]

*diff1|
�����\�����܂�1[lr]
@t0 smile
@wt
[l]
@t0 cry
@wt
[l]
@t0 surprise
@wt
[l]
�������܂�[lr]
@t0 dis
@wt
[l]

*diff2|
�����\�����܂�2[lr]
@t0 smile scale=200
@wt
[l]
@t0 cry
@wt
[l]
@t0 surprise
@wt
[l]
�������܂�[lr]
@t0 dis
@wt
[l]

*diff2|
�ړ����Ȃ���g�����W�V����[lr]
@t0 smile scale=200
@wt
@wm
[l]
@t0 cry method='mt' path="(0, 0, 255, 200, 0)"
@wt
@wm
[l]
@t0 surprise
@wt
[l]
�������܂�[lr]
@t0 dis
@wt
[l]

*t|
�g�����X�ŕ\�����܂�[lr]
@t0 pos=c smile
@wt
[l]
@t1 pos=l smile
@wt
[l]
@t2 pos=lc smile
@wt
[l]
@t3 pos=rc smile
@wt
[l]
@t4 method=t pos=r smile
@wt

*tdis|
�g�����X�ŏ������܂�[lr]
@t0 dis
@wt
[l]
@t1 dis
@wt
[l]
@t2 dis
@wt
[l]
@t3 dis
@wt
[l]
@t4 dis
@wt
[l]

*ml|
�ړ��ŕ\��, �������܂�1[lr]
@t0 method=m from=l  pos=l smile
@wm
[l]
@t1 method=m from=t  pos=lc smile
@wm
[l]
@t2 method=m from=r pos=c smile
@wm
[l]
@t3 method=m from=b pos=rc smile
@wm
[l]
@t4 method=m from=bl pos=r smile
@wm
[l]

*mdis|
@t0 dis method=m to=l
@wm
[l]
@t1 dis method=m to=t
@wm
[l]
@t2 dis method=m to=r
@wm
[l]
@t3 dis method=m to=b
@wm
[l]
@t4 dis  method=m to=bl
@wm
[l]

@t5 method=m from=bt pos=l smile
@wm
[l]
@t6 method=m from=br pos=lc smile
@wm
[l]
@t7 method=m from=bb pos=c smile
@wm
[l]

*mdis2|
@t5 dis  method=m to=bt
@wm
[l]
@t6 dis  method=m to=br
@wm
[l]
@t7 dis  method=m to=bb
@wm
[l]

�ړ��ŕ\�����܂�2[lr]
@t0 method=m from=ul  pos=l smile
@wm
[l]
@t1 method=m from=ll  pos=lc smile
@wm
[l]
@t2 method=m from=b pos=c smile
@wm
[l]
@t3 method=m from=ur pos=rc smile
@wm
[l]
@t4 method=m from=lr pos=r smile
@wm
[l]

*mdis3|
�ړ��ŏ������܂�2[lr]
@t0 dis method=m to=ul
@wm
[l]
@t1 dis method=m to=ll
@wm
[l]
@t2 dis method=m to=ur
@wm
[l]
@t3 dis method=m to=lr
@wm
[l]
@t4 dis  method=m to=b
@wm
[l]

*mm|
�����Ɉړ��ŕ\��[lr]
@t0 pos=l method=m multi=true from=ul  time=500 smile
@t1 pos=lc method=m multi=true from=ul time=500 smile
@t2 pos=c method=m multi=true from=ul  time=500 smile
@AutoImage_mm
@AutoImage_wmm
�����Ɉړ��ŏ���[lr]
@t0 dis method=m multi=true to=ur time=500
@t1 dis method=m multi=true to=ur time=500 
@t2 dis method=m multi=true to=ur time=500 
@AutoImage_mm
@AutoImage_wmm
�\���Ə����𓯎���[lr]
@t0 pos=l method=m multi=true from=ul  time=500 smile
@t1 pos=lc method=m multi=true from=ul time=500 smile
@AutoImage_mm
@AutoImage_wmm
[lr]

@t2 pos=c method=m multi=true time=500 from=ll smile
@t3 pos=rc method=m multi=true time=500 from=rr smile
@t0 dis method=m multi=true time=500 from=br
@t1 dis method=m multi=true time=500 from=ur
@AutoImage_mm
@AutoImage_wmm
[lr]

*mt|
�����Ƀg�����X�ŕ\��[lr]
@t0 pos=l multi=true smile
@t1 pos=lc multi=true smile
@AutoImage_mt
@AutoImage_wmt

�����Ƀg�����X�ŏ���[lr]
@t2 dis multi=true
@t3 dis multi=true
@AutoImage_mt
@AutoImage_wmt

�\���Ə����𓯎���[lr]
@t2 pos=r  multi=true smile
@t3 pos=rc multi=true smile
@t0 dis multi=true
@t1 dis multi=true
@AutoImage_mt
@AutoImage_wmt

*cac|
�ꎞ�I�ɑS�������܂�[lr]
@AutoImage_tempcai
�\�����܂�[lr]
@AutoImage_untempcai
�S�������܂�[lr]
@AutoImage_cai
@AutoImage_wmt
[l]

*et|
�g�����X�ŉ�]�g��k���\�����܂�[lr]
@t0 method=t scale=200 smile
@wt
[l]
@t1 left=400 method=t top=200 scale=50 angle=30 smile
@wt
[l]
�����ɕ\�����܂�[lr]
@t2 multi=true method=t smile
@t3 multi=true method=t left=300 top=20 smile
@AutoImage_mt
@AutoImage_wmt

[l]
@AutoImage_cai
@AutoImage_wmt
[l]
*em|
�ړ��ŉ�]�g��k���\�����܂�[lr]
@t0 method=m time=1000 path=(300,300,255,200,0) smile
[l]
@t1 method=m left=1 top=1 from=l scale=50 time=1000 smile
[l]
�����ɕ\�����܂�[lr]
@t2 multi=true method=m time=1000 scale=200 smile
@t3 multi=true method=m left=300 top=20 from=b time=1000 scale=40 smile
@AutoImage_mm
@AutoImage_wmm

[l]
�ړ��ŉ�]�g��k���������܂�[lr]
@t0 dis method=m time=1000 to=t
[l]
@t1 dis method=m path="(300,200,0,50,0)" time=1000
[l]
�����ɏ������܂�[lr]
@t2 dis multi=true method=m time=1000 smile
@t3 dis multi=true method=m path="(800,300,0,30,0)" time=1000
@AutoImage_mm
@AutoImage_wmm
[l]
@AutoImage_reset
�ŏ��ɖ߂�܂�
@call target=*pos
