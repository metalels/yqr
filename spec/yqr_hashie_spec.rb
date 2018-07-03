require "open3"

test_cases = [
  {
    command: %q(bundle exec yqr --file spec/files/example4.yaml ".cat.first"),
    stdout: "---\n:name: mike\n:sex: male\n"
  },
  {
    command: %q(bundle exec yqr --file spec/files/example4.yaml --raw ".cat.first"),
    stdout: %Q(#<Hashie::Mash name="mike" sex="male">\n)
  },
]


errs = []
test_cases.each do |test|
  stdout, stderr, stcode = Open3.capture3 test[:command]
  if test.include?(:stdout) && stdout == test[:stdout]
    print "."
  elsif test.include?(:stdout_include) && stdout =~ /#{test[:stdout_include]}/
    print "."
  elsif test.include?(:stderr) && stderr == test[:stderr]
      print "."
  elsif test.include?(:stderr_include) && stderr =~ /#{test[:stderr_include]}/
      print "."
  else
    print "x"
    errs.push({
      command: test[:command],
      expect: test[:stdout],
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
  stdout: #{err[:stdout]}
  stderr: #{err[:stderr]}

    EOS
  end
  puts
  puts "Faild #{errs.count} case."
  exit 1
end


