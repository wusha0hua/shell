function Usage()
{
	echo "Usage : nw [path]filename"
}

function ifInputValid()
{
	input_len=$1
	if [ ${input_len} == 1 ]
	then
		echo 1
		return 1
	else
		echo 0
		return 0
	fi
	
}

function ifLinkPathValid()
{
	linkpath=$1
	
	for((i=0;i<${#global_root_dir};i++))
	do
		if [ ${linkpath:$i:1} != ${global_root_dir:$i:1} ]
		then
			echo 0
			return 0
		fi
	done
	
	if [ $i == ${#linkpath} ]
	then
		echo 1
	fi
}


function getLinkPath()
{
	linkpath_arr=$1
	linkpath_arr_len=$2
	linkpath=$3

	if [ ${linkpath: -1} == '/' ]
	then
		PrintError "please input a file not directory"
		exit
	fi

	if [ ${linkpath:0:1} == '/' ]
	then
		ret=${linkpath}
	else
		ret=`pwd`/${linkpath}
	fi

	echo ${ret}
}

function getStoragePath()
{
	suffix=$1


	for((i=0;i<${global_code_suffix_arr_len};i++))
	do
		if [ ${suffix} == ${global_code_suffix_arr[$i]} ]
		then
			echo ${global_code_dir}
			return 0
		fi
	done

	for((i=0;i<${global_doc_suffix_arr_len};i++))
	do
		if [ ${suffix} == ${global_doc_suffix_arr[$i]} ]
		then
			echo ${global_doc_dir}
			return 0
		fi
	done

	for((i=0;i<${global_cfg_suffix_arr_len};i++))
	do
		if [ ${suffix} == ${global_cfg_suffix_arr[$i]} ]
		then
			echo ${global_cfg_dir}
			return 0
		fi
	done

	for((i=0;i<${global_file_suffix_arr_len};i++))
	do
		if [ ${suffix} == ${global_file_suffix_arr[$i]} ]
		then
			echo ${global_file_dir}
			return 0
		fi
	done

	return 1	
}

function getFileName()
{
	ret=""
	linkpath=$1

	time=$(date "+%Y%m%d%H%M%S")
	echo ${linkpath}"-"${time}|base64
}

#main function 

source /disk/configure/LinkFileSystem.sh

if [ 0 == $(ifInputValid $#) ]
then
	Usage
	exit
fi

linkpath=$1
linkpath_arr=(${linkpath//\// })
linkpath_arr_len=${#linkpath_arr[@]}

linkpath=$(getLinkPath ${linkpath_arr} ${linkpath_arr_len} ${linkpath})


if [  $(ifLinkPathValid ${linkpath}) ]
then
	PrintError "${linkpath} is not in ${global_root_dir}"
fi

linkfilename=${linkpath_arr[-1]}
suffix=${linkfilename##*.}

otherfile=0
storagepath=$(getStoragePath ${suffix})
if [ $? != 0 ]
then
	otherfile=1

	PrintWarning "target directory not found"

	echo "("${global_target_dir_arr[@]}")"

	read -p "input target directory:" inputdir
	
	for((i=0;i<${#global_target_dir_arr[@]};i++))
	do
		if [ ${inputdir} == ${global_target_dir_arr[$i]} ]
		then
			storagepath="/disk/"${inputdir}
			break
		fi
	done
	
	if [ $i == ${#global_target_dir_arr[@]} ]
	then
		PrintError "no tartget directory"
		exit
	fi
fi


filename=$(getFileName ${linkpath})

touch ${storagepath}/${filename}
if [ $? != 0 ]
then
	PrintError "create ${storagepath}/${filename} error"
	exit
fi

ln -s ${storagepath}/${filename} ${linkpath}
if [ $? != 0 ]
then
	PrintError "link file ${linkpath} create error"
	rm ${storagepath}/${filename}
	exit
fi

echo ${linkpath}"->"${storagepath}/${filename} >> ${global_log_file}
if [ $? != 0 ]
then
	PrintError "log error"
	rm ${storagepath}/${filename} ${linkpath}
	exit
fi




