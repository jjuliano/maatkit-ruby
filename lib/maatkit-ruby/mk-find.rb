  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Find MySQL tables and execute actions, like GNU find.
  #
  # Maatkit::Find.new( array, str, array)
  #
  class Maatkit::Find

    attr_accessor :ask_pass # FALSE
    attr_accessor :autoinc # (No value)
    attr_accessor :avgrowlen # (No value)
    attr_accessor :case_insensitive # FALSE
    attr_accessor :charset # (No value)
    attr_accessor :checksum # (No value)
    attr_accessor :cmin # (No value)
    attr_accessor :collation # (No value)
    attr_accessor :column_name # (No value)
    attr_accessor :column_type # (No value)
    attr_accessor :comment # (No value)
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_find.conf,/home/joel/.maatkit.conf,/home/joel/.mk_find.conf
    attr_accessor :connection_id # (No value)
    attr_accessor :createopts # (No value)
    attr_accessor :ctime # (No value)
    attr_accessor :datafree # (No value)
    attr_accessor :datasize # (No value)
    attr_accessor :day_start # FALSE
    attr_accessor :dblike # (No value)
    attr_accessor :dbregex # (No value)
    attr_accessor :defaults_file # (No value)
    attr_accessor :empty # FALSE
    attr_accessor :engine # (No value)
    attr_accessor :exec # (No value)
    attr_accessor :exec_dsn # (No value)
    attr_accessor :exec_plus # (No value)
    attr_accessor :function # (No value)
    attr_accessor :help # TRUE
    attr_accessor :host # (No value)
    attr_accessor :indexsize # (No value)
    attr_accessor :kmin # (No value)
    attr_accessor :ktime # (No value)
    attr_accessor :mmin # (No value)
    attr_accessor :mtime # (No value)
    attr_accessor :or # FALSE
    attr_accessor :password # (No value)
    attr_accessor :pid # (No value)
    attr_accessor :port # (No value)
    attr_accessor :print # FALSE
    attr_accessor :printf # (No value)
    attr_accessor :procedure # (No value)
    attr_accessor :quote # TRUE
    attr_accessor :rowformat # (No value)
    attr_accessor :rows # (No value)
    attr_accessor :server_id # (No value)
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :socket # (No value)
    attr_accessor :tablesize # (No value)
    attr_accessor :tbllike # (No value)
    attr_accessor :tblregex # (No value)
    attr_accessor :tblversion # (No value)
    attr_accessor :trigger # (No value)
    attr_accessor :trigger_table # (No value)
    attr_accessor :user # (No value)
    attr_accessor :version # FALSE
    attr_accessor :view # (No value)

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_find

    #
    # Returns a new Find Object
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

      unless @path_to_mk_find
        ostring = "mk-find "
      else
        ostring = @path_to_mk_find + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-find"
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

