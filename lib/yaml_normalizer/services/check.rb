# frozen_string_literal: true

require 'peach'
require 'pathname'

module YamlNormalizer
  module Services
    # Check is a service class that provides functionality to check if giving
    # YAML files are already standardized (normalized).
    # @exmaple
    #   check = YamlNormalizer::Services::Call.new('path/to/*.yml')
    #   result = check.call
    class Check < Base
      include Helpers::Normalize

      # files is a sorted array of file path Strings
      attr_reader :files

      # Create a Check service object by calling .new and passing one or
      # more Strings that are interpreted as file glob pattern.
      # @param *args [Array<String>] a list of file glob patterns
      def initialize(*args)
        files = args.each_with_object([]) { |a, o| o << Dir[a.to_s] }
        @files = files.flatten.sort.uniq
      end

      # Normalizes all YAML files defined on instantiation.
      def call
        files.peach do |file|
          if IsYaml.call(file)
            normalized?(file)
          else
            $stderr.puts "#{file} not a YAML file"
          end
        end
      end

      private

      def normalized?(file)
        file = Pathname.new(file).relative_path_from(Pathname.new(Dir.pwd))
        input = File.read(file, mode: 'r:bom|utf-8')
        norm = normalize_yaml(input)

        if input.eql?(norm)
          $stdout.puts "[PASSED] already normalized #{file}"
        else
          $stdout.puts "[FAILED] normalization suggested for #{file}"
        end
      end
    end
  end
end
