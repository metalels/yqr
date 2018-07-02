require "open3"

test_cases = [
  {
    command: %q(cat spec/files/example1.yaml | bundle exec yqr [dog][0]),
    result: "pochi\n"
  },
  {
    command: %q(cat spec/files/example2.yaml | bundle exec yqr ".find{|a| a[kind] == 'dog'}[name]"),
    result: "pochi\n"
  },
  {
    command: %q(cat spec/files/example2.yaml | bundle exec yqr ".select{|a| a[kind] == 'cat'}.last[name]"),
    result: "buchi\n"
  },
]


errs = []
test_cases.each do |test|
  stdout, stderr, stcode = Open3.capture3 test[:command]
  if stdout == test[:result]
    print "."
  else
    print "x"
    errs.push({
      command: test[:command],
      expect: test[:result],
      stdout: stdout,
      stderr: stderr,
      status: stcode
    })
  end
end

puts
puts

if errs.empty?
  puts "Success!"
else
  errs.each do |err|
    puts <<-EOS
Case: #{err[:command]}
  expect: #{err[:expect]}
  result: #{err[:stdout]}#{"\n#{err[:stderr]}" unless err[:stderr].empty?}

    EOS
  end
  puts
  puts "Faild #{errs.count} case."
  exit 1
end


