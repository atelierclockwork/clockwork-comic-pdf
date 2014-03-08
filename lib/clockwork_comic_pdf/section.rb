require_relative 'option_validation'

module ClockworkComicPDF
  # this stores the data for each section of the book
  class Sections < Array
    include OptionValidation

    def initialize(sections)
      sections.each do |section|
        self << section_by_type(section)
      end
    end

    def validate
      each { |section| section.validate }
    end
  end

  # this is the base class for sections data that stores common section info
  class Section
    include OptionValidation

    attr_writer :section_type, :print_intro_page, :intro_page_options,
                :include_in_toc, :content, :options, :name

    def validate
      # check_required(req_keys)
    end

    def initialize(options = {})
      load_options options
      YAML.dump(self)
    end
  end
end
