
def load_fronts(current_test,omni_call)

    prefix_cnt = 0
    prefixes = ['','','','','',''] #this array holds the prefixes, ie: c.a.DeviceName
    omni_row = 1
    omni_values = omni_call.split('&')  #Split all the URL parameters
    test_idx = -1
    section_parameter = false

    #is this a new test?  If not, use the same index previously used.
    (0..$test_count).each do |x|
        if $fronts_array[x,0,0] == current_test or $fronts_array[x,0,0].nil?
            test_idx = x
            break
        end
    end

    #begin where the last entry was added to this test
    (1..$test_count).each do |x|
        if $fronts_array[test_idx,x,0].nil?
            omni_row = x
            break
        end
    end

    $fronts_array[test_idx,0,0] = current_test
    if $fronts_array[test_idx,0,1].nil?
        $fronts_array[test_idx,0,1] = 'empty'       #default 'empty' for testing
    end

    omni_values.each do |value|

        param = value.split('=')
        col = 1
        param.each do |p_value|
            
            if p_value.slice(-1,1) == '.' #we have a prefix
                prefixes[prefix_cnt] = p_value
                prefix_cnt = prefix_cnt + 1

            elsif p_value.slice(0,1) == '.'  #we have a suffix
                prefixes[prefix_cnt-1] = ''
                prefix_cnt = prefix_cnt - 1
                
            elsif col == 1   #Parameter name
                col = 2
                $fronts_array[test_idx,omni_row,0] = prefixes[0]+prefixes[1]+prefixes[2]+prefixes[4]+prefixes[5]+p_value.upcase

                if p_value == 'Section'
                    section_parameter = true    #signal that this property needs to be captured 
                end

            elsif col==2  #Parameter value
                col = 1 
                $fronts_array[test_idx,omni_row,1] = p_value.upcase
                omni_row = omni_row + 1

                if section_parameter
                    $fronts_array[test_idx,0,1] = p_value.upcase
                    section_parameter = false
                end
            end                    
        end           
    end

    #Sort the parameters with the awesome bubble sort!
    # for index in 0..omni_row-1
    #     for index2 in index..omni_row-1
    #         if $fronts_array[test_idx,index,0] > $fronts_array[test_idx,index2,0]
    #             testsave1 = $fronts_array[test_idx,index2,0]
    #             testsave2 = $fronts_array[test_idx,index2,1]
    #
    #             $fronts_array[test_idx,index2,0] = $fronts_array[test_idx,index,0]
    #             $fronts_array[test_idx,index2,1] = $fronts_array[test_idx,index,1]
    #
    #             $fronts_array[test_idx,index,0] = testsave1
    #             $fronts_array[test_idx,index,1] = testsave2
    #         end
    #     end
    # end


    return true
end
