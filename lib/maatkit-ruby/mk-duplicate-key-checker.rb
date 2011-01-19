  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Find duplicate indexes and foreign keys on MySQL tables.
  #
  # Maatkit::DuplicateKeyChecker.new( array, str, array)
  #
  class Maatkit::DuplicateKeyChecker

    #
    # Compare indexes with different structs (BTREE, HASH, etc).
    # By default this is disabled, because a BTREE index that covers the same columns as a FULLTEXT index is
    # not really a duplicate, for example.
    attr_accessor :all_structs # FALSE

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
    # default: yes
    # PK columns appended to secondary key is duplicate.
    # Detects when a suffix of a secondary key is a leftmost prefix of the primary key, and treats it as a
    # duplicate key.  Only detects this condition on storage engines whose primary keys are clustered
    # (currently InnoDB and solidDB).
    # Clustered storage engines append the primary key columns to the leaf nodes of all secondary keys
    # anyway, so you might consider it redundant to have them appear in the internal nodes as well.  Of
    # course, you may also want them in the internal nodes, because just having them at the leaf nodes won't
    # help for some queries.  It does help for covering index queries, however.
    # Here's an example of a key that is considered redundant with this option:
    #  PRIMARY KEY  (`a`)
    #  KEY `b` (`b`,`a`)
    # The use of such indexes is rather subtle.  For example, suppose you have the following query:
    #  SELECT ... WHERE b=1 ORDER BY a;
    # This query will do a filesort if we remove the index on "b,a".  But if we shorten the index on "b,a" to
    # just "b" and also remove the ORDER BY, the query should return the same results.
    # The tool suggests shortening duplicate clustered keys by dropping the key and re-adding it without the
    # primary key prefix.  The shortened clustered key may still duplicate another key, but the tool cannot
    # currently detect when this happens without being ran a second time to re-check the newly shortened
    # clustered keys.  Therefore, if you shorten any duplicate clusterted keys, you should run the tool
    # again.
    attr_accessor :clustered # TRUE

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the
    # command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_duplicate_key_checker.conf,/home/joel/.maatkit.conf,/home/joel/.mk_duplicate_key_checker.conf

    #
    # short form: -d; type: hash
    # Check only this comma-separated list of databases.
    attr_accessor :databases # (No value)

    #
    # short form: -F; type: string
    # Only read mysql options from the given file.  You must give an absolute pathname.
    attr_accessor :defaults_file # (No value)

    #
    # short form: -e; type: hash
    # Check only tables whose storage engine is in this comma-separated list.
    attr_accessor :engines # (No value)

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No value)

    #
    # type: Hash
    # Ignore this comma-separated list of databases.
    attr_accessor :ignore_databases #

    #
    # type: Hash
    # Ignore this comma-separated list of storage engines.
    attr_accessor :ignore_engines #

    #
    # Ignore index order so KEY(a,b) duplicates KEY(b,a).
    attr_accessor :ignore_order # FALSE

    #
    # type: Hash
    # Ignore this comma-separated list of tables.  Table names may be qualified with the database name.
    attr_accessor :ignore_tables #

    #
    # type: string; default: fk
    # Check for duplicate f=foreign keys, k=keys or fk=both.
    attr_accessor :key_types # fk

    #
    # short form: -p; type: string
    # Password to use when connecting.
    attr_accessor :password # (No value)

    #
    # type: string
    # Create the given PID file.  The file contains the process ID of the script.  The PID file is removed
    # when the script exits.  Before starting, the script checks if the PID file already exists.  If it does
    # not, then the script creates and writes its own PID to it.  If it does, then the script checks the
    # following: if the file contains a PID and a process is running with that PID, then the script dies; or,
    # if there is no process running with that PID, then the script overwrites the file with its own PID and
    # starts; else, if the file contains no PID, then the script dies.
    attr_accessor :pid # (No value)

    #
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No value)

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
    # default: yes
    # Print DROP KEY statement for each duplicate key.  By default an ALTER TABLE DROP KEY statement is
    # printed below each duplicate key so that, if you want to remove the duplicate key, you can copy-paste
    # the statement into MySQL.
    # To disable printing these statements, specify --nosql.
    attr_accessor :sql # TRUE

    #
    # default: yes
    # Print summary of indexes at end of output.
    attr_accessor :summary # TRUE

    #
    # short form: -t; type: hash
    # Check only this comma-separated list of tables.
    # Table names may be qualified with the database name.
    attr_accessor :tables # (No value)

    #
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No value)

    #
    # short form: -v
    # Output all keys and/or foreign keys found, not just redundant ones.
    attr_accessor :verbose # FALSE

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_duplicate_key_checker

    #
    # Returns a new DuplicateKeyChecker Object
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

      unless @path_to_mk_duplicate_key_checker
        ostring = "mk-duplicate-key-checker "
      else
        ostring = @path_to_mk_duplicate_key_checker + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-duplicate-key-checker"
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

