Feature: Get time 
Background: 
Given I load Time dependencies

@time
Scenario Outline: make date instance from string
Given I have the date <date> with <time_obj>
And I find out the <separator> separator
And I found the order <order>
When I make a time object 
Then I should have these many seconds

Examples:

| date | separator | order | time_obj |
| 24-12-2011 | - | dmy | Time.local(2011,12,24) |
| 2011-12-24 | - | ymd | Time.local(2011,12,24) |
| 24/12/2011 | / | dmy | Time.local(2011,12,24) |
| 2011/12/24 | / | ymd | Time.local(2011,12,24) |
| 24122011 | null | dmy | Time.local(2011,12,24) |
| 20111224 | null | ymd | Time.local(2011,12,24) |
| 30042012 | null | dmy | Time.local(2012,04,30) |
| 20120430 | null | ymd | Time.local(2012,04,30) |
| 01052012 | null | dmy | Time.local(2012,05,01) |
| 20120501 | null | ymd | Time.local(2012,05,01) |



@time @datetime
Scenario Outline: make datetime instance from string
Given I have the date <datetime> with <datetime_obj>
And I find out the datetime <separator> separator
And I found the order <order> of the datetime
When I make a time object 
Then I should have these many seconds

Examples:

| datetime | separator | order | datetime_obj |
| 24-12-2011 22:10:54 | space | dmy | Time.local(2011,12,24,22,10,54) |
| 2011-12-24_12:10:54 | _ | ymd | Time.local(2011,12,24,12,10,54) |
| 24/12/2011-12:20:31 | - | dmy | Time.local(2011,12,24,12,20,31) |
| 01052012122031 | null | dmy | Time.local(2012,05,01,12,20,31) |
| 20120501122031 | null | ymd | Time.local(2012,05,01,12,20,31) |

@time @operations
Scenario Outline: Make time operations on time object
Given I have the datetime object: <datetime_obj>
When I try to <operation> <number> <unit>
Then my result should be on the correct: <date_obj>
Examples:
|datetime_obj | operation | number | unit | date_obj |
| Time.local(2011,12,24,22,10,54) | add | 2 | year | Time.local(2011,12,24,22,10,54) + 2*60*60*24*365 |
| Time.local(2012,05,01,12,20,31) | substract | 1 | month | Time.local(2012,05,01,12,20,31) - 60*60*24*30 |
| Time.local(2011,12,24,22,10,54) | add | 1 | day |Time.local(2011,12,24,22,10,54) + 60*60*24 |
| Time.local(2012,05,01,12,20,31) | substract | 1 | minute | Time.local(2012,05,01,12,20,31)  - 60 |
 
@time @operations
Scenario Outline: Make operations with multiple units
Given I have the datetime object: <datetime_obj>
When I try with hash to <operation> <op_hash>
Then my result should be on the correct: <date_obj>

Examples:
|datetime_obj | operation | op_hash | date_obj |
| Time.local(2011,12,24,22,10,54) | add | {:year => 2, :month => 1 } | Time.local(2011,12,24,22,10,54) + (2*60*60*24*365 + 60*60*24*30) |
| Time.local(2012,05,01,12,20,31) | substract | {:month => 2, :day => 3} | Time.local(2012,05,01,12,20,31) - (60*60*24*30*2 + 60*60*24*3)|
| Time.local(2011,12,24,22,10,54) | add | {:day => 1, :hour => 3} |Time.local(2011,12,24,22,10,54) + (60*60*24 + 60*60*3) |
 
