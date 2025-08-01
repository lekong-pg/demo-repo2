find . -name "reg_info*" -exec sh -c 'p4 edit "$1"' _ {} \;
echo "Checked out files"

function file_ends_with_newline() {
	#[$(tail -c 1) = "" ]
    [[ $(tail -c1 "$1" | wc -l) -gt 0 ]]
}

# Use find to locate files named "reg_info"
find . -type f -name "reg_info" | while read -r FILE; do
    # Remove occurrences of the string "faulty"
    #sed -i '/Official: ...../d' "$FILE"
    sed -i 's/Official: .....//' "$FILE"
    #sed -i '/hello/d' "$FILE"
    # Append "hello" to the end of the file
    echo "Deletion of Official words"
#    sed '${/^[[:space:]]*$/d;}' "$FILE"
    sed -i '/^$/d' "$FILE"

    while ! file_ends_with_newline "$FILE";
    #while tail -c 1 "$FILE";
    do
       echo "" >> "$FILE"
       #sed -i '$ d' "$FILE"
       #echo "Deleted newline"
     #  echo "Inserted newline"
    done


    echo -e "Official: false" >> "$FILE"
    echo "Done appending Official: false"
done


#find . -name "reg_info*" -exec sh -c 'echo "hello" >> "$1"' _ {} \;
#echo "Done appending Official: false"
find . -name "reg_info*" -exec sh -c 'less "$1"' _ {} \;
