source /disk/configure/LinkFileSystem.sh

docfile_arr=($(ls ${global_doc_dir}))

echo -n "" > ${global_chkdoc_log_file}

for docfilename in ${docfile_arr[@]}
do
	docfilepath=${global_doc_dir}/${docfilename}
	
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
				echo "${docfilename}'s link ${linkpath} not found">>${global_chkdoc_log_file}
				echo "${docfilename}'s link ${linkpath} not found"
			fi
		fi
	done

	if [ ${sourcefound} == 0 ]
	then
		echo "${docfilename} not found" >> ${global_chkdoc_log_file}
		echo "${docfilename} not found"
	fi

done
