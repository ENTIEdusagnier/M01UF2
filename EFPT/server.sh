#!/bin/bash

PORT=3333
TIMEOUT=1

echo "Server de EFPT"
echo "(0) Listen"
DATA=`nc -l -p $PORT -w $TIMEOUT`

PREFIX=`echo "$DATA" | awk '{print $1}'`
VERSION=`echo "$DATA" | awk '{print $2}'`
echo "Prfix $CLIENT: $PREFIX"
echo "Version $CLIENT: $VERSION "

echo "(3) Test & Send"
if [ "$PREFIX $VERSION" != "EFTP 1.0" ];then
	echo "To $CLIENT KO_HEADER"
	sleep 3
	echo "KO_HEADER" | nc "$CLIENT" $PORT
	exit 1
fi

CLIENT=`echo "$DATA" | awk '{print $3}'`
echo "IP Client: $CLIENT" 

echo "To $CLIENT OK_HEADER"
sleep 2
echo "OK_HEADER" | nc "$CLIENT" $PORT


echo "(4) Listen"
DATA1=`nc -l -p $PORT -w $TIMEOUT`
echo $DATA1


echo "(7) Test & Send"
if [ "$DATA1" != "BOOOM" ];then
	echo "To $CLIENT KO_HEADER"
	sleep 1
    echo "KO_HEADER" | nc "$CLIENT" $PORT
    exit 2
fi

echo "To $CLIENT OK_HEADER"
sleep 2
echo "OK_HEADER" | nc "$CLIENT" $PORT


echo "(8) Listen"
FILENAME=`nc -l -p $PORT -w $TIMEOUT`


echo "(12) Test & Store & Send"
FILE_NAME=`echo "$FILENAME" | awk '{print $1}'`
if [ "$FILE_NAME" != "FILE_NAME" ]; then
	echo "To $CLIENT KO_FILE_NAME PREFIX"
    sleep 2
    echo "KO_FILE_NAME" | nc "$CLIENT" $PORT
    exit 3
fi

NAME_FILE=`echo "$FILENAME" | awk '{print $2}'`
HASH_FILENAME=`echo "$FILENAME" | awk '{print $3}'`
echo "Name of the File recived: $NAME_FILE"
echo "Hash of the name recived: $HASH_FILENAME"
CHECK_FILE_HASH=`echo "$NAME_FILE" | md5sum | awk '{print $1}'`

if [ "$HASH_FILENAME" != "$CHECK_FILE_HASH" ];then
	echo "To $CLIENT KO_FILE_NAME MD5"
    sleep 2
    echo "KO_FILE_NAME" | nc "$CLIENT" $PORT
    exit 3
fi

echo "To $CLIENT OK_FILE_NAME"
sleep 2
echo "OK_FILE_NAME" | nc "$CLIENT" $PORT

echo "(13) Listen File"
nc -l -p $PORT -w $TIMEOUT > /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE"



echo "(16) Store & Send"
FILE=`cat /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE"`

if [ -z "$FILE" ];then
	echo "To $CLIENT (EMPTY DATA) KO_DATA"
	sleep 1
	echo "KO_DATA" | nc $CLIENT $PORT
	exit 4
fi
echo "To $CLIENT OK_DATA"
echo "OK_DATA" | nc $CLIENT $PORT

echo "(17) Listen Hash"
HASH=`nc -l -p $PORT -w $TIMEOUT`
echo "Hash from $CLIENT 's file $HASH"


echo "(20) Test & Send (Hash)"

PREFIX=`echo "$HASH" | awk '{print $1}'`

if [ $PREFIX != "FILE_MD5" ];then
	echo "To $CLIENT ERROR Prefix FILE_MD5"
	wait 1
	echo "KO_DATA" | nc $CLIENT $PORT
	exit 6
fi

HASH_FILE=`echo "$HASH" | awk '{print $2}'`
CREATE_HASH=`md5sum /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE"| awk '{print $1}'`

#Request file util its correct
#while [ "$CREATE_HASH" != "$HASH" ]
#do
	#echo "REQUEST_FILE" | nc $CLIENT $PORT
	#nc -l -p $PORT -w $TIMEOUT > /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE"
	#HASH=`nc -l -p $PORT -w $TIMEOUT`
	#echo $HASH
	#CREATE_HASH=`md5sum /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$NAME_FILE" | awk '{print $1}'`
#done

if [ "$HASH_FILE" != "$CREATE_HASH"  ];then
	echo "To $CLIENT MD5 it's not equal"
	wait 1
	echo "KO_FILE_MD5" | nc $CLIENT $PORT
	exit 6
fi

echo "OK_FILE_MD5" | nc $CLIENT $PORT
echo "To $CLIENT OK_FILE_MD5 RECIVED PERFECTLY"
exit 0
