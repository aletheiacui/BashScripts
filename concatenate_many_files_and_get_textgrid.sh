#!/bin/bash
# generate an experiment sound file along with a textgrid

# $1 name of the files to be generated
# this script needs to be run in the directory with the sound files
files=`find . -type f -name "*.wav" -maxdepth 1`

# concatenate sound files in 5 parts because sox complains
# about too many files being open otherwise
for i in {1..5};
do
    echo $files | tr " " "\n" | gshuf > ./tmp/$1-$i.txt
    sox $(for f in `cat ./tmp/$1-$i.txt`; do echo -n "$f ./tmp/silence.wav "; done) ./tmp/$1-$i.wav
done

# now concatenate the 5 separate sound files
sox $(for f in `find ./tmp -type f -name "$1-*.wav" -maxdepth 1`; do echo -n " $f"; done) ./tmp/$1.wav
cat ./tmp/$1-*.txt > ./tmp/$1.txt

# now make a textgrid
duration=`soxi -D ./tmp/$1.wav` # duration of the sound file
n=`cat ./tmp/$1.txt | wc -l` # number of lines in the text file

header="File type = \"ooTextFile\"
Object class = \"TextGrid\"

xmin = 0
xmax = $duration
tiers? <exists>
size = 1
item []:
item [1]:
    class = \"IntervalTier\"
    name = \"word\"
    xmin = 0
    xmax = $duration
    intervals: size = $n
"

echo "$header" > ./tmp/$1.TextGrid

index=1
xmax=0
intdur=1.4
for line in `cat ./tmp/$1.txt`
do
    xmin=$xmax
    xmax=$(awk "BEGIN {print $xmin+$intdur; exit}")
    interval="
    intervals [$index]:
        xmin = $xmin
        xmax = $xmax
        text = \"${line:5:8}\"
    "
    echo "$interval" >> ./tmp/$1.TextGrid
done

# cleanup
for i in {1..5};
do
    rm ./tmp/$1-$i.txt
    rm ./tmp/$1-$i.wav
done
