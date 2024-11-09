if defined? RubyVM::YJIT.enable
  RubyVM::YJIT.enable
else
  STDERR.puts "WARNING: No YJIT detected, performance may be suboptimal."
end