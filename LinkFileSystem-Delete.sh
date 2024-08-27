function Usage()
{
	echo "Uasge : del [path]linkname"
}


function ifInputValid()
{
	if [ $1 != 1 ]
	then
		echo 0
		return 0
	else
		echo 1
		return 1
	fi
}


function getLinkPath()
{
	
	inputpath=$1
	if [ ${inputpath:0:1} == '/' ]
	then
		ret=${inputpath}
	else
		ret=`pwd`"/"${inputpath}
	fi
	echo ${ret}
}

# main function

source /disk/configure/LinkFileSystem.sh

if [ 0 == $(ifInputValid $#) ]
then
	Usage
	exit
fi

linkpath=$(getLinkPath $1)
if [ ! -h ${linkpath} ]
then
	PrintError "${linkpath} is not a link"
	exit
fi

sourcepath=`readlink ${linkpath}`
if [ ! -f ${sourcepath} ]
then
	PrintError "${sourcepath} is not exist"
	exit
fi


search=${linkpath}"->"${sourcepath}

find=`grep "^${search}$" ${global_log_file}`

if [ ${find} == "" ]
then
	PrintError "log ${search} not found"
	exit
fi

read -p "delete source file ${sourcepath}? [n/y]" del

if [ "${del}" == 'y' -o "${del}" == 'Y' ]
then
	rm ${sourcepath}	
fi

rm ${linkpath}

find=${find//\//\\\/}
sed -i "/^${find}$/d" ${global_log_file}


