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
        set_key(k, v[:default]) if  v[:default]
      end
    end

    # Checks the options for valid keys and values and applies them to
    # the class
    def load_options(options = {})
      load_defaults
      options.each_pair do |k, v|
        warn = "Unsupported key '#{k}' for '#{self.class}'"
        fail UndefinedKeyError, warn unless o_list.keys.include? k
        load_key k, v, o_list[k]
      end if options
    end

    private

    def o_list
      o_map = YAML.load_file(File.join(__dir__, 'option_map.yml'))
      o_map[self.class.to_s]
    end

    def set_key(k, v)
      send("#{k}=".to_sym, v)
    end

    def load_key(k, v, r)
      return set_key(k, v) if v.class == r[:type]
      case r[:type]
      when 'Points' then set_key(k, v.to_points)
      when 'Boolean' then set_key(k, v == true)
      else
        check_ccpdf_classes(k, v, r)
      end
    end

    def check_ccpdf_classes(k, v, r)
      case r[:type]
      when 'ClockworkComicPDF::PageHeader' then set_key(k, PageHeader.new(v))
      when 'ClockworkComicPDF::Cover' then set_key(k, Cover.new(v))
      else
        fail "Invalid value #{v}" unless v.class.to_s == r[:type]
        set_key(k, v)
      end
    end

    public

    def check_options(options, valid_options)
      options.each do |key|
        unless valid_options.include? key
          warn = "Unsupported key '#{key}' for #{self.class}"
          fail UndefinedKeyError, warn
        end
      end
    end

    def check_required(options = {})
      options.each_pair do |key, val|
        warn = "#{self.class} requires key #{key}"
        fail UndefinedKeyError, warn if val.nil?
      end
    end
  end
end
