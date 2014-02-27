Gem::Specification.new do |s|
  s.name        = 'clockworkcomicpdf'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.date        = '2014-02-27'
  s.summary     = 'Clockwork Comic PDF'
  s.description = 'A Simple(ish) Ruby System for creating print and web ready PDF files.'
  s.authors     = ['Michael Skiba']
  s.email       = 'mike.skiba@atelierclockwork.net'
  s.files       = Dir.glob('lib/clockwork_comic_pdf/*') +
                  ['lib/clockworkcomicpdf.rb']
  s.required_ruby_version = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.3.6'
  s.homepage    =
    'http://www.atelierclockwork.net/ccpdf/'
  s.license       = 'MIT'
  s.add_dependency('prawn', '~> 0.15.0')
end