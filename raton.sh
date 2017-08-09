while :
do
mousecount=`grep mouse /proc/bus/input/devices |grep Handler |wc -l`
if [ "$mousecount" -eq "1" ]
then
	synclient TouchpadOff=0
elif [ "$mousecount" -gt "1" ]
then
	synclient TouchpadOff=1
fi
sleep 0.25
done
