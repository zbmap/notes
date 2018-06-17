#!/bin/bash

TMP=.tmp
prj_dir=$(cd `dirname $0`; pwd)
filelist=$(find $prj_dir | grep -E "^.*\.h$")
for file in ${filelist}
do
	echo $(dirname "${file}") >> ${TMP}
done

TARGET="$prj_dir/.ycm_extra_conf.py"
YCMPY1="$prj_dir/.ycm_extra_conf.beg"
YCMPY2="$prj_dir/.ycm_extra_conf.end"
cat ${YCMPY1} > ${TARGET}
DIR=$(cat ${TMP} | sort -u)
for i in ${DIR}
do
	echo "'-I'," >> ${TARGET}
	echo "'${i}'," >> ${TARGET}
done
cat ${YCMPY2} >> ${TARGET}

rm -rf ${TMP}

INDEX=/home/zb/.indexer_files
prj_name=$(basename ${prj_dir})
$(grep ${prj_name} ${INDEX} -q)
if [ $? -eq 0 ]
then
	echo "already added in ${INDEX}"
else
	echo "" >> ${INDEX}
	echo "[${prj_name}]">> ${INDEX}
	echo ${prj_dir} >> ${INDEX}
fi
