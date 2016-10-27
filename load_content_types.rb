
def load_content_types(current_test,omni_call)

    prefix_cnt = 0
    prefixes = ["","","","","",""] #this array holds the prefixes, ie: c.a.DeviceName
    omni_row = 1
    omni_values = omni_call.split("&")  #Split all the URL parameters
    section_parameter = false
    include_action = false
    test_idx = -1

    #get the next available test index slot
    (0..$content_type_count).each do |x|
        if $content_type_array[x,0,0].nil?   #$actions_array[x,0,0] == current_test or
            test_idx = x
            break
        end
    end

    if current_test == ""
        $content_type_array[test_idx,0,0] = "OUTSIDE OF TEST SCOPE"
    else
        $content_type_array[test_idx,0,0] = current_test
    end
    $content_type_array[test_idx,0,1] = "empty"       #default "empty" for testing

    omni_row = 1
    omni_values.each do |value|

        param = value.split("=")
        col = 1
        param.each do |p_value|
            
            if p_value.slice(-1,1) == "." #we have a prefix
                prefixes[prefix_cnt] = p_value
                prefix_cnt = prefix_cnt + 1

            elsif p_value.slice(0,1) == "."  #we have a suffix
                prefixes[prefix_cnt-1] = ""
                prefix_cnt = prefix_cnt - 1
                
            elsif col == 1   #Parameter name
                col = 2

                if p_value.include? "ContentType"
                    $content_type_array[test_idx,omni_row,0] = prefixes[0]+prefixes[1]+prefixes[2]+prefixes[4]+prefixes[5]+p_value.upcase
                    include_action = true
                end

                if p_value == "Section"
                    section_parameter = true    #signal that this property needs to be captured
                end

            elsif col==2  #Parameter value
                col = 1 

                if include_action
                    $content_type_array[test_idx,omni_row,1] = p_value.upcase
                    omni_row = omni_row + 1
                end

                if section_parameter
                    $content_type_array[test_idx,0,1] = p_value.upcase
                    section_parameter = false
                end

                include_action = false
            end
        end           
    end

    #Sort the parameters with the awesome bubble sort!
    # for index in 0..omni_row-1
    #     for index2 in index..omni_row-1
    #         if $actions_array[test_idx,index,0] > $actions_array[test_idx,index2,0]
    #             testsave1 = $actions_array[test_idx,index2,0]
    #             testsave2 = $actions_array[test_idx,index2,1]
    #
    #             $actions_array[test_idx,index2,0] = $actions_array[test_idx,index,0]
    #             $actions_array[test_idx,index2,1] = $actions_array[test_idx,index,1]
    #
    #             $actions_array[test_idx,index,0] = testsave1
    #             $actions_array[test_idx,index,1] = testsave2
    #         end
    #     end
    # end


    return true
end
