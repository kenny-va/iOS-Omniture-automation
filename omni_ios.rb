require 'uri'
require "./check_duplicate.rb"
require "./mobile-automation-values.rb"
require "./biz_rules.rb"
require "./biz_validate.rb"
require "./print_test.rb"

require "./load_fronts.rb"
require "./print_fronts.rb"

require "./load_actions.rb"
require "./print_actions.rb"

require "./load_content_types.rb"
require "./print_content_types.rb"

#TO DO'S


if ARGV[0].nil?
    filename = "./data-ios/api-url-logfile.txt"
else
    filename = ARGV[0]
end
puts "Filename: " + filename

product_name_style = "style='font-weight: bold;font-size: xx-large; background-color:green'"
omni_style = "style='background-color: PaleGoldenRod; '"

id = 1 #rolling id # to make unique api call divs
product_name = ""  #Product being tested
environment_tested = ""

module_cnt = 0  #track the number of API calls for display purposes per test
in_test = false #tracks if we are currently within a test when parsing the log

ad_data = Array.new(1000) { Array.new(5) }   #array for ad calls.  1000 is upper bound.
ad_index = 0  #counter for ad call array

omni_data = My3Array.new
omni_testname = Array.new  #Stores the name of the automated test
omni_url = Array.new
omni_url_index = 0
current_test = ""   #Current test being processed
specific_test = ""  #Specific test within the "current_test"
comscore = "" # Store the comscore call

#This is good for 10 testnames, 10 fronts, 20 fields
$test_count = 100
$front_count = 100
$field_count = 25
$fronts_array = My3Array.new

$actions_array = My3Array.new
$actions_count = 50

$content_type_array = My3Array.new
$content_type_count = 50

duplicate_array = Array.new  # Stores names of test that are duplicate. These are prevented from printing out more than once
duplicate_count = 0  #Stores actual number of entries in the duplicate_array

omni_index = 0  #counter for omniture calls
omni_row = 0 #counter for # of parameters per omniture call
div_counter = 0 #counter to keep the divs for the omniture calls unique

#Create and open HTML file for output
html_filename = filename.slice(0,filename.rindex(".")) + ".html"
hf = File.open(html_filename, "w")

hf.write("<head>")
hf.write("<link rel='stylesheet' type='text/css' href='styles.css'>")
hf.write("</head>")

hf.write("<script type='text/javascript'>")
hf.write("   function ReverseDisplay(id) {")
hf.write("       var e = document.getElementById(id);")
hf.write("      if(e.style.display == 'block')")
hf.write("          e.style.display = 'none';")
hf.write("       else")
hf.write("          e.style.display = 'block';")
hf.write("    }") 
hf.write("</script><br><br>")

hf.write("<script src='sorttable.js'></script>")

#Build the html table casing
hf.write("<html><body>")
hf.write("<a name='top_of_page'></a>")

f=1

File.open(filename) do |f|       #LOOP THROUGH THE FILE TO PROCESS SPECIFIC LINES
 
    f.each do |line|

        if line.include? "TESTNAME:"

            #Get test name
            j = line.index("TESTNAME:")  

            # This will strip off the text prior to and after the TEST NAME
            omni_testname[omni_index] = line.slice(j+12,line.length-(j+12+2))

            in_test = true
            current_test = omni_testname[omni_index]
            module_cnt = 0

            omni_index = omni_index + 1
        
        
        elsif line.include? "END_OF_TEST"
            in_test = false
            current_test = ""

            omni_url[omni_index] = line.slice(line.index("END_OF_TEST:"),line.length).strip
            omni_index = omni_index + 1
            
        elsif line.include? "THE_PRODUCT_NAME_IS"

            product_name = line.slice(line.index("THE_PRODUCT_NAME_IS") + 20,line.length)

        elsif line.include? "Testing environment:"
            environment_tested = line.slice(line.index("Testing environment") + 21,line.length)

        elsif line.include? "Beginning Omniture test:"

            omni_url[omni_index] = line.slice(line.index("Beginning Omniture test:") + 24,line.length).strip
            specific_test = current_test + " / " + omni_url[omni_index]
            omni_index = omni_index + 1

        elsif line.include? "Ending Omniture test:"

            omni_url[omni_index] = line.slice(line.index("Ending Omniture test:"),line.length).strip
            specific_test = ""
            omni_index = omni_index + 1

        elsif line.include? "sb.scorecardresearch.com"

            comscore = URI.decode(line)
            comscore = comscore.slice(line.index("https"),comscore.length).strip

        elsif line.include? "/gampad/"

            ad_values = line.split("&")

            
            ad_values.each do |value|
                if value.start_with? ("iu")
                    ad_data[ad_index][0] = URI.decode(value.slice(value.index("iu=")+3,value.length))
                 
                elsif value.start_with? ("sz")
                    ad_data[ad_index][1] = URI.decode(value.slice(value.index("sz=")+3,value.length))
                end                
            end

            ad_index = ad_index + 1

        elsif (line.include? "repdata.usatoday.com") and in_test and !line.include? "http://repdata.usatoday.com/id"  #only works for USAToday parsing
        #elsif (line.include? "gannett.demdex.net" or line.include? "repdata.usatoday.com") and in_test  #REMOVE DEMDEX CALLS
     
            if line.include? "gannett.demdex.net" 
                omni_call = URI.decode(line.slice(line.index("gannett.demdex.net/event?"),line.length))
                omni_url[omni_index] = omni_call.slice(0,omni_call.length-2)

                omni_call = omni_call.slice(omni_call.index("?")+1,omni_call.length)  #Strip off the domain and API call, leaving just the parameters
                omni_call = omni_call.slice(0,omni_call.length-3)  #strip off last )
            else
                omni_call = URI.decode(line.slice(line.index("/ndh")+1,line.length))
                omni_url[omni_index] = omni_call.slice(0,omni_call.length-2)

            end

            #
            #Load up the FRONTS array
            #
            if omni_url[omni_index].include? "action=Front" and specific_test.length > 0
                rc = load_fronts(specific_test,omni_call)
            end

            #USER ACTIONS
            if omni_url[omni_index].include? "action=" and specific_test.length > 0
                rc = load_actions(specific_test,omni_call)
            end

            #CONTENT TYPES
            if (omni_url[omni_index].include? "&ContentType=" or omni_url[omni_index].include? "&c_gnt_ContentType=") #and specific_test.length > 0
                rc = load_content_types(specific_test,omni_call)
            end

            omni_index = omni_index + 1

        end

    end #each file record

