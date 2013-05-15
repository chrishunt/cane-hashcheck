module Cane
  # Creates violations for hashes using pre-Ruby 1.9 hash syntax. Hash rockets
  # are allowed only if the key is a 'string' or CONSTANT.
  HashCheck = Struct.new(:options) do

    DESCRIPTION  = 'Ruby 1.9 hash syntax violation'
    DEFAULT_GLOB = '{app,lib}/**/*.rb'

    def self.key; :hash; end
    def self.name; 'Hash check'; end
    def self.options
      {
        hash_glob: [
          'File glob to run hash checks over',
          default: DEFAULT_GLOB,
          clobber: :no_hash
        ]
      }
    end

    def violations
      [].tap do |violations|
        unless options[:no_hash]
          each_violation do |file_name, line_number|
            violations << new_violation(file_name, line_number)
          end
        end
      end
    end

    private

    def new_violation(file_name, line_number)
      {
        file: file_name,
        line: line_number,
        description: DESCRIPTION
      }
    end

    def each_violation
      file_names.each do |file_name|
        ::File.read(file_name).each_line.map.with_index do |line, line_number|
          if invalid? line
            yield file_name, line_number + 1
          end
        end
      end
    end

    def invalid?(line)
      line =~ /([^'"A-Z\d])\s+=>\s+/
    end

    def file_names
      Dir[ options.fetch(:hash_glob){ DEFAULT_GLOB } ]
    end
  end
end
