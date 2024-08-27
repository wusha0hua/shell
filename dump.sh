source /disk/configure/LinkFileSystem.sh

for line in `cat ${global_log_file}`
do
	log_arr=(${line/->/ })

	link_path=${log_arr[0]}
	file_path=${log_arr[1]}

	mv ${file_path} ${link_path}
done
