


# main function

source /disk/configure/LinkFileSystem.sh

for((i=0;i<${global_name_arr_len};i++))
do
	echo -n ${i}":"${global_name_arr[$i]}" "	
done
echo 

read -p "input position [0-$(expr ${i} - 1 )]:" pos


if [ ${pos} -gt ${i} -o ${pos} -lt 0 ]
then
	PrintError "position not found"
	exit
fi

name_arr=()
for((i=0;i<${global_name_arr_len};i++))
do 
	if [ $i == ${pos} ]
	then
		continue
	fi
	name_arr=(${name_arr[@]} ${global_name_arr[$i]})
done


line=`sed -n 1p /disk/configure/LinkFileSystem.sh`

newline="global_name_arr=(${name_arr[@]})"

sed  -i "s/^${line}$/${newline}/" /disk/configure/LinkFileSystem.sh 

echo ${newline}

l=1
for line in `cat ${global_log_file}`
do
	line_arr=(${line/->/ })
	linkpath=${line_arr[0]}
	linkdir=${linkpath%/*}
	linkname=${linkpath##*/}
	sourcepath=${line_arr[1]}
	sourcedir=${sourcepath%/*}
	sourcename=${sourcepath##*/}
	suffix=${sourcename##*.}

	ifs=$IFS
	IFS="-"
	source_arr=(${sourcename%.*})
	IFS=${ifs}
	source_arr_len=${#source_arr[@]}

	if [ ${#source_arr[@]} == 1 ]
	then
		continue
	fi

	newname=""
	newlog=${linkpath}"->"${sourcedir}"/"

	for((i=0;i<${source_arr_len};i++))
	do
		if [ $i == ${pos} ]
		then
			continue
		fi
		
		newlog=${newlog}${source_arr[$i]}
		newname=${newname}${source_arr[$i]}

		if [ $i != $( expr $source_arr_len - 1) ]
		then
			if [ $i == $( expr ${source_arr_len} - 2 ) -a ${pos} == $( expr ${source_arr_len} - 1 ) ]
			then
				continue
			fi
			newlog=${newlog}"-"
			newname=${newname}"-"
		fi

	done
	
	newname=${newname}"."${suffix}
	newlog=${newlog}"."${suffix}
    
	sed -i "${l}c ${newlog}" ${global_log_file}

	rm ${linkpath}

	mv ${sourcepath} ${sourcedir}/${newname}

	ln -s ${sourcedir}/${newname} ${linkpath}

	l=$( expr $l + 1 )

done



