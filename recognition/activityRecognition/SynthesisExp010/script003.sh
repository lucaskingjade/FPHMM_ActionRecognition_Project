#/usr/bin/bash
DPATH="./Experiment004/test_BVH_2Activity_20PCA_MissPairs*12states_dim_theta00*.m"

subExp="subExperiment = 'Experiment004';"
MissingPair="MissingPairs = {'Pride','Simple Walk';'Anger','Walk with smth in the Hands'};"
MissStr="MissingStr ='PrSW_AgWH_RmFirst3Dims_Unscaled_';"
LoadName="LoadDataName ='DataSetOffSetFirst4Dim_2Activity_Unscaled_20PCA_SW_WH_PrSW_AgWH.mat'"
for f in $DPATH
do
	sed -i -e 's/SynthesisExp009/SynthesisExp010/g' "$f"
	sed -i -e "/subExperiment =/c $subExp" "$f"
	sed -i -e "/MissingPairs = {/c $MissingPair" "$f"
	sed -i -e "/MissingStr =/c $MissStr" "$f"
	sed -i -e "/LoadDataName =/c $LoadName" "$f"
done



