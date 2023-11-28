#!/bin/bash

PORT=3333
TIMEOUT=1

echo "Server de EFPT"
echo "(0) Listen"
DATA=`nc -l -p $PORT -w $TIMEOUT`
echo $DATA
PATRON_IP='([0-9]*\.){3}[0-9]*'
CLIENT=`echo "$DATA" | grep -Eo "$PATRON_IP"`
echo "$CLIENT" 

echo "(3) Test & Send"
if [ "$DATA" != "EFPT 1.0 $CLIENT" ];then
	echo "KO_HEATHER"
	sleep 3
	echo "KO_HEATHER" | nc "$CLIENT" $PORT
	exit 1
fi

echo "OK_HEATHER"
sleep 2
echo "OK_HEATHER" | nc "$CLIENT" $PORT


echo "(4) Listen"
DATA1=`nc -l -p $PORT -w $TIMEOUT`
echo $DATA1


echo "(7) Test & Send"
if [ "$DATA1" != "BOOOM" ];then
	echo "KO_HEATHER"
	sleep 1
    echo "KO_HEATHER" | nc "$CLIENT" $PORT
    exit 2
fi

echo "OK_HEATHER"
sleep 2
echo "OK_HEATHER" | nc "$CLIENT" $PORT


echo "(8) Listen"
FILENAME=`nc -l -p $PORT -w $TIMEOUT`
echo $FILENAME

echo "(12) Test & Store & Send"
FILE_NAME=`echo "$FILENAME" | awk '{print $1}'`
if [ "$FILE_NAME" != "FILE_NAME" ]; then
	echo "KO_FILE_NAME PREFIX"
    sleep 2
    echo "KO_FILE_NAME" | nc "$CLIENT" $PORT
    exit 3
fi

NAME_FILE=`echo "$FILENAME" | awk '{print $2}'`
HASH_FILENAME=`echo "$FILENAME" | awk '{print $3}'`
echo "$NAME_FILE"
echo "$HASH_FILENAME"
CHECK_FILE_HASH=`echo "$NAME_FILE" | md5sum | awk '{print $1}'`

if [ "$HASH_FILENAME" != "$CHECK_FILE_HASH" ];then
	echo "KO_FILE_NAME MD5"
    sleep 2
    echo "KO_FILE_NAME" | nc "$CLIENT" $PORT
    exit 3
fi

echo "OK_FILE_NAME"
sleep 2
echo "OK_FILE_NAME" | nc "$CLIENT" $PORT

echo "(13) Listen File & Listen Hash"
nc -l -p $PORT -w $TIMEOUT > /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE"



echo "(16) Store & Send"
FILE=`cat /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE"`

if [ -z "$FILE" ];then
	echo "EMPTY DATA"
	sleep 1
	echo "KO_DATA" | nc $CLIENT $PORT
	exit 4
fi

echo "OK_DATA" | nc $CLIENT $PORT

echo "(17) Listen Hash"
HASH=`nc -l -p $PORT -w $TIMEOUT`
echo $HASH


echo "(18) Test & Send (Hash)"
CREATE_HASH=`md5sum /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE"| awk '{print $1}'`

while [ "$CREATE_HASH" != "$HASH" ]
do
	echo "REQUEST_FILE" | nc $CLIENT $PORT
	nc -l -p $PORT -w $TIMEOUT > /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE"
	HASH=`nc -l -p $PORT -w $TIMEOUT`
	echo $HASH
	CREATE_HASH=`md5sum /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE" | awk '{print $1}'`
done

echo "OK_DATA" | nc $CLIENT $PORT
echo "OK_DATA FILE RECIVED PERFECTLY"
exit 0
