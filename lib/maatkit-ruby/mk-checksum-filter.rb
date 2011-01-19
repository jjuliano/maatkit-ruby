  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Filter checksums from mk-table-checksum.
  #
  # Maatkit::ChecksumFilter.new( array, str, array)
  #
  class Maatkit::ChecksumFilter

    #
    # type: Hash
    # This comma-separated list of databases are equal.
    # These database names are always considered to have the same tables. In other words, this makes database1.table1.chunk1 equal to database2.table1.chunk1 if they have the same checksum.
    # This disables incremental processing, so you won't see any results until all input is processed.
    attr_accessor :equal_databases

    #
    # short form: -h
    # Preserves headers output by mk-table-checksum.
    attr_accessor :header # FALSE

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # Ignore the database name when comparing lines.
    # This disables incremental processing, so you won't see any results until all input is processed.
    attr_accessor :ignore_databases # FALSE

    #
    # type: string
    # The name of the master server.
    # Specifies which host is the replication master, and sorts lines for that host first, so you can see the checksum values on the master server before the slave.
    attr_accessor :master

    #
    # type: string
    # Show unique differing host/db/table names.
    # The argument must be one of host, db, or table.
    attr_accessor :unique # (No value)

    #
    # short form: -v
    # Output all lines, even those that have no differences, except for header lines.
    attr_accessor :verbose # FALSE

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_checksum_filter

    #
    # Returns a new ChecksumFilter Object
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

      unless @path_to_mk_checksum_filter
        ostring = "mk-checksum-filter "
      else
        ostring = @path_to_mk_checksum_filter + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-checksum-filter"
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

