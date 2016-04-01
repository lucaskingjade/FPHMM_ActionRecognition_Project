#/usr/bin/bash
for i in {1..5..1}
	do
	cp -n ../SynthesisExp011/Experiment5States00$(($i+2))/Command* ./Experiment5States00$i/
	Command="./Experiment5States00$i/Command*"	
	for f in $Command
		do
		#sed -i -e "s/12states/5states/g" $f
		#sed -i -e "s/2Activity/AllActivity/g" $f
		sed -i -e "s/5states/5states_orthogonalConstraint/g" $f
	done
done

