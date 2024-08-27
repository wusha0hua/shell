function Usage()
{
	echo "Usage : change [path]filename"
}


function ifInputValid()
{
	input=$1
	if [ $1 == 1 ]
	then
		echo 0
	else
		echo 1
	fi
}


function getFilePath()
{
	oldfilepath=$1
	if [ ${oldfilepath:0:1} == '/' ]
	then
		echo ${oldfilepath}
	else
		echo `pwd`"/"${oldfilepath}
	fi
}

# main function
source /disk/configure/LinkFileSystem.sh
if [ $(ifInputValid $#) != 0 ] 
then
	Usage
	exit
fi

oldfilepath=$(getFilePath $1)
oldfilename=${oldfilepath##*/}

found=0
i=0
for line in `cat ${global_log_file}`
do
	line_arr=(${line/->/ })
	linkpath=${line_arr[0]}
	sourcepath=${line_arr[1]}
	sourcename=${sourcepath##*/}
	sourcedir=${sourcepath%/*}
	suffix=${sourcename##*.}

	if [ "${sourcename}" == "${oldfilename}" ]
	then
		found=1
		n=$( expr $i + 1 )
		break
	fi

	i=$(expr $i + 1)
done


if [ ${found} == 0 ]
then
	PrintError "${oldfilepath} not found in log"
	exit
fi

ifs=$IFS
IFS="-"
oldfilename_arr=(${oldfilename%.*})
IFS=${ifs}


newfilename=""
for((i=0;i<${global_name_arr_len};i++))
do
	read -p "${global_name_arr[$i]}:" item
	if [ "${item}" == "" ]
	then
		newfilename=${newfilename}${oldfilename_arr[$i]}
	elif [ "${item}" == "-" ]
	then
		newfilename=${newfilename}
	else
		newfilename=${newfilename}${item}
	fi

	if [ $i != $(expr ${global_name_arr_len} - 1 ) ]
	then
		newfilename=${newfilename}"-"
	fi
done

newlog=${linkpath}"->"${sourcedir}"/"${newfilename}"."${suffix}
./lfs-log.sh
sed -i  "${n}c ${newlog}" ${global_log_file}

mv ${sourcepath} ${sourcedir}"/"${newfilename}"."${suffix}

rm ${linkpath}

ln -s ${sourcedir}"/"${newfilename}"."${suffix} ${linkpath}


