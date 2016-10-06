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
                                puts $fronts_array[i,0,0] + "|" + $fronts_array[i,0,1] + "|" + $fronts_array[i,j,0]+ "|" + $fronts_array[i,j,1]
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
                        hf.write("<tr>")
                        hf.write("<td>" + $fronts_array[x,0,0] + "</td>")   #test
                        hf.write("<td>" + $fronts_array[x,0,1] + "</td>")   #front
                        hf.write("<td>" + $fronts_array[x,y,0] + "</td>")   #field
                        hf.write("<td>" + $fronts_array[x,y,1] + "</td>")   #value
                        hf.write("</tr>")
                    end

                else
                    break
                end
            end
        else
            break
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