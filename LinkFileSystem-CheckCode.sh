source /disk/configure/LinkFileSystem.sh

codefile_arr=($(ls ${global_code_dir}))

echo -n "" > ${global_chkcode_log_file}

for codefilename in ${codefile_arr[@]}
do
	codefilepath=${global_code_dir}/${codefilename}
	
	sourcefound=0
	for log in `cat ${global_log_file}`
	do
		log_arr=(${log/->/ })
		linkpath=${log_arr[0]}
		sourcepath=${log_arr[1]}
	
		if [ "${sourcepath}" == "${codefilepath}" ]
		then
			sourcefound=1
			if [ ! -h ${linkpath} ]
			then
				echo "${codefilename}'s link ${linkpath} not found">>${global_chkcode_log_file}
				echo "${codefilename}'s link ${linkpath} not found"
			fi
		fi
	done

	if [ ${sourcefound} == 0 ]
	then
		echo "${codefilename} not found" >> ${global_chkcode_log_file}
		echo "${codefilename} not found"
	fi

done
