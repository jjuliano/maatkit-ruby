  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Monitor MySQL replication delay.
  #
  # Maatkit::Heartbeat.new( array, str, array)
  #
  class Maatkit::Heartbeat

    #
    # Prompt for a password when connecting to MySQL.
    attr_accessor :ask_pass # FALSE

    #
    # short form: -A; type: string
    # Default character set.  If the value is utf8, sets Perl's binmode on STDOUT to utf8, passes the
    # mysql_enable_utf8 option to DBD::mysql, and runs SET NAMES UTF8 after connecting to MySQL.  Any other
    # value sets binmode on STDOUT without the utf8 layer, and runs SET NAMES after connecting to MySQL.
    attr_accessor :charset # (No value)

    #
    # Check slave delay once and exit.
    attr_accessor :check # FALSE

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the
    # command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_heartbeat.conf,/home/joel/.maatkit.conf,/home/joel/.mk_heartbeat.conf

    #
    # Create the heartbeat "--table" if it does not exist.
    # This option causes the table specified by "--database" and "--table" to be created with the following
    # MAGIC_create_heartbeat table definition:
    #  CREATE TABLE heartbeat (
    #  # id int NOT NULL PRIMARY KEY,
    #  # ts datetime NOT NULL
    #  );
    # The heartbeat table requires at least one row.  If you manually create the heartbeat table, then you
    # must insert a row by doing:
    #  INSERT INTO heartbeat (id) VALUES (1);
    # This is done automatically by --create-table.
    attr_accessor :create_table # FALSE

    #
    # Fork to the background and detach from the shell.  POSIX operating systems only.
    attr_accessor :daemonize # FALSE

    #
    # short form: -D; type: string
    # The database to use for the connection.
    attr_accessor :database # (No value)

    #
    # default: mysql; type: string
    # Specify a driver for the connection; "mysql" and "Pg" are supported.
    attr_accessor :dbi_driver # mysql

    #
    # short form: -F; type: string
    # Only read mysql options from the given file.  You must give an absolute pathname.
    attr_accessor :defaults_file # (No value)

    #
    # type: string
    # Print latest "--monitor" output to this file.
    # When "--monitor" is given, prints output to the specified file instead of to STDOUT.  The file is
    # opened, truncated, and closed every interval, so it will only contain the most recent statistics.
    # Useful when "--daemonize" is given.
    attr_accessor :file # (No value)

    #
    # type: string; default: 1m,5m,15m
    # Timeframes for averages.
    # Specifies the timeframes over which to calculate moving averages when "--monitor" is given.  Specify as
    # a comma-separated list of numbers with suffixes.  The suffix can be s for seconds, m for minutes, h for
    # hours, or d for days.  The size of the largest frame determines the maximum memory usage, as up to the
    # specified number of per-second samples are kept in memory to calculate the averages.  You can specify
    # as many timeframes as you like.
    attr_accessor :frames # 1m,5m,15m

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No value)

    #
    # type: time; default: 1s
    # Interval between updates and checks.
    # How often to check or update values.  The updates and checks will happen when the Unix time (seconds
    # since epoch) is an even multiple of this value.  The suffix is similar to "--frames".
    attr_accessor :interval # 1

    #
    # type: string
    # Print all output to this file when daemonized.
    attr_accessor :log # (No value)

    #
    # Monitor slave delay continuously.
    # Specifies that mk-heartbeat should check the slave's delay every second and report to STDOUT (or if
    # "--file" is given, to the file instead).  The output is the current delay followed by moving averages
    # over the timeframe given in "--frames".  For example,
    #  5s [  0.25s,  0.05s,  0.02s ]
    attr_accessor :monitor # FALSE

    #
    # short form: -p; type: string
    # Password to use when connecting.
    attr_accessor :password # (No value)

    #
    # type: string
    # Create the given PID file when daemonized.  The file contains the process ID of the daemonized
    # instance.  The PID file is removed when the daemonized instance exits.  The program checks for the
    # existence of the PID file when starting; if it exists and the process with the matching PID exists, the
    # program exits.
    attr_accessor :pid # (No value)

    #
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No value)

    #
    # short form: -q
    # Suppresses normal output.
    attr_accessor :quiet # FALSE

    #
    # type: int
    # Check slaves recursively to this depth in "--check" mode.
    # Try to discover slave servers recursively, to the specified depth.  After discovering servers, run the
    # check on each one of them and print the hostname (if possible), followed by the slave delay.
    # This currently works only with MySQL.  See "--recursion-method".
    attr_accessor :recurse # (No value)

    #
    # type: string
    # Preferred recursion method used to find slaves.
    # Possible methods are:
    #   METHOD #  #  USES
    #   ===========  ================
    #   processlist  SHOW PROCESSLIST
    #   hosts #  #   SHOW SLAVE HOSTS
    # The processlist method is preferred because SHOW SLAVE HOSTS is not reliable.  However, the hosts
    # method is required if the server uses a non-standard port (not 3306).  Usually mk-heartbeat does the
    # right thing and finds the slaves, but you may give a preferred method and it will be used first.  If it
    # doesn't find any slaves, the other methods will be tried.
    attr_accessor :recursion_method # (No value)

    #
    # Use "REPLACE" instead of "UPDATE" for --update.
    # When running in "--update" mode, use "REPLACE" instead of "UPDATE" to set the heartbeat table's
    # timestamp.  The "REPLACE" statement is a MySQL extension to SQL.  This option is useful when you don't
    # know whether the table contains any rows or not.
    attr_accessor :replace # FALSE

    #
    # type: time
    # Time to run before exiting.
    attr_accessor :run_time # (No value)

    #
    # type: string; default: /tmp/mk-heartbeat-sentinel
    # Exit if this file exists.
    attr_accessor :sentinel # /tmp/mk_heartbeat_sentinel

    #
    # type: string; default: wait_timeout=10000
    # Set these MySQL variables.  Immediately after connecting to MySQL, this string will be appended to SET
    # and executed.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # type: int; default: 500000
    # How long to delay checks, in milliseconds.
    # The default is to delay checks one half second.  Since the update happens as soon as possible after the
    # beginning of the second on the master, this allows one half second of replication delay before
    # reporting that the slave lags the master by one second.  If your clocks are not completely accurate or
    # there is some other reason you'd like to delay the slave more or less, you can tweak this value.  Try
    # setting the "MKDEBUG" environment variable to see the effect this has.
    attr_accessor :skew # 500000

    #
    # short form: -S; type: string
    # Socket file to use for connection.
    attr_accessor :socket # (No value)

    #
    # Stop running instances by creating the sentinel file.
    # This should have the effect of stopping all running instances which are watching the same sentinel
    # file.  If none of "--update", "--monitor" or "--check" is specified, "mk-heartbeat" will exit after
    # creating the file.  If one of these is specified, "mk-heartbeat" will wait the interval given by
    # "--interval", then remove the file and continue working.
    # You might find this handy to stop cron jobs gracefully if necessary, or to replace one running instance
    # with another.  For example, if you want to stop and restart "mk-heartbeat" every hour (just to make
    # sure that it is restarted every hour, in case of a server crash or some other problem), you could use a
    # "crontab" line like this:
    #  0 * * * * mk-heartbeat --update -D test --stop \
    #  # --sentinel /tmp/mk-heartbeat-hourly
    # The non-default "--sentinel" will make sure the hourly "cron" job stops only instances previously
    # started with the same options (that is, from the same "cron" job).
    # See also "--sentinel".
    attr_accessor :stop # FALSE

    #
    # type: string; default: heartbeat
    # The table to use for the heartbeat.
    # Don't specify database.table; use "--database" to specify the database.
    attr_accessor :table # heartbeat

    #
    # Update a master's heartbeat.
    attr_accessor :update # FALSE

    #
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No value)

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_heartbeat

    #
    # Returns a new Heartbeat Object
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

      unless @path_to_mk_heartbeat
        ostring = "mk-heartbeat "
      else
        ostring = @path_to_mk_heartbeat + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-heartbeat"
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

