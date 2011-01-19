  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Analyze MySQL variables and advise on possible problems.
  #
  # Maatkit::VisualExplain.new( array, str, array)
  #
  class Maatkit::VisualExplain

    attr_accessor :ask_pass # FALSE
    attr_accessor :charset # (No # value)
    attr_accessor :clustered_pk # FALSE
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk_visual_explain.conf,/home/joel/.maatkit.conf,/home/joel/.mk_visual_explain.conf
    attr_accessor :connect # FALSE
    attr_accessor :database # (No # value)
    attr_accessor :defaults_file # (No # value)
    attr_accessor :format # tree
    attr_accessor :help # TRUE
    attr_accessor :host # (No # value)
    attr_accessor :password # (No # value)
    attr_accessor :pid # (No # value)
    attr_accessor :port # (No # value)
    attr_accessor :set_vars # wait_timeout=10000
    attr_accessor :socket # (No # value)
    attr_accessor :user # (No # value)
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_visual_explain

    #
    # Returns a new VisualExplain Object
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

      unless @path_to_mk_visual_explain
        ostring = "mk-visual-explain "
      else
        ostring = @path_to_mk_visual_explain + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-visual-explain"
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

