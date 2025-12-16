require_relative 'lexer'

def stop
  puts
  exit
end

# handle Ctrl+C
%w[INT].each do |sig|
  trap(sig) { stop }
end

loop do
  print '>>> '
  input = gets

  # handle Ctrl+D
  stop if input.nil?

  l = Lexer.new(input:)
  puts l.get_tokens
end
