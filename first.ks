@call storage=AutoImageMacros.ks
@call storage=eximage2.ks
@call storage=exmove.ks
@laycount layers= 20
@macro name=lr
@l
@r
@endmacro
@AutoImage_Init layer=2 width=242 height=409
@camera_Init baselayer=1 width=242 height=409

;@eximage storage=t0 layer=0 visible=true top=0 left=0 angle=45
;[l]
;@eximage storage=t0 layer=0 visible=true top=0 left=0 scale=50
;@im name=t1 method=em left=1 top=1 from=l scale=50 time=1000
;@im name=t0
;@exmove layer=&f.t0 path="(0,0,255,50,0)" time=1000
[l]
*et
�g�����X�ŉ�]�g��k���\�����܂�[lr]
@im name=t0 method=et scale=200
[l]
@im name=t1 left=400 method=et top=200 scale=50 angle=30
[l]
�����ɕ\�����܂�[lr]
@im name=t2 multi=true method=et
@im name=t3 multi=true method=et left=300 top=20
@mt

[l]
@cai
[l]
*em
�ړ��ŉ�]�g��k���\�����܂�[lr]
@im name=t0 method=em time=1000 path=(300,300,255,200,0)
[l]
@im name=t1 method=em left=1 top=1 from=l scale=50 time=1000
[l]
�����ɕ\�����܂�[lr]
@im name=t2 multi=true method=em time=1000 scale=200
@im name=t3 multi=true method=em left=300 top=20 from=b time=1000 scale=40
@mm

[l]
�ړ��ŉ�]�g��k���������܂�[lr]
@ci name=t0 method=em time=1000 to=t
[l]
@ci name=t1 method=em path="(300,200,0,50,0)" time=1000
[l]
�����ɏ������܂�[lr]
@ci name=t2 multi=true method=em time=1000
@ci name=t3 multi=true method=em path="(800,300,0,30,0)" time=1000
@mm

*t
�g�����X�ŕ\�����܂�[lr]
@im name=t0
[l]
@im name=t1 pos=l
[l]
@im name=t2 pos=lc
[l]
@im name=t3 pos=rc
[l]
@im name=t4 method=t pos=r

�g�����X�ŏ������܂�[lr]
@ci name=t0
[l]
@ci name=t1
[l]
@ci name=t2
[l]
@ci name=t3
[l]
@ci name=t4
[l]

*m
�ړ��ŕ\�����܂�[lr]
@im name=t0 method=m from=l  pos=l
[l]
@im name=t1 method=m from=t  pos=lc
[l]
@im name=t2 method=m
[l]
@im name=t3 method=m from=bl pos=r
[l]
@im name=t4 method=m from=br pos=rc
[l]

�ړ��ŏ������܂�[lr]
@ci name=t0 method=m
[l]
@ci name=t1 method=m to=l
[l]
@ci name=t2 method=m to=t
[l]
@ci name=t3 method=m to=br
[l]
@ci name=t4  method=m to=bl
[l]

�ړ��ŕ\�����܂�2[lr]
@im name=t0 method=m from=ul  pos=l
[l]
@im name=t1 method=m from=ll  pos=lc
[l]
@im name=t2 method=m from=b
[l]
@im name=t3 method=m from=ur pos=r
[l]
@im name=t4 method=m from=lr pos=rc
[l]

�ړ��ŏ������܂�2[lr]
@ci name=t0 method=m to=ul
[l]
@ci name=t1 method=m to=ll
[l]
@ci name=t2 method=m to=ur
[l]
@ci name=t3 method=m to=lr
[l]
@ci name=t4  method=m to=b
[l]

*mm
�����Ɉړ��ŕ\��[lr]
@im name=t0 pos=l method=m multi=true from=ul  time=500
@im name=t1 pos=lc method=m multi=true from=ul time=500
@im name=t2 pos=c method=m multi=true from=ul  time=500
@mm
�����Ɉړ��ŏ���[lr]
@ci name=t0 method=m multi=true to=ur time=500
@ci name=t1 method=m multi=true to=ur time=500
@ci name=t2 method=m multi=true to=ur time=500
@mm
�\���Ə����𓯎���[lr]
@im name=t0 pos=l method=m multi=true from=ul  time=500
@im name=t1 pos=lc method=m multi=true from=ul time=500
@mm
[lr]

@im name=t2 pos=c method=m multi=true time=500 from=ll
@im name=t3 pos=rc method=m multi=true time=500 from=r
@ci name=t0 method=m multi=true time=500 from=br
@ci name=t1 method=m multi=true time=500 from=ur
@mm
[lr]

*mt
�����Ƀg�����X�ŕ\��[lr]
@im name=t0 pos=l multi=true
@im name=t1 pos=lc multi=true
@mt

�����Ƀg�����X�ŏ���[lr]
@ci name=t2 multi=true
@ci name=t3 multi=true
@mt

�\���Ə����𓯎���[lr]
@im name=t2 pos=r  multi=true
@im name=t3 pos=rc multi=true
@ci name=t0 multi=true
@ci name=t1 multi=true
@mt

*cac
�ꎞ�I�ɑS�������܂�[lr]
@tempcai
�\�����܂�[lr]
@untempcai
�S�������܂�[lr]
@cai
[l]
