  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Find new and different MySQL error log entries.
  #
  # Maatkit::ErrorLog.new( array, str, array)
  #
  class Maatkit::ErrorLog

    #
    # Prompt for a password when connecting to MySQL.
    attr_accessor :ask_pass # FALSE

    #
    # short form: -A; type: string
    # Default character set.  If the value is utf8, sets Perl's binmode on STDOUT to utf8, passes the
    # mysql_enable_utf8 option to DBD::mysql, and runs SET NAMES UTF8 after connecting to MySQL.  Any other
    # value sets binmode on STDOUT without the utf8 layer, and runs SET NAMES after connecting to MySQL.
    attr_accessor :charset # (No # value)

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the
    # command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_error_log.conf,/home/joel/.maatkit.conf,/home/joel/.mk_error_log.conf

    #
    # default: yes
    # Continue parsing even if there is an error.
    attr_accessor :continue_on_error # TRUE

    #
    # short form: -F; type: string
    # Only read mysql options from the given file.  You must give an absolute pathname.
    attr_accessor :defaults_file # (No # value)

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No # value)

    #
    # default: yes
    # Load known, built-in patterns.
    # mk-error-log has a built-in list of known patterns.  This are normally loaded by default, but if you
    # don't want them to be used you can disable them from being loaded by specifying "--no-known-patterns".
    attr_accessor :known_patterns # TRUE

    #
    # type: string
    # Load a list of known patterns from this file.
    # Patterns in the file should be formatted like this:
    #   name1
    #   level1
    #   pattern1
    #   nameN
    #   levelN
    #   patternN
    # Each pattern has three parts: name, level and regex pattern.  Patterns are separated by a blank line.
    # A pattern's name is what is printed under the Message column in the "OUTPUT".  Likewise, its level is
    # printed under the Level column.  The regex pattern is what mk-error-log uses to match this pattern.
    # Any Perl regular expression should be valid.
    # Here is a simple example:
    #   InnoDB: The first specified data file did not exist!
    #   info
    #   InnoDB: The first specified data file \S+
    #   InnoDB: Rolling back of trx complete
    #   info
    #   InnoDB: Rolling back of trx id .*?complete
    # See also "--save-patterns".
    attr_accessor :load_patterns # (No # value)

    #
    # short form: -p; type: string
    # Password to use when connecting.
    attr_accessor :password # (No # value)

    #
    # type: string
    # Create the given PID file when daemonized.  The file contains the process ID of the daemonized
    # instance.  The PID file is removed when the daemonized instance exits.  The program checks for the
    # existence of the PID file when starting; if it exists and the process with the matching PID exists, the
    # program exits.
    attr_accessor :pid # (No # value)

    #
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No # value)

    #
    # type: string
    # Read and write resume position to this file; resume parsing from last position.
    # By default mk-error-log parses an error logs from start (pos 0) to finish.  This option allows the tool
    # to start parsing an error log from where it last ended as long as the file has the same name and inode
    # (e.g. it hasn't been rotated) and its size is larger.  If the log file's name or inode is different,
    # then a new resume file is started and the old resume file is saved with the old error log's inode
    # appended to its file name.  If the log file's size is smaller (e.g. the log was truncated), then
    # parsing begins from the start.
    # A resume file is a simple, four line text file like:
    #   file:/path/to/err.log
    #   inode:12345
    #   pos:67890
    #   size:987100
    # The resume file is read at startup and updated when mk-error-log finishes parsing the log.  Note that
    # CTRL-C prevents the resume file from being updated.
    # If the resume file doesn't exist it is created.
    # A line is printed before the main report which tells when and at what position parsing began for the
    # error log if it was resumed.
    attr_accessor :resume # (No # value)

    #
    # type: string
    # After running save all new and old patterns to this file.
    # This option causes mk-error-log to save every pattern it has to the file.  This file can be used for
    # subsequent runs with "--load-patterns".  The patterns are saved in descending order of frequency, so
    # the most frequent patterns are at top.
    attr_accessor :save_patterns # (No # value)

    #
    # type: string; default: wait_timeout=10000
    # Set these MySQL variables.  Immediately after connecting to MySQL, this string will be appended to SET
    # and executed.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # type: string
    # Parse only events newer than this value (parse events since this date).
    # This option allows you to ignore events older than a certain value and parse only those events which
    # are more recent than the value.  The value can be several types:
    #   * Simple time value N with optional suffix: N[shmd], where
    #  #  s=seconds, h=hours, m=minutes, d=days (default s if no suffix
    #  #  given); this is like saying "since N[shmd] ago"
    #   * Full date with optional hours:minutes:seconds: YYYY-MM-DD [HH:MM::SS]
    #   * Short, MySQL-style date: YYMMDD [HH:MM:SS]
    # Events are assumed to be in chronological--older events at the beginning of the log and newer events at
    # the end of the log.  "--since" is strict: it ignores all events until one is found that is new enough.
    # Therefore, if the events are not consistently timestamped, some may be ignored which are actually new
    # enough.
    # See also "--until".
    attr_accessor :since # (No # value)

    #
    # short form: -S; type: string
    # Socket file to use for connection.
    attr_accessor :socket # (No # value)

    #
    # type: string
    # Parse only events older than this value (parse events until this date).
    # This option allows you to ignore events newer than a certain value and parse only those events which
    # are older than the value.  The value can be one of the same types listed for "--since".
    # Unlike "--since", "--until" is not strict: all events are parsed until one has a timestamp that is
    # equal to or greater than "--until".  Then all subsequent events are ignored.
    attr_accessor :until # (No # value)

    #
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No # value)

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_error_log

    #
    # Returns a new ErrorLog Object
    #
    def initialize()
    end

    #
    # Execute the command
    #
    def start(options = nil)
      tmp = Tempfile.new('tmp')
      command = option_string() + options.to_s + " 2> " + tmp.path
      success = system(command)
      if success
        begin
          while (line = tmp.readline)
            line.chomp
            selected_string = line
          end
        rescue EOFError
          tmp.close
        end
        return selected_string
      else
        tmp.close!
        return success
      end
    end

    def config
      option_string()
    end

    private

    def option_string()

      unless @path_to_mk_error_log
        ostring = "mk-error-log "
      else
        ostring = @path_to_mk_error_log + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-error-log"
          if (tmp_value.is_a? TrueClass) || (tmp_value.is_a? FalseClass)
            ostring += "#{tmp_string} "
          else
            ostring += "#{tmp_string} #{tmp_value} "
          end
        end
      end

      return ostring

    end

  end

