#!/bin/bash
#notice mount 

function help()
{                                                                                            
	echo "                    
	NAME                          
		$0 - resize file for github upload size limit
	Usage:
			$0 {reduce/restore}	 filename
			run advice: reduce -> restore 
	notice: reduce file will create filename.split Dir
	"                             
}   

if [  $# -eq 0 ] ;then
	help
	exit 0
fi
CMD=$1
FILE=$2
PREFIX=unit
function reduceprocess()
{
	if [ -f ${FILE} ]; then
		echo "start resize"
	else
		echo "do not have file:${FILE}"
		exit 1
	fi	
	mkdir -p ./${FILE}.split
	cd ${FILE}.split
	md5sum ../${FILE} |cut -f 1 -d " " |tee > ${FILE}.checksum
	
	split -b 1M -d -a 5 ../${FILE} ${PREFIX}
	
	echo "split done"
	
}
function restoreprocess()
{
	if [ -d ${FILE}.split ]; then
		echo "start restore"
		cd ${FILE}.split
		cat ${PREFIX}* > ${FILE}

	else
		echo "do not have Dir"
		exit 0
	fi
	TMP=$(md5sum ${FILE} |cut -f 1 -d " ")
	RAW=$(cat ${FILE}.checksum)
	if [ ${RAW} = ${TMP} ]; then
		echo "md5sum check pass"
	else
		echo "md5sum check failed"
		echo "	raw checksum :${RAW}"
		echo "	now checksum :${TMP}"
	fi
}
if [ "${CMD}" = "reduce" ]; then    
       
	reduceprocess
	exit 0 
elif [ "${CMD}" = "restore" ]; then  

	restoreprocess
	exit 0 
else  

	help
	exit 0 
fi    
