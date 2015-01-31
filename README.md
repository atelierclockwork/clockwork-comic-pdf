#Clockwork Comic PDF:

###A Simple(ish) Ruby System for creating print and web ready PDF files.

Clockwork Comic PDF is designed to allow an artist to create a print ready version of a comic collection faster and easier than laying out out by hand.  

###Should I Be Using CCPDF?

While CCPDF supports some text features, it really is meant for adding similarly sized, ordered images to a document. If you want more control of creating your document and are comfortable with Ruby, you should consider [Prawn](http://prawnpdf.org).

###Current Features

- 1 image (jpg or pdf) per page comics, centered and with a title above them.
- Automatic, optional, table of contents generation.
- Optional page headers and page numbers.
- The ability to automatically offset pages from the spine
- User specified page size and margins.
- Support for loading external fonts via .ttf or .dfont files and specify the standard font size for a document
- Formatted and unformatted text boxes with size, position, width and height controls and loading content from files outside of the YAML file.
- Support for a cover page that is a different page size from the rest of the document
- Specify multiple versions of the same book that use different DPI settings and image directories to load optimized images for every version.
- Disable the offset from spine in versions for digital distribution

###Usage

To install CCPDF, you need to have ruby installed, and then run:

    gem install clockworkcomicpdf

To create PDF files specified in a YAML file:

    irb
    
    require 'clockworkcomicpdf'

    ClockworkComicPDF.book_from_yaml 'comic.yaml'

###Sample YAML

This is a skeleton of a YAML file that will produce a book, assuming all of the correct subdirectories exist in the folder CCPDF is run in. A viable sample is planned for the next release. 

    :base_file_name: Clockwork Comic PDF Sample
    :info:
      :Title: CCPDF Sample
      :Author: Michael Skiba
    :page_size:
      - :val: 6.5
        :type: :in
      - :val: 9
        :type: :in
    :margin:
     - :val: .5
       :type: :in
     - :val: .25
       :type: :in
     - :val: .5
       :type: :in
     - :val: .25
       :type: :in
    :spine_offset:
      :val: 0.5
      :type: :in
    :font: Arial
    :font_size: 10
    :print_toc: true
    :print_pagenum: true
    :page_header:
      :left_text: Clockwork Comic PDF
      :right_text: Michael Skiba Skiba
      :align: :center
      :size: 8
    :cover:
      :size:
        - :val: 12.25
          :type: :in
        - :val: 8.75
          :type: :in
      :path: ./cover
      :file: ccpdf_cover.png
    :versions:
      - :name: print
        :dpi: 1200
      - :name: web
        :dpi: 150
        :print_cover: true
        :trim_offset: true
    :sections:
      :front_matter:
        - :name: Title Page
          :type: :formatted_text_box
          :file: ./pages/title.yml
          :options:
            :align: :center
            :valign: :center
            :at: :bounds_top_left
            :width: :bounds_width
            :height: :bounds_height
            :leading: 10
            :size: 10
        - :name: Copyright Page
          :type: :text_box
          :file: ./pages/copyright.txt
          :options:
            :align: :left
            :valign: :bottom
            :at: :bounds_top_left
            :width: :bounds_width
            :height: :bounds_height
            :size: 10
        - :name: Dedication Page
          :type: :text_box
          :file: ./pages/dedication.txt
          :options:
            :align: :center
            :valign: :center
            :at: 
                - :bounds_center_width
                - :bounds_top
            :width_ratio: 1/2
            :height: :bounds_height
            :size: 12
      :body:
        - :name: "Part 1: Using CCPDF"
          :type: :comic_pages
          :directory: part1
          :print_section_intro: true
        - :name: "Part 2: More Tricks"
          :type: :comic_pages
          :directory: part2
          :print_section_intro: true
      :end_matter:
        - :name: About the Author
          :type: :text_box
          :file: ./pages/about.txt
          :options:
            :align: :center
            :valign: :center
            :at:
              - :bounds_center_width
              - :bounds_top
            :width_ratio: 2/3
            :height: :bounds_height
            :size: 12

###Planned Features

- A verbose sample and extended manual.
- Support of multiple images per page
- Support for one off placeholder images
- Breaking more of the hard coded sections of the layout like header properties into YML configuration
- Separate linting for verifying the YAML input files before trying to print.

###Release Policies

I plan to keep the YAML files backwards compatible, but right now the software is in an early beta state and I may make major structural changes.

###Credits

This wouldn't exist without [Prawn](http://prawnpdf.org), all of the real PDF rendering in the project uses Prawn.

###License
Clockwork Comic PDF is distributed under the MIT License. If you need 