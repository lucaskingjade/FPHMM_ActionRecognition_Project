#/usr/bash

FileName="./test*dim*"

for f in $FileName

do
	sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'theta_dim','-append');" $f
	sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'meanPose_Actor','-append');" $f
	sed -i -e "s/mat-binary/mat7-binary/g" $f
done
