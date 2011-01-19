  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Replay MySQL query logs.
  #
  # Maatkit::LogPlayer.new( array, str, array)
  #
  class Maatkit::LogPlayer

    #
    # group: Play
    # Prompt for a password when connecting to MySQL.
    attr_accessor :ask_pass # FALSE

    #
    # type: string; default: ./
    # Base directory for "--split" session files and "--play" result file.
    attr_accessor :base_dir # ./

    #
    # type: string; default: session
    # Base file name for "--split" session files and "--play" result file.
    # Each "--split" session file will be saved as <base-file-name>-N.txt, where N is a four digit, zero-
    # padded session ID.  For example: session-0003.txt.
    # Each "--play" result file will be saved as <base-file-name>-results-PID.txt, where PID is the process
    # ID of the executing thread.
    # All files are saved in "--base-dir".
    attr_accessor :base_file_name # session

    #
    # group: Play
    # short form: -A; type: string
    # Default character set.  If the value is utf8, sets Perl's binmode on STDOUT to utf8, passes the
    # mysql_enable_utf8 option to DBD::mysql, and runs SET NAMES UTF8 after connecting to MySQL.  Any other
    # value sets binmode on STDOUT without the utf8 layer, and runs SET NAMES after connecting to MySQL.
    attr_accessor :charset # FALSE

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the
    # command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_log_player.conf,/home/joel/.maatkit.conf,/home/joel/.mk_log_player.conf

    #
    # short form: -F; type: string
    # Only read mysql options from the given file.
    attr_accessor :defaults_file # (No # value)

    #
    # Print which processes play which session files then exit.
    attr_accessor :dry_run # FALSE

    #
    # type: string; group: Split
    # Discard "--split" events for which this Perl code doesn't return true.
    # This option only works with "--split".
    # This option is a string of Perl code or a file containing Perl code that gets compiled into a
    # subroutine with one argument: $event.  This is a hashref.  If the given value is a readable file, then
    # mk-log-player reads the entire file and uses its contents as the code.  The file should not contain a
    # shebang (#!/usr/bin/perl) line.
    # If the code returns true, the query is split; otherwise it is discarded.  The code is the last
    # statement in the subroutine other than "return $event".  The subroutine template is:
    #   sub { $event = shift; filter && return $event; }
    # Filters given on the command line are wrapped inside parentheses like like "( filter )".  For complex,
    # multi-line filters, you must put the code inside a file so it will not be wrapped inside parentheses.
    # Either way, the filter must produce syntactically valid code given the template.  For example, an if-
    # else branch given on the command line would not be valid:
    #   --filter 'if () { } else { }'  # WRONG
    # Since it's given on the command line, the if-else branch would be wrapped inside parentheses which is
    # not syntactically valid.  So to accomplish something more complex like this would require putting the
    # code in a file, for example filter.txt:
    #   my $event_ok; if (...) { $event_ok=1; } else { $event_ok=0; } $event_ok
    # Then specify "--filter filter.txt" to read the code from filter.txt.
    # If the filter code won't compile, mk-log-player will die with an error.  If the filter code does
    # compile, an error may still occur at runtime if the code tries to do something wrong (like pattern
    # match an undefined value).  mk-log-player does not provide any safeguards so code carefully!
    # An example filter that discards everything but SELECT statements:
    #   --filter '$event->{arg} =~ m/^select/i'
    # This is compiled into a subroutine like the following:
    #   sub { $event = shift; ( $event->{arg} =~ m/^select/i ) && return $event; }
    # You can find an explanation of the structure of $event at
    # <http://code.google.com/p/maatkit/wiki/EventAttributes>.
    attr_accessor :filter # (No # value)

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string; group: Play
    # Connect to host.
    attr_accessor :host # (No # value)

    #
    # type: int; default: 1; group: Play
    # How many times each thread should play all its session files.
    attr_accessor :iterations # 1

    #
    # type: int; default: 5000000; group: Split
    # Maximum number of sessions to "--split".
    # By default, "mk-log-player" tries to split every session from the log file.  For huge logs, however,
    # this can result in millions of sessions.  This option causes only the first N number of sessions to be
    # saved.  All sessions after this number are ignored, but sessions split before this number will continue
    # to have their queries split even if those queries appear near the end of the log and after this number
    # has been reached.
    attr_accessor :max_sessions # 5000000

    #
    # group: Play
    # Play only SELECT and USE queries; ignore all others.
    attr_accessor :only_select # FALSE

    #
    # short form: -p; type: string; group: Play
    # Password to use when connecting.
    attr_accessor :password # (No # value)

    #
    # type: string
    # Create the given PID file.  The file contains the process ID of the script.  The PID file is removed
    # when the script exits.  Before starting, the script checks if the PID file already exists.  If it does
    # not, then the script creates and writes its own PID to it.  If it does, then the script checks the
    # following: if the file contains a PID and a process is running with that PID, then the script dies; or,
    # if there is no process running with that PID, then the script overwrites the file with its own PID and
    # starts; else, if the file contains no PID, then the script dies.
    attr_accessor :pid # (No # value)

    #
    # type: string; group: Play
    # Play (execute) session files created by "--split".
    # The argument to play must be a commaxn-separated list of session files created by "--split" or a
    # directory.  If the argument is a directory, ALL files in that directory will be played.
    attr_accessor :play # (No # value)

    #
    # short form: -P; type: int; group: Play
    # Port number to use for connection.
    attr_accessor :port # (No # value)

    #
    # group: Play
    # Print queries instead of playing them; requires "--play".
    # You must also specify "--play" with "--print".  Although the queries will not be executed, "--play" is
    # required to specify which session files to read.
    attr_accessor :print # FALSE

    #
    # Do not print anything; disables "--verbose".
    attr_accessor :quiet # FALSE

    #
    # default: yes
    # Print "--play" results to files in "--base-dir".
    attr_accessor :results # TRUE

    #
    # type: int; default: 8; group: Split
    # Number of session files to create with "--split".
    # The number of session files should either be equal to the number of "--threads" you intend to "--play"
    # or be an even multiple of "--threads".  This number is important for maximum performance because it:
    #   * allows each thread to have roughly the same amount of sessions to play
    #   * avoids having to open/close many session files
    #   * avoids disk IO overhead by doing large sequential reads
    # You may want to increase this number beyond "--threads" if each session file becomes too large.  For
    # example, splitting a 20G log into 8 sessions files may yield roughly eight 2G session files.
    # See also "--max-sessions".
    attr_accessor :session_files # 8

    #
    # type: string; group: Play; default: wait_timeout=10000
    # Set these MySQL variables.  Immediately after connecting to MySQL, this string will be appended to SET
    # and executed.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # short form: -S; type: string; group: Play
    # Socket file to use for connection.
    attr_accessor :socket # (No # value)

    #
    # type: string; group: Split
    # Split log by given attribute to create session files.
    # Valid attributes are any which appear in the log: Thread_id, Schema, etc.
    attr_accessor :split # (No # value)

    #
    # group: Split
    # Split log without an attribute, write queries round-robin to session files.
    # This option, if specified, overrides "--split" and causes the log to be split query-by-query, writing
    # each query to the next session file in round-robin style.  If you don't care about "sessions" and just
    # want to split a lot into N many session files and the relation or order of the queries does not matter,
    # then use this option.
    attr_accessor :split_random # FALSE

    #
    # type: int; default: 2; group: Play
    # Number of threads used to play sessions concurrently.
    # Specifies the number of parallel processes to run.  The default is 2.  On GNU/Linux machines, the
    # default is the number of times 'processor' appears in /proc/cpuinfo.  On Windows, the default is read
    # from the environment.  In any case, the default is at least 2, even when there's only a single
    # processor.
    # See also "--session-files".
    attr_accessor :threads # 2

    #
    # type: string; group: Split
    # The type of log to "--split" (default slowlog).  The permitted types are
    # binlog
    #  #  Split a binary log file.
    # genlog
    #  #  Split a general log file.
    # slowlog
    #  #  Split a log file in any varation of MySQL slow-log format.
    attr_accessor :type # slowlog

    #
    # short form: -u; type: string; group: Play
    # User for login if not current user.
    attr_accessor :user # (No # value)

    #
    # short form: -v; cumulative: yes; default: 0
    # Increase verbosity; can specifiy multiple times.
    # This option is disabled by "--quiet".
    attr_accessor :verbose # 0

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # type: array; default: 0; group: Play
    # Not implemented yet.
    # The wait time is given in seconds with microsecond precision and can be either a single value or a
    # range.  A single value causes an exact wait; example: 0.010 = wait 10 milliseconds.  A range causes a
    # random wait between the given value times; example: 0.001,1 = random wait from 1 millisecond to 1
    # second.
    attr_accessor :wait_between_sessions # (No # value)

    #
    # default: no; group: Play
    # Print warnings about SQL errors such as invalid queries to STDERR.
    attr_accessor :warnings # TRUE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_log_player

    #
    # Returns a new LogPlayer Object
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

      unless @path_to_mk_log_player
        ostring = "mk-log-player "
      else
        ostring = @path_to_mk_log_player + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-log-player"
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

