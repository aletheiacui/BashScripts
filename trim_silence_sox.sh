# trim silences on either end of sound files in a directory

for filename in `ls *.wav`
	do
		sox ./$filename ../input_trimmed/$filename silence 1 0.1 1% reverse silence 1 0.1 1% reverse
	done
