function Usage()
{
	echo "Usage : todir [path]filename targetdir"
}

function ifInputValid()
{
	input_len=$1
	if [ ${input_len} == 2 ]
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

	return 1	
}

function getFileName()
{
	ret=""
	linkfilename=$1
	suffix=$2

	for((i=0;i<${global_name_arr_len};i++))
	do
		if [ ${global_name_arr[$i]} == "linkname" ]
		then
			ret=${ret}${linkfilename}"-"
			continue
		fi
		
		if [ ${global_name_arr[$i]} == "language" ] 
		then
			for((j=0;j<${#global_language_arr[@]};j++))
			do
				if [ ${suffix} == ${global_suffix_arr[$j]} ]
				then
					ret=${ret}${global_language_arr[$j]}"-"
					break
				fi
				if [ $j == ${#global_language_arr[@]} ]
				then
					ret=${ret}"none-"
				fi
			done
			continue
		fi

		if [ ${global_name_arr[$i]} == "time" ]
		then
			time=$(date "+%Y%m%d%H%M%S")
			ret=${ret}${time}"-"
			continue
		fi
		read -p "${global_name_arr[$i]}:" input
		ret=${ret}${input}
		if [ $i != `expr ${global_name_arr_len} - 1` ]
		then
			ret=${ret}"-"
		fi
	done

	echo ${ret}
}

#main function 

source /disk/configure/LinkFileSystem.sh

if [ 0 == $(ifInputValid $#) ]
then
	Usage
	exit
fi

linkpath=$1
dirpath=$2
linkpath_arr=(${linkpath//\// })
linkpath_arr_len=${#linkpath_arr[@]}

linkpath=$(getLinkPath ${linkpath_arr} ${linkpath_arr_len} ${linkpath})


if [  $(ifLinkPathValid ${linkpath}) ]
then
	PrintError "${linkpath} is not in ${global_root_dir}"
	exit
fi

isfile=1
if [ ! -f ${linkpath} ]
then
	if [ -h ${linkpath} ]
	then
		isfile=0
	else
		PrintError "${linkpath} not found"
		exit
	fi
fi



if [ ! -d "/disk/${dirpath}" ]
then
	PrintError "/disk/${dirpath} not found"
	exit
fi

linkfilename=${linkpath_arr[-1]}
suffix=${linkfilename##*.}

if [ ${isfile} == 1 ]
then
	filename=$(getFileName ${linkfilename} ${suffix})"."${suffix}
	
	mv ${linkpath} "/disk/dir/sourcefile/"${filename}
	if [ $? != 0 ]
	then
		PrintError "create /disk/dir/sourcefile/${filename} error"
	fi
	
	ln -s "/disk/dir/sourcefile/${filename}" ${linkpath}
	if [ $? != 0 ]
	then
		PrintError "link error"
		rm "/disk/dir/sourcefile/${filename}"
		exit
	fi

	ln -s "/disk/dir/sourcefile/"${filename} "/disk/dir/${dirpath}${filename}" 
	if [ $? != 0 ]
	then
		PrintError "link /disk/dir/${dirpath}"
		rm "/disk/dir/sourcefile/${filename}" ${linkpath}
		exit
	fi

	echo ${linkpath}"->/disk/dir/sourcefile/"${filename} >> ${global_log_file}
	if [ $? != 0 ]
	then 
		PrintError "log error"
		rm "/disk/dir/sourcefile/"${filename} ${linkpath}
		exit
	fi

	echo "/disk/dir${dirpath}${filename}->/disk/dir/sourcefile/${filename}" >> ${global_log_file}
	if [ $? != 0 ]
	then
		PrintError "log error"
		exit
	fi

else
	sourcepath=`readlink ${linkpath}`
	
	sourcename=${sourcepath##*/}

	ln -s ${sourcepath} "/disk/dir/${dirpath}/${sourcename}"
	if [ $? != 0 ]
	then 
		PrintError "link error"
		exit
	fi

	echo "/disk/dir/${dirpath}/${sourcename}->${sourcepath}" >> ${global_log_file}
	if [ $? != 0 ]
	then
		PrintError "log error"
		exit
	fi
fi


