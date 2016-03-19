#/usr/bin/bash
OLD="SdSW_PrWH"
NEW="SdSW_NtWH"
DPATH="./test_BVH_2Activity_20PCA_MissPairs*12states_dim_theta00*.m"
ReplacedLine="LoadDataName ='DataSetOffSetFirst4Dim_2Activity_Unscaled_20PCA_SW_WH_PrSW_NtWH.mat'"
for f in $DPATH
do
	#sed -i "/subExperimentName = 'Experiment001';/d" "$f"
	#sed -i -e "/ExperimentName = 'SynthesisExp009';/a $insertLine" "$f"
	#sed -i -e "/$insertLine/c $insertLine" "$f"
	#sed -i -e "/MissingPairs = {/c $MissingPair" "$f"
#	sed -i -e "/MissingStr =/c $MissStr" "$f"
#	sed -i -e "/LoadDataName =/c $LoadName" "$f"
	sed -i -e "s/DatASetOffSetFirst/DataSetOffSetFirst/g" "$f"
	#sed -i -e " a/$insertLine"
    #sed -i -e "64 c\
#save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');" "$f"
done



