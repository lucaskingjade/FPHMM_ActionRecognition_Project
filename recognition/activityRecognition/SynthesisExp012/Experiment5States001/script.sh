#/usr/bin/bash
DEST="./test*.m"
for f in $DEST
do
	#sed -i -e "/^left2rightHMMtopology =/a cov_type = 'diag';" $f
	#sed -i -e "/^lefe2rightHMMtopology =/a orthogonal_constrain_W = 1;" $f
	#sed -i -e "/^subExperiment =/c subExperiment = 'Experiment5States001';" $f
	#sed -i -e "/^ExperimentName =/c ExperimentName = 'SynthesisExp012';" $f
	#sed -i -e "s/PfSW/JyBS/g" $f	
 	#sed -i -e "/MissingPairs =/c MissingPairs = {'Joy','Being Seated'};" $f	

	#rename the files
	#rename "5states_HMM" "5states_diagonal_HMM" $f
	#rename "5states_orthogonalConstraint" "5states_diagonal_orthogonalConstraint" $f
	rename "PfSW" "JyBS" $f
done

COMMAND="./Command*"
for h in $COMMAND
do 
	#sed -i -e "s/5states_orthogonalConstraint_HMM/5states_diagonal_HMM/g" $h
	#sed -i -e "s/5states_orthogonalConstraint/5states_diagonal_orthogonalConstraint/g" $h
	sed -i -e "s/PfSW/JyBS/g" $h
done
