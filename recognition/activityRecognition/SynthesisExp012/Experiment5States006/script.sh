#/usr/bin/bash
DEST="./test*.m"
str_Missing="NtKD"
for f in $DEST
do
	#sed -i -e "/^left2rightHMMtopology =/a cov_type = 'diag';" $f
	sed -i -e "/^subExperiment =/c subExperiment = 'Experiment5States006';" $f
	#sed -i -e "/^ExperimentName =/c ExperimentName = 'SynthesisExp012';" $f
	sed -i -e "s/JyWH/$str_Missing/g" $f
	#sed -i -e "s/Centered_002/Centered_001/g" $f
 	sed -i -e "/MissingPairs =/c MissingPairs = {'Neutral','Knocking on the Door'};" $f	

	#rename the files
	#rename "5states_HMM" "5states_diagonal_HMM" $f
	#rename "5states_orthogonalConstraint" "5states_diagonal_orthogonalConstraint" $f
	rename "JyWH" "$str_Missing" $f
done

COMMAND="./Command*"
for h in $COMMAND
do 
	#sed -i -e "s/5states_orthogonalConstraint_HMM/5states_diagonal_HMM/g" $h
	#sed -i -e "s/5states_orthogonalConstraint/5states_diagonal_orthogonalConstraint/g" $h
	sed -i -e "s/JyWH/$str_Missing/g" $h
done
