#!/bin/bash
# Script to generate MIPS instruction
#

#
# Some colors:
#
default="\e[0m"
bold="\e[;1m"
yellow="\e[1;33m"
green="\e[1;32m"
red="\e[1;31m"
blue="\e[1;34m"
cyan="\e[1;36m"
purple="\e[1;35m"

#
# Check if the input is composed by 3 operand
# Only jump has 1 operand
#
if [ "$1" != "j" ] ; then
	if [ -z $4 ] ; then
		echo -e "You must write 3 operands"
		exit 1
	fi
fi

uncolored=false
if [ "$1" != "j" ] ; then
	if [ "$5" == "-u" ] ; then
		uncolored=true
	fi
else
	if [ "$3" == "-u" ] ; then
		uncolored=true
	fi
fi

# Set the type (R,I,J), Opcode and possibly the Func
case $1 in
	#################
	# Arithmetic    #
	#################
	add)
		# Op:   0x00
		# Func:	0x20
		InType="R"
		OpCode=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Func=$(echo "ibase=16; obase=2; 20" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} + S${4#S}"
	;;
	sub)
		# Op:   0x00
		# Func:	0x22
		InType="R"
		OpCode=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Func=$(echo "ibase=16; obase=2; 22" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} - S${4#S}"
	;;
	and)
		# Op:   0x00
		# Func:	0x24
		InType="R"
		OpCode=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Func=$(echo "ibase=16; obase=2; 24" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} & S${4#S}"
	;;
	nor)
		# Op:   0x00
		# Func:	0x27
		InType="R"
		OpCode=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Func=$(echo "ibase=16; obase=2; 27" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} =~ S${3#S} | S${4#S}"
	;;
	xor)
		# Op:   0x00
		# Func:	0x26
		InType="R"
		OpCode=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Func=$(echo "ibase=16; obase=2; 26" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} xor S${4#S}"
	;;
	or)
		# Op:   0x00
		# Func:	0x25
		InType="R"
		OpCode=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Func=$(echo "ibase=16; obase=2; 25" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} | S${4#S}"
	;;
	sll)
		# Op:   0x00
		# Func:	0x00
		InType="R"
		OpCode=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Func=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} << S${4#S}"
	;;
	srl)
		# Op:   0x00
		# Func:	0x02
		InType="R"
		OpCode=$(echo "ibase=16; obase=2; 00" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Func=$(echo "ibase=16; obase=2; 02" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} >> S${4#S}"
	;;
	#################
	# Data transfer #
	#################
	lw)
		# Op: 0x23
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 23" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = Memory[S${3#S} + ${4#S}]"
	;;
	sw)
		# Op: 0x2B
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 2B" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="Memory[S${3#S} + ${4#S}] = S${2#S}"
	;;
	addi)
		# Op: 0x08
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 08" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} + ${4#S}"
	;;
	andi)
		# Op: 0x0C
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 0C" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} & ${4#S}"
	;;
	ori)
		# Op: 0x0D
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 0D" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="S${2#S} = S${3#S} | ${4#S}"
	;;
	beq)
		# Op: 0x04
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 04" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="if [S${2#S} == S${3#S}] goto PC+$((4*${4#S}))" #TODO check sugli ingressi
	;;
	bne)
		# Op: 0x05
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 05" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="if [S${2#S} != S${3#S}] goto PC+$((4*${4#S}))" #TODO check sugli ingressi
	;;
	slt)
		# Op: 0x2A
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 2A" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="if [S${3#S} < S${4#S}] then S${2#S}=1 ; else S${2#S}=0" #TODO check sugli ingressi
	;;
	slti)
		# Op: 0x0A
		InType="I"
		OpCode=$(echo "ibase=16; obase=2; 0A" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="if [$3 < ${4#S}] then $2=1 ; else $2=0" #TODO check sugli ingressi
	;;
	#################
	# Jump          #
	#################
	j)
		# Op: 0x02
		InType="J"
		OpCode=$(echo "ibase=16; obase=2; 02" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%06d\n", $0 }')
		Desc="go to ${2#S}"
	;;
	*)
		echo -e "'$1' is an unsupported operation"
		exit 1
	;;
esac

# If is a shift, set the shift amount in ShAmtBin, otherwise set to 0
if [[ ("$1" = "sll" || "$1" = "srl") ]] ; then
	ShAmtBin=$(echo "obase=2; $4" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%05d\n", $0 }')
else
	ShAmtBin=$(echo "obase=2; 0" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%05d\n", $0 }')
fi

# If is a jump set the address
if [ "$1" = "j" ] ; then
	LabelBin=$(echo "obase=2; ${2#S}" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%026d\n", $0 }')
fi

# If InType is I convert the address
if [ "$InType" = "I" ] ; then
	AddressBin=$(echo "obase=2; ${4#S}" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%016d\n", $0 }')
fi
#####################################################

# Remove the S in the inputs registers
S1Dec="${2#S}"
S2Dec="${3#S}"
S3Dec="${4#S}"


# Rapid check if hasn't been used registers or memory address not valid 
case $InType in
	R)
		if [ ${S1Dec} -gt 31 ] ; then
			echo -e "Op1: Max 2^31"
			exit 1
		fi

		if [ ${S2Dec} -gt 31 ] ; then
			echo -e "Op2: Max 2^31"
			exit 1
		fi

		if [ ${S3Dec} -gt 31 ] ; then
			echo -e "Op3: Max 2^31"
			exit 1
		fi
	;;
	I)
		if [ ${S1Dec} -gt 31 ] ; then
			echo -e "Op1: Max 2^31"
			exit 1
		fi
		if [ ${S2Dec} -gt 31 ] ; then
			echo -e "Op2: Max 2^31"
			exit 1
		fi
		if [ ${S3Dec} -gt 65535 ] ; then
			echo -e "Address: Max 2^16-1"
			exit 1
		fi
	;;
	J)
		if [ ${S1Dec} -gt 67108863 ] ; then
			echo -e "Address for abs jump: Max 2^26-1"
			exit 1
		fi
	;;
esac

echo -e
echo -e "\t${bold}$Desc"

# Set the outputs
case $InType in
	R)
		DestBin=$(echo "obase=2; ${2#S}" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%05d\n", $0 }')
		Op1Bin=$(echo "obase=2; ${3#S}" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%05d\n", $0 }')
		Op2Bin=$(echo "obase=2; ${4#S}" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%05d\n", $0 }')
		[[ "$1" = "sll" || "$1" = "srl" ]] && Op2Bin=00000
		echo -e
		echo -e "\t${cyan}OpCode: \t $OpCode \t 0x$(echo "obase=16; ibase=2; $OpCode" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%02d\n", $0 }'\n)"
		echo -e "\t${purple}RegisterSource:  $Op1Bin \t\t reg${3#S}"
		echo -e "\t${yellow}RegisterTemp: \t $Op2Bin \t\t reg${4#S}" #reg$(echo "ibase=2; reg${4#S}" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%02d\n", $0 }')"
		echo -e "\t${red}RegisterDest: \t $DestBin \t\t reg${2#S}"
		echo -e "\t${blue}ShAmt: \t \t $ShAmtBin \t\t n$(echo "ibase=2; $ShAmtBin" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%02d\n", $0 }')"
		echo -e "\t${green}Func: \t \t $Func"
		echo -e "\t${default}"
		echo -e "\t${cyan}$OpCode${purple}$Op1Bin${yellow}$Op2Bin${red}$DestBin${blue}$ShAmtBin${green}$Func${default}"
		echo -e
		[ $uncolored = true ] && echo -e "${OpCode}${Op1Bin}${Op2Bin}${DestBin}${ShAmtBin}${Func}" || true
	;;
	J)
		echo -e
		echo -e "\t${cyan}OpCode:  $OpCode \t\t\t 0x$(echo "obase=16; ibase=2; $OpCode" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%02d\n", $0 }')"
		echo -e "\t${yellow}Label: \t $LabelBin \t n${2#S}"
		echo -e "\t${default}"
		echo -e "\t${cyan}$OpCode${yellow}$LabelBin${default}"
		echo -e
		[ $uncolored = true ] && echo -e "$OpCode$LabelBin" || true
	;;
	I)
		Op1Bin=$(echo "obase=2; ${3#S}" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%05d\n", $0 }')
		Op2Bin=$(echo "obase=2; ${2#S}" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%05d\n", $0 }')
		echo -e
		echo -e "\t${cyan}OpCode: \t $OpCode \t\t 0x$(echo "obase=16; ibase=2; $OpCode" | BC_LINE_LENGHT=9999 bc | awk '{ printf "%02d\n", $0 }')"
		echo -e "\t${purple}RegisterSource:  $Op1Bin \t\t\t reg${3#S}"
		echo -e "\t${yellow}RegisterTemp: \t $Op2Bin \t\t\t reg${2#S}"
		echo -e "\t${green}Const/Offset: \t $AddressBin \t n${4#S}"
		echo -e "\t${default}"
		echo -e "\t${cyan}$OpCode${purple}$Op1Bin${yellow}$Op2Bin${green}$AddressBin${default}"
		echo -e
		[ $uncolored = true ] && echo -e "${OpCode}${Op1Bin}${Op2Bin}${AddressBin}" || true
	;;
esac