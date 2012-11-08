#encoding: utf-8
#@version 2.0.0 
#@author Arthur
class Time
    #datetime regex
    DateTimeRegex = /^\d{2}|\d{4}[^\d]?\d{2}[^\d]?\d{2}|\d{4}(?:[^\d]?\d{2}:?\d{2}:?\d{2})?$/
    #class methods
    class << self
        #@param string [String] a datetime string with many possible formats
        #@see Time#valid_datetime? or the feature file for valid format
        #@return [Time] set in the date of the string passed
        def strtotime string
            unless valid_datetime? string
                raise InvalidTimeStringFormat
            end
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
        #@param string [String] datetime string
        #@return [Boolean]
        def valid_datetime? string
            valid_number_only_date_sizes = [8,14]
            valid_date_sizes             = [10, 19]
            if string.match /^\d+$/
                return false unless valid_number_only_date_sizes.include? string.length
            else
                return false unless valid_date_sizes.include? string.length
            end
            return false unless string.match DateTimeRegex
            return true
        end
        #@return [Time] Time object set 24 hours ago
        def tomorrow
            return Time.now.add(:day => 1 )
        end
        #@return [Time] return time object 24 hours from now
        def yesterday
            return Time.now.substract(:day => 1 )
        end
        #Converts a Date in to utc format
        #
        #@param value [String] 
        #@return [Time] in UTC
        def utc_parse value
            Time.strtotime(value).utc
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

                raise GenericInputError.new 'separators must be equal'  unless separators[2] == separators[1]
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
                raise GenericInputError.new 'could not find date time separator'
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
                        raise GenericInputError.new 'can\'t find order'
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
                raise GenericInputError.new 'can\'t find order'
            end
    end

    #@param params [Hash] hash of time to be added {:time => amount } (can take several at once)
    #@return [Time] new time object with date set to the result
    # @example add time
    #  t = Time.now()
    #  t.add(:year => 1 ) #=> a time object set for 365 days from now
    #  t.add(:year => 2, :day => 1 ) #=>  a time object set 731 days from now
    #  accepts :year :month :day :minute :hour :second :week
    def add params
        seconds = get_seconds params
        return self + seconds
    end

    #@param params [Hash] hash of time to be added {:time => amount } (can take several at once)
    #@return [Time] new time object with date set to the result
    # @example substract time
    #  t = Time.now()
    #  t.substract(:year => 1 ) returns a time object set for 365 days ago
    #  t.substract(:year => 2, :day => 1 ) returns a time object set 731 ago
    #  accepts :year :month :day :minute :hour :second :week
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

    public
#compares if two Time objects are close enough to each other
#@param other_time [Time] time to be compared to
#@param acceptable_diff [Fixnum]
# @example
# a = Time.now
# b = Time.now.add(:day = 1)
# a =~ b
# => false
# a.=~ b, 86400
# => true
#@note to compare up to the hour you just need var =~ other_var,
# but to pass the second argument you must use var.=~(other_var, :min)
#@note minute is :min seconds is :sec
    def =~(other_time, acceptable_diff = 300 )
        raise InvalidArgument.new('Argument must be an instance of Time') unless other_time.class == Time
        raise InvalidArgument.new('Argument must be fix number') unless acceptable_diff.class == Fixnum
        diff = self.to_i - other_time.to_i
        return ( diff.abs <= acceptable_diff  )
    end

##### Errors #####
    class GenericInputError < StandardError; end
    class InvalidArgument < GenericInputError; end
    class InvalidTimeStringFormat < GenericInputError; end
end
