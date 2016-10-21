#!/bin/sh
# company : Team Brainworks
# Author  : Chandrakant Nakhate 
# This shell sript creates dynamic parameter file
# ---------------------------------------------------------------------------------------------------------
 
## date format ##
NOW=$(date +"%F")
NOWT=$(date +"%T")
 
## log file ##
path="/home/server/log/"
filename="query-$NOW-$NOWT.log"
querylogfile=$path$filename
touch $querylogfile
 
## dbuser info ##
DBUSER='system';
DBUSERPASSWORD='system';
MYDB='xe';
 
## parafile path ##
path="/home/server/outputfile/"
filename="para_test.txt"
filepath=$path$filename
#rm $filepath
#touch $filepath
 
## Get table data ##
sqlretrieve()
{

sqlresult=$(
sqlplus -s $DBUSER/$DBUSERPASSWORD@$MYDB  <<END
set pagesize 40000 LINESIZE 80 feedback off verify off heading off echo off;

$1      
 
exit;
END
)
echo $sqlresult

}

## GLOBAL PARAMETER ##
row=$(sqlretrieve "select PARAMETERNAME||'='||PARAMETERVALUE from ETL_GLOBAL_CONFIG;")
echo $querylogfile-Call of function>>$querylogfile
echo [GLOBAL]>$filepath
for p in $row; do
  echo $p>>$filepath
done

## SESSION PARAMETER ##
echo $querylogfile-Call of function>>$querylogfile
rows=$(sqlretrieve "SELECT rtrim(FOLDERNAME)||'|'||rtrim(WORKFLOWNAME)||'|'||rtrim(MAPPINGNAME) from mappinginfo group by FOLDERNAME,WORKFLOWNAME,MAPPINGNAME;")

for row in $rows; 
do          
          
		  f=$(echo $row |cut -d'|' -f1)
		  w=$(echo $row |cut -d'|' -f2)
		  m=$(echo $row |cut -d'|' -f3)
	    
	echo '\n['$f'.WF:'$w'.ST:s_'$m']'>>$filepath
echo $querylogfile-Call of function>>$querylogfile
para=$(sqlretrieve "SELECT PARAMETERNAME||'='||CURR_VALUE AS from mappinginfo 
where FOLDERNAME='$f' and WORKFLOWNAME='$w' and MAPPINGNAME='$m';")
   
		  
		  for p in $para; do
		  	  echo $p>>$filepath
		  done

done


