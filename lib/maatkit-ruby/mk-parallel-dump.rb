  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Dump MySQL tables in parallel.
  #
  # Maatkit::ParallelDump.new( array, str, array)
  #
  class Maatkit::ParallelDump

    #
    # Prompt for a password when connecting to MySQL.
    attr_accessor :ask_pass # FALSE

    #
    # type: string
    # The base directory in which files will be stored.
    # The default is the current working directory.  Each database gets its own directory under the base
    # directory.  So if the base directory is "/tmp" and database "foo" is dumped, then the directory
    # "/tmp/foo" is created which contains all the table dump files for "foo".
    attr_accessor :base_dir # /home/joel/maatkit_ruby/lib/maatkit_ruby

    #
    # default: yes
    # Process tables in descending order of size (biggest to smallest).
    # This strategy gives better parallelization.  Suppose there are 8 threads and the last table is huge.
    # We will finish everything else and then be running single-threaded while that one finishes.  If that
    # one runs first, then we will have the max number of threads running at a time for as long as possible.
    attr_accessor :biggest_first # TRUE

    #
    # default: yes
    # Dump the master/slave position.
    # Dump binary log positions from both "SHOW MASTER STATUS" and "SHOW SLAVE STATUS", whichever can be
    # retrieved from the server.  The data is dumped to a file named 00_master_data.sql in the "--base-dir".
    # The file also contains details of each table dumped, including the WHERE clauses used to dump it in
    # chunks.
    attr_accessor :bin_log_position # TRUE

    #
    # short form: -A; type: string
    # Default character set.  If the value is utf8, sets Perl's binmode on STDOUT to utf8, passes the
    # mysql_enable_utf8 option to DBD::mysql, and runs SET NAMES UTF8 after connecting to MySQL.  Any other
    # value sets binmode on STDOUT without the utf8 layer, and runs SET NAMES after connecting to MySQL.
    attr_accessor :charset # (No # value)

    #
    # type: string
    # Number of rows or data size to dump per file.
    # Specifies that the table should be dumped in segments of approximately the size given.  The syntax is
    # either a plain integer, which is interpreted as a number of rows per chunk, or an integer with a suffix
    # of G, M, or k, which is interpreted as the size of the data to be dumped in each chunk.  See "CHUNKS"
    # for more details.
    attr_accessor :chunk_size # (No # value)

    #
    # Fetch and buffer results in memory on client.
    # By default this option is not enabled because it causes data to be completely fetched from the server
    # then buffered in-memory on the client.  For large dumps this can require a lot of memory
    # Instead, the default (when this option is not specified) is to fetch and dump rows one-by-one from the
    # server.  This requires a lot less memory on the client but can keep the tables on the server locked
    # longer.
    # Use this option only if you're sure that the data being dumped is relatively small and the client has
    # sufficient memory.  Remember that, if this option is specified, all "--threads" will buffer their
    # results in-memory, so memory consumption can increase by a factor of N "--threads".
    attr_accessor :client_side_buffering # FALSE

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the
    # command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_parallel_dump.conf,/home/joel/.maatkit.conf,/home/joel/.mk_parallel_dump.conf

    #
    # Do "--tab" dump in CSV format (implies "--tab").
    # Changes "--tab" options so the dump file is in comma-separated values (CSV) format.  The SELECT INTO
    # OUTFILE statement looks like the following, and can be re-loaded with the same options:
    # # SELECT * INTO OUTFILE %D.%N.%6C.txt
    # # FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'
    # # LINES TERMINATED BY '\n' FROM %D.%N;
    attr_accessor :csv # FALSE

    #
    # short form: -d; type: hash
    # Dump only this comma-separated list of databases.
    attr_accessor :databases # (No # value)

    #
    # type: string
    # Dump only databases whose names match this Perl regex.
    attr_accessor :databases_regex # (No # value)

    #
    # short form: -F; type: string
    # Only read mysql options from the given file.  You must give an absolute pathname.
    attr_accessor :defaults_file # (No # value)

    #
    # Print commands instead of executing them.
    attr_accessor :dry_run # FALSE

    #
    # short form: -e; type: hash
    # Dump only tables that use this comma-separated list of storage engines.
    attr_accessor :engines # (No # value)

    #
    # Use "FLUSH TABLES WITH READ LOCK".
    # This is enabled by default.  The lock is taken once, at the beginning of the whole process and is
    # released after all tables have been dumped.  If you want to lock only the tables you're dumping, use
    # "--lock-tables".
    attr_accessor :flush_lock # FALSE

    #
    # Execute "FLUSH LOGS" when getting binlog positions.
    # This option is NOT enabled by default because it causes the MySQL server to rotate its error log,
    # potentially overwriting error messages.
    attr_accessor :flush_log # FALSE

    #
    # default: yes
    # Compress (gzip) SQL dump files; does not work with "--tab".
    # The IO::Compress::Gzip Perl module is used to compress SQL dump files as they are written to disk.  The
    # resulting dump files have a ".gz" extension, like "table.000000.sql.gz".  They can be uncompressed with
    # gzip.  mk-parallel-restore will automatically uncompress them, too, when restoring.
    # This option does not work with "--tab" because the MySQL server writes the tab dump files directly
    # using "SELECT INTO OUTFILE".
    attr_accessor :gzip # TRUE

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No # value)

    #
    # type: Hash
    # Ignore this comma-separated list of databases.
    attr_accessor :ignore_databases #

    #
    # type: string
    # Ignore databases whose names match this Perl regex.
    attr_accessor :ignore_databases_regex # (No # value)

    #
    # type: Hash; default: FEDERATED,MRG_MyISAM
    # Do not dump tables that use this comma-separated list of storage engines.
    # The schema file will be dumped as usual.  This prevents dumping data for Federated tables and Merge
    # tables.
    attr_accessor :ignore_engines # FEDERATED,MRG_MyISAM

    #
    # type: Hash
    # Ignore this comma-separated list of table names.
    # Table names may be qualified with the database name.
    attr_accessor :ignore_tables #

    #
    # type: string
    # Ignore tables whose names match the Perl regex.
    attr_accessor :ignore_tables_regex # (No # value)

    #
    # Use "LOCK TABLES" (disables "--[no]flush-lock").
    # Disables "--[no]flush-lock" (unless it was explicitly set) and locks tables with "LOCK TABLES READ".
    # The lock is taken and released for every table as it is dumped.
    attr_accessor :lock_tables # FALSE

    #
    # Dump float types with extra precision for lossless restore (requires "--tab").
    # Wraps these types with a call to "FORMAT()" with 17 digits of precision.  According to the comments in
    # Google's patches, this will give lossless dumping and reloading in most cases.  (I shamelessly stole
    # this technique from them.  I don't know enough about floating-point math to have an opinion).
    # This works only with "--tab".
    attr_accessor :lossless_floats # FALSE

    #
    # short form: -p; type: string
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
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No # value)

    #
    # Display progress reports.
    # Progress is displayed each time a table or chunk of a table finishes dumping.  Progress is calculated
    # by measuring the average data size of each full chunk and assuming all bytes are created equal.  The
    # output is the completed and total bytes, the percent completed, estimated time remaining, and estimated
    # completion time.  For example:
    #   40.72k/112.00k  36.36% ETA 00:00 (2009-10-27T19:17:53)
    # If "--chunk-size" is not specified then each table is effectively one big chunk and the progress
    # reports are pretty accurate.  When "--chunk-size" is specified the progress reports can be skewed
    # because of averaging.
    # Progress reports are inaccurate when a dump is resumed.  This is known issue and will be fixed in a
    # later release.
    attr_accessor :progress # FALSE

    #
    # short form: -q
    # Quiet output; disables "--verbose".
    attr_accessor :quiet # FALSE

    #
    # default: yes
    # Resume dumps.
    attr_accessor :resume # TRUE

    #
    # type: string; default: wait_timeout=10000
    # Set these MySQL variables.  Immediately after connecting to MySQL, this string will be appended to SET
    # and executed.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # short form: -S; type: string
    # Socket file to use for connection.
    attr_accessor :socket # (No # value)

    #
    # Issue "STOP SLAVE" on server before dumping data.
    # This ensures that the data is not changing during the dump.  Issues "START SLAVE" after the dump is
    # complete.
    # If the slave is not running, throws an error and exits.  This is to prevent possibly bad things from
    # happening if the slave is not running because of a problem, or because someone intentionally stopped
    # the slave for maintenance or some other purpose.
    attr_accessor :stop_slave # FALSE

    #
    # Dump tab-separated (sets "--umask" 0).
    # Dump via "SELECT INTO OUTFILE", which is similar to what "mysqldump" does with the "--tab" option, but
    # you're not constrained to a single database at a time.
    # Before you use this option, make sure you know what "SELECT INTO OUTFILE" does!  I recommend using it
    # only if you're running mk-parallel-dump on the same machine as the MySQL server, but there is no
    # protection if you don't.
    # This option sets "--umask" to zero so auto-created directories are writable by the MySQL server.
    attr_accessor :tab # FALSE

    #
    # short form: -t; type: hash
    # Dump only this comma-separated list of table names.
    # Table names may be qualified with the database name.
    attr_accessor :tables # (No # value)

    #
    # type: string
    # Dump only tables whose names match this Perl regex.
    attr_accessor :tables_regex # (No # value)

    #
    # type: int; default: 2
    # Number of threads to dump concurrently.
    # Specifies the number of parallel processes to run.  The default is 2 (this is mk-parallel-dump, after
    # all -- 1 is not parallel).  On GNU/Linux machines, the default is the number of times 'processor'
    # appears in /proc/cpuinfo.  On Windows, the default is read from the environment.  In any case, the
    # default is at least 2, even when there's only a single processor.
    attr_accessor :threads # 2

    #
    # default: yes
    # Enable TIMESTAMP columns to be dumped and reloaded between different time zones.  mk-parallel-dump sets
    # its connection time zone to UTC and adds "SET TIME_ZONE='+00:00'" to the dump file.  Without this
    # option, TIMESTAMP columns are dumped and reloaded in the time zones local to the source and destination
    # servers, which can cause the values to change.  This option also protects against changes due to
    # daylight saving time.
    # This option is identical to "mysqldump --tz-utc".  In fact, the above text was copied from mysqldump's
    # man page.
    attr_accessor :tz_utc # TRUE

    #
    # type: string
    # Set the program's "umask" to this octal value.
    # This is useful when you want created files and directories to be readable or writable by other users
    # (for example, the MySQL server itself).
    attr_accessor :umask # (No # value)

    #
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No # value)

    #
    # short form: -v; cumulative: yes
    # Be verbose; can specify multiple times.
    # See "OUTPUT".
    attr_accessor :verbose # 0

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # short form: -w; type: time; default: 5m
    # Wait limit when the server is down.
    # If the MySQL server crashes during dumping, waits until the server comes back and then continues with
    # the rest of the tables.  "mk-parallel-dump" will check the server every second until this time is
    # exhausted, at which point it will give up and exit.
    # This implements Peter Zaitsev's "safe dump" request: sometimes a dump on a server that has corrupt data
    # will kill the server.  mk-parallel-dump will wait for the server to restart, then keep going.  It's
    # hard to say which table killed the server, so no tables will be retried.  Tables that were being
    # concurrently dumped when the crash happened will not be retried.  No additional locks will be taken
    # after the server restarts; it's assumed this behavior is useful only on a server you're not trying to
    # dump while it's in production.
    attr_accessor :wait # 300

    #
    # default: yes
    # Add a chunk for rows with zero or zero-equivalent values.  The only has an effect when "--chunk-size"
    # is specified.  The purpose of the zero chunk is to capture a potentially large number of zero values
    # that would imbalance the size of the first chunk.  For example, if a lot of negative numbers were
    # inserted into an unsigned integer column causing them to be stored as zeros, then these zero values are
    # captured by the zero chunk instead of the first chunk and all its non-zero values.
    attr_accessor :zero_chunk # TRUE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_parallel_dump

    #
    # Returns a new ParallelDump Object
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

      unless @path_to_mk_parallel_dump
        ostring = "mk-parallel-dump "
      else
        ostring = @path_to_mk_parallel_dump + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-parallel-dump"
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

