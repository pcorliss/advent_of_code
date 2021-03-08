#guard :shell do
#  watch(%r{^*\.rb}) { `bundle exec rspec --force-color -f doc spec/ ` }
#end

guard 'rspec', cmd: 'bundle exec rspec --force-color -f doc spec/', :all_on_start => true do
  watch(%r{^([^/]+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/.*_spec\.rb$})
end

notification :tmux,
  display_message: true,
  timeout: 5, # in seconds
  default_message_format: '%s >> %s',
  success:                "green",
  failed:                 "red",
  pending:                "yellow",
  default:                "green"
