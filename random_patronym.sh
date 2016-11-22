#! /bin/bash
# Options:
# -b with birth date
# -n number of patronyms
# -x with gender

OPT_BIRTHDATE=
OPT_N=1
OPT_GENDER=
while getopts "bn:x" opt; do
    case $opt in
	b)
	    OPT_BIRTHDATE=1
	    ;;
	n)
	    OPT_N=$OPTARG
	    ;;
	x)
	    OPT_GENDER=1
	    ;;
    esac
done

FEMININE_FIRSTS=./girls.txt
MASCULINE_FIRSTS=./boys.txt
LASTS=./names.txt
for i in $(seq $OPT_N); do 
    if [[ -n $OPT_GENDER ]]; then
	GENDER=$(($RANDOM % 2))
	if [[ $GENDER -eq 0 ]]; then
	    N=$(cat $MASCULINE_FIRSTS | shuf -n 1)
	else
	    N=$(cat $FEMININE_FIRSTS | shuf -n 1)
	fi
    else
	N=$(cat $FEMININE_FIRSTS $MASCULINE_FIRSTS | shuf -n 1)
    fi
    if [[ -n $OPT_BIRTHDATE ]]; then
	YEAR=$((1990 + $RANDOM % 10))
	MONTH=$(($RANDOM % 12 + 1))
	DAY=$(($RANDOM % 28 + 1))
	printf "%02d/%02d/%d," $DAY $MONTH $YEAR 
    fi
    P=$(shuf -n 1 $LASTS)
    [[ -n $OPT_GENDER ]] && echo -n $GENDER","
    echo -n "$N,$P,$(echo ${N,,} | head -c 1)${P,,}"
    [[ -n $OPT_BIRTHDATE ]] && printf "%02d%02d%02d" $YEAR $MONTH $DAY
    echo
done
