�ԋ���	http://akakyouryuu.blog.fc2.com/

�O�i�摜�\���p�}�N��

�����Ń��C�����Ǘ����A�摜��l�X�ȉ��o�ŕ\���A�������o����B
�F�X�ȕ��̃L�����N�^�[���C���Ǘ��v���O�C���̓�����Q�l�ɂ��Ă��邪�A
�������͗����G�̐���͍s�Ȃ�Ȃ�
�啔����kag�ŏ�����Ă���A�\���A�����̃e���v���[�g�ȓ��삪����Ȃ�A
method�ɒǉ�����΂悢�B
eximage2.ks,exmove.ks��g�ݍ���ł���̂ŉ�]�g��k���ړ����\
�A����L��2�̃v���O�C���̎d�l��w�i���C���ɂ͎g���Ȃ�
�܂����C���ԍ��� f.nameID �ɓ����Ă���̂ŁA�蓮�ő�����o����B
����nameID�̉摜�𕡐������ɕ\������Ƃ���nameID�𕡐�����

�}�N�����������̂͑��Ɣ��̂�����邽�߁A���̃}�N���ɑg�ݍ���ł����Ă�����
���B

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
first.ks�ŌĂяo������,
AutoImage_Init�ŏ�������
AutoImage_name��nameID��o�^
�K�v�Ȃ�AutoImage_name_reg�Ń}�N���ɂ��o�^����
�^�C�g����ʓ��ł�AutoImage_reset�ŕK�����������邱��

(��)
@call storage=AutoImage2.ks


�g����^�O
AutoImage_im        : ��������
AutoImage_dis       : �摜����
AutoImage_mm        : �����ړ�
AutoImage_mt        : �����g�����W�V����
AutoImage_wmm       : �����ړ��҂�
AutoImage_wmt       : �����g�����W�V�����҂�
AutoImage_name_reg  : nameID�o�^
AutoImage_name      : nameID��type��ݒ�
AutoImage_tempcai   : �ꎞ�I�ɑO�i�摜������
AutoImage_untempcai : �O�i�摜��\��
AutoImage_cai       : �O�i�摜������
AutoImage_getlayer  : �Ǘ����C�����󂯎��
AutoImage_freelayer : �Ǘ����C�����J������
AutoImage_Init      : �ݒ肷��
AutoImage_reset     : ���ׂĂ�nameID������������

---------------------------------------------------------------------------- 
@AutoImage_Init
�K�{
layer		:���̐��ȏ�̃��C���������Ǘ��ɂ܂�����
�C��

��֔w�i���C���͎����Ǘ��Ɋ܂܂Ȃ��悤��
AutoImage_tempcai,AutoImage_untempcai,AutoImage_cai�ňꏏ�ɏ����Ă��܂��̂�

(��)
@call storage=AutoImage2.ks
@AutoImage_Init layer=1

�K�v�Ȑݒ������A
laycount�Ń��C�����������Ă�layer�Ŏw�肵���ԍ��ȏ�̃��C��
�͎����ŊǗ�����

---------------------------------------------------------------------------- 
@AutoImage_name
nameID��type�^�C�v�̑g�ݍ��킹�ɑΉ�����t�@�C����ݒ肷��
�ȍ~�͂��̂Ƃ��̐ݒ�ɏ]���ĕ\������摜�����肷��

�K�{
name    : �o�^����nameID
type    : �g�ݍ��킹��type
storage : �Ή�����摜
top     : �\�����̍���

(��)
@name name=nameID type= storage= top=

�K�v�Ȃ�摜��\������Ƃ��̍������w�肷��
�f�t�H���g�ł͉摜�̉��[�ő�����
---------------------------------------------------------------------------- 
@AutoImage_name_reg

�}�N���o�^������ݒ肷��ΈȌ� @nameID �Ǝg����
�K�{
name		:nameID��o�^

�����Ŏ��̂悤�ɓ��삵�Ă���
@macro name=%name
@AutoImage_im * name=%name
@endmacro

---------------------------------------------------------------------
@AutoImage_reset
���C���I������ԂȂǂ�����������B�^�C�g���ɂ�������

---------------------------------------------------------------------------- 
@AutoImage_im
�󋵂ɍ��킹�ĉ��L���̓��������

dis���^�Ȃ�摜������@AutoImage_dis
�w�肵��nameID�̉摜�����łɕ\������Ă����獷���\����@AutoImage_diff,
�\������Ă��Ȃ�������@AutoImage_app�ŕ\������
(��)
@AutoImage_im name=nameID dis

��֔w�i�Ƃ��Ďg���ꍇ�͎��̃}�N����ݒ肵�Ďg���Ƃ悢
�{���̔w�i���C���Ƒg�ݍ��킹�邱�ƂŁA���o���L����B
(��)left,top���w�肵�Ȃ��Ə���ɋ󂫃|�W�V�����ɕ\�����Ă��܂��B

@macro name=base
@AutoImage_im * name=base layer=0 left=0 top=0
@endmacro
---------------------------------------------------------------------------- 
@AutoImage_app
�O�i�摜�\��
�����Ń��C�����|�W�V�������Ǘ����A�摜�̗l�X�ȉ��o�ŕ\�����o����B
�܂����C���ԍ��� f.nameID �ɓ����Ă���B
left,top���w�肳��Ă��Ȃ���Ύ��̏��ɋ󂢂Ă���|�W�V������
�\������Bcenter,right,left,right_center,left_center
�A���\����Ɉړ����Ă����m���Ȃ�

(����)
�ꖇ�G�����\���ł��Ȃ�

�K�{
name		:nameID���w�肷��
type		:type=XXX�ł����̂܂�XXX�Ƃ��Ă��悢
		 �A���󔒂͂͂��߂Ȃ�
(��)
@app name=nameID XXX

@AutoImage_name�Őݒ肵��nameID��type����t�@�C����\������B

layer		:�����Ń��C�����w�肵�Ă��悢
		 �w�i�Ƃ��Ďg���Ȃ炱�����w�肷��

multi		:�������s����B�f�t�H���g�l��false
		 method��t,m�Ŏw��\
		 �ݒ���
		 method=t�Ȃ�@AutoImage_mt
		 method=m�Ȃ�@AutoImage_mm
		 �Ŏ��s����
		 �ݒ�シ���Ɏ��s���邱�ƁA
		 �\���Ə����𓯎��ɂ����Ȃ����́A�\�����Ă����������
		 (�����������_�Ń��C�����J�����Ă��܂�)
		 
method		:�\�����@���w��f�t�H���g�l��t
		 ���L�Q��


method=t
�g�����W�V�����ŕ\��
��]�g��k�����ăg�����W�V�����ŕ\��
�g�����W�V������method��tmethod�Ŏw�肷��B
���̑���eximage,trans�Ɠ���������������
@AutoImage_app name=nameID type=XXX method=t pos=(center) multi=(false)  time=(500)

method=m
�C�ӂ̏ꏊ�����]�g��k�����Ȃ���C�ӂ̏ꏊ�ɕ\��
path��ݒ肷��ƁAleft,top����Apath�Ɉړ����ĕ\��
(�g��k����]�𔺂��Ƃ��Apath�̑��A�������͉摜�̒��S������)
from��ݒ肷��ƁAleft�Atop�A�܂���pos�Ŏw�肵���ʒu��from�Ŏw�肵����������ړ����ĕ\��
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

