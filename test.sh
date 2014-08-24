#!/usr/bin/env bash

# Script that test the other script.
# Yeah, we are that good on bash.


# Path to the script or alias
PACKAGE='./rch.sh'



# @param 1. The old string that should have the source
# @param 2. The directory with the sources (should not exist)
# @param 3. The path to the first file that will be tested
# @param 4. The path to the second file that will be tested
generate_sources() {
	echo " [+] Generating source files.."
	# Lets write some boring stuff because we are testing ¬.¬
	local readonly OLD="$1"
	local readonly DIRECTORY="$2"
	local readonly SOURCE_FILE_ONE="$3"
	local readonly SOURCE_FILE_TWO="$4"
	local readonly OUTPUT='Hello World!'

	# Create directory
	mkdir "$DIRECTORY";

	# Create the sources
	OUTPUT="FILE 1. This is going to be the only line. So - $OLD - should change and '$OLD' too."
	# OUTPUT=$OUTPUT"\nThis is going to be $OLD on a first line."
	# OUTPUT=$OUTPUT"\nThis is going to be $OLD on a second line."
	# OUTPUT=$OUTPUT"\nThis is going to be $OLD on a third line."
	# Store the content
	echo "$OUTPUT" > "$SOURCE_FILE_ONE";
	OUTPUT="FILE 2. This is going to be the only line. So - $OLD - should change and '$OLD' too."
	echo "$OUTPUT" > "$SOURCE_FILE_TWO";
}


# Used to remove the directories generated while testing
#
# @param The full path to the directory to remove
remove_sources() {
	echo " [+] Removing obsolete files.."
	rm -R "$*";
}


# Run the script using a directory as target
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The directory with the files to test
run_script_using_directory() {
	local readonly OLD="$1"
	local readonly NEW="$2"
	local readonly DIRECTORY="$3"
	# Run the script
	$PACKAGE -o "$OLD" -n "$NEW" -d "$DIRECTORY"
}


# Run the script using a pattern as target
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The pattern of the path with files to test
run_script_using_pattern() {
	local readonly OLD="$1"
	local readonly NEW="$2"
	local readonly PATTERN="$3"
	# Run the script
	$PACKAGE -o "$OLD" -n "$NEW" -p "$PATTERN"
}


# Test the script using a directory as target with a backup directory
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The directory with the files to test
# @param 4. The directory for the backup
run_script_using_directory_with_backup() {
	local readonly OLD="$1"
	local readonly NEW="$2"
	local readonly DIRECTORY="$3"
	local readonly BACKUP="$4"
	# Run the script
	$PACKAGE -o "$OLD" -n "$NEW" -p "$DIRECTORY" -b "$BACKUP"
}


# Test the script using a pattern as target with a backup directory
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The pattern of the path with files to test
# @param 4. The directory for the backup
run_script_using_pattern_with_backup() {
	local readonly OLD="$1"
	local readonly NEW="$2"
	local readonly PATTERN="$3"
	local readonly BACKUP="$4"
	# Run the script
	$PACKAGE -o "$OLD" -n "$NEW" -p "$PATTERN" -b "$BACKUP"
}


# Check if the content of the target file
# is equal to the expected value
#
# @param 1. The old string that should not be
# @param 2. The new string that should be
# @param 3. The pattern to the files to check
# @param 4. The amount of files that should be
# @return When error 1, otherwise 0
check_results() {
	local readonly OLD="$1"
	local readonly NEW="$2"
	local readonly PATTERN="$3"
	# The amount of files that should exists and actually exists
	local readonly EXISTS=0
	local readonly SHOULD_EXISTS="$4"
	# Iterate over the files
	for f in $PATTERN;
	do
		if [ "$f" != '.' ];
    	then
    		should_be_empty=`grep -s $OLD "$f"` 	# Remove -s to get messages on standar output
    		should_have_content=`grep -s $NEW "$f"` # Same here, remove -s if you want to
    		# Check for errors
    		if [ ! -z "$should_be_empty" -o -z "$should_have_content" ];
    		then
    			echo 1;
    			return;
    		fi
    		EXISTS=$(( $EXISTS + 1 ))
    	fi
	done
	# If it did not returned previously and
	# the amount of files presents are equal
	# to the expected number, then everything is ok
	if [[ $EXISTS == $SHOULD_EXISTS ]]; then
		echo 0;
	else
		echo 1;
	fi
}