end #open file

###################################################################################
#
#
#
# Print title and anchor tags
#
#
###################################################################################

hf.write("<table style='width:100%'><tr><td><product_name_style>PRODUCT TESTED: " + product_name + "</product_name_style></td></tr>")
hf.write("<tr><td>Environment tested: #{environment_tested}</td></tr></table>")

# for i in 0..omni_index - 1
#     if !omni_testname[i].nil?
#         if omni_testname[i].length > 0
#             hf.write("<p><p><a href='./api-url-logfile/#{omni_testname[i]}'>Jump to #{omni_testname[i]}</a><br>")
#         end
#     end
#     if !omni_url[i].nil?
#         if omni_url[i].length > 0 and omni_url[i].include?"Beginning Omniture"
#             duplicate = check_duplicate(duplicate_array, duplicate_count, omni_url[i])
#             if !duplicate
#                 duplicate_array[duplicate_count] = omni_url[i]
#                 duplicate_count = duplicate_count + 1
#                 hf.write("&emsp;<a href='##{omni_url[i]}'>#{omni_url[i].slice(omni_url[i].index("Beginning")+10,200)}</a><br>")
#             end
#         end
#     end
# end

# clear the data as routine may be used again
duplicate_count = 0
duplicate_array.clear

###################################################################################
#
#
#
# Print out AD calls
#
#
#
###################################################################################

=begin


ad_index=0
hf.write("<p><p><a name='ad_calls'></a>")

hf.write("<table><tr class='ad_style'><td>AD CALLS</td></tr></table>")

hf.write("<a href=""javascript:ReverseDisplay('ADCALL_ID')"">Click to show/hide AD Calls</a>")
hf.write("<div id='ADCALL_ID' style='display:none;'>")
hf.write("<table class='sortable'><tr><td>Section</td><td>Size</td></tr>")

ad_data.each do |line|
    if ad_data[ad_index][0].nil?  #this signifies there are no more elements
        break
    else
        hf.write("<td>"+ad_data[ad_index][0]+"</td>")
        hf.write("<td>"+ad_data[ad_index][1]+"</td>")
        #hf.write("<td>"+ad_data[ad_index][2]+"</td>")
        #hf.write("<td>"+ad_data[ad_index][3]+"</td>")
        #hf.write("<td>"+ad_data[ad_index][4]+"</td>")
        hf.write("</tr>")
        ad_index = ad_index + 1
    end 
end #do

#Build the html table casing
hf.write("</table></div>")

=end


###################################################################################
#
#
#
# PRINT THE FRONTS
#
#
#
###################################################################################

    # Loop through all tests and find the NEWS FRONT test
    print_fronts(hf)

    print_actions(hf)

    print_content_types(hf)


###################################################################################
#
#
#
# Beginning printing the smoke tests
#
#
#
###################################################################################

