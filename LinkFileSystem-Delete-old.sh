function Help()
{
	echo "Usage: del [path]"
}

source /disk/cfg/new.cfg

if [ $# == 1 ]
then
	input_path=$1
	
	now_path=`pwd`

	input_path_array=(${input_path//\// })
	now_path_array=(${now_path//\// })

	#echo ${input_path_array[@]}
	#echo ${now_path_array[@]}

	input_path_array_len=${#input_path_array[@]}
	now_path_array_len=${#now_path_array[@]}

	if [ ${input_path: 0:1} == '\' ]
	then
		link_path=${input_path}
	else
		link_path=${now_path}/${input_path}
	fi

	if [ ! -L ${link_path} ]
	then
		echo "${link_path} is not a link"
		exit
	fi

	target_path=`readlink ${link_path}`

	#echo ${target_path}

#	matched=0
#
#	for line in `cat ${log_path}`
#	do
#		log_array=(${line//'->'/ })
#		link_path_log=${log_array[0]}
#		#target_path_log=${log_array[1]}
#	
#		if [ ${#link_path} != ${#link_path_log} ]
#		then
#			continue
#		fi
#
#		if [ ${#target_path} != ${#target_path_log} ]
#		then
#			continue
#		fi
#
#		for((i=0;i<${#link_path};i++))
#		do
#			if [ ${link_path: $i:1} != ${link_path_log: $i:1} ]
#			then
#				break
#			fi
#		done
#
#		if [ $i == ${#link_path} ]
#		then
#			for((j=0;j<${#target_path};j++))
#			do
#				if [ ${target_path: $j:1} != ${target_path_log: $j:1} ]
#				then
#					break
#				fi
#			done
#
#			if [ $j == ${#target_path} ]
#			then 
#				matched=1
#				break
#			fi
#		fi
#
#	done

	match_path=${link_path}'->'${target_path}
	#echo ${match_path}
	
	ret=`cat ${log_path}|grep "^${match_path}$"`

	if [ -z ${ret} ]
	then
		echo "no such record"
	fi

	if [ ! -f ${target_path} ]
	then
		echo "target file not exist"
		exit
	fi

	read -p "remove the real file (y/n):" select

	if [ ${select} == 'y' ]
	then
		rm ${target_path}
	fi

	rm ${link_path}

	ret=${ret//\//\\\/}
	
	#echo ${ret}
	sed -i "/^${ret}$/d" ${log_path}


else
	Help
fi