# It try and hopes for good results
# Way: using a directory
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The directory with the files to test
# @param 4. The pattern of the path with files to test
# @param 5. The amount of files that should be
optimistic_using_directory() {
	run_script_using_directory "$1" "$2" "$3"
	echo `check_results "$1" "$2" "$4" "$5"`
}


# It try and hopes for bad results doing bad things.
# How? Removing the source file
# Way: using a directory
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The directory with the files to test
# @param 4. The pattern of the path with files to test
# @param 5. The amount of files that should be
# @param 6. The first source file that should exist
pessimistic_remove_source_using_directory() {
	run_script_using_directory "$1" "$2" "$3"
	rm "$6";
	real_result=`check_results "$1" "$2" "$4" "$5"`

	# We are waiting for errors!
	if [[ $real_result == 1 ]]; then
		echo 0;
	else
		echo 1;
	fi
}


# It try and hopes for bad results doing bad things.
# How? Removing the directory to the path with files to test
# Way: using a directory
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The directory with the files to test
# @param 4. The pattern of the path with files to test
# @param 5. The amount of files that should be
pessimistic_remove_directory_using_directory() {
	run_script_using_directory "$1" "$2" "$3"
	rm -R "$3";
	real_result=`check_results "$1" "$2" "$4" "$5"`

	# We are waiting for errors!
	if [[ $real_result == 1 ]]; then
		echo 0;
	else
		echo 1;
	fi
}


# It try and hopes for good results
# Way: using a pattern
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The pattern with the files to test
# @param 4. The amount of files that should be
optimistic_using_pattern() {
    run_script_using_pattern "$1" "$2" "$3"
    echo `check_results "$1" "$2" "$3" "$4"`
}


# It try and hopes for bad results doing bad things.
# How? Removing the source file
# Way: using a pattern
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The pattern with the files to test
# @param 4. The amount of files that should be
# @param 5. The first source file that should exist
pessimistic_remove_source_using_pattern() {
    run_script_using_pattern "$1" "$2" "$3"
    rm "$5";
    real_result=`check_results "$1" "$2" "$3" "$4"`

    # We are waiting for errors!
    if [[ $real_result == 1 ]]; then
        echo 0;
    else
        echo 1;
    fi
}


# It try and hopes for bad results doing bad things.
# How? Removing the pattern to the path with files to test
# Way: using a pattern
#
# @param 1. The old string to replace
# @param 2. The new string that will replace
# @param 3. The directory with the files to test
# @param 4. The pattern to the path with files to test
# @param 5. The amount of files that should be
pessimistic_remove_directory_using_pattern() {
    run_script_using_pattern "$1" "$2" "$4"
    rm -R "$3";
    real_result=`check_results "$1" "$2" "$4" "$5"`

    # We are waiting for errors!
    if [[ $real_result == 1 ]]; then
        echo 0;
    else
        echo 1;
    fi
}



# Set the conditions to run a script
#
# @param 1. The old string that should have the source
# @param 2. The directory with the sources (should not exist)
# @param 3. The path to the first file that will be tested
# @param 4. The path to the second file that will be tested
setup() {
	generate_sources "$1" "$2" "$3" "$4"
}


# Set the conditions to finish a script
#
# @param 1. [OPTIONAL] The directory with the files to test
# @param 2. [OPTIONAL] The directory for the backup
teardown() {
	if [ ! -z "$1" ];
	then
		remove_sources "$1"
	fi
	# Check if backup was giving
	if [ ! -z "$2" ];
	then
		remove_sources "$2"
	fi
}


