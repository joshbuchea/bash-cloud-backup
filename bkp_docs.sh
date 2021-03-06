#!/bin/bash
#----------------------------------------------------------------------------------
# SCRIPT.........: bkp_docs
# ACTION.........: Performs backup of selected documents (in conf/docs)
# COPYRIGHT......: Christos Pontikis - http://www.pontikis.gr
# LICENSE........: MIT (see https://opensource.org/licenses/MIT)
# DOCUMENTATION..: See README for instructions
#----------------------------------------------------------------------------------

scriptpath=`dirname "$0"`
if [ $scriptpath = "." ]; then scriptpath=''; else scriptpath=${scriptpath}/; fi

# include config script
source ${scriptpath}conf/config.sh
# include init script
source ${scriptpath}common/init.sh

createlog "-Daily backup of DOCS is starting..."

currentdir="$backuproot/$dir_docs"
if [ ! -d $currentdir ]; then $MKDIR $currentdir; fi

# create temp dir to store backup_list
tmpdir=$currentdir/tmp
if [ -d $tmpdir ]; then $RM -rf $tmpdir; fi
$MKDIR $tmpdir;

for line in `cat ${scriptpath}conf/docs |grep ^/`
do
  $FIND $line -type f >> $tmpdir/backup_list
done

# tar files
dt=`$DATE +%Y%m%d.%H%M%S`
listfile=$currentdir/docs-$dt-list.tar
bkpfile=$currentdir/docs-$dt.tar
createlog "---creating tar $bkpfile..."
$TAR $tar_docs_list $listfile $tmpdir/backup_list > /dev/null
$TAR $tar_docs $bkpfile -T $tmpdir/backup_list > /dev/null

# compress files
zip_file $listfile
zip_file $bkpfile

# rotating delete
rotate_delete $currentdir 2

createlog "-Daily backup of DOCS completed."