#! /usr/bin/ruby

=begin
 P523 Assignment 1
 Tanghong Qiu
=end 

class Scanner
	def initialize()
		@scop_count = 0
	end

	def scan()
		STDIN.read.split("\n").each do |line|
   			if line == "{"
				new_env = Env.new(@scop_count)
				@scop_count += 1
				if defined?(@env)
					new_env.set_next_env(@env)
					@env = new_env
				else
					@env = new_env
				end
				id = @env.get_env_id()
				puts "BEG SCOPE #{id}: {"
			elsif line == "}"
				id = @env.get_env_id()
				@env = @env.get_next_env()
				@scop_count -= 1
				puts "END SCOPE #{id}: }"
			elsif line[0..6] == "double "
				val = line[7..-1]
				id = @env.get_env_id()
				@env.extend_env(val, "double")
				puts "DEF SCOPE #{id}: double #{val}"
			elsif line[0..4] == "long "
				val = line[5..-1]
				id = @env.get_env_id()
				@env.extend_env(val, "long")
				puts "DEF SCOPE #{id}: long #{val}"
			elsif line[0..3] == "int "
				val = line[4..-1]
				id = @env.get_env_id()
				@env.extend_env(val, "int")
				puts "DEF SCOPE #{id}: int #{val}"
			else 
				type, id = @env.apply_env(line)
				puts "USE SCOPE #{id}: #{line} (#{type})"
			end
		end
	end
end 

class Env
	def initialize(id)
		@vals = Hash.new("undefined")
		@env_id = id
	end

	def set_next_env(env)
		@next_env = env
	end

	def get_next_env()
		@next_env
	end

	def get_env_id()
		@env_id
	end
	
	def extend_env(name, type)
		@vals[name] = type
	end

	def apply_env(name)
		if @vals[name] == "undefined"
			if defined?(@next_env)
				@next_env.apply_env(name)
			else
				return "undefined", @env_id
			end
		else
			return @vals[name], @env_id 
		end
	end
end

my_scanner = Scanner.new()
my_scanner.scan()

