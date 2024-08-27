file_path='/disk/dir/'
source /disk/cfg/new.cfg

 if [ $# == 2 ] 
 then
	input_path=$1
	
	input_dir=$2

	now_path=`pwd`

	input_path_array=(${input_path//\// })
	now_path_array=(${now_path//\// })

	input_path_array_len=${#input_path_array[@]}

	valid_path_array=(${valid_path//\// })
	valid_path_array_len=${#valid_path_array[@]}

	input_filename=${input_path_array[$( expr ${input_path_array_len} - 1 )]}


	for((i=0;i<valid_path_array_len;i++))
	do
		if [ ${valid_path_array[i]} != ${input_path_array[i]} ]
		then
			break
		fi
	done

	if [ $i != ${valid_path_array_len} ]
	then
		if [ ${input_path: 0:1} != '/' ]
		then
			whole_path=${now_path}/${input_path}
		else
			whole_path=${now_path}/${input_filename}
		fi
	else
		whole_path=${input_path}
	fi
	
	if [ ${input_dir: 0:1} == '/'  ]
	then 
		echo "dir name error"
		exit
	fi

	if [ ! -d ${file_path}${input_dir} ]
	then
		echo "no "${file_path}${input_dir}'/' 
	fi

	if [ ${input_dir: -1:1} != '/' ]
	then
		input_dir=${input_dir}'/'
	fi
	
	if [ ! -L ${whole_path} ]
	then
		echo ${whole_path}" is not link"
		exit
	fi

	target_path=`readlink ${whole_path}`

	target_path_array=(${target_path//\// })

	target_path_array_len=${#target_path_array[@]}

	filename=${target_path_array[$( expr ${target_path_array_len} - 1 )]}

	ln -s ${target_path} ${file_path}${input_dir}${filename}
 else
	 echo "Usage: todir [file] [dir]"
 fi
