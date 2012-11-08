Feature: Get time 
Background: 
Given I load Time dependencies

@time
Scenario Outline: Date Validity
Then date string "<date>"'s validity is "<validity>"
Examples: 
| date                        | validity |
| 24-12-2011                  | true     |
| 2011-12-24                  | true     |
| 24/12/2011                  | true     |
| 2011/12/24                  | true     |
| 24122011                    | true     |
| 01052012                    | true     |  
| 2011212124                  | false    | 
| not a date                  | false    |
| 24/12/2011-12:20:31.001     | false    |
| 24/12/2011-12:20:31 + 01:00 | false    |
| 20120501122031              | true     |
| 2012050311222031            | false    |  
| 3247y9208u4                 | false    |

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
 


@time
Scenario: Get Tomorrow's date
Given I want "tomorrow"'s date
Then my Time object should be like "Time.now.add(:day => 1)"

@time
Scenario: Get Yesterday's date
Given I want "yesterday"'s date
Then my Time object should be like "Time.now.substract(:day => 1)"

@time @errors
  Scenario Outline: Testing Time Input Errors
    Given I have the string "<input>"
    When I try to run strtotime I should get a "<error_class>"
  Examples:
    | input        | error_class |
    | 12-11/11 | GenericInputError |
    | 12-11-1111:11:11 | GenericInputError |
    | 3247y9208u4 | InvalidTimeStringFormat |

@time @comparison
Scenario Outline: Comparing Times with =~
    Then comparing TimeA with TimeB with an acceptable difference of delta seconds will yeild a true or false result
    | TimeA  | <timeA>  |
    | TimeB  | <timeB>  |
    | delta  | <delta>  | 
    | result | <result> | 
 Examples:
    | timeA | timeB | delta | result |
    | Time.now | Time.now.add(:minute => 5 ) | 300 | true | 
    | Time.now | Time.now.add(:minute => 5 ) | 299 | false | 
    | Time.now | Time.now.add(:hour => 5 ) | 3600 | false | 
    | Time.strtotime('11-01-2000') | Time.strtotime('11-05-2000') | 31536000 | true | 
    | Time.now | Time.now.add(:year => 5 ) | 60 | false | 
