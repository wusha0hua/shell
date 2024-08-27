source /disk/configure/LinkFileSystem.sh

if [ $# != 1 ]
then
	echo "Usage : de [path]file"
	exit
fi

inputfile=$1
decode=`echo ${inputfile} | base64 -d`

decode_arr=(${decode/-/ })

if [ ${#decode_arr[@]} != 2 ]
then
	PrintError "format error"
	exit
fi

linkpath=${decode_arr[0]}
linkname=${linkpath##*/}
time=${decode_arr[1]}
suffix=${linkname##*.}

if [ ! -h ${linkpath} ]
then
	PrintError "${linkpath} not found"
	exit
fi

found=0
l=1
for line in `cat ${global_log_file}`
do
	log_arr=(${line/->/ })
	if [ ${log_arr[1]} == "`pwd`/${inputfile}" ]
	then
		found=1
		if [ ${log_arr[0]} != ${linkpath} ]
		then
			PrintError "link error"
			exit
		fi
		break
	fi
	l=$( expr $l + 1 )
done

if [ ${found} == 0 ]
then
	PrintError "${inputfile} not found in log"
	exit
fi

newname=""
for((i=0;i<${global_name_arr_len};i++))
do
	if [ ${global_name_arr[$i]} == "linkname"  ]
	then
		newname=${newname}${linkname}

	elif [ ${global_name_arr[$i]} == "time" ]
	then
		newname=${newname}${time}

	elif [ ${global_name_arr[$i]} == "language" ]
	then
		suffixfound=0
		for((j=0;j<${#global_suffix_arr[@]};j++))
		do
			if [ ${suffix} == ${global_suffix_arr[$j]} ]
			then
				suffixfound=1
				newname=${newname}${global_language_arr[$j]}
				break
			fi
		done

		if [ ${suffixfound} == 0 ]
		then
			read -p "language:" lang
			newname=${newname}${lang}
		fi
	else
		read -p "${global_name_arr[$i]}:" input
		newname=${newname}${input}
	fi	

	if [ $i != $( expr ${global_name_arr_len} - 1 ) ]
	then
		newname=${newname}"-"
	fi

done

newname=${newname}"."${suffix}

log="${linkpath}->`pwd`/${inputfile}"
newlog="${linkpath}->`pwd`/${newname}"

sed -i "${l}c ${newlog}" ${global_log_file}

rm ${linkpath}
mv `pwd`/${inputfile} `pwd`/${newname}

ln -s `pwd`/${newname} ${linkpath}

