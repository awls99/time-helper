Given /^I have the date (.+?) with (.+?)$/ do |time_string, time_obj|
    @time_string  = time_string
    @control_time = eval time_obj
end

Given /^I find out the (.|null) separator$/ do |separator|
    separator = nil if separator == 'null'
    Testing.test_get_separator( @time_string ).should == separator
end

Given /^I found the order ([dmy]{3})$/ do |order|
    Testing.test_get_order( @time_string ).to_s.should == order
end
Given /^I found the order ([dmy]{3}) of the datetime$/ do |order|
    Testing.test_get_dt_order( @time_string ).to_s.should == order
end

When /^I make a time object$/ do
     @time = Time.strtotime @time_string
end

Then /^I should have these many seconds$/ do
    puts @control_time.to_i
    @time.to_i.should == @control_time.to_i
end

Given /^I find out the datetime (.+?) separator$/ do |dt_separator|
    dt_separator = ' ' if dt_separator == 'space'
    dt_separator = nil if dt_separator == 'null'
    Testing.test_dt_get_separator( @time_string ).should == dt_separator
end

Given /^I have the datetime object: (.+?)$/ do |time_obj|
    @time = eval time_obj
end

When /^I try to ((?:add)|(?:substract)) (\d+) (\w+?)$/ do |operation, number, unit|
    time    = @time.clone
    @result = time.method( operation ).call( unit.to_sym => number.to_i )
end

Then /^my result should be on the correct: (.+?)$/ do |obj|
    expected = eval obj
    @result.to_i.should == expected.to_i
end

When /^I try with hash to ((?:add)|(?:substract)) (.+?)$/ do |operation, hash|
    time    = @time.clone
    op_hash = eval hash
    @result = time.method( operation ).call( op_hash )
end
