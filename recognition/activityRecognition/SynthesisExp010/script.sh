#/usr/bin/bash
#create directories
for i in {1..4..1}
	do
		mkdir Experiment00$i
done
Name1="PfSW_NtWH"
Name2="PfSW_AgWH"
Name3="PfSW_AxWH"
Name4="PrSW_AgWH"

Name=('PfSW_NtWH','PfSW_NtWH','PfSW_NtWH','PfSW_NtWH')
#for i in {1..1..1}
#	do
		#cp ../SynthesisExp009/Experiment001/test* ./Experiment00$i/
		#cp ../SynthesisExp009/Experiment001/Comma* ./Experiment00$i/
		#rename $Name[$i] ./Experiment00$i/test*.m

#done

rename 'NtSW_SdWH' 'PfSW_NtWH' ./Experiment001/test*.m
rename 'NtSW_SdWH' 'PfSW_AgWH' ./Experiment002/test*.m
rename 'NtSW_SdWH' 'PfSW_AxWH' ./Experiment003/test*.m
rename 'NtSW_SdWH' 'PrSW_AgWH' ./Experiment004/test*.m


