#/usr/bin/bash
DEST="./test*.m"
for f in $DEST
do
	sed -i -e "/^left2rightHMMtopology =/a cov_type = 'diag';" $f
done
