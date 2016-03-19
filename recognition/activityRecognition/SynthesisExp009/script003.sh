#/usr/bin/bash
DPATH="./test_BVH_2Activity_20PCA_MissPairs*12states_dim_theta00*.m"
subExp="subExperiment = 'Experiment004';"
MissingPair="MissingPairs = {'Pride','Simple Walk';'Neutral','Walk with smth in the Hands'};"
MissStr="MissingStr ='PrSW_NtWH_RmFirst3Dims_Unscaled_';"
LoadName="LoadDataName ='DatASetOffSetFirst4Dim_2Activity_Unscaled_20PCA_SW_WH_PrSW_NtWH.mat'"
for f in $DPATH
do
	sed -i -e "/subExperiment =/c $subExp" "$f"
	sed -i -e "/MissingPairs = {/c $MissingPair" "$f"
	sed -i -e "/MissingStr =/c $MissStr" "$f"
	sed -i -e "/LoadDataName =/c $LoadName" "$f"
done



