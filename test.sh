#!/bin/bash

set +x
set +e

echo "checking for README"
if [ ! -e "./README" ]
then
        echo "Error: No README file"
        exit 1
fi

echo "checking for Makefile"
if [ ! -e "./Makefile" ]
then
        echo "Error: No Makefile file"
        exit 1
fi

echo "Running make"
make
rc=$?
if [ $rc -ne 0 ]
then
        echo "Error when running the make command"
        exit 1
fi

if [ ! -e "./secure_house" ]
then
        echo "Error: Running make did not create the secure_house file"
        exit 1
fi

if [ ! -x "./secure_house" ]
then
        echo "Error: secure_house is not executable"
        exit 1
fi

for test_file in $(find ./tests -type f -name "*.txt" | sort); do

        source ${test_file}
        
        echo "Testing your program"
        OUTPUT=$( echo -n "$INPUT_CASE" | $START_UP )

        # echo "Your program's output is as follows:"
        # echo "------------------------------------"
        # echo "$OUTPUT"
        # echo "------------------------------------"

        DIFF=$(diff -aBw <(echo "$OUTPUT") <(echo "$CORRECT_OUTPUT"))
        rc=$?
        if [ $rc -ne 0 ]
        then
                echo "------------------------------------"
                echo "FAILURE"
                echo "------------------------------------"

                # echo "$DIFF"
        else
                echo "------------------------------------"
                echo "SUCCESS"
                echo "------------------------------------"
        fi
done