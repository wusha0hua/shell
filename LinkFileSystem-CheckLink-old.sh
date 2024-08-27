source /disk/cfg/new.cfg

log_path='/disk/doc/link.log'

for line in `cat ${log_path}`
do
	line_array=(${line//'->'/ })
	link_path=${line_array[0]}
	target_path=${line_array[1]}

	if [[ ! -L ${link_path} ]] && [[ -f ${target_path} ]]
	then
		echo 'no link file but target file exist'
		echo 'log: '${line}
	elif [[ ! -L ${link_path} ]] && [[ ! -f ${target_path} ]]
		echo 'no link file and no target file'
		echo "log: "${line}
	elif [[ -L ${link_path} ]] && [[ ! -f ${target_path} ]]
		echo 'link file exist but no target file'
		echo 'log: '${line}
	fi

	
done
