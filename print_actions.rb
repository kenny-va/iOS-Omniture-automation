# This routine prints out an individual test and includes all formatting.
#
require './biz_validate.rb'

def print_actions(hf)


	# num_divs = div_counter
    is_unique = true

    # Bubble sort the results by field value
    (0..$front_count-1).each do |x|
        if !$actions_array[x,1,1].nil?
            (x+1..$front_count-1).each do |y|
                if !$actions_array[y,1,1].nil?
                    if $actions_array[x,1,1] > $actions_array[y,1,1]
                        testsave1 = $actions_array[x,0,0]
                        testsave2 = $actions_array[x,0,1]
                        testsave3 = $actions_array[x,1,0]
                        testsave4 = $actions_array[x,1,1]

                        $actions_array[x,0,0] = $actions_array[y,0,0]
                        $actions_array[x,0,1] = $actions_array[y,0,1]
                        $actions_array[x,1,0] = $actions_array[y,1,0]
                        $actions_array[x,1,1] = $actions_array[y,1,1]

                        $actions_array[y,0,0] = testsave1
                        $actions_array[y,0,1] = testsave2
                        $actions_array[y,1,0] = testsave3
                        $actions_array[y,1,1] = testsave4
                    end
                else
                    break
                end
            end
        else
            break
        end
    end

    hf.write("<table style='width:100%'><tr class='begin_test_style'><td>LIST OF ACTIONS (DUPLICATES REMOVED)</td><td>FRONT</td><td>FIELD</td><td>VALUE</td></tr>")

    (0..$front_count).each do |x|
        is_unique = true
        if !$actions_array[x,0,0].nil?
            (1..$field_count).each do |y|
                if !$actions_array[x,y,0].nil?

                    #Check for is_unique. Don't print if we've already printed
                    (0..x-1).each do |i|
                        is_unique = true

                        if !$actions_array[i,0,0].nil?
                            #puts $actions_array[i,0,0] + "|" + $actions_array[i,0,1] + "|" + $actions_array[i,1,0]+ "|" + $actions_array[i,1,1]

                            #if $actions_array[x,0,0] == $actions_array[i,0,0] and  $actions_array[x,0,1] == $actions_array[i,0,1] and  $actions_array[x,1,0] == $actions_array[i,1,0] and  $actions_array[x,1,1] == $actions_array[i,1,1]
                            if $actions_array[x,1,1] == $actions_array[i,1,1]   # don't print duplicate action values
                                is_unique = false
                                break
                            end

                        end
                    end
                end
            end
        end

        if is_unique and !$actions_array[x,0,0].nil?
            puts 'X: ',x, $actions_array[x,0,0], $actions_array[x,1,0], $actions_array[x,1,1]
            hf.write('<tr>')
            hf.write('<td>' + $actions_array[x,0,0] + '</td>')   #test
            hf.write('<td>' + $actions_array[x,0,1] + '</td>')   #front
            hf.write('<td>' + $actions_array[x,1,0] + '</td>')   #field
            hf.write('<td>' + $actions_array[x,1,1] + '</td>')   #value
            hf.write('</tr>')
        end

    end
    hf.write('</table>')

end