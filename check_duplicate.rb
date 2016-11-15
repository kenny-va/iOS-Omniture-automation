# This routine checks to see if an entry has already been added to the duplicate_array.  It is used multiple times
# throughout the testing algorithm.

def check_duplicate(duplicate_array, duplicate_count, testname)

	is_duplicate = false

	for idx in 0 .. duplicate_count
		unless is_duplicate
			if duplicate_array[idx] == testname
				is_duplicate = true
			end
		end
	end

	return is_duplicate

end
