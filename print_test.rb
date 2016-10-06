# This routine prints out an individual test and includes all formatting.
#
require "./biz_validate.rb"

def print_test(hf, x, omni_data, omni_url, div_counter, current_test)


	num_divs = div_counter

	hf.write("<table style='width:100%'><tr><td class='begin_test_style'>" + current_test + "</td></tr></table>")
	hf.write("<table><tr class='outsidetable'><td class='outsidetable'>")

    while !omni_url[x].include? "END_OF_TEST:"

        	
        # Get the anchor tag test (A.ACTION or C.GNT.CONTENTTYPE)
        anchor_text = ""
        for y in 0..100   
            if omni_data[x,y,0].nil? 
                break
            elsif omni_data[x,y,0].upcase.include? "A.ACTION"
                anchor_text = "Action=" + omni_data[x,y,1]
                break
            elsif omni_data[x,y,0].upcase.include? "C.GNT.CONTENTTYPE"
                anchor_text = "ContentType=" + omni_data[x,y,1]
                break
            end
        end
       
        if anchor_text == "Action=FRONT VIEW" or anchor_text == "ContentType=SECTIONFRONT"

	        # Write the hyperlink for the Omniture call
	        hf.write("<a href=""javascript:ReverseDisplay('myid" + num_divs.to_s + "')"">" + anchor_text + "</a>")
	        hf.write("<div id='myid" + num_divs.to_s + "' style='display:none;'>")
	        hf.write ("<table><tr class=hovertable_header><td>Omniture Parameter</td><td>Value</td></row>")
	       
	        for y in 0..100   
	            if !omni_data[x,y,0].nil? 

	                # Validate the property
	                valid = biz_validate($biz,current_test,omni_data[x,y,0],omni_data[x,y,1])
	                if valid #this is good
	                    tmp = "hovertable"
	                else #this is bad
	                    tmp = "hovertable_bad"
	                end
	                hf.write("<tr class=" + tmp + ">")

	                hf.write("<td>"+omni_data[x,y,0]+"</td>")
	                hf.write("<td>"+omni_data[x,y,1]+"</td>")
	                hf.write("</tr>")
	            end
	        end
	        
        end

        x = x + 1
        num_divs = num_divs + 1

    end
    hf.write("</table></div>")

    return num_divs	

end