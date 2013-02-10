#! /usr/bin/ruby

class TestParser 
	def run () 
		i = 0
		while File::exists? "example#{i}.c" do
			t1 = IO.popen("ruby ./../../pcc.rb -p  < example#{i}.c", mode = 'r')
			IO.popen("ruby ./../../pcc.rb < example#{i}.c > unparsed_code.tmp", mode = 'r').close
			t2 = IO.popen("ruby ./../../pcc.rb -p < unparsed_code.tmp", mode = 'r')
			
			output1 = t1.read
			output2 = t2.read
			if output1 != output2  then
				puts "Failed test case: exmaple#{i}.c"
				puts "===== Parsing tree ====="
				puts output1
				puts "===== Re-parsing tree ====="
				puts output2 
				t1.close
				t2.close
				exit
			end
			puts "Tese case \"example#{i}.c\" pass"
			i += 1
			t1.close
			t2.close
		end
		puts "Done!"
		File.delete("unparsed_code.tmp")
	end
end

test = TestParser.new
test.run
