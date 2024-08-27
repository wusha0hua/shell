source /disk/configure/LinkFileSystem.sh

l=1
echo -n "" > ${global_chklog_log_file} 
for line in `cat ${global_log_file}`
do
	line_arr=(${line/->/ })
	linkpath=${line_arr[0]}
	sourcepath=${line_arr[1]}
	
	if [ ! -h ${linkpath} ]
	then
		if [ ! -f ${sourcepath} ]
		then
			echo "${linkpath} not found and ${sourcepath} not found in ${line}">>${global_chklog_log_file}
			echo "${linkpath} not found and ${sourcepath} not found in ${line}"
		else
			echo "${linkpath} not found in ${line}">>${global_chklog_log_file}
		fi
	else
		if [ ! -f ${sourcepath} ]
		then
			echo "${sourcepath} not found in ${line}">>${global_chklog_log_file}
			echo "${sourcepath} not found in ${line}"
		fi
	fi

	l=$( expr $l + 1 )
done
