#!/bin/sh
#
# create a list of pathnames with all the file prefixes
for file in `find ../timit -type f -name "*.wav"`
do
    echo ${file%.wav} >> filelist.txt
done

# Iterate through the file prefixes in filelist. Track pitch of each
# .wav file with REAPER, and put the output in a separate folder called 
# timitdata to avoid accidentally overwriting the original files etc.
for file in `cat filelist.txt`
do
    echo $file
    
    # Make a corresponding directory in timitdata if one does not already
    # exist
    dirname=${file/timit/timitdata}
    dirname=${dirname%/*}
    if [ ! -d $dirname ]
    then
        echo "Directory does not exist. Creating it now."
        mkdir -p $dirname
    fi
    
    # Finally, track pitch
    # Minimum F0: 60
    # Maximum F0: 650
    # Frame shift: Default (0.005)
    reaper -i $file.wav -f ${file/timit/timitdata}.f0 -p ${file/timit/timitdata}.pm -a -x 650 -m 60
done
