#/usr/bin/bash
OLD="SdSW_PrWH"
NEW="NtSW_SdWH"
DPATH="./Experiment001/test_BVH_2Activity_20PCA_MissPairs*12states_dim_theta00*.m"
insertLine="subExperiment = 'Experiment001';"
OLD1="ExperimentName,'\/Results\/'"
NEW1="save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');"
for f in $DPATH
do
	sed -i -e "s/$OLD/$NEW/g" "$f"
    sed -i -e "64 c\
save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');" "$f"
done



