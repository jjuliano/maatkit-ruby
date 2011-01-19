  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Archive rows from a MySQL table into another table or a file.
  #
  # Maatkit::Archiver.new( array, str, array)
  #
  class Maatkit::Archiver

    #
    # type: string
    # Run ANALYZE TABLE afterwards on --source and/or --dest.
    # Runs ANALYZE TABLE after finishing. The argument is an arbitrary string. If it contains the letter 's', the source will be analyzed. If it contains 'd', the destination will be analyzed. You can specify either or both. For example, the following will analyze both:
    #   --analyze=ds
    # See http://dev.mysql.com/doc/en/analyze-table.html for details on ANALYZE TABLE.
    attr_accessor :analyze # (No value)

    #
    # Ascend only first column of index.
    # If you do want to use the ascending index optimization (see --no-ascend), but do not want to incur the overhead of ascending a large multi-column index, you can use this option to tell mk-archiver to ascend only the leftmost column of the index. This can provide a significant performance boost over not ascending the index at all, while avoiding the cost of ascending the whole index.
    # See EXTENDING for a discussion of how this interacts with plugins.
    attr_accessor :ascend_first # FALSE

    #
    # Prompt for a password when connecting to MySQL.
    attr_accessor :ask_pass # FALSE

    #
    # Buffer output to --file and flush at commit.
    # Disables autoflushing to --file and flushes --file to disk only when a transaction commits. This typically means the file is block-flushed by the operating system, so there may be some implicit flushes to disk between commits as well. The default is to flush --file to disk after every row.
    # The danger is that a crash might cause lost data.
    # The performance increase I have seen from using --buffer is around 5 to 15 percent. Your mileage may vary.
    attr_accessor :buffer # FALSE

    #
    # Delete each chunk with a single statement (implies --commit-each).
    # Delete each chunk of rows in bulk with a single DELETE statement. The statement deletes every row between the first and last row of the chunk, inclusive. It implies --commit-each, since it would be a bad idea to INSERT rows one at a time and commit them before the bulk DELETE.
    # The normal method is to delete every row by its primary key. Bulk deletes might be a lot faster. They also might not be faster if you have a complex WHERE clause.
    # This option completely defers all DELETE processing until the chunk of rows is finished. If you have a plugin on the source, its before_delete method will not be called. Instead, its before_bulk_delete method is called later.
    # WARNING: if you have a plugin on the source that sometimes doesn't return true from is_archivable(), you should use this option only if you understand what it does. If the plugin instructs mk-archiver not to archive a row, it will still be deleted by the bulk delete!
    attr_accessor :bulk_delete # FALSE

    #
    # default: yes
    # Add --limit to --bulk-delete statement.
    # This is an advanced option and you should not disable it unless you know what you are doing and why! By default, --bulk-delete appends a --limit clause to the bulk delete SQL statement. In certain cases, this clause can be omitted by specifying --no-bulk-delete-limit. --limit must still be specified.
    attr_accessor :nobulk_delete_limit

    #
    # Insert each chunk with LOAD DATA INFILE (implies --bulk-delete --commit-each).
    # Insert each chunk of rows with LOAD DATA LOCAL INFILE. This may be much faster than inserting a row at a time with INSERT statements. It is implemented by creating a temporary file for each chunk of rows, and writing the rows to this file instead of inserting them. When the chunk is finished, it uploads the rows.
    # To protect the safety of your data, this option forces bulk deletes to be used. It would be unsafe to delete each row as it is found, before inserting the rows into the destination first. Forcing bulk deletes guarantees that the deletion waits until the insertion is successful.
    # The --low-priority-insert, --replace, and --ignore options work with this option, but --delayed-insert does not.
    attr_accessor :bulk_insert # FALSE

    #
    # short form: -A; type: string
    # Default character set. If the value is utf8, sets Perl's binmode on STDOUT to utf8, passes the mysql_enable_utf8 option to DBD::mysql, and runs SET NAMES UTF8 after connecting to MySQL. Any other value sets binmode on STDOUT without the utf8 layer, and runs SET NAMES after connecting to MySQL.
    attr_accessor :charset # (No value)

    #
    # default: yes
    # Ensure --source and --dest have same columns.
    # Enabled by default; causes mk-archiver to check that the source and destination tables have the same columns. It does not check column order, data type, etc. It just checks that all columns in the source exist in the destination and vice versa. If there are any differences, mk-archiver will exit with an error.
    # To disable this check, specify --no-check-columns.
    attr_accessor :check_columns # TRUE

    #
    # type: time; default: 1s
    # How often to check for slave lag if --check-slave-lag is given.
    attr_accessor :check_interval # 1

    #
    # type: string
    # Pause archiving until the specified DSN's slave lag is less than --max-lag.
    attr_accessor :check_slave_lag # (No value)

    #
    # short form: -c; type: array
    # Comma-separated list of columns to archive.
    # Specify a comma-separated list of columns to fetch, write to the file, and insert into the destination table. If specified, mk-archiver ignores other columns unless it needs to add them to the SELECT statement for ascending an index or deleting rows. It fetches and uses these extra columns internally, but does not write them to the file or to the destination table. It does pass them to plugins.
    # See also --primary-key-only.
    attr_accessor :columns # (No value)

    #
    # Commit each set of fetched and archived rows (disables --txn-size).
    # Commits transactions and flushes --file after each set of rows has been archived, before fetching the next set of rows, and before sleeping if --sleep is specified. Disables --txn-size; use --limit to control the transaction size with --commit-each.
    # This option is useful as a shortcut to make --limit and --txn-size the same value, but more importantly it avoids transactions being held open while searching for more rows. For example, imagine you are archiving old rows from the beginning of a very large table, with --limit 1000 and --txn-size 1000. After some period of finding and archiving 1000 rows at a time, mk-archiver finds the last 999 rows and archives them, then executes the next SELECT to find more rows. This scans the rest of the table, but never finds any more rows. It has held open a transaction for a very long time, only to determine it is finished anyway. You can use --commit-each to avoid this.
    attr_accessor :commit_each # FALSE

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_archiver.conf,/home/joel/.maatkit.conf,/home/joel/.mk_archiver.conf

    #
    # Add the DELAYED modifier to INSERT statements.
    # Adds the DELAYED modifier to INSERT or REPLACE statements. See http://dev.mysql.com/doc/en/insert.html for details.
    attr_accessor :delayed_insert # FALSE

    #
    # type: DSN
    # DSN specifying the table to archive to.
    # This item specifies a table into which mk-archiver will insert rows archived from --source. It uses the same key=val argument format as --source. Most missing values default to the same values as --source, so you don't have to repeat options that are the same in --source and --dest. Use the --help option to see which values are copied from --source.
    # WARNING: Using a default options file (F) DSN option that defines a socket for --source causes mk-archiver to connect to --dest using that socket unless another socket for --dest is specified. This means that mk-archiver may incorrectly connect to --source when it connects to --dest. For example:
    #   --source F=host1.cnf,D=db,t=tbl --dest h=host2
    # When mk-archiver connects to --dest, host2, it will connect via the --source, host1, socket defined in host1.cnf.
    attr_accessor :dest # (No value)

    #
    # Print queries and exit without doing anything.
    # Causes mk-archiver to exit after printing the filename and SQL statements it will use.
    attr_accessor :dry_run # FALSE

    #
    # type: string
    # File to archive to, with DATE_FORMAT()-like formatting.
    # Filename to write archived rows to. A subset of MySQL's DATE_FORMAT() formatting codes are allowed in the filename, as follows:
    #    %d# Day of the month, numeric (01..31)
    #    %H# Hour (00..23)
    #    %i# Minutes, numeric (00..59)
    #    %m# Month, numeric (01..12)
    #    %s# Seconds (00..59)
    #    %Y# Year, numeric, four digits
    # You can use the following extra format codes too:
    #    %D# Database name
    #    %t# Table name
    # Example:
    #    --file '/var/log/archive/%Y-%m-%d-%D.%t'
    # The file's contents are in the same format used by SELECT INTO OUTFILE, as documented in the MySQL manual: rows terminated by newlines, columns terminated by tabs, NULL characters are represented by \N, and special characters are escaped by \. This lets you reload a file with LOAD DATA INFILE's default settings.
    # If you want a column header at the top of the file, see --header. The file is auto-flushed by default; see --buffer.
    attr_accessor :file # (No value)

    #
    # Adds the FOR UPDATE modifier to SELECT statements.
    # For details, see http://dev.mysql.com/doc/en/innodb-locking-reads.html.
    attr_accessor :for_update # FALSE

    #
    # Print column header at top of --file.
    # Writes column names as the first line in the file given by --file. If the file exists, does not write headers; this keeps the file loadable with LOAD DATA INFILE in case you append more output to it.
    attr_accessor :header # FALSE

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # Adds the HIGH_PRIORITY modifier to SELECT statements.
    # See http://dev.mysql.com/doc/en/select.html for details.
    attr_accessor :high_priority_select # FALSE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No value)

    #
    # Use IGNORE for INSERT statements.
    # Causes INSERTs into --dest to be INSERT IGNORE.
    attr_accessor :ignore # FALSE

    #
    # type: int; default: 1
    # Number of rows to fetch and archive per statement.
    # Limits the number of rows returned by the SELECT statements that retrieve rows to archive. Default is one row. It may be more efficient to increase the limit, but be careful if you are archiving sparsely, skipping over many rows; this can potentially cause more contention with other queries, depending on the storage engine, transaction isolation level, and options such as --for-update.
    attr_accessor :limit # 1

    #
    # Do not write OPTIMIZE or ANALYZE queries to binlog.
    # Adds the NO_WRITE_TO_BINLOG modifier to ANALYZE and OPTIMIZE queries. See --analyze for details.
    attr_accessor :local # FALSE

    #
    # Adds the LOW_PRIORITY modifier to DELETE statements.
    # See http://dev.mysql.com/doc/en/delete.html for details.
    attr_accessor :low_priority_delete # FALSE

    #
    # Adds the LOW_PRIORITY modifier to INSERT or REPLACE statements.
    # See http://dev.mysql.com/doc/en/insert.html for details.
    attr_accessor :low_priority_insert # FALSE

    #
    # type: time; default: 1s
    # Pause archiving if the slave given by --check-slave-lag lags.
    # This option causes mk-archiver to look at the slave every time it's about to fetch another row. If the slave's lag is greater than the option's value, or if the slave isn't running (so its lag is NULL), mk-table-checksum sleeps for --check-interval seconds and then looks at the lag again. It repeats until the slave is caught up, then proceeds to fetch and archive the row.
    # This option may eliminate the need for --sleep or --sleep-coef.
    attr_accessor :max_lag # 1

    #
    # Do not use ascending index optimization.
    # The default ascending-index optimization causes mk-archiver to optimize repeated SELECT queries so they seek into the index where the previous query ended, then scan along it, rather than scanning from the beginning of the table every time. This is enabled by default because it is generally a good strategy for repeated accesses.
    # Large, multiple-column indexes may cause the WHERE clause to be complex enough that this could actually be less efficient. Consider for example a four-column PRIMARY KEY on (a, b, c, d). The WHERE clause to start where the last query ended is as follows:
    #    WHERE (a > ?)
    # #   OR (a = ? AND b > ?)
    # #   OR (a = ? AND b = ? AND c > ?)
    # #   OR (a = ? AND b = ? AND c = ? AND d >= ?)
    # Populating the placeholders with values uses memory and CPU, adds network traffic and parsing overhead, and may make the query harder for MySQL to optimize. A four-column key isn't a big deal, but a ten-column key in which every column allows NULL might be.
    # Ascending the index might not be necessary if you know you are simply removing rows from the beginning of the table in chunks, but not leaving any holes, so starting at the beginning of the table is actually the most efficient thing to do.
    # See also --ascend-first. See EXTENDING for a discussion of how this interacts with plugins.
    attr_accessor :no_ascend # FALSE

    #
    # Do not delete archived rows.
    # Causes mk-archiver not to delete rows after processing them. This disallows --no-ascend, because enabling them both would cause an infinite loop.
    # If there is a plugin on the source DSN, its before_delete method is called anyway, even though mk-archiver will not execute the delete. See EXTENDING for more on plugins.
    attr_accessor :no_delete # FALSE

    #
    # type: string
    # Run OPTIMIZE TABLE afterwards on --source and/or --dest.
    # Runs OPTIMIZE TABLE after finishing. See --analyze for the option syntax and http://dev.mysql.com/doc/en/optimize-table.html for details on OPTIMIZE TABLE.
    attr_accessor :optimize # (No value)

    #
    # short form: -p; type: string
    # Password to use when connecting.
    attr_accessor :password # (No value)

    #
    # type: string
    # Create the given PID file when daemonized. The file contains the process ID of the daemonized instance. The PID file is removed when the daemonized instance exits. The program checks for the existence of the PID file when starting; if it exists and the process with the matching PID exists, the program exits.
    attr_accessor :pid # (No value)

    #
    # type: string
    # Perl module name to use as a generic plugin.
    # Specify the Perl module name of a general-purpose plugin. It is currently used only for statistics (see --statistics) and must have new() and a statistics() method.
    # The new( src = $src, dst => $dst, opts => $o )> method gets the source and destination DSNs, and their database connections, just like the connection-specific plugins do. It also gets an OptionParser object ($o) for accessing command-line options (example: $o-get('purge');>).
    # The statistics(\%stats, $time) method gets a hashref of the statistics collected by the archiving job, and the time the whole job started.
    attr_accessor :plugin # (No value)

    #
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No value)

    #
    # Primary key columns only.
    # A shortcut for specifying --columns with the primary key columns. This is an efficiency if you just want to purge rows; it avoids fetching the entire row, when only the primary key columns are needed for DELETE statements. See also --purge.
    attr_accessor :primary_key_only # FALSE

    #
    # type: int
    # Print progress information every X rows.
    # Prints current time, elapsed time, and rows archived every X rows.
    attr_accessor :progress # (No value)

    #
    # Purge instead of archiving; allows omitting --file and --dest.
    # Allows archiving without a --file or --dest argument, which is effectively a purge since the rows are just deleted.
    # If you just want to purge rows, consider specifying the table's primary key columns with --primary-key-only. This will prevent fetching all columns from the server for no reason.
    attr_accessor :purge # FALSE

    #
    # Adds the QUICK modifier to DELETE statements.
    # See http://dev.mysql.com/doc/en/delete.html for details. As stated in the documentation, in some cases it may be faster to use DELETE QUICK followed by OPTIMIZE TABLE. You can use --optimize for this.
    attr_accessor :quick_delete # FALSE

    #
    # short form: -q
    # Do not print any output, such as for --statistics.
    # Suppresses normal output, including the output of --statistics, but doesn't suppress the output from --why-quit.
    attr_accessor :quiet # FALSE

    #
    # Causes INSERTs into --dest to be written as REPLACE.
    attr_accessor :replace # FALSE

    #
    # type: int; default: 1
    # Number of retries per timeout or deadlock.
    # Specifies the number of times mk-archiver should retry when there is an InnoDB lock wait timeout or deadlock. When retries are exhausted, mk-archiver will exit with an error.
    # Consider carefully what you want to happen when you are archiving between a mixture of transactional and non-transactional storage engines. The INSERT to --dest and DELETE from --source are on separate connections, so they do not actually participate in the same transaction even if they're on the same server. However, mk-archiver implements simple distributed transactions in code, so commits and rollbacks should happen as desired across the two connections.
    # At this time I have not written any code to handle errors with transactional storage engines other than InnoDB. Request that feature if you need it.
    attr_accessor :retries # 1

    #
    # type: time
    # Time to run before exiting.
    # Optional suffix s=seconds, m=minutes, h=hours, d=days; if no suffix, s is used.
    attr_accessor :run_time # (No value)

    #
    # default: yes
    # Do not archive row with max AUTO_INCREMENT.
    # Adds an extra WHERE clause to prevent mk-archiver from removing the newest row when ascending a single-column AUTO_INCREMENT key. This guards against re-using AUTO_INCREMENT values if the server restarts, and is enabled by default.
    # The extra WHERE clause contains the maximum value of the auto-increment column as of the beginning of the archive or purge job. If new rows are inserted while mk-archiver is running, it will not see them.
    attr_accessor :safe_auto_increment # TRUE

    #
    # type: string; default: /tmp/mk-archiver-sentinel
    # Exit if this file exists.
    # The presence of the file specified by --sentinel will cause mk-archiver to stop archiving and exit. The default is /tmp/mk-archiver-sentinel. You might find this handy to stop cron jobs gracefully if necessary. See also --stop.
    attr_accessor :sentinel # /tmp/mk_archiver_sentinel

    #
    # type: string; default: wait_timeout=10000
    # Set these MySQL variables.
    # Specify any variables you want to be set immediately after connecting to MySQL. These will be included in a SET command.
    attr_accessor :set_vars # wait_timeout=10000

    #
    # Adds the LOCK IN SHARE MODE modifier to SELECT statements.
    # See http://dev.mysql.com/doc/en/innodb-locking-reads.html.
    attr_accessor :share_lock # FALSE

    #
    # Disables foreign key checks with SET FOREIGN_KEY_CHECKS=0.
    attr_accessor :skip_foreign_key_checks # FALSE

    #
    # type: int
    # Sleep time between fetches.
    # Specifies how long to sleep between SELECT statements. Default is not to sleep at all. Transactions are NOT committed, and the --file file is NOT flushed, before sleeping. See --txn-size to control that.
    # If --commit-each is specified, committing and flushing happens before sleeping.
    attr_accessor :sleep # (No value)

    #
    # type: float
    # Calculate --sleep as a multiple of the last SELECT time.
    # If this option is specified, mk-archiver will sleep for the query time of the last SELECT multiplied by the specified coefficient. This option is ignored if --sleep is specified.
    # This is a slightly more sophisticated way to throttle the SELECTs: sleep a varying amount of time between each SELECT, depending on how long the SELECTs are taking.
    attr_accessor :sleep_coef # (No value)

    #
    # short form: -S; type: string
    # Socket file to use for connection.
    attr_accessor :socket # (No value)

    #
    # type: DSN
    # DSN specifying the table to archive from (required). This argument is a DSN. See DSN OPTIONS for the syntax. Most options control how mk-archiver connects to MySQL, but there are some extended DSN options in this tool's syntax. The D, t, and i options select a table to archive:
    #   --source h=my_server,D=my_database,t=my_tbl
    # The a option specifies the database to set as the connection's default with USE. If the b option is true, it disables binary logging with SQL_LOG_BIN. The m option specifies pluggable actions, which an external Perl module can provide. The only required part is the table; other parts may be read from various places in the environment (such as options files).
    # The 'i' part deserves special mention. This tells mk-archiver which index it should scan to archive. This appears in a FORCE INDEX or USE INDEX hint in the SELECT statements used to fetch archivable rows. If you don't specify anything, mk-archiver will auto-discover a good index, preferring a PRIMARY KEY if one exists. In my experience this usually works well, so most of the time you can probably just omit the 'i' part.
    # The index is used to optimize repeated accesses to the table; mk-archiver remembers the last row it retrieves from each SELECT statement, and uses it to construct a WHERE clause, using the columns in the specified index, that should allow MySQL to start the next SELECT where the last one ended, rather than potentially scanning from the beginning of the table with each successive SELECT. If you are using external plugins, please see EXTENDING for a discussion of how they interact with ascending indexes.
    # The 'a' and 'b' options allow you to control how statements flow through the binary log. If you specify the 'b' option, binary logging will be disabled on the specified connection. If you specify the 'a' option, the connection will USE the specified database, which you can use to prevent slaves from executing the binary log events with --replicate-ignore-db options. These two options can be used as different methods to achieve the same goal: archive data off the master, but leave it on the slave. For example, you can run a purge job on the master and prevent it from happening on the slave using your method of choice.
    # WARNING: Using a default options file (F) DSN option that defines a socket for --source causes mk-archiver to connect to --dest using that socket unless another socket for --dest is specified. This means that mk-archiver may incorrectly connect to --source when it is meant to connect to --dest. For example:
    #   --source F=host1.cnf,D=db,t=tbl --dest h=host2
    # When mk-archiver connects to --dest, host2, it will connect via the --source, host1, socket defined in host1.cnf.
    attr_accessor :source # (No value)

    #
    # Collect and print timing statistics.
    # Causes mk-archiver to collect timing statistics about what it does. These statistics are available to the plugin specified by --plugin
    # Unless you specify --quiet, mk-archiver prints the statistics when it exits. The statistics look like this:
    #  Started at 2008-07-18T07:18:53, ended at 2008-07-18T07:18:53
    #  Source: D=db,t=table
    #  SELECT 4
    #  INSERT 4
    #  DELETE 4
    #  Action# #  Count#    Time# # Pct
    #  commit# # # 10#  0.1079#   88.27
    #  select# # #  5#  0.0047#    3.87
    #  deleting# #    4#  0.0028#    2.29
    #  inserting# #   4#  0.0028#    2.28
    #  other# # #   0#  0.0040#    3.29
    # The first two (or three) lines show times and the source and destination tables. The next three lines show how many rows were fetched, inserted, and deleted.
    # The remaining lines show counts and timing. The columns are the action, the total number of times that action was timed, the total time it took, and the percent of the program's total runtime. The rows are sorted in order of descending total time. The last row is the rest of the time not explicitly attributed to anything. Actions will vary depending on command-line options.
    # If --why-quit is given, its behavior is changed slightly. This option causes it to print the reason for exiting even when it's just because there are no more rows.
    # This option requires the standard Time::HiRes module, which is part of core Perl on reasonably new Perl releases.
    attr_accessor :statistics # FALSE

    #
    # Stop running instances by creating the sentinel file.
    # Causes mk-archiver to create the sentinel file specified by --sentinel and exit. This should have the effect of stopping all running instances which are watching the same sentinel file.
    attr_accessor :stop # FALSE

    #
    # type: int; default: 1
    # Number of rows per transaction.
    # Specifies the size, in number of rows, of each transaction. Zero disables transactions altogether. After mk-archiver processes this many rows, it commits both the --source and the --dest if given, and flushes the file given by --file.
    # This parameter is critical to performance. If you are archiving from a live server, which for example is doing heavy OLTP work, you need to choose a good balance between transaction size and commit overhead. Larger transactions create the possibility of more lock contention and deadlocks, but smaller transactions cause more frequent commit overhead, which can be significant. To give an idea, on a small test set I worked with while writing mk-archiver, a value of 500 caused archiving to take about 2 seconds per 1000 rows on an otherwise quiet MySQL instance on my desktop machine, archiving to disk and to another table. Disabling transactions with a value of zero, which turns on autocommit, dropped performance to 38 seconds per thousand rows.
    # If you are not archiving from or to a transactional storage engine, you may want to disable transactions so mk-archiver doesn't try to commit.
    attr_accessor :txn_size # 1

    #
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No value)

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # type: string
    # WHERE clause to limit which rows to archive (required).
    # Specifies a WHERE clause to limit which rows are archived. Do not include the word WHERE. You may need to quote the argument to prevent your shell from interpreting it. For example:
    #    --where 'ts < current_date - interval 90 day'
    # For safety, --where is required. If you do not require a WHERE clause, use --where 1=1.
    attr_accessor :where # (No value)

    #
    # Print reason for exiting unless rows exhausted.
    # Causes mk-archiver to print a message if it exits for any reason other than running out of rows to archive. This can be useful if you have a cron job with --run-time specified, for example, and you want to be sure mk-archiver is finishing before running out of time.
    # If --statistics is given, the behavior is changed slightly. It will print the reason for exiting even when it's just because there are no more rows.
    # This output prints even if --quiet is given. That's so you can put mk-archiver in a cron job and get an email if there's an abnormal exit.
    attr_accessor :why_quit # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_archiver

    #
    # Returns a new Archiver Object
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

      unless @path_to_mk_archiver
        ostring = "mk-archiver "
      else
        ostring = @path_to_mk_archiver + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-archiver"
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

