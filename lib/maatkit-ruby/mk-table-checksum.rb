  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Perform an online replication consistency check, or checksum MySQL tables efficiently on one or many servers.
  #
  # Maatkit::TableChecksum.new( array, str, array)
  #
  class Maatkit::TableChecksum

    attr_accessor :algorithm # (No # value)
    attr_accessor :arg_table # (No # value)
    attr_accessor :ask_pass # FALSE
    attr_accessor :check_interval # 1
    attr_accessor :check_replication_filters # TRUE
    attr_accessor :check_slave_lag # (No # value)
    attr_accessor :checksum # FALSE
    attr_accessor :chunk_column # (No # value)
    attr_accessor :chunk_index # (No # value)
    attr_accessor :chunk_size # (No # value)
    attr_accessor :chunk_size_limit # (No # value)
    attr_accessor :columns # (No # value)
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_table_checksum.conf,/home/joel/.maatkit.conf,/home/joel/.mk_table_checksum.conf
    attr_accessor :count # FALSE
    attr_accessor :crc # TRUE
    attr_accessor :create_replicate_table # FALSE
    attr_accessor :databases # (No # value)
    attr_accessor :defaults_file # (No # value)
    attr_accessor :empty_replicate_table # FALSE
    attr_accessor :engines # (No # value)
    attr_accessor :explain # FALSE
    attr_accessor :explain_hosts # FALSE
    attr_accessor :float_precision # (No # value)
    attr_accessor :function # (No # value)
    attr_accessor :help # TRUE
    attr_accessor :ignore_columns # (No # value)
    attr_accessor :ignore_databases # (No # value)
    attr_accessor :ignore_engines # FEDERATED,MRG_MyISAM
    attr_accessor :ignore_tables # (No # value)
    attr_accessor :lock # FALSE
    attr_accessor :max_lag # 1
    attr_accessor :modulo # (No # value)
    attr_accessor :offset # (No # value)
    attr_accessor :optimize_xor # TRUE
    attr_accessor :password # (No # value)
    attr_accessor :pid # (No # value)
    attr_accessor :port # (No # value)
    attr_accessor :probability # 100
    attr_accessor :quiet # FALSE
    attr_accessor :recheck # FALSE
    attr_accessor :recurse # FALSE
    attr_accessor :recursion_method # (No # value)
    attr_accessor :replicate # (No # value)
    attr_accessor :replicate_check # (No # value)
    attr_accessor :replicate_database # (No # value)
    attr_accessor :resume # (No # value)
    attr_accessor :resume_replicate # FALSE
    attr_accessor :save_since # FALSE
    attr_accessor :schema # FALSE
    attr_accessor :separator # #
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :since # (No # value)
    attr_accessor :since_column # (No # value)
    attr_accessor :single_chunk # FALSE
    attr_accessor :slave_lag # FALSE
    attr_accessor :sleep # (No # value)
    attr_accessor :sleep_coef # (No # value)
    attr_accessor :socket # (No # value)
    attr_accessor :tab # FALSE
    attr_accessor :tables # (No # value)
    attr_accessor :throttle_method # none
    attr_accessor :trim # FALSE
    attr_accessor :unchunkable_tables # TRUE
    attr_accessor :use_index # TRUE
    attr_accessor :user # (No # value)
    attr_accessor :verify # TRUE
    attr_accessor :version # FALSE
    attr_accessor :wait # (No # value)
    attr_accessor :where # (No # value)
    attr_accessor :zero_chunk # TRUE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_table_checksum

    #
    # Returns a new TableChecksum Object
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

      unless @path_to_mk_table_checksum
        ostring = "mk-table-checksum "
      else
        ostring = @path_to_mk_table_checksum + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-table-checksum"
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

