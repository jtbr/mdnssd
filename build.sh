#!/bin/bash

list="x86_64-linux-gnu-gcc x86-linux-gnu-gcc arm-linux-gnueabi-gcc aarch64-linux-gnu-gcc sparc64-linux-gnu-gcc mips-linux-gnu-gcc powerpc-linux-gnu-gcc"
declare -A alias=( [x86-linux-gnu-gcc]=i686-linux-gnu-gcc )
declare -a selected

IFS= read -ra offered <<< "$list"

# first check if it's just cleaning
for arg in $@
do
	if [ $arg == "clean" ]; then
		clean="clean"
	else 
		for cc in ${offered[@]}
		do
			if [[ $cc == *$arg* ]]; then 
				selected+=($cc)
				break
			fi
		done
	fi	
done

selected=${selected:=$offered}

# then iterate selected targets/compilers
for cc in ${selected[@]}
do
	IFS=- read -r target os dummy <<< "$cc"
	cc=${alias[$cc]:-$cc}
	
	if ! command -v $cc &> /dev/null; then
		echo $cc is not available
		continue
	fi	

	make CC=$cc $clean
	if [ $clean ]; then
		continue
	fi
done