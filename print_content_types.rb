# This routine prints out an individual test and includes all formatting.
#
require "./biz_validate.rb"

def print_content_types(hf)

	# num_divs = div_counter
    is_unique = true

    hf.write("<table style='width:100%'><tr class='begin_test_style'><td>LIST OF CONTENT TYPES PER TEST</td><td>FRONT</td><td>FIELD</td><td>VALUE</td></tr>")
    # hf.write("<table class='outsidetable'>")

    (0..$front_count).each do |x|
        is_unique = true
        if !$content_type_array[x,0,0].nil?
            (1..$field_count).each do |y|
                if !$content_type_array[x,y,0].nil?

                    #Check for is_unique. Don't print if we've already printed
                    (0..x-1).each do |i|
                        is_unique = true

                        if !$content_type_array[i,0,0].nil?
                            #puts $content_type_array[i,0,0] + "|" + $content_type_array[i,0,1] + "|" + $content_type_array[i,1,0]+ "|" + $content_type_array[i,1,1]

                            #if $content_type_array[x,0,0] == $content_type_array[i,0,0] and  $content_type_array[x,0,1] == $content_type_array[i,0,1] and  $content_type_array[x,1,0] == $content_type_array[i,1,0] and  $content_type_array[x,1,1] == $content_type_array[i,1,1]
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
            hf.write("<tr>")
            hf.write("<td>" + $content_type_array[x,0,0] + "</td>")   #test
            hf.write("<td>" + $content_type_array[x,0,1] + "</td>")   #front
            hf.write("<td>" + $content_type_array[x,1,0] + "</td>")   #field
            hf.write("<td>" + $content_type_array[x,1,1] + "</td>")   #value
            hf.write("</tr>")
        end

    end
    hf.write("</table>")


    #
    # while !omni_url[x].include? "END_OF_TEST:"
    #
    #
    #     # Get the anchor tag test (A.ACTION or C.GNT.CONTENTTYPE)
    #     anchor_text = ""
    #     for y in 0..100
    #         if omni_data[x,y,0].nil?
    #             break
    #         elsif omni_data[x,y,0].upcase.include? "A.ACTION"
    #             anchor_text = "Action=" + omni_data[x,y,1]
    #             break
    #         elsif omni_data[x,y,0].upcase.include? "C.GNT.CONTENTTYPE"
    #             anchor_text = "ContentType=" + omni_data[x,y,1]
    #             break
    #         end
    #     end
    #
    #     if anchor_text == "Action=FRONT VIEW" or anchor_text == "ContentType=SECTIONFRONT"
    #
	   #      # Write the hyperlink for the Omniture call
	   #      hf.write("<a href=""javascript:ReverseDisplay('myid" + num_divs.to_s + "')"">" + anchor_text + "</a>")
	   #      hf.write("<div id='myid" + num_divs.to_s + "' style='display:none;'>")
	   #      hf.write ("<table><tr class=hovertable_header><td>Omniture Parameter</td><td>Value</td></row>")
	   #
	   #      for y in 0..100
	   #          if !omni_data[x,y,0].nil?
    #
	   #              # Validate the property
	   #              valid = biz_validate($biz,current_test,omni_data[x,y,0],omni_data[x,y,1])
	   #              if valid #this is good
	   #                  tmp = "hovertable"
	   #              else #this is bad
	   #                  tmp = "hovertable_bad"
	   #              end
	   #              hf.write("<tr class=" + tmp + ">")
    #
	   #              hf.write("<td>"+omni_data[x,y,0]+"</td>")
	   #              hf.write("<td>"+omni_data[x,y,1]+"</td>")
	   #              hf.write("</tr>")
	   #          end
	   #      end
	   #
    #     end
    #
    #     x = x + 1
    #     num_divs = num_divs + 1
    #
    # end
    # hf.write("</table></div>")
    #
    # return num_divs

end