module ClockworkComicPDF
  # Validation Module for Book Class
  module BookValidation
    def validate
      validate_self
      cover.validate_self if cover
      sections.each { |s| s.validate_self }
      versions.each { |v| v.validate_self }
      miss = image_mismatch
      if miss.count > 0
        fail_s = "Image directories do no match: #{miss.join(', ')}"
        fail MissingValueError, fail_s
      end
    end

    def image_mismatch
      mismatch = []
      files = version_files
      files.each_pair do |key_v, sec|
        mismatch.concat(scan_version(key_v, sec, files))
      end
      mismatch.flatten
    end

    def scan_version(key_v, sec, files)
      mismatch = []
      files.each_pair do |c_ver, c_sec|
        unless key_v == c_ver
          mismatch << scan_section(key_v.name, sec, c_ver.name, c_sec)
        end
      end
      mismatch
    end

    def scan_section(v_name, sec_v, c_name, sec_c)
      mismatch = []
      sec_v.each_pair do |ss_key, ss_v|
        ss_v.each do |f|
          unless sec_c[ss_key].include? f
            mismatch << "#{f} in section #{ss_key.name} exists " <<
                        "in #{v_name} but not #{c_name}"
          end
        end
      end
      mismatch
    end

    def version_files
      files = {}
      versions.each do |version|
        files[version] = section_files(version)
      end
      files
    end

    def section_files(check_ver)
      s_files = {}
      sections.each do |sub|
        if sub.is_a? ClockworkComicPDF::Sections::SectionImageSet
          s_files[sub] = get_comic_files(check_ver, sub)
        end
      end
      s_files
    end

    def get_comic_files(check_ver, sub)
      current_dir = "./#{check_ver.name}/#{sub.img_path}/"
      unless File.exist?(current_dir)
        fail InvalidValueError, "#{File.path(current_dir)} does not exist"
      end
      c_files = []
      Dir["#{current_dir}*.*"].each do |file|
        c_files << File.basename(file, '.*')
      end
      c_files
    end
  end
end
