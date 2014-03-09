require 'yaml'
require_relative 'errors'
require_relative 'to_points'

module ClockworkComicPDF
  # Loads the default options and valid options from the the companion
  # option_map.yml file, which follows the structure of:
  # <Class Name>:
  #   :<Symbol for value name>:
  #      :type: Class name of Stored Variable
  #      :default: value for key OR :required: false to signal the key is not
  #                a required key for this setting during the final validation
  #
  module OptionValidation
    # Loads the default options for the class
    def load_defaults
      o_list.each_pair do |k, v|
        set_key(k, v[:default]) unless  v[:default].nil?
      end
    end

    # Checks the options for valid keys and values and applies them to
    # the class
    def load_options(options = {})
      load_defaults
      options.each_pair do |k, v|
        warn = "Unsupported key '#{k}' for '#{self.class}'"
        fail UndefinedKeyError, warn unless o_list.keys.include? k
        set_key(k, validate_key(v, o_list[k][:type]))
      end if options
    end

    def validate_self
      puts "validating #{self}"
    end

    # TODO: Update check_required method to use the option_map.yml info
    def check_required(options = {})
      options.each_pair do |key, val|
        warn = "#{self.class} requires key #{key}"
        fail UndefinedKeyError, warn if val.nil?
      end
    end

    private

    def o_map
      YAML.load_file(File.join(__dir__, 'option_map.yml'))
    end

    def o_list
      o_map[self.class.to_s]
    end

    def set_key(k, v)
      send("#{k}=".to_sym, v)
    end

    def validate_key(v, type)
      return v if v.class.to_s == type
      o_map.keys.include?(type) ? s_to_class(type).new(v) :
                                  check_types(v, type)
    end

    def check_types(v, type)
      case type
      when 'Points' then return v.to_points
      when 'Boolean' then return v == true
      when 'Numeric' then return check_number(v)
      else
        fail ArgumentError, "Invalid value #{v}. #{type} expected."
      end
    end

    def check_number(v)
      warn = "Invalid value #{v}. Numeric type expected."
      fail ArgumentError, warn unless v.is_a? Numeric
      v
    end

    def s_to_class(s)
      s.split('::').reduce(Object) { |a, e| a.const_get e }
    end
  end
end
