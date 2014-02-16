#!/bin/bash
# GenInstructionMemoryInit.sh
#

if [ ! -e genMIPS.sh ] ; then
	echo -e "genMIPS.sh not found in $(pwd)"
fi

if [ "$1" == "" ] ; then
	echo -e
	echo -e "No instruction list file given"
	echo -e "Usage: GenInstructionMemoryInit.sh foo.txt"
	exit 1
fi

#
# Change the Internal Field Separator to newline instead whitespace
#
IFS=$'\n'

# index: number of instruction
# line:  ISA instruction
#
# Usage: SplitForModelsim index line
#
# Will produce 4 lines to paste in the Instruction Memory initialization. Example:
# 0 => "00000000"
# 1 => "00000000"
# 2 => "00000000"
# 3 => "00000000"
#
SplitForModelsim()
{
	position=$1
	let position=$position*4
	isa=$2
	echo -e "$position => \"${isa:0:8}\","
	let position++
	echo -e "$position => \"${isa:8:8}\","
	let position++
	echo -e "$position => \"${2:16:8}\","
	let position++
	echo -e "$position => \"${2:24:8}\","
}

#
# Loop through all lines:
#
# To get the error line if present
index=1

for line in $(cat $1) ; do
	#
	# Restore IFS as default
	#
	IFS=$' '
	#
	# From string to array
	# Needed to pass the right number of inputs to genMIPS
	#
	linearray=($(echo ${line}))
	#
	# Put the output in ISAinstruction
	#
	ISAinstructionFull=$(./genMIPS.sh ${linearray[*]})
	#
	# Catch the exit code to verify if the input file data is valid
	#
	if [ $? == 1 ] ; then
		echo -e "Line $index contains not valid or not supported instruction"
		exit 1
	fi
	#
	# Print the ISA instruction
	#
	# Get only the last line of genMIPS output that contains the right code
	#
	let index--
	#
	# -m is to get a ModelSim ready initialization data for Instruction Memory
	#
	if [ ! "$2" == "-m" ] ; then
		IFS=$'\n'
		ISAinstruction=$(./genMIPS.sh ${linearray[*]} | tail -n 2 | head -n 1| tr -d '\t')
		checkcode[index]=$(./genMIPS.sh ${linearray[*]} | head -n 2 | tail -n 1 | tr -d '\t')
		echo -e $ISAinstruction
	else
		ISAinstruction=$(./genMIPS.sh ${linearray[*]} -u | tail -n 1)
		SplitForModelsim $index $ISAinstruction
	fi
	let index++
	#
	# Increment the index
	#
	let index=$index+1
done

if [ ! "$2" == "-m" ] ; then
	echo
	let maxi=$index-2
	for i in $(seq 0 $maxi) ; do
		echo ${checkcode[$i]}
	done
fi