# hf.write("<p><p><a href='#top_of_page'>Back to Top</a><br><br>")
#
# for x in 0..omni_index-1 #Loop through each omniture call
#
#     if !omni_testname[x].nil? and omni_testname[x].length > 1
#         #puts "Testname length > 0:  #{omni_testname[x]}"
#         if module_cnt > 0
#             hf.write("</td></row></table>")
#         end
#         hf.write("<a name='#{omni_testname[x]}'></a>")
#         hf.write("<table style='width:100%'><tr><td class='begin_test_style'>" + omni_testname[x] + "</td></tr></table>")
#
#
#         hf.write("<a href='#top_of_page'>Back to Top</a><br><br>")
#         module_cnt = 0
#
#     elsif omni_url[x].include? "Beginning Omniture test:"
#
#         #Check for a duplicate test
#         #puts "Calling duplicate function with #{omni_url[x]}"
#         #puts omni_url[x]
#         duplicate = check_duplicate(duplicate_array, duplicate_count, omni_url[x])
#         if !duplicate
#             duplicate_array[duplicate_count] = omni_url[x]
#             duplicate_count = duplicate_count + 1
#         end
#         #puts "Is this a duplicate? #{duplicate}"
#
#         if !duplicate
#             current_test = omni_url[x].slice(omni_url[x].index(":")+2,omni_url[x].length).strip
#             if module_cnt > 0
#                 hf.write("</td></row></table>")
#             end
#             hf.write("<a name='#{omni_url[x].strip}'></a>")
#             hf.write("<table><tr class=omni_style><td>" + omni_url[x] + "</td></tr></table>")
#
#             module_cnt = 0
#         end
#
#     elsif omni_url[x].include? "Ending Omniture test"
#         if !duplicate
#             current_test = ""
#             if module_cnt > 0
#                 hf.write("</td></row></table>")
#             end
#
#             hf.write("<table><tr class=omni_style><td>" + omni_url[x] + "</td></tr></table><p><p><p>")
#             module_cnt = 0
#         else
#             duplicate = false #reset duplicate value for next omniture test
#         end
#
#     elsif omni_url[x].include? "END_OF_TEST:"
#         if module_cnt > 0
#             hf.write("</td></row></table>")
#         end
#         hf.write("<p><p><a href='#top_of_page'>Back to Top</a>")
#         hf.write("<p class='end_test_style'>" + omni_url[x] + "</p><p><p><p><p>")
#
#         module_cnt = 0
#     end
#
#
#     if !omni_url[x].nil? and omni_url[x].length > 0 and !duplicate
#
#         if !omni_url[x].nil? and !omni_url[x].include? "Omniture test:" and !omni_url[x].include? "END_OF_TEST:"
#
#             module_cnt = module_cnt + 1
#
#             case module_cnt
#                 when 1
#                     hf.write("<table><tr class='outsidetable'><td class='outsidetable'>")
#                 when 2
#                     hf.write("</td><td class='outsidetable'>")
#                 when 3
#                     hf.write("</td><td class='outsidetable'>")
#                 when 4
#                     hf.write("</td><td class='outsidetable'>")
#                 when 5
#                     hf.write("</td></tr></table><table><tr class='outsidetable'><td class='outsidetable'>")
#                     module_cnt = 0
#             end
#
#             #Write out the API call
#             #hf.write("<a href=""javascript:ReverseDisplay('myid" + id.to_s + "')"">Click to show/hide parameters</a>")
#             #hf.write("<div id='myid" + id.to_s + "' style='display:none;'><table " + omni_style + "><tr><td>" + omni_url[x] + "</td></tr></table></div>")
#             #id = id + 1
#
#             ###################################
#             #
#             # Write out the Omniture parameters
#             #
#             ###################################
#
#             # Get the anchor tag test (A.ACTION or C.GNT.CONTENTTYPE)
#             anchor_text = ""
#             for y in 0..100
#                 if omni_data[x,y,0].nil?
#                     break
#                 elsif omni_data[x,y,0].upcase.include? "A.ACTION"
#                     anchor_text = "Action=" + omni_data[x,y,1]
#                     break
#                 elsif omni_data[x,y,0].upcase.include? "C.GNT.CONTENTTYPE"
#                     anchor_text = "ContentType=" + omni_data[x,y,1]
#                     break
#                 end
#             end
#             if anchor_text.length == 0
#                 anchor_text = "Omniture call " + div_counter.to_s
#             end
#
#             # Write the hyperlink for the Omniture call
#             hf.write("<a href=""javascript:ReverseDisplay('myid" + div_counter.to_s + "')"">" + anchor_text + "</a>")
#             hf.write("<div id='myid" + div_counter.to_s + "' style='display:none;'>")
#             hf.write ("<table><tr class=hovertable_header><td>Omniture Parameter</td><td>Value</td></row>")
#             for y in 0..100
#                 if omni_data[x,y,0].nil?
#                     break
#                 else
#
#                     # Validate the property
#                     valid = biz_validate($biz,current_test,omni_data[x,y,0],omni_data[x,y,1])
#                     if valid #this is good
#                         tmp = "hovertable"
#                     else #this is bad
#                         tmp = "hovertable_bad"
#                     end
#                     hf.write("<tr class=" + tmp + ">")
#
#                     hf.write("<td>"+omni_data[x,y,0]+"</td>")
#                     hf.write("<td>"+omni_data[x,y,1]+"</td>")
#                     hf.write("</tr>")
#                 end
#             end
#             hf.write("</table></div>")
#             div_counter = div_counter + 1
#         end
#     end
# end

hf.write("<p></p><p></p><p></p>")
hf.write("<table style=table90><tr class=comscore_style><td>COMSCORE</td><td>" + comscore + "</td></tr></table>")

hf.write("</body></html>")



