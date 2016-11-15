# This routine prints out an individual test and includes all formatting.
#
require "./biz_validate.rb"

def print_fronts(hf)


	# num_divs = div_counter

    hf.write("<table style='width:100%'><tr class='begin_test_style'><td>CALLS WITH ACTION=FRONT</td><td>FRONT</td><td>FIELD</td><td>VALUE</td></tr>")
    # hf.write("<table class='outsidetable'>")

    is_unique = true
    (0..$front_count).each do |x|
        if !$fronts_array[x,0,0].nil?
            (1..$field_count).each do |y|
                puts $fronts_array[x,0,0], $fronts_array[x,y,0], $fronts_array[x,y,1]
                if !$fronts_array[x,y,0].nil?

                    #Check for is_unique. Don't print if we've already printed
                    (0..x-1).each do |i|
                        is_unique = true

                        if !$fronts_array[i,0,0].nil?
                            (1..y-1).each do |j|
                                if !is_unique or $fronts_array[i,j,0].nil?
                                    break
                                end
                                puts $fronts_array[i,0,0] + '|' + $fronts_array[i,0,1] + '|' + $fronts_array[i,j,0]+ '|' + $fronts_array[i,j,1]
                                if !$fronts_array[i,j,0].nil?

                                    if $fronts_array[x,0,0] == $fronts_array[i,0,0] and  $fronts_array[x,0,1] == $fronts_array[i,0,1] and  $fronts_array[x,y,0] == $fronts_array[i,j,0] and  $fronts_array[x,y,1] == $fronts_array[i,j,1]
                                        is_unique = false
                                        break
                                    end
                                end
                            end
                        end
                    end

                    if is_unique
                        if x % 2 == 0
                            hf.write('<tr>')
                        else
                            hf.write("<tr style='background-color: lightgray'>")
                        end
                        hf.write('<td>' + $fronts_array[x,0,0] + '</td>')   #test
                        hf.write('<td>' + $fronts_array[x,0,1] + '</td>')   #front
                        hf.write('<td>' + $fronts_array[x,y,0] + '</td>')   #field
                        hf.write('<td>' + $fronts_array[x,y,1] + '</td>')   #value
                        hf.write('</tr>')
                    end

                else
                    break
                end
            end
        else
            break
        end
    end
    hf.write('</table>')

end