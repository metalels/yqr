require "open3"

test_cases = [
  {
    command: %q(bundle exec yqr --file spec/files/example1.yaml [dog][0]),
    stdout: "pochi\n"
  },
  {
    command: %q(bundle exec yqr ".find{|a| a[kind] == 'dog'}[name]" < spec/files/example2.yaml),
    stdout: "pochi\n"
  },
  {
    command: %q(cat spec/files/example2.yaml | bundle exec yqr ".select{|a| a[kind] == 'cat'}.last[name]"),
    stdout: "buchi\n"
  },
  {
    command: %q(yqr --file spec/files/example4.yaml "[cat].first"),
    stdout: "---\n:name: mike\n:sex: male\n"
  },
  {
    command: %q(yqr --file spec/files/example4.yaml --raw "[cat].first"),
    stdout: %Q({:name=>"mike", :sex=>"male"}\n)
  },
  {
    command: %q(yqr --file spec/files/example4.yaml --json "[cat].first"),
    stdout: %Q({"name":"mike","sex":"male"}\n)
  },
  {
    command: %q(yqr --file spec/files/example4.yaml ".cat.first"),
    stderr_include: "undefined method"
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


