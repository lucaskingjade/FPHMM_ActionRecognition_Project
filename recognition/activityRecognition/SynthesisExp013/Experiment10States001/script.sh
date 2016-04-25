#/usr/bin/bash

Dest="test*.m"

for f in $Dest
do 
	#change the state number to 10
	#sed -i -e "/^ExperimentName =/c ExperimentName = 'SynthesisExp013';" $f
	#sed -i -e "/^subExperiment = /c subExperiment = 'Experiment10States001'" $f
	#sed -i -e "/Lambda =/d" $f
    #sed -i -e "/^left2rightHMMtopology =/a Lambda = 0.1;" $f
    #sed -i -e "s/TrainingFPHMM_Synthesis;/TrainingFPHMM_Synthesis_Penalty;/g" $f
	#rename "orthogonalConstraint_Penalty" "Orth_Cst_Pnt" $f
	rename "oOrth" "Orth" $f
done
