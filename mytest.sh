#!/bin/sh
#####################################################
script_abs=$(readlink -f "$0")
script_dir=$(dirname $script_abs)
workspace=$script_dir/test

#####################################################
#           main routine
#   
#####################################################

usage()
{
    echo "-t [ast]         type"
    echo "-l               list"
    echo "-r               run"
}

if [ $# -eq 0 ]; then
    echo "lt error: no args specified."
    usage
    exit 1
fi

lt_type=toy
lt_action_list=0
lt_action_run=0
lt_count=0

while getopts 't:lrh' OPTION
do
    case $OPTION in
    t)  if [ -z "$OPTARG" ]; then
            echo "lt error: no type specified."
            exit 1
        fi    
        lt_type=$OPTARG
        if [ $lt_type != "ast" -a $lt_type != "py" -a $lt_type != "c" -a $lt_type != "cpp" ]; then
            echo "lt error: unknown type "$lt_type
            exit 1
        fi 
        ;;
    l)  lt_action_list=1
        lt_count=`expr $lt_count + 1`
        ;;
    r)  lt_action_run=1
        lt_count=`expr $lt_count + 1`
        ;;
    h)  usage
        exit 0
        ;; 
    \?) echo "lt error: unknown parameter '$OPTION'"
        usage
        exit 1
        ;;
    esac
done

if [ $lt_count == 0 ]; then
    echo "lt error: not action specified"
    exit 1
fi

if [ $lt_action_list == 1 ]; then
    
    test_dir_list=$(find $workspace -type d| grep -v -e "\.$")
    for pt_dir in $test_dir_list
    {
        # query test
        test_sh_list=$(ls $pt_dir | grep -e ".${lt_type}$")
        for pt_name in $test_sh_list
        {        
            echo $pt_dir/$pt_name 
        }
    }

fi


lt_succ=0
lt_total=0

if [ $lt_action_run == 1 ]; then

    test_dir_list=$(find $workspace -type d| grep -v -e "\.$")
    for pt_dir in $test_dir_list
    {
        # query test
        test_sh_list=$(ls $pt_dir | grep -e ".${lt_type}$")
        for pt_name in $test_sh_list
        {        
             test_path=$pt_dir/$pt_name 
             cmd=$(cat $test_path | grep "# RUN:" | awk -F : '{print $2}')
             a=$(echo $test_path | sed 's#\/#\\\/#g')
             cmd=$(echo $cmd | sed "s/%s/$a/g")
             echo -n $test_path
             rst=$(eval $cmd 2>&1)

             if [ "$rst" = "" ]
             then
                echo ", succ"
                lt_succ=`expr $lt_succ + 1`
             else 
                echo ", fail"
                echo "    : "$cmd
             fi

            lt_total=`expr $lt_total + 1`
        }
    }

    echo "total "$lt_total", succ "$lt_succ
    
fi

