#/usr/bin/bash

FILENAME="./Experiment003/CommandsPassiveJobOnCluster"
sed -i -e 's/NtSW_SdWH/PfSW_AxWH/g' $FILENAME

FILENAME="./Experiment004/CommandsPassiveJobOnCluster"
sed -i -e 's/NtSW_SdWH/PrSW_AgWH/g' $FILENAME 