���̑���eximage,exmove�Ɠ���������������

@app name=nameID type= method=m accel= time=(500) from=(left)

method=n
���ڕ\��ʂɕ\��
���̑���eximage�𓯂�������������
(��)
@AutoImage_app name=nameID type= method=n

---------------------------------------------------------------------------- 
@AutoImage_diff
�\���ς���A(�܂荷���\��)
scale�ɂ��g��k�������Ȃ玩���Œ�������
xscale,yscale���]�����Ă��玩���Ŏw�肷��

�K�{
nameID		:nameID���w�肷��
type		:type=XXX�ł����̂܂�XXX�Ƃ��Ă��悢
		 �A���󔒂͂͂��߂Ȃ�
�C��
multi		:�f�t�H���g�lfalse
		 method��t�̎��w��\
		 �ݒ��@AutoImage_mt�Ŏ��s�A@AutoImage_wmt�ő҂�
method		:�f�t�H���g�l��t
		 t�Ȃ�g�����W�V����
		 mt�Ȃ�g�����W�V�������Ȃ���
		 �ړ�����
tmethod		:trans��method�Ɠ���


���̑���eximage,trans�Ɠ���������������



---------------------------------------------------------------------------- 
@AutoImage_dis

�摜�N���A
�����������摜��nameID���w�肷��

�K�{
nameID		:nameID���w�肷��

�C��
multi		:�������s����B�f�t�H���g�l��false
		 method��t,m�Ŏw��\
		 �ݒ���method=t,�Ȃ�@AutoImage_mt
		 �ݒ���method=m�Ȃ�@AutoImage_mm
		 �Ŏ��s����
		 �ݒ肵����A�����Ɏ��s���邱�ƁA
		 �\���Ə����𓯎��ɂ����Ȃ����́A�\�����Ă����������
		 (�����������_�Ń��C�����J�����Ă��܂�

method		:�\�����@���w��f�t�H���g�l��t

*���L�Q��

method=t
�g�����W�V����
�g�����W�V������method��tmethod�Ŏw�肷��B
���̑���trans�Ɠ���������������
@dis name=nameID method=(t) multi=(false) time=

method=m
to�Ŏw�肵�������Ɉړ����ď���
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
���̑���@exmove�Ɠ���������������

method=n
������������
@dis name=nameID method=n

---------------------------------------------------------------------------- 
@AutoImage_mm
��x�ɕ������ړ�
@wAutoImage_mm�ő҂�
---------------------------------------------------------------------------- 
@AutoImage_mt
��x�ɕ������g�����W�V����
@trans�Ɠ���������������
@AutoImage_wmt�ő҂�
---------------------------------------------------------------------------- 
@AutoImage_wmm
@AutoImage_mm��҂�
---------------------------------------------------------------------------- 
@AutoImage_wmt
@AutoImage_mt��҂�
---------------------------------------------------------------------------- 
 �O�i���ꎞ�I�ɏ���(�����܂ňꎞ�I)
@AutoImage_tempcai
---------------------------------------------------------------------------- 
 �ꎞ�I�ɏ������O�i��\��
@AutoImage_untempcai
---------------------------------------------------------------------------- 
�O�i��S�ď���
@AutoImage_cai
tmethod		:trans��method�Ɠ���
����@trans�Ɠ���������������
@AutoImage_wmt�ő҂�

---------------------------------------------------------------------------- 
���C�����m�ۂ���
@AutoImage_getlayer
name		:f.nameID�Ɋm�ۂ��ꂽ���C���ԍ�������
		 �����ƊJ�����邱��
(��)
@AutoImage_getlayer name=nameID
---------------------------------------------------------------------------- 
���C�����J������
@AutoImage_freelayer
name		:nameID���w�肷��
