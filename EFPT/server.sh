#!/bin/bash

PORT=3333
TIMEOUT=1

echo "Server de EFPT"
echo "(0) Listen" && echo ""
DATA=`nc -l -p $PORT -w $TIMEOUT`

PREFIX=`echo "$DATA" | awk '{print $1}'`
VERSION=`echo "$DATA" | awk '{print $2}'`
echo "Prefix $CLIENT: $PREFIX"
echo "Version $CLIENT: $VERSION "

echo "" && echo "(3) Test & Send" && echo ""
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


echo "" && echo "(4) Listen" && echo ""
DATA1=`nc -l -p $PORT -w $TIMEOUT`
echo $DATA1


echo "" && echo "(7) Test & Send" && echo ""
if [ "$DATA1" != "BOOOM" ];then
	echo "To $CLIENT KO_HANDSHAKE"
	sleep 1
    echo "KO_HANDSHAKE" | nc "$CLIENT" $PORT
    exit 2
fi

echo "To $CLIENT OK_HANDSHAKE"
sleep 2
echo "OK_HANDSHAKE" | nc "$CLIENT" $PORT


echo "" && echo "(12)Listen & Check file Num" && echo ""
FILENUM=`nc -l -p $PORT -w $TIMEOUT`
echo "File num is: $FILENUM"

if [ -z "$FILENUM" ]; then
	sleep 2
	echo "KO_NUM" | nc $CLIENT $PORT
	echo "KO_NUM CLIENT"
fi
sleep 2
echo "OK_NUM" | nc $CLIENT $PORT
echo "OK_NUM_OF_FILES"

echo "" && echo "(23) Listen & Check files sended" && echo ""
for files in $(seq 1 $FILENUM);do

	FILECLIENT=`nc -l -p $PORT -w $TIMEOUT`
	echo "NAME & HASH $CLIENT: $FILECLIENT"

	PREFIX=`echo "$FILECLIENT" | awk '{print $1}'`
	if [ "$PREFIX" != "FILE_MD5" ];then
		echo "KO_FILE" | nc $CLIENT $PORT
		echo "KO_FILE_WRONG_PREFIX"
		exit 7
	fi

	FILENAME=`echo "$FILECLIENT" | awk '{print $2}'`
	#echo "Name of the file: $FILENAME"
	
	if [ -z $FILENAME ];then
		echo "KO_FILE" | nc $CLIENT $PORT
		echo "KO_FILE_NAME_EMPTY"
		exit 7
	fi
	HASHFILE=`echo "$FILECLIENT" | awk '{print $3}'`
	# echo "Hash recived from file: $HASHFILE"

	HASHCHECK=`echo "$FILENAME" | md5sum | awk '{print $1}'`
	echo "Local hash: $HASHCHECK"

	if [ "$HASHFILE" != "$HASHCHECK" ];then
		echo "KO_FILE" | nc $CLIENT $PORT
		echo "KO_FILE_HASH"
		exit 7
	fi
	echo "OK_FILE" | nc $CLIENT $PORT
	echo "FileName $FILENAME Success"
	
	nc -l -p $PORT -w $TIMEOUT > /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$FILENAME"
	
	FILE=`cat /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$FILENAME"`

	if [ -z "$FILE" ];then
		sleep 2
		echo "KO_SEND_FILE" | nc $CLIENT $PORT
		echo "KO_SEND_FILE: $FILENAME EMPTY FROM: $CLIENT" >> /home/enti/M01UF2/EFPT/logs/files_send.log
	else
		sleep 1
		echo "OK_SEND_FILE" | nc $CLIENT $PORT

		RECIVEDHASH=`nc -l -p $PORT -w $TIMEOUT`
		PREFIX=`echo "$RECIVEDHASH" | awk '{print $1}'`
		echo "$RECIVEDHASH"
		if [ "$PREFIX" != "SEND_MD5" ];then
			sleep 2
			echo "KO_MD5" | nc $CLIENT $PORT
			echo "KO_MD5_PREFIX: FILE $FILENAME FROM: $CLIENT" >> /home/enti/M01UF2/EFPT/logs/files_send.log
		else
			echo "OK_MD5_PREFIX"
			HASHCREATED=`md5sum /home/enti/M01UF2/EFPT/inbox/"$CLIENT"_"$FILENAME" | awk '{print $1}'`
			HASH=`echo "$RECIVEDHASH" | awk '{print $2}'`

			if [ "$HASH" != "$HASHCREATED" ];then
				sleep 2
				echo "KO_MD5" | nc $CLIENT $PORT
				echo "KO_MD5_MD5 DON'T MATCH: FILE $FILENAME FROM: $CLIENT" >> /home/enti/M01UF2/EFPT/logs/files_send.log

			else
				sleep 2
				echo OK_MD5	| nc $CLIENT $PORT
				echo "OK_MD5 $FILENAME FROM $CLIENT"
			fi
		fi		
	fi
	((COUNTER++))
done
exit 0
