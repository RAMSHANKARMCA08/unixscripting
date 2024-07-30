#Test Data
#sh prgm.sh 10 3 7 ram 1 100

# Initialize an empty array
args=()

# Loop through all command-line arguments and store in an array
for arg in "$@"; do
    #Filter only numbers to store
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        args+=("$arg")
    fi
done

# Print the array elements
echo "Arguments stored in array:"
for element in "${args[@]}"; do
    echo "$element"
done

# Sort the array Ascending
sorted_numbers=($(printf "%s\n" "${args[@]}" | sort -n))

# Print the sorted array
echo "Sorted array (Ascending):"
for number in "${sorted_numbers[@]}"; do
    echo "$number"
done

# Sort the array Descending
sorted_numbers=($(printf "%s\n" "${args[@]}" | sort -nr))

# Print the sorted array
echo "Sorted array (Descending):"
for number in "${sorted_numbers[@]}"; do
    echo "$number"
done


#Display an random Number
# Get the array lenth
array_length=${#args[@]}
# Generate a random index within the range of the array
random_index=$((RANDOM % array_length))
echo "Random element from the array: ${args[$random_index]}"