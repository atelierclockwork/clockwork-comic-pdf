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
      cleanup
    end

    # Checks to make sure that all required keys are non-nil, and that all
    # values conform to the appropriate class
    def validate_self
      o_list.each_pair do |k, v|
        if v[:required] || v[:default]
          warn = "#{k} required for #{self.class}"
          fail MissingValueError, warn if send(k).nil?
        end
        validate_key(send(k), v[:type])
      end
      cleanup
    end

    private

    # nils out the o_map and o_list variables when parsing finishes
    def cleanup
      @o_map = nil
      @o_list = nil
    end

    # loads the YAML info from option_map into memory
    def o_map
      return @o_map if @o_map
      @o_map = YAML.load_file(File.join(__dir__, 'option_map.yml'))
    end

    # returns the appropriate mapping for the current class
    def o_list
      return @o_list if @o_list
      @o_list = o_map[self.class.to_s]
    end

    # uses message sending to convert the symbol value into a setter and then
    # sets the variable
    def set_key(k, v)
      send("#{k}=".to_sym, v)
    end

    # checks if the key is valid, and returns the key if it is
    # also assumes any class defined by options validation is
    # option validation compliant and attempts to instantiate it
    # with a hash value if types don't line up
    def validate_key(v, type)
      return v if v.class.to_s == type
      o_map.keys.include?(type) ? s_to_class(type).new(v) :
                                  check_types(v, type)
    end

    # performs conversion checks for a handful of special case types
    def check_types(v, type)
      case type
      when 'Points' then return v.to_points
      when 'Boolean' then return v == true
      when 'Numeric' then return check_number(v)
      else
        fail ArgumentError, "Invalid value #{v}. #{type} expected."
      end unless v.nil?
    end

    # checks to see the input is any numeric type for Numeric
    def check_number(v)
      warn = "Invalid value #{v}. Numeric type expected."
      fail ArgumentError, warn unless v.is_a? Numeric
      v
    end

    # converts a string to a class constant
    def s_to_class(s)
      s.split('::').reduce(Object) { |a, e| a.const_get e }
    end
  end
end
