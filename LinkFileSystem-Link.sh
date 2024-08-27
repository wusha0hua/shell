source /disk/configure/LinkFileSystem.sh
if [ $# != 2 ]
then
	PrintError "input error"
	exit
fi
linkfilename=$1
sourcefilepath=$2
nowpath=`pwd`
linkfilepath=${nowpath}"/"${linkfilename}
log=${linkfilepath}"->"${sourcefilepath}

echo ${log} >> ${global_log_file}

ln -s ${sourcefilepath} ${linkfilepath}