# Display to the user weter a test result is correct or not
#
# @param 1. The result of the latest test
# @param 2. The number of the test
print_partial_result() {
	case "$1" in
		"0")
			echo " -> Test $2 passed!"
			;;
		"1")
			echo " -> Test $2 failed."
			;;
		*)
			echo " -> There were internal errors executing the test $2."
			;;
	esac
}


run_all_the_tests() {
	local OLD='sad'
	local NEW='happy'
	local BACKUP="/home/user/testing/backup_test_$$"
	local DIRECTORY="/home/user/testing/test_$$"
    local DIRECTORY_SLASH="/home/user/testing/test_$$/"
    local RELATIVE_DIRECTORY=~/testing/test_$$
    local RELATIVE_DIRECTORY_SLASH=~/testing/test_$$/
	local PATTERN="$DIRECTORY/*.tst"
	local SOURCE_FILE_ONE="$DIRECTORY/first.tst"
	local SOURCE_FILE_TWO="$DIRECTORY/second.tst"
	local amount_of_files=2 # The number of files to test
	local result=-1
    local test_number=0


    #exit 0 # Use this to stop the execution flow in some test


	# ~*~ TEST ~*~ TEST ~*~ TEST #
    #                            #
	# Set of test without backup #
    #  using directory as target #
    #                            #
	# ~*~ TEST ~*~ TEST ~*~ TEST #

	# Kill it with fire!
	setup "$OLD" "$DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
	result=`optimistic_using_directory "$OLD" "$NEW" "$DIRECTORY" "$PATTERN" "$amount_of_files"`
	teardown "$DIRECTORY"

    test_number=$(( $test_number + 1 ))
	print_partial_result "$result" "$test_number"

	# Kill it with fire!
	setup "$OLD" "$DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
	result=`pessimistic_remove_source_using_directory "$OLD" "$NEW" "$DIRECTORY" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
	teardown "$DIRECTORY"

    test_number=$(( $test_number + 1 ))
	print_partial_result "$result" "$test_number"

	# Kill it with fire!
	setup "$OLD" "$DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
	result=`pessimistic_remove_directory_using_directory "$OLD" "$NEW" "$DIRECTORY" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
	teardown #"$DIRECTORY" Directory should have been removed on test

    test_number=$(( $test_number + 1 ))
	print_partial_result "$result" "$test_number"




    # ~*~ TEST ~*~ TEST ~*~ TEST #
    #                            #
    # Set of test without backup #
    #    with a trailing slash   #
    #  using directory as target #
    #                            #
    # ~*~ TEST ~*~ TEST ~*~ TEST #


    # Kill it with fire!
    setup "$OLD" "$DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`optimistic_using_directory "$OLD" "$NEW" "$DIRECTORY_SLASH" "$PATTERN" "$amount_of_files"`
    teardown "$DIRECTORY_SLASH"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_source_using_directory "$OLD" "$NEW" "$DIRECTORY_SLASH" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown "$DIRECTORY_SLASH"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_directory_using_directory "$OLD" "$NEW" "$DIRECTORY_SLASH" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown #"$DIRECTORY_SLASH" Directory should have been removed on test

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"




    # ~*~ TEST ~*~ TEST ~*~ TEST #
    #                            #
    # Set of test without backup #
    #   with relative directory  #
    #  using directory as target #
    #                            #
    # ~*~ TEST ~*~ TEST ~*~ TEST #


    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`optimistic_using_directory "$OLD" "$NEW" "$RELATIVE_DIRECTORY" "$PATTERN" "$amount_of_files"`
    teardown "$RELATIVE_DIRECTORY"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_source_using_directory "$OLD" "$NEW" "$RELATIVE_DIRECTORY" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown "$RELATIVE_DIRECTORY"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_directory_using_directory "$OLD" "$NEW" "$RELATIVE_DIRECTORY" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown #"$RELATIVE_DIRECTORY" Directory should have been removed on test

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"


    # ~*~ TEST ~*~ TEST ~*~ TEST #
    #                            #
    # Set of test without backup #
    #   with relative directory  #
    #    with a trailing slash   #
    #  using directory as target #
    #                            #
    # ~*~ TEST ~*~ TEST ~*~ TEST #


    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`optimistic_using_directory "$OLD" "$NEW" "$RELATIVE_DIRECTORY_SLASH" "$PATTERN" "$amount_of_files"`
    teardown "$RELATIVE_DIRECTORY_SLASH"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_source_using_directory "$OLD" "$NEW" "$RELATIVE_DIRECTORY_SLASH" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown "$RELATIVE_DIRECTORY_SLASH"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_directory_using_directory "$OLD" "$NEW" "$RELATIVE_DIRECTORY_SLASH" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown #"$RELATIVE_DIRECTORY_SLASH" Directory should have been removed on test

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"





    ####################
    # NEW SET OF TESTS #
    ####################


    # ~*~ TEST ~*~ TEST ~*~ TEST #
    #                            #
    # Set of test without backup #
    #    using path as target    #
    #                            #
    # ~*~ TEST ~*~ TEST ~*~ TEST #

    # Kill it with fire!
    setup "$OLD" "$DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`optimistic_using_pattern "$OLD" "$NEW" "$PATTERN" "$amount_of_files"`
    teardown "$DIRECTORY"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_source_using_pattern "$OLD" "$NEW" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown "$DIRECTORY"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_directory_using_pattern "$OLD" "$NEW" "$DIRECTORY" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown #"$DIRECTORY" Directory should have been removed on test

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"




    # ~*~ TEST ~*~ TEST ~*~ TEST #
    #                            #
    # Set of test without backup #
    #    with a trailing slash   #
    #    using path as target    #
    #                            #
    # ~*~ TEST ~*~ TEST ~*~ TEST #


    # Kill it with fire!
    setup "$OLD" "$DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`optimistic_using_pattern "$OLD" "$NEW" "$PATTERN" "$amount_of_files"`
    teardown "$DIRECTORY_SLASH"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_source_using_pattern "$OLD" "$NEW" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown "$DIRECTORY_SLASH"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_directory_using_pattern "$OLD" "$NEW" "$DIRECTORY_SLASH" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown #"$DIRECTORY_SLASH" Directory should have been removed on test

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"




    # ~*~ TEST ~*~ TEST ~*~ TEST #
    #                            #
    # Set of test without backup #
    #   with relative directory  #
    #    using path as target    #
    #                            #
    # ~*~ TEST ~*~ TEST ~*~ TEST #


    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`optimistic_using_pattern "$OLD" "$NEW" "$PATTERN" "$amount_of_files"`
    teardown "$RELATIVE_DIRECTORY"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_source_using_pattern "$OLD" "$NEW" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown "$RELATIVE_DIRECTORY"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_directory_using_pattern "$OLD" "$NEW" "$RELATIVE_DIRECTORY" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown #"$RELATIVE_DIRECTORY" Directory should have been removed on test

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"


    # ~*~ TEST ~*~ TEST ~*~ TEST #
    #                            #
    # Set of test without backup #
    #   with relative directory  #
    #    with a trailing slash   #
    #    using path as target    #
    #                            #
    # ~*~ TEST ~*~ TEST ~*~ TEST #


    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`optimistic_using_pattern "$OLD" "$NEW" "$PATTERN" "$amount_of_files"`
    teardown "$RELATIVE_DIRECTORY_SLASH"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_source_using_pattern "$OLD" "$NEW" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown "$RELATIVE_DIRECTORY_SLASH"

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"

    # Kill it with fire!
    setup "$OLD" "$RELATIVE_DIRECTORY_SLASH" "$SOURCE_FILE_ONE" "$SOURCE_FILE_TWO"
    result=`pessimistic_remove_directory_using_pattern "$OLD" "$NEW" "$RELATIVE_DIRECTORY_SLASH" "$PATTERN" "$amount_of_files" "$SOURCE_FILE_ONE"`
    teardown #"$RELATIVE_DIRECTORY_SLASH" Directory should have been removed on test

    test_number=$(( $test_number + 1 ))
    print_partial_result "$result" "$test_number"


}

run_all_the_tests "$@"