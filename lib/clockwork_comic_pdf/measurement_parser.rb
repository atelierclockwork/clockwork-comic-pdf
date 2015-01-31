module ClockworkComicPDF
  # stores the option parsing logic for PDFMaker
  module MeasurementParser
    def parse_options(pdf, opt_in)
      out = {}
      opt_in.each_pair do |key, val|
        case key
        when :height_ratio then out[:height] = pdf.bounds.height * val.to_r
        when :width_ratio then out[:width] = pdf.bounds.width * val.to_r
        else out[key] = convert_val(pdf, val, opt_in)
        end
      end
      out
    end

    def convert_val(pdf, val, opt_in)
      if val.is_a? Array
        val = Array.new(val)
        val.each_index do |i|
          val[i] = convert_val(pdf, val[i], opt_in)
        end
      else
        val = convert_position(pdf, val)
        val = convert_size(pdf, val, opt_in)
      end
      val
    end

    def convert_position(pdf, val)
      val = convert_complex_position(pdf, val)
      val = convert_simple_position(pdf, val)
      val
    end

    def convert_complex_position(pdf, val)
      case val
      when :bounds_top_left then return pdf.bounds.top_left
      when :bounds_top_right then return pdf.bounds.top_right
      when :bounds_bottom_left then return pdf.bounds.bottom_left
      when :bounds_bottom_right then return pdf.bounds.bottom_right
      else return val
      end
    end

    def convert_simple_position(pdf, val)
      case val
      when :bounds_top then return pdf.bounds.top
      when :bounds_bottom then return pdf.bounds.bottom
      when :bounds_left then return pdf.bounds.left
      when :bounds_right then return pdf.bounds.right
      else return val
      end
    end

    def convert_size(pdf, val, opt_in)
      case val
      when :bounds_width then return pdf.bounds.width
      when :bounds_height then return pdf.bounds.height
      when :bounds_center_width then return get_h_center(pdf, opt_in)
      when :bounds_center_height then return get_v_center(pdf, opt_in)
      else return val
      end
    end

    def get_h_center(pdf, opt_in)
      if opt_in[:width_ratio]
        box_width = opt_in[:width_ratio].to_r * pdf.bounds.width
      else
        box_width = opt_in[:width]
      end
      pdf.bounds.width / 2 - box_width / 2
    end

    def get_v_center(pdf, opt_in)
      box_height = get_box_height(opt_in)
      pdf.bounds.height / 2 - box_height / 2
    end

    def get_box_height(opt_in)
      if opt_in[:height_ratio]
        opt_in[:height_ratio].to_r * pdf.bounds.height
      else
        opt_in[:height]
      end
    end
  end
end
