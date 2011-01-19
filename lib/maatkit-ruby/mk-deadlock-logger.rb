  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Extract and log MySQL deadlock information.
  #
  # Maatkit::DeadlockLogger.new( array, str, array)
  #
  class Maatkit::DeadlockLogger

    #
    # Prompt for a password when connecting to MySQL.
    attr_accessor :ask_pass # FALSE

    #
    # short form: -A; type: string
    # Default character set. If the value is utf8, sets Perl's binmode on STDOUT to utf8, passes the mysql_enable_utf8 option to DBD::mysql, and runs SET NAMES UTF8 after connecting to MySQL. Any other value sets binmode on STDOUT without the utf8 layer, and runs SET NAMES after connecting to MySQL.
    attr_accessor :charset # (No value)

    #
    # type: string
    # Use this table to create a small deadlock. This usually has the effect of clearing out a huge deadlock, which otherwise consumes the entire output of SHOW INNODB STATUS. The table must not exist. mk-deadlock-logger will create it with the following MAGIC_clear_deadlocks structure:
    #   CREATE TABLE test.deadlock_maker(a INT PRIMARY KEY) ENGINE=InnoDB;
    # After creating the table and causing a small deadlock, the tool will drop the table again.
    attr_accessor :clear_deadlocks # (No value)

    #
    # Collapse whitespace in queries to a single space. This might make it easier to inspect on the command line or in a query. By default, whitespace is collapsed when printing with --print, but not modified when storing to --dest. (That is, the default is different for each action).
    attr_accessor :collapse # FALSE

    #
    # type: hash
    # Output only this comma-separated list of columns. See OUTPUT for more details on columns.
    attr_accessor :columns # (No value)

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_deadlock_logger.conf,/home/joel/.maatkit.conf,/home/joel/.mk_deadlock_logger.conf

    #
    # Create the table specified by --dest.
    # Normally the --dest table is expected to exist already. This option causes mk-deadlock-logger to create the table automatically using the suggested table structure.
    attr_accessor :create_dest_table # FALSE

    #
    # Fork to the background and detach from the shell. POSIX operating systems only.
    attr_accessor :daemonize # FALSE

    #
    # short form: -F; type: string
    # Only read mysql options from the given file. You must give an absolute pathname.
    attr_accessor :defaults_file # (No value)

    #
    # type: DSN
    # DSN for where to store deadlocks; specify at least a database (D) and table (t).
    # Missing values are filled in with the same values from the source host, so you can usually omit most parts of this argument if you're storing deadlocks on the same server on which they happen.
    # By default, whitespace in the query column is left intact; use --[no]collapse if you want whitespace collapsed.
    # The following MAGIC_dest_table is suggested if you want to store all the information mk-deadlock-logger can extract about deadlocks:
    #  CREATE TABLE deadlocks (
    #    server char(20) NOT NULL,
    #    ts datetime NOT NULL,
    #    thread int unsigned NOT NULL,
    #    txn_id bigint unsigned NOT NULL,
    #    txn_time smallint unsigned NOT NULL,
    #    user char(16) NOT NULL,
    #    hostname char(20) NOT NULL,
    #    ip char(15) NOT NULL, -- alternatively, ip int unsigned NOT NULL
    #    db char(64) NOT NULL,
    #    tbl char(64) NOT NULL,
    #    idx char(64) NOT NULL,
    #    lock_type char(16) NOT NULL,
    #    lock_mode char(1) NOT NULL,
    #    wait_hold char(1) NOT NULL,
    #    victim tinyint unsigned NOT NULL,
    #    query text NOT NULL,
    #    PRIMARY KEY  (server,ts,thread)
    #  ) ENGINE=InnoDB
    # If you use --columns, you can omit whichever columns you don't want to store.
    attr_accessor :dest # (No value)

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No value)

    #
    # type: time
    # How often to check for deadlocks. If no --run-time is specified, mk-deadlock-logger runs forever, checking for deadlocks at every interval. See also --run-time.
    attr_accessor :interval # (No value)

    #
    # type: string
    # Print all output to this file when daemonized.
    attr_accessor :log # (No value)

    #
    # Express IP addresses as integers.
    attr_accessor :numeric_ip # FALSE

    #
    # short form: -p; type: string
    # Password to use when connecting.
    attr_accessor :password # (No value)

    #
    # type: string
    # Create the given PID file when daemonized. The file contains the process ID of the daemonized instance. The PID file is removed when the daemonized instance exits. The program checks for the existence of the PID file when starting; if it exists and the process with the matching PID exists, the program exits.
    attr_accessor :pid # (No value)

    #
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No value)

    #
    # Print results on standard output. See OUTPUT for more. By default, enables --[no]collapse unless you explicitly disable it.
    # If --interval or --run-time is specified, only new deadlocks are printed at each interval. A fingerprint for each deadlock is created using --columns server, ts and thread (even if those columns were not specified by --columns) and if the current deadlock's fingerprint is different from the last deadlock's fingerprint, then it is printed.
    attr_accessor :print # FALSE

    #
    # type: time
    # How long to run before exiting. By default mk-deadlock-logger runs once, checks for deadlocks, and exits. If --run-time is specified but no --interval is specified, a default 1 second interval will be used.
    attr_accessor :run_time # (No value)

    #
    # type: string; default: wait_timeout=10000
    # Set these MySQL variables. Immediately after connecting to MySQL, this string will be appended to SET and executed.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # short form: -S; type: string
    # Socket file to use for connection.
    attr_accessor :socket # (No value)

    #
    # Print tab-separated columns, instead of aligned.
    attr_accessor :tab # FALSE

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
    attr_accessor :path_to_mk_deadlock_logger

    #
    # Returns a new DeadlockLogger Object
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

      unless @path_to_mk_deadlock_logger
        ostring = "mk-deadlock-logger "
      else
        ostring = @path_to_mk_deadlock_logger + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-deadlock-logger"
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

