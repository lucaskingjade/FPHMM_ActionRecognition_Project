#/usr/bin/bash
FILENAME="./test_BVH_2Activity_20PCA_MissPairs_*_12states_HMM.m"
subExperiment="subExperiment = 'Experiment002';"
MissStr="MissingStr ='PfSW_AgWH_RmFirst3Dims_Unscaled_';"
LoadName="LoadDataName ='DataSetOffSetFirst4Dim_2Activity_Unscaled_20PCA_SW_WH_PfSW_AgWH.mat'"
oldpath="save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/Results/');"
newpath="save_path = strcat(path0,'fullyParameterizedHMM/Project/recognition/activityRecognition/',ExperimentName,'/',subExperiment,'/Results/');"
for f in $FILENAME
do
ExperimentName="ExperimentName ='SynthesisExp010';"
sed -i -e "/ExperimentName =/c $ExperimentName" "$f"
sed -i -e "/ExperimentName =/a $subExperiment" "$f"
sed -i -e "/MissingStr =/c $MissStr" "$f"
sed -i -e "/LoadDataName =/c $LoadName" "$f"
#sed -i -e "/$oldpath/c $newpath" "$f"
done
