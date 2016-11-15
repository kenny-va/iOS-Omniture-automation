# This routine prints out an individual test and includes all formatting.
#
require './biz_validate.rb'

def print_content_types(hf)

    is_unique = true

    hf.write("<table style='width:100%'><tr class='begin_test_style'><td>LIST OF CONTENT TYPES PER TEST</td><td>FRONT</td><td>FIELD</td><td>VALUE</td></tr>")

    (0..$front_count).each do |x|
        is_unique = true
        if !$content_type_array[x,0,0].nil?
            (1..$field_count).each do |y|
                if !$content_type_array[x,y,0].nil?

                    #Check for is_unique. Don't print if we've already printed
                    (0..x-1).each do |i|
                        is_unique = true

                        if !$content_type_array[i,0,0].nil?

                            if $content_type_array[x,1,1] == $content_type_array[i,1,1]  # only show unique parameter values
                                is_unique = false
                                break
                            end

                        end
                    end
                end
            end
        end

        if is_unique and !$content_type_array[x,0,0].nil?
            puts x,$content_type_array[x,0,0], $content_type_array[x,1,0], $content_type_array[x,1,1]
            hf.write('<tr>')
            hf.write('<td>' + $content_type_array[x,0,0] + '</td>')   #test
            hf.write('<td>' + $content_type_array[x,0,1] + '</td>')   #front
            hf.write('<td>' + $content_type_array[x,1,0] + '</td>')   #field
            hf.write('<td>' + $content_type_array[x,1,1] + '</td>')   #value
            hf.write('</tr>')
        end

    end
    hf.write('</table>')

end