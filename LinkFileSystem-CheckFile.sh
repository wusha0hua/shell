source /disk/configure/LinkFileSystem.sh

docfile_arr=($(ls ${global_file_dir}))

echo -n "" > ${global_chkfile_log_file}

for filefilename in ${filefile_arr[@]}
do
	filefilepath=${global_file_dir}/${filefilename}
	
	sourcefound=0
	for log in `cat ${global_log_file}`
	do
		log_arr=(${log/->/ })
		linkpath=${log_arr[0]}
		sourcepath=${log_arr[1]}
	
		if [ "${sourcepath}" == "${filefilepath}" ]
		then
			sourcefound=1
			if [ ! -h ${linkpath} ]
			then
				echo "${filefilename}'s link ${linkpath} not found">>${global_chkfile_log_file}
				echo "${filefilename}'s link ${linkpath} not found"
			fi
		fi
	done

	if [ ${sourcefound} == 0 ]
	then
		echo "${filefilename} not found" >> ${global_chkfile_log_file}
		echo "${filefilename} not found"
	fi

done
