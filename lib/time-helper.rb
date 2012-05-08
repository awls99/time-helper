#@version 1.0
#@author Arthur
class Time
    #class methods
    class << self
        def strtotime string
            abort 'invalid date' unless valid_datetime? string
            h,m,s = 0,0,0

            if date_or_dt( string ) == :datetime
                separator = dt_get_separator string
                date, time = 0, 0
                if separator 
                    date, time = string.split( separator )
                else
                    date, time = string[0..7], string[8..13]
                end
                h,m,s  = get_time_array time
                string = date
            end    
            separator = get_separator string
            order     = get_order string
            if separator
                dy, mo, yd = string.split( separator )
                if order == :dmy
                    return Time.local( yd, mo, dy,h,m,s )
                elsif order == :ymd
                    return Time.local( dy, mo, yd,h,m,s) 
                end
            end
            if order == :dmy
                return Time.local( string[4..7].to_i, string[2..3].to_i, string[0..1].to_i,h,m,s )
            elsif order == :ymd
                return Time.local( string[0..3].to_i, string[4..5].to_i, string[6..7].to_i,h,m,s )
            end
            
        end

        def valid_datetime? string
            return false unless string.match /\d{2,4}.?\d{2}.?\d{2,4}(?:.?\d{2}:?\d{2}:?\d{2})?/
            return true
        end

        private
            def get_time_array time
                h,m,s = 0,0,0
                if time.match /\d{6}/
                    h,m,s = time[0..1], time[2..3], time[4..5]
                else
                    h,m,s = time.split(':')
                end
                return h,m,s
            end
            #@return [Symbol] if string is date or datetime
            def date_or_dt string
                #case there's no separators are the easiest to handle
                return :datetime if string.match /\d{14}/
                return :date if string.match /\d{8}/
                #now those are out of the way it's easier...
                return :datetime if string.match /^\d{2,4}(?:.\d{2,4}){5}$/
                #we assume the string is valid here...
                return :date
            end
            #@param string [String] date string
            #@return [String|Nil] separator
            def get_separator string
                separators = string.match( /\d{2,4}(.)?\d{2}(.)?\d{2,4}/ )
                return nil unless separators[1]

                abort 'separators must be equal'  unless separators[2] == separators[1]
                return separators[2]
            end
            #@param string [String] datetime string
            #@return [String] separator between date and time
            def dt_get_separator string
                #trying most commong: space
                separator = ' '
                date, time = string.split separator
                if date and time
                    return separator
                end
                #if there's no separator...
                return nil if string.match /\d{14}/
                separators = string.match(/(.)\d{2}:\d{2}:\d{2}$/)
                return separators[1] if separators[1]
                abort 'could not find date time separator'
            end
            #see Time#get_order
            def get_dt_order string
                separator = dt_get_separator string
                if separator 
                    return get_order( string.split( separator )[0] )
                end
                return get_order( string[0..7] )
            end
            
            #@param string [String] date string
            #@return [symbol] order dmy or ymd
            def get_order string
                separator  = get_separator string
                day  = Regexp.new('^([012]\d)|(3[01])$')
                year = Regexp.new('^\d{4}$')
                if separator
                    dy, m, yd = string.split( separator )
                    if day.match( dy ) and year.match( yd )
                        return :dmy
                    elsif year.match( dy ) and day.match( yd )
                        return :ymd
                    else
                        abort 'can\'t find order'
                    end
                else
                    return no_separator_order string
                end
            end
             
            #@param string [String] date string
            #@return [symbol] order dmy or ymd
            #@note called when no separator is found on string
            #@note might not work well for years < 1970 or > 2020
            #@note experimental
            def no_separator_order string
                if string[0..1].to_i <= 31 and string[2..3].to_i <= 12 and string[4..7].to_i >= 1970 
                    return :dmy
                elsif string[0..3].to_i >= 1970 and string[4..5].to_i and string[6..7].to_i <= 31
                    return :ymd
                end
                abort 'can\'t find order'
            end
    end

    #instance methods
    def add params
        seconds = get_seconds params
        return self + seconds
    end
    def substract params
        seconds = get_seconds params
        return self - seconds
    end

    private
        #@note may not account for leap years etc
        def get_seconds params
            seconds = 0
            times = {
                :year    => 60*60*24*365,
                :month   => 60*60*24*30,
                :day     => 60*60*24,
                :minute  => 60,
                :hour    => 60*60,
                :second => 1,
                :week    => 60*60*24*7,
            }
            params.each do |unit, quantity|
                seconds += quantity * times[ unit ]
            end
            return seconds
        end

end
