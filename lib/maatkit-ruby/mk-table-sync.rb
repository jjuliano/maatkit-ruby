  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Synchronize MySQL table data efficiently.
  #
  # Maatkit::TableSync.new( array, str, array)
  #
  class Maatkit::TableSync

    #
    # type: string; default: Chunk,Nibble,GroupBy,Stream
    # Algorithm to use when comparing the tables, in order of preference.
    # For each table, mk-table-sync will check if the table can be synced with the given algorithms in the order that they're given. The first algorithm that can sync the table is used. See ALGORITHMS.
    #
    attr_accessor :algorithms # Chunk,Nibble,GroupBy,Stream

    #
    # Prompt for a password when connecting to MySQL.
    #
    attr_accessor :ask_pass # FALSE

    #
    # Enable bidirectional sync between first and subsequent hosts.
    #
    attr_accessor :bidirectional # FALSE

    #
    # default: yes
    # Log to the binary log (SET SQL_LOG_BIN=1).
    # Specifying --no-bin-log will SET SQL_LOG_BIN=0.
    #
    attr_accessor :bin_log # TRUE

    #
    # Instruct MySQL to buffer queries in its memory.
    # This option adds the SQL_BUFFER_RESULT option to the comparison queries. This causes MySQL to execute the queries and place them in a temporary table internally before sending the results back to mk-table-sync. The advantage of this strategy is that mk-table-sync can fetch rows as desired without using a lot of memory inside the Perl process, while releasing locks on the MySQL table (to reduce contention with other queries). The disadvantage is that it uses more memory on the MySQL server instead.
    # You probably want to leave --[no]buffer-to-client enabled too, because buffering into a temp table and then fetching it all into Perl's memory is probably a silly thing to do. This option is most useful for the GroupBy and Stream algorithms, which may fetch a lot of data from the server.
    #
    attr_accessor :buffer_in_mysql # FALSE

    #
    # default: yes
    # Fetch rows one-by-one from MySQL while comparing.
    # This option enables mysql_use_result which causes MySQL to hold the selected rows on the server until the tool fetches them. This allows the tool to use less memory but may keep the rows locked on the server longer.
    # If this option is disabled by specifying --no-buffer-to-client then mysql_store_result is used which causes MySQL to send all selected rows to the tool at once. This may result in the results "cursor" being held open for a shorter time on the server, but if the tables are large, it could take a long time anyway, and use all your memory.
    # For most non-trivial data sizes, you want to leave this option enabled.
    # This option is disabled when --bidirectional is used.
    #
    attr_accessor :buffer_to_client # TRUE

    #
    # short form: -A; type: string
    # Default character set. If the value is utf8, sets Perl's binmode on STDOUT to utf8, passes the mysql_enable_utf8 option to DBD::mysql, and runs SET NAMES UTF8 after connecting to MySQL. Any other value sets binmode on STDOUT without the utf8 layer, and runs SET NAMES after connecting to MySQL.
    #
    attr_accessor :charset # (No value)

    #
    # default: yes
    # With --sync-to-master, try to verify that the detected master is the real master.
    #
    attr_accessor :check_master # TRUE

    #
    # default: yes
    # Check that user has all necessary privileges on source and destination table.
    attr_accessor :check_privileges # TRUE

    #
    # default: yes
    # Check whether the destination server is a slave.
    # If the destination server is a slave, it's generally unsafe to make changes on it. However, sometimes you have to; --replace won't work unless there's a unique index, for example, so you can't make changes on the master in that scenario. By default mk-table-sync will complain if you try to change data on a slave. Specify --no-slave-check to disable this check. Use it at your own risk.
    attr_accessor :check_slave # TRUE

    #
    # default: yes
    # Check that no triggers are defined on the destination table.
    # Triggers were introduced in MySQL v5.0.2, so for older versions this option has no effect because triggers will not be checked.
    attr_accessor :check_triggers # TRUE

    #
    # type: string
    # Chunk the table on this column.
    attr_accessor :chunk_column # (No value)

    #
    # type: string
    # Chunk the table using this index.
    attr_accessor :chunk_index # (No value)

    #
    # type: string; default: 1000
    # Number of rows or data size per chunk.
    # The size of each chunk of rows for the Chunk and Nibble algorithms. The size can be either a number of rows, or a data size. Data sizes are specified with a suffix of k=kibibytes, M=mebibytes, G=gibibytes. Data sizes are converted to a number of rows by dividing by the average row length.
    attr_accessor :chunk_size # 1000

    #
    # short form: -c; type: array
    # Compare this comma-separated list of columns.
    attr_accessor :columns # (No value)

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_table_sync.conf,/home/user/.maatkit.conf,/home/user/.mk_table_sync.conf

    #
    # type: string
    # Compare this column when rows conflict during a --bidirectional sync.
    # When a same but differing row is found the value of this column from each row is compared according to --conflict-comparison, --conflict-value and --conflict-threshold to determine which row has the correct data and becomes the source. The column can be any type for which there is an appropriate --conflict-comparison (this is almost all types except, for example, blobs).
    # This option only works with --bidirectional. See BIDIRECTIONAL SYNCING for more information.
    attr_accessor :conflict_column # (No value)

    #
    # type: string
    # Choose the --conflict-column with this property as the source.
    # The option affects how the --conflict-column values from the conflicting rows are compared. Possible comparisons are one of these MAGIC_comparisons:
    #newest|oldest|greatest|least|equals|matches
    #COMPARISON  CHOOSES ROW WITH
    #==========  =========================================================
    #newest  #Newest temporal L<--conflict-column> value
    #oldest  #Oldest temporal L<--conflict-column> value
    #greatest  # Greatest numerical L<--conflict-column> value
    #least  # Least numerical L<--conflict-column> value
    #equals  #L<--conflict-column> value equal to L<--conflict-value>
    #matches  #L<--conflict-column> value matching Perl regex pattern
    #  #  #L<--conflict-value>
    # This option only works with --bidirectional. See BIDIRECTIONAL SYNCING for more information.
    attr_accessor :conflict_comparison # (No value)

    #
    # type: string; default: warn
    # How to report unresolvable conflicts and conflict errors
    # This option changes how the user is notified when a conflict cannot be resolved or causes some kind of error. Possible values are:
    #* warn: Print a warning to STDERR about the unresolvable conflict
    #* die:  Die, stop syncing, and print a warning to STDERR
    # This option only works with --bidirectional. See BIDIRECTIONAL SYNCING for more information.
    attr_accessor :conflict_error # warn

    #
    # type: string
    # Amount by which one --conflict-column must exceed the other.
    # The --conflict-threshold prevents a conflict from being resolved if the absolute difference between the two --conflict-column values is less than this amount. For example, if two --conflict-column have timestamp values "2009-12-01 12:00:00" and "2009-12-01 12:05:00" the difference is 5 minutes. If --conflict-threshold is set to "5m" the conflict will be resolved, but if --conflict-threshold is set to "6m" the conflict will fail to resolve because the difference is not greater than or equal to 6 minutes. In this latter case, --conflict-error will report the failure.
    # This option only works with --bidirectional. See BIDIRECTIONAL SYNCING for more information.
    attr_accessor :conflict_threshold # (No value)

    #
    # type: string
    # Use this value for certain --conflict-comparison.
    # This option gives the value for equals and matches --conflict-comparison.
    # This option only works with --bidirectional. See BIDIRECTIONAL SYNCING for more information.
    attr_accessor :conflict_value # (No value)

    #
    # short form: -d; type: hash
    # Sync only this comma-separated list of databases.
    # A common request is to sync tables from one database with tables from another database on the same or different server. This is not yet possible. --databases will not do it, and you can't do it with the D part of the DSN either because in the absence of a table name it assumes the whole server should be synced and the D part controls only the connection's default database.
    attr_accessor :databases # (No value)

    #
    # short form: -F; type: string
    # Only read mysql options from the given file. You must give an absolute pathname.
    attr_accessor :defaults_file # (No value)

    #
    # Analyze, decide the sync algorithm to use, print and exit.
    # Implies --verbose so you can see the results. The results are in the same output format that you'll see from actually running the tool, but there will be zeros for rows affected. This is because the tool actually executes, but stops before it compares any data and just returns zeros. The zeros do not mean there are no changes to be made.
    attr_accessor :dry_run # FALSE

    #
    # short form: -e; type: hash
    # Sync only this comma-separated list of storage engines.
    attr_accessor :engines # (No value)

    #
    # Execute queries to make the tables have identical data.
    # This option makes mk-table-sync actually sync table data by executing all the queries that it created to resolve table differences. Therefore, the tables will be changed! And unless you also specify --verbose, the changes will be made silently. If this is not what you want, see --print or --dry-run.
    attr_accessor :execute # FALSE

    #
    # Print connection information and exit.
    # Print out a list of hosts to which mk-table-sync will connect, with all the various connection options, and exit.
    attr_accessor :explain_hosts # FALSE

    #
    # type: int
    # Precision for FLOAT and DOUBLE number-to-string conversion. Causes FLOAT and DOUBLE values to be rounded to the specified number of digits after the decimal point, with the ROUND() function in MySQL. This can help avoid checksum mismatches due to different floating-point representations of the same values on different MySQL versions and hardware. The default is no rounding; the values are converted to strings by the CONCAT() function, and MySQL chooses the string representation. If you specify a value of 2, for example, then the values 1.008 and 1.009 will be rounded to 1.01, and will checksum as equal.
    attr_accessor :float_precision # (No value)

    #
    # default: yes
    # Enable foreign key checks (SET FOREIGN_KEY_CHECKS=1).
    # Specifying --no-foreign-key-checks will SET FOREIGN_KEY_CHECKS=0.
    attr_accessor :foreign_key_checks # TRUE

    #
    # type: string
    # Which hash function you'd like to use for checksums.
    # The default is CRC32. Other good choices include MD5 and SHA1. If you have installed the FNV_64 user-defined function, mk-table-sync will detect it and prefer to use it, because it is much faster than the built-ins. You can also use MURMUR_HASH if you've installed that user-defined function. Both of these are distributed with Maatkit. See mk-table-checksum for more information and benchmarks.
    attr_accessor :function # (No value)

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # default: yes
    # HEX() BLOB, TEXT and BINARY columns.
    # When row data from the source is fetched to create queries to sync the data (i.e. the queries seen with --print and executed by --execute), binary columns are wrapped in HEX() so the binary data does not produce an invalid SQL statement. You can disable this option but you probably shouldn't.
    attr_accessor :hex_blob # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No value)

    #
    # type: Hash
    # Ignore this comma-separated list of column names in comparisons.
    # This option causes columns not to be compared. However, if a row is determined to differ between tables, all columns in that row will be synced, regardless. (It is not currently possible to exclude columns from the sync process itself, only from the comparison.)
    attr_accessor :ignore_columns #

    #
    # type: Hash
    # Ignore this comma-separated list of databases.
    attr_accessor :ignore_databases #

    #
    # type: Hash; default: FEDERATED,MRG_MyISAM
    # Ignore this comma-separated list of storage engines.
    attr_accessor :ignore_engines # FEDERATED,MRG_MyISAM

    #
    # type: Hash
    # Ignore this comma-separated list of tables.
    # Table names may be qualified with the database name.
    attr_accessor :ignore_tables #

    #
    # default: yes
    # Add FORCE/USE INDEX hints to the chunk and row queries.
    # By default mk-table-sync adds a FORCE/USE INDEX hint to each SQL statement to coerce MySQL into using the index chosen by the sync algorithm or specified by --chunk-index. This is usually a good thing, but in rare cases the index may not be the best for the query so you can suppress the index hint by specifying --no-index-hint and let MySQL choose the index.
    # This does not affect the queries printed by --print; it only affects the chunk and row queries that mk-table-sync uses to select and compare rows.
    attr_accessor :index_hint # TRUE

    #
    # type: int
    # Lock tables: 0=none, 1=per sync cycle, 2=per table, or 3=globally.
    # This uses LOCK TABLES. This can help prevent tables being changed while you're examining them. The possible values are as follows:
    #VALUE  MEANING
    #=====  =======================================================
    #0  #Never lock tables.
    #1  #Lock and unlock one time per sync cycle (as implemented
    #  # by the syncing algorithm).  This is the most granular
    #  # level of locking available.  For example, the Chunk
    #  # algorithm will lock each chunk of C<N> rows, and then
    #  # unlock them if they are the same on the source and the
    #  # destination, before moving on to the next chunk.
    #2  #Lock and unlock before and after each table.
    #3  #Lock and unlock once for every server (DSN) synced, with
    #  # C<FLUSH TABLES WITH READ LOCK>.
    # A replication slave is never locked if --replicate or --sync-to-master is specified, since in theory locking the table on the master should prevent any changes from taking place. (You are not changing data on your slave, right?) If --wait is given, the master (source) is locked and then the tool waits for the slave to catch up to the master before continuing.
    # If --transaction is specified, LOCK TABLES is not used. Instead, lock and unlock are implemented by beginning and committing transactions. The exception is if --lock is 3.
    # If --no-transaction is specified, then LOCK TABLES is used for any value of --lock. See --[no]transaction.
    attr_accessor :lock # (No value)

    #
    # Lock the source and destination table, sync, then swap names. This is useful as a less-blocking ALTER TABLE, once the tables are reasonably in sync with each other (which you may choose to accomplish via any number of means, including dump and reload or even something like mk-archiver). It requires exactly two DSNs and assumes they are on the same server, so it does no waiting for replication or the like. Tables are locked with LOCK TABLES.
    attr_accessor :lock_and_rename # FALSE

    #
    # short form: -p; type: string
    # Password to use when connecting.
    attr_accessor :password # (No value)

    #
    # type: string
    # Create the given PID file. The file contains the process ID of the script. The PID file is removed when the script exits. Before starting, the script checks if the PID file already exists. If it does not, then the script creates and writes its own PID to it. If it does, then the script checks the following: if the file contains a PID and a process is running with that PID, then the script dies; or, if there is no process running with that PID, then the script overwrites the file with its own PID and starts; else, if the file contains no PID, then the script dies.
    attr_accessor :pid # (No value)

    #
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No value)

    #
    # Print queries that will resolve differences.
    # If you don't trust mk-table-sync, or just want to see what it will do, this is a good way to be safe. These queries are valid SQL and you can run them yourself if you want to sync the tables manually.
    attr_accessor :print # FALSE

    #
    # type: string
    # Preferred recursion method used to find slaves.
    # Possible methods are:
    #METHOD  # USES
    #===========  ================
    #processlist  SHOW PROCESSLIST
    #hosts  #  SHOW SLAVE HOSTS
    # The processlist method is preferred because SHOW SLAVE HOSTS is not reliable. However, the hosts method is required if the server uses a non-standard port (not 3306). Usually mk-table-sync does the right thing and finds the slaves, but you may give a preferred method and it will be used first. If it doesn't find any slaves, the other methods will be tried.
    attr_accessor :recursion_method # (No value)

    #
    # Write all INSERT and UPDATE statements as REPLACE.
    # This is automatically switched on as needed when there are unique index violations.
    attr_accessor :replace # FALSE

    #
    # type: string
    # Sync tables listed as different in this table.
    # Specifies that mk-table-sync should examine the specified table to find data that differs. The table is exactly the same as the argument of the same name to mk-table-checksum. That is, it contains records of which tables (and ranges of values) differ between the master and slave.
    # For each table and range of values that shows differences between the master and slave, mk-table-checksum will sync that table, with the appropriate WHERE clause, to its master.
    # This automatically sets --wait to 60 and causes changes to be made on the master instead of the slave.
    # If --sync-to-master is specified, the tool will assume the server you specified is the slave, and connect to the master as usual to sync.
    # Otherwise, it will try to use SHOW PROCESSLIST to find slaves of the server you specified. If it is unable to find any slaves via SHOW PROCESSLIST, it will inspect SHOW SLAVE HOSTS instead. You must configure each slave's report-host, report-port and other options for this to work right. After finding slaves, it will inspect the specified table on each slave to find data that needs to be synced, and sync it.
    # The tool examines the master's copy of the table first, assuming that the master is potentially a slave as well. Any table that shows differences there will NOT be synced on the slave(s). For example, suppose your replication is set up as A->B, B->C, B->D. Suppose you use this argument and specify server B. The tool will examine server B's copy of the table. If it looks like server B's data in table test.tbl1 is different from server A's copy, the tool will not sync that table on servers C and D.
    attr_accessor :replicate # (No value)

    #
    # type: string; default: wait_timeout=10000
    # Set these MySQL variables. Immediately after connecting to MySQL, this string will be appended to SET and executed.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # short form: -S; type: string
    # Socket file to use for connection.
    attr_accessor :socket # (No value)

    #
    # Treat the DSN as a slave and sync it to its master.
    # Treat the server you specified as a slave. Inspect SHOW SLAVE STATUS, connect to the server's master, and treat the master as the source and the slave as the destination. Causes changes to be made on the master. Sets --wait to 60 by default, sets --lock to 1 by default, and disables --[no]transaction by default. See also --replicate, which changes this option's behavior.
    attr_accessor :sync_to_master # FALSE

    #
    # short form: -t; type: hash
    # Sync only this comma-separated list of tables.
    # Table names may be qualified with the database name.
    attr_accessor :tables # (No value)

    #
    # Keep going if --wait fails.
    # If you specify --wait and the slave doesn't catch up to the master's position before the wait times out, the default behavior is to abort. This option makes the tool keep going anyway. Warning: if you are trying to get a consistent comparison between the two servers, you probably don't want to keep going after a timeout.
    attr_accessor :timeout_ok # FALSE

    #
    # Use transactions instead of LOCK TABLES.
    # The granularity of beginning and committing transactions is controlled by --lock. This is enabled by default, but since --lock is disabled by default, it has no effect.
    # Most options that enable locking also disable transactions by default, so if you want to use transactional locking (via LOCK IN SHARE MODE and FOR UPDATE, you must specify --transaction explicitly.
    # If you don't specify --transaction explicitly mk-table-sync will decide on a per-table basis whether to use transactions or table locks. It currently uses transactions on InnoDB tables, and table locks on all others.
    # If --no-transaction is specified, then mk-table-sync will not use transactions at all (not even for InnoDB tables) and locking is controlled by --lock.
    # When enabled, either explicitly or implicitly, the transaction isolation level is set REPEATABLE READ and transactions are started WITH CONSISTENT SNAPSHOT.
    attr_accessor :transaction # FALSE

    #
    # TRIM() VARCHAR columns in BIT_XOR and ACCUM modes. Helps when comparing MySQL 4.1 to >= 5.0.
    # This is useful when you don't care about the trailing space differences between MySQL versions which vary in their handling of trailing spaces. MySQL 5.0 and later all retain trailing spaces in VARCHAR, while previous versions would remove them.
    attr_accessor :trim # FALSE

    #
    # default: yes
    # Enable unique key checks (SET UNIQUE_CHECKS=1).
    # Specifying --no-unique-checks will SET UNIQUE_CHECKS=0.
    attr_accessor :unique_checks # TRUE

    #
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No value)

    #
    # short form: -v; cumulative: yes
    # Print results of sync operations.
    # See OUTPUT for more details about the output.
    attr_accessor :verbose # 0

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # short form: -w; type: time
    # How long to wait for slaves to catch up to their master.
    # Make the master wait for the slave to catch up in replication before comparing the tables. The value is the number of seconds to wait before timing out (see also --timeout-ok). Sets --lock to 1 and --[no]transaction to 0 by default. If you see an error such as the following,
    #MASTER_POS_WAIT returned -1
    # It means the timeout was exceeded and you need to increase it.
    # The default value of this option is influenced by other options. To see what value is in effect, run with --help.
    # To disable waiting entirely (except for locks), specify --wait 0. This helps when the slave is lagging on tables that are not being synced.
    attr_accessor :wait # (No value)

    #
    # type: string
    # WHERE clause to restrict syncing to part of the table.
    attr_accessor :where # (No value)

    #
    # default: yes
    # Add a chunk for rows with zero or zero-equivalent values. The only has an effect when --chunk-size is specified. The purpose of the zero chunk is to capture a potentially large number of zero values that would imbalance the size of the first chunk. For example, if a lot of negative numbers were inserted into an unsigned integer column causing them to be stored as zeros, then these zero values are captured by the zero chunk instead of the first chunk and all its non-zero values.
    attr_accessor :zero_chunk # TRUE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_table_sync

    #
    # Returns a new TableSync Object
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

      unless @path_to_mk_table_sync
        ostring = "mk-table-sync "
      else
        ostring = @path_to_mk_table_sync + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-table-sync"
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

