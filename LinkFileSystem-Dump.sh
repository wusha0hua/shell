# main function
source /disk/configure/LinkFileSystem.sh

if [ $# != 1 ]
then
	echo "Usage : exhange [path]file"
	exit
fi

inputpath=$1

if [ ${inputpath:0:1} == '/' ]
then
	linkpath=${inputpath}
else
	linkpath=`pwd`/${inputpath}
fi

sourcepath=`readlink ${linkpath}`

log=${linkpath}"->"${sourcepath}

log_escape=${log//\//\\\/}
sed -i "/${log_escape}/d" ${global_log_file}

sourcename=${sourcepath##*/}
linkname=${linkpath##*/}

linkdir=${linkpath%/*}

cp ${sourcepath} ${linkdir}/${sourcename}


