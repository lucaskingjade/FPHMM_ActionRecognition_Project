#/usr/bin/bash
for i in {1..3..1}
do
	OARFILE="./Experiment10States00$i/OAR*.stdout"
	for f in $OARFILE
	do
		newf=${f##*OAR*states_}
		newf=${newf//.*.stdout}
		echo $newf
		cat $f | grep "indAct" |grep "iteration" |grep "loglik" > "./Experiment10States00$i/FPHMM_loglikelihood_$newf.txt"
		cat $f |grep "^iteration" > "./Experiment10States00$i/InitalizationLoglikelihood_$newf.txt"
	done
done
