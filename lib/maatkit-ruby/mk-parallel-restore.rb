  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Restore MySQL tables in parallel.
  #
  # Maatkit::ParallelRestore.new( array, str, array)
  #
  class Maatkit::ParallelRestore

    attr_accessor :ask_pass # FALSE
    attr_accessor :atomic_resume # TRUE
    attr_accessor :base_dir # /home/joel/maatkit_ruby/lib/maatkit_ruby
    attr_accessor :biggest_first # TRUE
    attr_accessor :bin_log # TRUE
    attr_accessor :bulk_insert_buffer_size # (No # value)
    attr_accessor :charset # BINARY
    attr_accessor :commit # TRUE
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_parallel_restore.conf,/home/joel/.maatkit.conf,/home/joel/.mk_parallel_restore.conf
    attr_accessor :create_databases # FALSE
    attr_accessor :create_tables # TRUE
    attr_accessor :csv # FALSE
    attr_accessor :database # (No # value)
    attr_accessor :databases # (No # value)
    attr_accessor :databases_regex # (No # value)
    attr_accessor :decompress # gzip # _d # _c
    attr_accessor :defaults_file # (No # value)
    attr_accessor :disable_keys # TRUE
    attr_accessor :drop_tables # TRUE
    attr_accessor :dry_run # FALSE
    attr_accessor :fast_index # FALSE
    attr_accessor :fifo # TRUE
    attr_accessor :foreign_key_checks # TRUE
    attr_accessor :help # TRUE
    attr_accessor :host # (No # value)
    attr_accessor :ignore # FALSE
    attr_accessor :ignore_databases #
    attr_accessor :ignore_tables #
    attr_accessor :local # FALSE
    attr_accessor :lock_tables # FALSE
    attr_accessor :no_auto_value_on_0 # TRUE
    attr_accessor :only_empty_databases # FALSE
    attr_accessor :password # (No # value)
    attr_accessor :pid # (No # value)
    attr_accessor :port # (No # value)
    attr_accessor :progress # FALSE
    attr_accessor :quiet # FALSE
    attr_accessor :replace # FALSE
    attr_accessor :resume # TRUE
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :socket # (No # value)
    attr_accessor :tab # FALSE
    attr_accessor :tables # (No # value)
    attr_accessor :tables_regex # (No # value)
    attr_accessor :threads # 2
    attr_accessor :truncate # FALSE
    attr_accessor :umask # 0
    attr_accessor :unique_checks # TRUE
    attr_accessor :user # (No # value)
    attr_accessor :verbose # 1
    attr_accessor :version # FALSE
    attr_accessor :wait # 300

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_parallel_restore

    #
    # Returns a new ParallelRestore Object
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

      unless @path_to_mk_parallel_restore
        ostring = "mk-parallel-restore "
      else
        ostring = @path_to_mk_parallel_restore + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-parallel-restore"
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

