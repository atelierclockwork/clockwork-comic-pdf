require 'yaml'
require_relative 'errors'

# Module-level parameter checker
module ClockworkComicPDF
  # provides option validation and requirements vaildaiton
  module OptionValidation
    def check_valid(options = {})
      o_list = options_for_class self.class
      # valid = o_list.reduce([]) { |a, e| a << e[:name] }
      o_list.each do |option|
        puts option[:name]
        send("#{option[:name]}=".to_sym, option[:default]) if option[:default]
        puts send(option[:name])
      end
    end

    def options_for_class(o_class)
      o_map = YAML.load_file(File.join(__dir__, 'option_map.yml'))
      o_map[o_class.to_s]
    end

    def check_options(options, valid_options)
      options.each do |key|
        unless valid_options.include? key
          fail UndefinedKeyError, "Unsupported key '#{key}' " <<
                                  "for '#{self.class}'"
        end
      end
    end

    def check_required(options = {})
      options.each_pair do |key, val|
        fail UndefinedKeyError, "'#{self.class}' requires " <<
                                "key '#{key}'" if val.nil?
      end
    end
  end
end
