#/usr/bin/bash
DestPath="./OAR*.stdout"

for f in $DestPath
	do
		x=$(sed '$!d' $f)
		if [[ $x == LoadDataName* ]]
		then
			rm $f	
		fi

		#if grep 'error:' $f
		#then
		#	rm $f 
		#fi	
done

