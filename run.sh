#!/usr/bin/env bash

# Find all text files
for file in `find $1 -type f -exec grep -Iq . {} \; -and -print`
do
    # Print file name
    echo "FILENAME: $file"

    # Convert line endings to UNIX
    dos2unix -q -o $file

    # Clear file permissions
    #cat $file > tmp_content
    #rm $file
    #cat tmp_content > $file
    #rm tmp_content

    # Remove trailing whitespace
    sed -i 's/[[:space:]]*$//' $file

    # Delete all leading blank lines at top of file
    sed -i '/./,$!d' $file

    # Delete all trailing blank lines at end of file
    sed -i -e :a -e '/^\n*$/N;/\n$/ba' $file

    # Add newline at end of file if it doesn't exist already
    sed -i '$a\' $file

    # Detect inconsistent indentation
    IND=$(detect-indent $file)
    cat $file | grep -Evn "^($IND)+|^\S|^$"
done
