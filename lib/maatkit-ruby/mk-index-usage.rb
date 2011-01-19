  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Read queries from a log and analyze how they use indexes.
  #
  # Maatkit::IndexUsage.new( array, str, array)
  #
  class Maatkit::IndexUsage

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
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_index_usage.conf,/home/joel/.maatkit.conf,/home/joel/.mk_index_usage.conf

    #
    # short form: -F; type: string
    # Only read mysql options from the given file.  You must give an absolute pathname.
    attr_accessor :defaults_file # (No value)

    #
    # type: Hash; default: non-unique
    # Suggest dropping only these types of unusued indexes.
    # By default mk-index-usage will only suggest to drop unused secondary indexes, not primary or unique
    # indexes.  You can specify which types of unused indexes the tool suggests to drop: primary, unique,
    # non-unique, all.
    # A separate "ALTER TABLE" statement for each type is printed.  So if you specify "--drop all" and there
    # is a primary key and a non-unique index, the "ALTER TABLE ... DROP" for each will be printed on
    # separate lines.
    attr_accessor :drop # non_unique

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # short form: -h; type: string
    # Connect to host.
    attr_accessor :host # (No value)

    #
    # short form: -p; type: string
    # Password to use when connecting.
    attr_accessor :password # (No value)

    #
    # short form: -P; type: int
    # Port number to use for connection.
    attr_accessor :port # (No value)

    #
    # type: array; default: time,30
    # Print progress reports to STDERR.  The value is a comma-separated list with two parts.  The first part
    # can be percentage, time, or iterations; the second part specifies how often an update should be
    # printed, in percentage, seconds, or number of iterations.
    attr_accessor :progress # time,30

    #
    # short form: -q
    # Do not print any warnings.  Also disables "--progress".
    attr_accessor :quiet # FALSE

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
    # short form: -u; type: string
    # User for login if not current user.
    attr_accessor :user # (No value)

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_index_usage

    #
    # Returns a new IndexUsage Object
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

      unless @path_to_mk_index_usage
        ostring = "mk-index-usage "
      else
        ostring = @path_to_mk_index_usage + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-index-usage"
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

