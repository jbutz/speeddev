require "speeddev/version"
require 'singleton'
require 'optparse'
require 'ostruct'
require 'less'
require 'sass'
require 'stylus'
require 'rdiscount'

module Speeddev

	ConfigurationStruct = Struct.new(:operation, :files, :compress)

	class Configuration
		include Singleton
		@@config = ConfigurationStruct.new

		def self.config
			yield(@@config) if block_given?
			@@config
		end

		# This provides an easy way to dump the configuration as a hash
		def self.to_hash
			Hash[@@config.each_pair.to_a]
		end

		# Pass any other calls (most likely attribute setters/getters on to the
		# configuration as a way to easily set/get attribute values 
		def self.method_missing(method, *args, &block)
			if @@config.respond_to?(method)
				@@config.send(method, *args, &block)
			else
				raise NoMethodError
			end
		end

		# Handles validating the configuration that has been loaded/configured
		def self.validate!
			valid = true

			valid = false if Configuration.files.count <= 0

			raise ArgumentError unless valid
		end
		
	end
	class CLIParser
		def self.parse(args)
			options = OpenStruct.new
			options.operation = nil
			options.files     = []
			options.compress  = false

			opt_parser = OptionParser.new do |opts|
				opts.banner = "Usage: speeddev OPERATION [options] file1 file2 ..."

				opts.separator ""
				opts.separator "Operations:"

				opts.on("-c", "--compile", "Compile to CSS (default)") do 
					Configuration.operation = "compile"
				end

				opts.separator ""
				opts.separator "Compile Operation options:"

				opts.on("-o","--compress", "Compress output") do 
					Configuration.compress = true
				end

				opts.separator ""
				opts.separator "Common options:"

				opts.on_tail("-h", "--help", "Show this message") do
					puts opts
					exit
				end

				# Another typical switch to print the version.
				opts.on_tail("--version", "Show version") do
					puts "v" + Speeddev::VERSION
					exit
				end
			end

			opt_parser.parse!(args)
			Configuration.files = args
			begin
				Configuration.validate!
			rescue ArgumentError
				puts opt_parser
				exit
			end
		end
	end

	class Operation
		def self.run
			if Configuration.operation == nil
				Configuration.operation = "compile"
			end

			case Configuration.operation
			when "compile"
				Compile.run
			else
				raise Exception
			end

		end
	end

	class Compile
		@@fileType = "less"

		def self.run
			tmpType = Configuration.files.first.scan(/\.([a-zA-Z]+)$/)
			if ! tmpType.empty?
				@@fileType = tmpType.first.join
			end
			
			case @@fileType
			when "less"
				less
			when "scss"
				scss
			when "sass"
				sass
			when "styl"
				styl
			when "md"
				markdown
			when "markdown"
				markdown
			else
				puts "Sorry, I can't deal with #{@@fileType} files yet."
				exit
			end
		end

		def self.less
			lessInput = loadFiles
			parser = Less::Parser.new
			input = parser.parse(lessInput)
			puts input.to_css(:compress => Configuration.compress)
		end

		def self.scss
			scssInput = loadFiles
			outputType = 
			puts Sass.compile(scssInput, {
				:style => Configuration.compress ? :compressed : :expanded,
				:syntax => :scss
			})
		end

		def self.sass
			scssInput = loadFiles
			puts Sass.compile(scssInput, {
				:style => Configuration.compress ? :compressed : :expanded,
				:syntax => :sass
			})
		end

		def self.styl
			stylInput = loadFiles
			puts Stylus.compile(stylInput, :compress => Configuration.compress)
		end

		def self.markdown
			markdownInput = loadFiles
			markdown = RDiscount.new(markdownInput)
			puts markdown.to_html
		end

		private

		def self.loadFiles
			output = ""
			Configuration.files.each do |v|
				file = File.new(v, "r")
				while (line = file.gets)
					output += line + "\n"
				end
				file.close
			end
			output
		end
	end
end
