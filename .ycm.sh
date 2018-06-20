#!/bin/bash


prj_dir=$(cd `dirname $0`; pwd)
new_ycm_conf() {
	filelist=$(find $prj_dir | grep -E "^.*\.h$")
	target="$prj_dir/.ycm_extra_conf.py"
	echo -n > ${target}
	tmp="$prj_dir/.ycm_extra_conf.tmp"
	ifs=$IFS
	IFS=
	cat ${tmp} | while read line
	do
		if [[ $(echo $line | xargs) == ']' ]]; then
			IFS=$ifs
			filelist=$(find $prj_dir | grep -E "^.*\.h$")
			for file in ${filelist}
			do
				echo $file
				echo '*'
				echo "    '-I'," >> ${target}
				echo "    '$(dirname "${file}")', " >> ${target}
			done
			echo "$line" >> ${target}
			ifs=$IFS
			IFS=
		else
			echo "$line" >> ${target}
		fi
	done
	IFS=$ifs
}

new_indexer_tag() {
	index=~/.indexer_files
	prj_name=$(basename ${prj_dir})
	$(grep ${prj_name} ${index} -q)
	if [ $? -ne 0 ]
	then
		echo "" >> ${index}
		echo "[${prj_name}]">> ${index}
		echo ${prj_dir} >> ${index}
	fi
}
new_ycm_conf
new_indexer_tag

