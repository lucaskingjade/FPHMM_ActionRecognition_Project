#/usr/bin/bash
for i in {1..4..1}
	do
	cp -n ../SynthesisExp010/Experiment00$i/Command* ./Experiment5States00$i/
	Command="./Experiment5States00$i/Command*"	
	for f in $Command
		do
		sed -i -e "s/12states/5states/g" $f
		sed -i -e "s/2Activity/AllActivity/g" $f
	done
done

