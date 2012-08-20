# -*- encoding : utf-8 -*-
Given /^I load Time dependencies$/ do
    require 'time'
    require File.dirname(__FILE__) + '/../../lib/time-helper'
    #declare Time::Test here so it doesn't get loaded when not needed
    class Testing < Time
        class << self
            def method_missing( name, args )
                method = name.to_s.gsub /test_/, ''
                return self.method( method ).call( args )
            end
        end
    end
end
