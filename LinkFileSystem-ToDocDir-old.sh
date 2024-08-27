file_path='/disk/doc/'
source /disk/cfg/new.cfg

 if [ $# == 1 ] 
 then
	input_path=$1

	now_path=`pwd`

	input_path_array=(${input_path//\// })
	now_path_array=(${now_path//\// })

	input_path_array_len=${#input_path_array[@]}

	valid_path_array=(${valid_path//\// })
	valid_path_array_len=${#valid_path_array[@]}

	input_filename=${input_path_array[$( expr ${input_path_array_len} - 1 )]}

	echo ${input_filename}

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

	read -p 'input the doc name :' filename

	if [ -f ${filename} ]
	then
		echo "file exist"
		exit
	fi

	cp ${whole_path} ${file_path}${filename}

	rm ${whole_path}

	ln -s ${file_path}${filename} ${whole_path}

 else
	 echo "Uasge: tofile [file]"
 fi
