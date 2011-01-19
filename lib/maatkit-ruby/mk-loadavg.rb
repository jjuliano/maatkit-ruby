  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Watch MySQL load and take action when it gets too high.
  #
  # Maatkit::LoadAvg.new( array, str, array)
  #
  class Maatkit::LoadAvg

    #
    # group: Action
    # Trigger the actions only when all "--watch" items exceed their thresholds.
    # The default is to trigger the actions when any one of the watched items exceeds its threshold.  This
    # option requires that all watched items exceed their thresholds before any action is triggered.
    attr_accessor :and # FALSE

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
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the
    # command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_loadavg.conf,/home/joel/.maatkit.conf,/home/joel/.mk_loadavg.conf

    #
    # Fork to the background and detach from the shell.  POSIX operating systems only.
    attr_accessor :daemonize # FALSE

    #
    # short form: -D; type: string
    # Database to use.
    attr_accessor :database # (No value)

    #
    # short form: -F; type: string
    # Only read mysql options from the given file.  You must give an absolute pathname.
    attr_accessor :defaults_file # (No value)

    #
    # type: string; group: Action
    # Execute this command when watched items exceed their threshold values
    # This command will be executed every time a "--watch" item (or all items if "--and" is specified)
    # exceeds its threshold.  For example, if you specify "--watch "Server:vmstat:swpd:":0">, then this
    # command will be executed when the server begins to swap and it will be executed again at each
    # "--interval" so long as the server is still swapping.
    # After the command is executed, mk-loadavg has no control over it, so it is responsible for its own info
    # gathering, logging, interval, etc.  Since the command is spawned from mk-loadavg, its STDOUT, STDERR
    # and STDIN are closed so it doesn't interfere with mk-loadavg.  Therefore, the command must redirect its
    # output to files or some other destination.  For example, if you specify "--execute-command 'echo
    # Hello'", you will not see "Hello" printed anywhere (neither to screen nor "--log") because STDOUT is
    # closed for the command.
    # No information from mk-loadavg is passed to the command.
    # See also "--and".
    attr_accessor :execute_command # (No value)

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No value)

    #
    # type: time; default: 60s; group: Watch
    # How long to sleep between each check.
    attr_accessor :interval # 60

    #
    # type: string
    # Print all output to this file when daemonized.
    # Output from "--execute-command" is not printed to this file.
    attr_accessor :log # (No value)

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
    # type: time
    # Time to run before exiting.
    # Causes "mk-loadavg" to stop after the specified time has elapsed.  Optional suffix: s=seconds,
    # m=minutes, h=hours, d=days; if no suffix, s is used.
    attr_accessor :run_time # (No value)

    #
    # type: string; default: /tmp/mk-loadavg-sentinel
    # Exit if this file exists.
    attr_accessor :sentinel # /tmp/mk_loadavg_sentinel

    #
    # type: string; default: wait_timeout=10000
    # Set these MySQL variables.  Immediately after connecting to MySQL, this string will be appended to SET
    # and executed.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # short form: -S; type: string
    # Socket file to use for connection.
    attr_accessor :socket # (No value)

    #
    # Stop running instances by creating the "--sentinel" file.
    attr_accessor :stop # FALSE

    #
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No value)

    #
    # short form: -v
    # Print information to STDOUT about what is being done.
    # This can be used as a heartbeat to see that mk-loadavg is still properly watching all its values.  If
    # "--log" is specified, this information will be printed to that file instead.
    attr_accessor :verbose # FALSE

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # type: string; default: vmstat 1 2; group: Watch
    # vmstat command for "--watch" Server:vmstat:...
    # The vmstat output should look like:
    #  procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
    #  r  b # swpd # free # buff  cache # si # so #  bi #  bo # in # cs us sy id wa
    #  0  0 #  # 0 590380 143756 571852 #  0 #  0 #   6 #   9  228  340  4  1 94  1
    #  0  0 #  # 0 590400 143764 571852 #  0 #  0 #   0 #  28  751  818  4  2 90  3
    # The second line from the top needs to be column headers for subsequent lines.  Values are taken from
    # the last line.
    # The default, "vmstat 1 2",  gets current values.  Running just "vmstat" would get average values since
    # last reboot.
    attr_accessor :vmstat # vmstat # 1 # 2

    #
    # type: time; default: 60s
    # Wait this long to reconnect to MySQL.
    # If the MySQL server goes away between "--interval" checks, mk-loadavg will attempt to reconnect to
    # MySQL forever, sleeping this amount of time in between attempts.
    attr_accessor :wait # 60

    #
    # type: string; group: Watch
    # A comma-separated list of watched items and their thresholds (required).
    # Each watched item is string of arguments separated by colons (like arg:arg).  Each argument defines the
    # watch item: what particular value is watched and how to compare the current value to a threshold value
    # (N).  Multiple watched items can be given by separating them with a comma, and the same watched item
    # can be given multiple times (but, of course, it only makes sense to do this if the comparison and/or
    # threshold values are differnt).
    # The first argument is the most important and is case-sensitive.  It defines the module responsible for
    # watching the value.  For example,
    #   --watch Status:...
    # causes the WatchStatus module to be loaded.  The second and subsequent arguments are passed to the
    # WatchStatus module which parses them.  Each watch module requires different arguments.  The watch
    # modules included in mk-loadavg and what arguments they require are listed below.
    # This is a common error when specifying "--watch" on the commnad line:
    #  # mk-loadavg --watch Server:vmstat:swpd:>:0
    #  # Failed to load --watch WatchServer: Error parsing parameters vmstat:swpd:: No comparison parameter; expected >, < or = at ./mk-loadavg line 3100.
    # The "--watch" values need to be quoted:
    #  # mk-loadavg --watch "Server:vmstat:swpd:>:0"
    # Status
    #  #  Watch SHOW STATUS, SHOW INNODB STATUS, and SHOW SLAVE STATUS values.  The value argument is case-
    #  #  sensitive.
    #  #  # --watch Status:[status|innodb|slave]:value:[><=]:N
    #  #  Examples:
    #  #  # --watch "Status:status:Threads_connected:>:16"
    #  #  # --watch "Status:innodb:Innodb_buffer_pool_hit_rate:<:0.98"
    #  #  # --watch "Status:slave:Seconds_behind_master:>:300"
    #  #  You can easily see what values are available for SHOW STATUS and SHOW SLAVE STATUS, but the values
    #  #  for SHOW INNODB STATUS are not apparent.  Some common values are:
    #  #  # Innodb_buffer_pool_hit_rate
    #  #  # Innodb_buffer_pool_pages_created_sec
    #  #  # Innodb_buffer_pool_pages_dirty
    #  #  # Innodb_buffer_pool_pages_read_sec
    #  #  # Innodb_buffer_pool_pages_written_sec
    #  #  # Innodb_buffer_pool_pending_data_writes
    #  #  # Innodb_buffer_pool_pending_dirty_writes
    #  #  # Innodb_buffer_pool_pending_fsyncs
    #  #  # Innodb_buffer_pool_pending_reads
    #  #  # Innodb_buffer_pool_pending_single_writes
    #  #  # Innodb_common_memory_allocated
    #  #  # Innodb_data_fsyncs_sec
    #  #  # Innodb_data_pending_fsyncs
    #  #  # Innodb_data_pending_preads
    #  #  # Innodb_data_pending_pwrites
    #  #  # Innodb_data_reads_sec
    #  #  # Innodb_data_writes_sec
    #  #  # Innodb_insert_buffer_pending_reads
    #  #  # Innodb_rows_read_sec
    #  #  # Innodb_rows_updated_sec
    #  #  # lock_wait_time
    #  #  # mysql_tables_locked
    #  #  # mysql_tables_used
    #  #  # row_locks
    #  #  # io_avg_wait
    #  #  # io_wait
    #  #  # max_io_wait
    #  #  Several of those values can appear multiple times in the SHOW INNODB STATUS output.  The value used
    #  #  for comparison is always the higest value.  So the value for io_wait is the highest io_wait value
    #  #  for all the IO threads.
    # Processlist
    #  #  Watch aggregated SHOW PROCESSLIST values.
    #  #  #  --watch Processlist:[db|user|host|state|command]:value:[count|time]:[><=]:N
    #  #  Examples:
    #  #  # --watch "Processlist:state:Locked:count:>:5"
    #  #  # --watch "Processlist:command:Query:time:<:1"
    # Server
    #  #  Watch server values.
    #  #  #  --watch Server:loadavg:[1|5|15]:[><=]:N
    #  #  #  --watch Server:vmstat:[r|b|swpd|free|buff|cache|si|so|bi|bo|in|cs|us|sy|id|wa]:[><=]:N
    #  #  Examples:
    #  #  # --watch "Server:loadavg:5:>:4.00"
    #  #  # --watch "Server:vmstat:swpd:>:0"
    #  #  # --watch "Server:vmstat:free:=:0"
    #  #  See "--vmstat".
    attr_accessor :watch # (No value)

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_loadavg

    #
    # Returns a new LoadAvg Object
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

      unless @path_to_mk_loadavg
        ostring = "mk-loadavg "
      else
        ostring = @path_to_mk_loadavg + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-loadavg"
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

