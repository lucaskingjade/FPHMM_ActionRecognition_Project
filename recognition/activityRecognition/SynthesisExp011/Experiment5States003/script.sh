#/urs/bin/bash

rename "PfSW_*WH" "PfSW" ./test*dim_theta*
DestFile="./test*dim_theta*"

for f in $DestFile
do
	sed -i -e "/MissingStr =/c MissingStr = 'PfSW_RmFirst3Dims_Unscaled_MeanSubtracted_EachActor_Centred_';" $f
	sed -i -e "/LoadDataName =/c LoadDataName = 'DataSetOffSet4thDim_RmFirst3Dims_UnScaled_20PCA_allTrainingSet_Bvh_MeanSub_eachActor_PfSW_Centered_001.mat';" $f
	sed -i -e "$ a save('-mat-binary',strcat(save_file_name,'.mat'),'theta_dim','-append');" $f
done

HMMFILE="test*HMM.m"
for h in $HMMFILE
do
	sed -i -e "/MissingStr =/c MissingStr = 'PfSW_RmFirst3Dims_Unscaled_MeanSubtracted_eachAtor_eachActivity_Centred';" $h
	sed -i -e "/LoadDataName =/c LoadDataName = 'DataSetOffSet4thDim_RmFirst3Dims_UnScaled_20PCA_allTrainingSet_Bvh_MeanSub_eachActor_PfSW_Centered_001.mat';" $h
	sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'meanpose_TrainingSet','-append');" $h
done

