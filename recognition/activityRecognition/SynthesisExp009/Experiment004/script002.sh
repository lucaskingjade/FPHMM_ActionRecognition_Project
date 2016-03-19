#/usr/bin/bash
OLD="SdSW_PrWH"
NEW="SdSW_NtWH"
DPATH="./test_BVH_2Activity_20PCA_MissPairs*_HMM*.m"
#insertLine="subExperiment = 'Experiment001';"
#OLD1="ExperimentName,'\/Results\/'"
activity="activityCell = {'Being Seated','Sitting Down','Knocking on the Door','Lift','Move Books','Simple Walk','Throw','Walk with smth in the Hands'};"
newActivity="activityCell = {'Simple Walk','Walk with smth in the Hands'};"
MissingPair="MissingPairs = {'Pride','Simple Walk';'Neutral','Walk with smth in the Hands'};"
MissStr="MissingStr ='PrSW_NtWH_RmFirst3Dims_Unscaled_';"
LoadName="LoadDataName ='DataSetOffSetFirst4Dim_2Activity_Unscaled_20PCA_SW_WH_PrSW_NtWH.mat'"
#SaveName="save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');"
for f in $DPATH
do
	#sed -i "/subExperimentName = 'Experiment001';/d" "$f"
	#sed -i -e "/ExperimentName = 'SynthesisExp009';/a $insertLine" "$f"
	#sed -i -e "/$insertLine/c $insertLine" "$f"
	sed -i -e "/MissingPairs = {/c $MissingPair" "$f"
    sed -i -e "/MissingStr =/c $MissStr" "$f"
    sed -i -e "/LoadDataName =/c $LoadName" "$f"
	sed -i -e "/activityCell = /c $newActivity" "$f"
	#sed -i -e "/save_path = /c $SaveName" "$f"
	#sed -i -e " a/$insertLine"
    #sed -i -e "64 c\
#save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');" "$f"
done



