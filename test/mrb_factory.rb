##
## Factory Test
##

assert("Factory#hello") do
  t = Factory.new "hello"
  assert_equal("hello", t.hello)
end

assert("Factory#bye") do
  t = Factory.new "hello"
  assert_equal("hello bye", t.bye)
end

assert("Factory.hi") do
  assert_equal("hi!!", Factory.hi)
end
