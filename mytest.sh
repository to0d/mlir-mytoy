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

while getopts 'lrh' OPTION
do
    case $OPTION in
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
    
    # query test
    test_sh_list=$(ls $workspace | grep -e ".toy" -e ".mlir")
    for pt_name in $test_sh_list
    {        
        echo $workspace/$pt_name 
    }

fi


lt_succ=0
lt_total=0

if [ $lt_action_run == 1 ]; then
 
    # query test
    test_sh_list=$(ls $workspace | grep -e ".toy")
    for pt_name in $test_sh_list
    {        
            test_path=$workspace/$pt_name 
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
    
    test_sh_list=$(ls $workspace | grep -e ".mlir")
    for pt_name in $test_sh_list
    {        
            test_path=$workspace/$pt_name 
            cmd=$(cat $test_path | grep "// RUN:" | awk -F : '{print $2}')
            
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

    echo "total "$lt_total", succ "$lt_succ
    
fi

