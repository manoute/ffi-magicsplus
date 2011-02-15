begin
  require 'echoe'

  Echoe.new('ffi-magics++', '0.1.1') do |p|
    p.description    = "Ruby wrapper for magics++ using ffi"
    p.url            = "https://github.com/manoute/ffi-magicsplus"
    p.author         = "Mathieu Deslandes"
    p.email          = "math.deslandes @nospam@ gmail.com"
    p.ignore_pattern = ["tmp/*", "script/*"]
    p.development_dependencies = ['ffi']
    p.runtime_dependencies = ['ffi']
  end
rescue LoadError => e
  p "e.message"
end


