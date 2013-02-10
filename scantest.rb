$:.unshift "#{File.dirname(__FILE__)}"

require 'PCParse/scanner'

s = Scanner.new
#s.lineno
#s.scan "int main() {int i = 0;}"
while true
  t = s.next_token
  puts "[#{t[0]}, #{t[1]}]"
  break if t[0] == false
end
