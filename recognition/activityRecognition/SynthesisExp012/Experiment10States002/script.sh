#/usr/bin/bash

Dest="test*.m"

for f in $Dest
do 
	#change the state number to 10
	sed -i -e "/^numStates =/c numStates = 10;" $f
    sed -i -e "/^subExperiment =/c subExperiment = 'Experiment10States002';" $f	
	rename "5states" "10states" $f	





	
done
