#/usr/bin/bash
OLD="SdSW_PrWH"
NEW="SdSW_NtWH"
DPATH="./Experiment006/test_BVH_2Activity_20PCA_MissPairs*12states_dim_theta00*.m"
insertLine="subExperiment = 'Experiment001';"
OLD1="ExperimentName,'\/Results\/'"
MissingPair="MissingPairs = {'Sadness','Simple Walk';'Neutral','Walk with smth in the Hands'};"
MissStr="MissingStr ='SdSW_NtWH_RmFirst3Dims_Unscaled_';"
LoadName="LoadDataName ='DataSetOffSetFirst4Dim_2Activity_Unscaled_20PCA_SW_WH_SdSW_NtWH.mat'"
SaveName="save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');"
for f in $DPATH
do
	#sed -i "/subExperimentName = 'Experiment001';/d" "$f"
	#sed -i -e "/ExperimentName = 'SynthesisExp009';/a $insertLine" "$f"
	#sed -i -e "/$insertLine/c $insertLine" "$f"
	#sed -i -e "/MissingPairs = {/c $MissingPair" "$f"
#	sed -i -e "/MissingStr =/c $MissStr" "$f"
#	sed -i -e "/LoadDataName =/c $LoadName" "$f"
	sed -i -e "/save_path = /c $SaveName" "$f"
	#sed -i -e " a/$insertLine"
    #sed -i -e "64 c\
#save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');" "$f"
done



