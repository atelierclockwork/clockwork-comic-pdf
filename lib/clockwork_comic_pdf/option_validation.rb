require_relative 'errors'

# Module-level parameter checker
module ClockworkComicPDF
  # provides option validation and requirements vaildaiton
  module OptionValidation
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
