�ԋ���	http://akakyouryuu.blog.fc2.com/

�O�i�摜�\���p�}�N��

�����Ń��C�����Ǘ����A�摜��l�X�ȉ��o�ŕ\���A�������o����B
�F�X�ȕ��̃L�����N�^�[���C���Ǘ��v���O�C���̓�����Q�l�ɂ��Ă��邪�A
�������͗����G�̐����ʒu�̎����Ǘ��͍s�Ȃ�Ȃ�
�啔����kag�ŏ�����Ă���A�\���A�����̃e���v���[�g�ȓ��삪����Ȃ�A
method�ɒǉ�����΂悢�B
eximage2.ks,exmove.ks��g�ݍ���ł���̂ŉ�]�g��k���ړ����\
�A����L��2�̃v���O�C���̎d�l��w�i���C���ɂ͎g���Ȃ�
�܂����C���ԍ��� f.nameID �ɓ����Ă���̂ŁA�蓮�ő�����o����B
����nameID�̉摜�𕡐������ɕ\������Ƃ���,nameID�𕡐�����

�������g�������l�������Ȃ�D���Ɏg���Ă���
���ρA�Ĕz�z�͎��R
�g�p�𖾋L����K�v���񍐂���K�v���Ȃ�
���Ǖ񍐂������Ƃ��ꂵ��


(����)
��L��2�̃v���O�C���̎d�l��ꖇ�G�����\���ł��Ȃ��Apimage�Ƃ��͂ł��Ȃ�
���RnameID�͕ϐ����ɏo������̂����w��o���Ȃ��B
AutoImage2�ŕ\���������͕̂K��AutoImage2�ŏ������邩�A
freelayer�ŊJ������B
�^�C�g����ʂȂǂł͕ϐ������������邽�߂ɕK��@AutoImage_reset���g��
path�̎w���exmove.ks���Q��

�K�v�Ȃ���
�F�X�ȕ���TJSFunctions.ks
TJS�ɒ���I��eximage2.ks,exmove.ks
�𗎂Ƃ��Ă���

�g����
first.ks�ŌĂяo������Ƃ���
����������

(��)
@call storage=AutoImage2.ks
@AutoImage_Init layer=1


�g����^�O
im		: ��������
dis             : �摜����
mm              : �����ړ�
mt              : �����g�����W�V����
wmm             : �����ړ��҂�
wmt             : �����g�����W�V�����҂�
name_reg        : nameID�o�^
name            : nameID��type��ݒ�
tempcai         : �ꎞ�I�ɑO�i�摜������
untempcai       : �O�i�摜��\��
cai             : �O�i�摜������
getlayer        : �Ǘ����C�����󂯎��
freelayer       : �Ǘ����C�����J������
AutoImage_Init  : �ݒ肷��
AutoImage_reset : ���ׂĂ�nameID������������

---------------------------------------------------------------------
@AutoImage_reset
nameID������������B�^�C�g���ɂ�������

---------------------------------------------------------------------------- 
@AutoImage_Init
�K�{
layer		:���̐��ȏ�̃��C���������Ǘ��ɂ܂�����
�C��

��֔w�i���C���͎����Ǘ��Ɋ܂܂Ȃ��悤��

(��)
@call storage=AutoImage2.ks
@AutoImage_Init layer=1

�K�v�Ȑݒ������A
laycount�Ń��C�����������Ă�layer�Ŏw�肵���ԍ��ȏ�̃��C��
�͎����ŊǗ�����

---------------------------------------------------------------------------- 
�}�N���o�^
@name_reg
�K�{
name		:nameID��o�^

�����Ŏ��̂悤�ɓ��삵�Ă���
@macro name=%name
@im * name=%name
@endmacro

�ݒ肷��ΈȌ� @nameID �Ǝg����
---------------------------------------------------------------------------- 
@name
nameID��type�ɑΉ�����t�@�C����ݒ肷��
@name name=nameID type= storage= top=
�K�v�Ȃ�摜��\������Ƃ��̍������w�肷��
�f�t�H���g�ł͉摜�̉��[�ő�����
---------------------------------------------------------------------------- 
@im

*���L���Q��

dis���^�Ȃ�@dis
nameID�Ŏw�肵���摜�����łɕ\������Ă�����@diff,
�\������Ă��Ȃ�������@app�����s����B
@im name=nameID dis

��֔w�i�Ƃ��Ďg���ꍇ�͎��̃}�N����ݒ肵�Ďg���Ƃ悢
�{���̔w�i���C���Ƒg�ݍ��킹�邱�ƂŁA���o���L����B
@macro name=base
@im * name=base layer=0
@endmacro
---------------------------------------------------------------------------- 
@app
�K�{
name		:nameID���w�肷��
type		:type=XXX�ł����̂܂�XXX�Ƃ��Ă��悢
		 �A���󔒂͂͂��߂Ȃ�
@app name=nameID XXX

@name�Őݒ肵��nameID��type����t�@�C����\������B

layer		:�����Ń��C�����w�肵�Ă��悢
		 �w�i�Ƃ��Ďg���Ȃ炱�����w�肷��

multi		:�������s����B�f�t�H���g�l��false
		 method��t,m�Ŏw��\
		 �ݒ���
		 method=t�Ȃ�@mt
		 method=m�Ȃ�@mm
		 �Ŏ��s����
		 �ݒ�シ���Ɏ��s���邱�ƁA
		 �\���Ə����𓯎��ɂ����Ȃ����́A�\�����Ă����������
		 (�����������_�Ń��C�����J�����Ă��܂�)
		 
method		:�\�����@���w��f�t�H���g�l��t
		 ���L�Q��

�O�i�摜�\��
�����Ń��C�����Ǘ����A�摜�̗l�X�ȉ��o�ŕ\�����o����B
�܂����C���ԍ��� f.nameID �ɓ����Ă���B
(����)
�ꖇ�G�����\���ł��Ȃ�


method=t
�g�����W�V�����ŕ\��
��]�g��k�����ăg�����W�V�����ŕ\��
left,top��ݒ肵�Ă����΁A�C�ӂ̏ꏊ�ɂ�����,
�g�����W�V������method��tmethod�Ŏw�肷��B
���̑���eximage,trans�𓯂�
@app name=nameID type=XXX method=t pos=(center) multi=(false)  time=(500)

method=m
�C�ӂ̏ꏊ�����]�g��k�����Ȃ���C�ӂ̏ꏊ�ɕ\��
path��ݒ肷��ƁAleft,top����Apath�Ɉړ����ĕ\��
(�g��k����]�𔺂��Ƃ��Apath�̑��A�������͉摜�̒��S������)
from��ݒ肷��ƁAleft,top�Ŏw�肵���ʒu��from�Ŏw�肵����������ړ����ĕ\��
from�ɂ�
	left
	right
	bigleft
	bigright
	top
	bottom
	bigtop
	bigbottom
	upper left
	lower left
	upper right
	lower right
�܂����̏ȗ���
	l
	r
	bl
	br
	t
	b
	bt
	bb
	ul
	ll
	ur
	lr
���w��\�A���ꂼ��̓���̓T���v�����Q��

���̑���eximage,exmove�𓯂�

@app name=nameID type= method=m accel= time=(500) from=(left)

method=n
���ڕ\��ʂɕ\��
���̑���eximage�𓯂�
@app name=nameID type= method=n

---------------------------------------------------------------------------- 
@diff
�K�{
nameID		:nameID���w�肷��
type		:type=XXX�ł����̂܂�XXX�Ƃ��Ă��悢
		 �A���󔒂͂͂��߂Ȃ�
�C��
multi		:�f�t�H���g�lfalse
		 method��t�̎��w��\
		 �ݒ��@mt�Ŏ��s�A@wmt�ő҂�
method		:�f�t�H���g�l��t
		 t�Ȃ�g�����W�V����
		 mt�Ȃ�g�����W�V�������Ȃ���
		 �ړ�����
tmethod		:trans��method�Ɠ���


���̑���eximage�𓯂�

�\���ς���A(�܂荷���\��)
scale�ɂ��g��k�������Ȃ玩���Œ�������
xscale,yscale���]�����Ă��玩���Ŏw�肷��
@wt�ő҂�


---------------------------------------------------------------------------- 
@dis
�K�{
nameID		:nameID���w�肷��

�C��
multi		:�������s����B�f�t�H���g�l��false
		 method��t,m�Ŏw��\
		 �ݒ���method=t,�Ȃ�@mt
		 �ݒ���method=m�Ȃ�@mm
		 �Ŏ��s����
		 �ݒ肵����A�����Ɏ��s���邱�ƁA
		 �\���Ə����𓯎��ɂ����Ȃ����́A�\�����Ă����������
		 (�����������_�Ń��C�����J�����Ă��܂�

method		:�\�����@���w��f�t�H���g�l��t

*���L�Q��

�摜�N���A
�����������摜��nameID���w��

method=t
�g�����W�V����
�g�����W�V������method��tmethod�Ŏw�肷��B
@dis name=nameID method=(t) multi=(false) time=

method=m
to�Ɉړ����ď���
path��ݒ肷��ƔC�ӂ̏ꏊ�Ɉړ����ď���
@dis name=nameID method=m path= to=(right) time= accel=
to�̈����ɂ�
	left
	right
	bigleft
	bigright
	top
	bottom
	bigtop
	bigbottom
	upper left
	lower left
	upper right
	lower right
�܂����̏ȗ���
	l
	r
	bl
	br
	t
	b
	bt
	bb
	ul
	ll
	ur
	lr
���w��\�A���ꂼ��̓���̓T���v�����Q��

method=n
������������
@dis name=nameID method=n

---------------------------------------------------------------------------- 
@mm
��x�ɕ������ړ�
@wmm�ő҂�
---------------------------------------------------------------------------- 
@mt
��x�ɕ������g�����W�V����
@wmt�ő҂�
---------------------------------------------------------------------------- 
@wmm
---------------------------------------------------------------------------- 
@wmt
---------------------------------------------------------------------------- 
 �O�i���ꎞ�I�ɏ���(�����܂ňꎞ�I)
@tempcai
---------------------------------------------------------------------------- 
 �ꎞ�I�ɏ������O�i��\��
@untempcai
---------------------------------------------------------------------------- 
�O�i��S�ď���
@cai
tmethod		:trans��method�Ɠ���
����@trans�Ɠ���
@wmt�ő҂�

---------------------------------------------------------------------------- 
���C�����m�ۂ���
@getlayer
name		:f.nameID�Ƀ��C�����m�ۂ����
		 �����ƊJ�����邱��
---------------------------------------------------------------------------- 
���C�����J������
@freelayer
name		:nameID���w�肷��
