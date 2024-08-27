function Help()
{
	echo "Usage: new [path]"
}

source /disk/cfg/new.cfg
if [ $# == 1 ];
then
	input_path=$1
	
	now_path=`pwd`

	#echo input_path : ${input_path}
	#echo ${now_path}

	input_path_array=(${input_path//\// })
	now_path_array=(${now_path//\// })

	#echo ${input_path_array[@]}
	#echo ${now_path_array[@]}
	#exit

	input_path_array_len=${#input_path_array[@]}
	now_path_array_len=${#now_path_array[@]}
	#echo ${input_path_array_len}

	valid_path_array=(${valid_path//\// })
	valid_path_array_len=${#valid_path_array[@]}

	c=`echo ${input_path: -1}`
	#echo $c
	if [ $c == '/' ];
	then
		echo "can not new a directory"
		exit
	fi
	
	#echo $c
	#exit
	filename=${input_path_array[$( expr ${input_path_array_len} - 1 )]}

	for((i=0;i<valid_path_array_len;i++));
	do
		#echo ${valid_path_array[i]}
		if [ ${valid_path_array[i]} != ${input_path_array[i]} ];
		then
			break
		fi
	done


	if [ $i != ${valid_path_array_len} ]
	then
		if [ ${input_path: 0:1} != '/' ]
		then
			whole_path=`echo ${now_path}/${input_path}`
		else
			#whole_path=`echo ${now_path}/${input_path_array[$( expr ${input_path_array_len} - 1 )]}`
			whole_path=`echo ${now_path}/${filename}`
		fi
	else	
		whole_path=${input_path}
	fi

	#echo ${whole_path}
	#echo ${filename}
	
	if [ -f ${whole_path} ];
	then
		echo "link exist"
		exit
	fi

	for var in ${doc_type[@]};
	do
		if [ ${var} == ${filename##*.} ];
		then
			target_dir='/disk/doc/'
		fi
	done

	if [ -z ${target_dir} ];
	then
		for var in ${code_type[@]};
		do
			if [ ${var} == ${filename##*.} ];
			then
				target_dir='/disk/code/'
			fi
		done
	fi

	if [ -z ${target_dir} ];
	then
		read -p "input a directory:" target_dir
	fi

	if [ ${target_dir: -1} != '/' ];
	then
		target_dir=${target_dir}'/'
	fi

	#echo ${target_dir}

	if [ ! -d ${target_dir} ];
	then
		echo "no dir"
		exit
	fi
	
	read -p "input the file name :" create_filename
	#create_filename=`echo ${whole_path}|sed 's/\//%/g'`
	#echo ${create_filename}
	create_path=${target_dir}${create_filename}
	#echo ${create_path}
	
	#exit
	#echo ${create_path}

	if [ -f ${create_path} ];
	then
		echo "file exist"
		exit
	fi

	touch ${create_path}
	if [ $? != 0 ];
	then
		echo "create file fail"
		exit
	fi

	ln -s ${create_path} ${whole_path}
	if [ $? != 0 ];
	then
		echo "link fail"
		rm ${create_path}
		echo ${create_path} is deleted
		exit
	fi
	
	echo ${whole_path}'->'${create_path} >> ${log_path} 

else
	Help
fi

