#/usr/bin/bash
cp ../Experiment005/CommandsPassiveJobOnCluster ./
FILENAME="./CommandsPassiveJobOnCluster"

sed -i -e 's/SdSW_PrWH/PrSW_SdWH/g' $FILENAME
#sed -i -e '1,4s/videosense1/karma1/' $FILENAME

#sed -i -e "s/videosense4/karma1/g" $FILENAME


