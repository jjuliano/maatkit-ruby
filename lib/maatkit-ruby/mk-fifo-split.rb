  # = maatkit-ruby - A maatkit gem for Ruby
  #
  # Homepage::  http://github.com/jjuliano/maatkit-ruby
  # Author::    Joel Bryan Juliano
  # Copyright:: (cc) 2011 Joel Bryan Juliano
  # License::   MIT

  #
  # Split files and pipe lines to a fifo without really splitting.
  #
  # Maatkit::FifoSplit.new( array, str, array)
  #
  class Maatkit::FifoSplit

    #
    # type: Array
    # Read this comma-separated list of config files; if specified, this must be the first option on the
    # command line.
    attr_accessor :config # /etc/maatkit/maatkit.conf,/etc/maatkit/mk-fifo-split.conf,/home/joel/.maatkit.conf,/home/joel/.mk-fifo-split.conf

    #
    # type: string; default: /tmp/mk-fifo-split
    # The name of the fifo from which the lines can be read.
    attr_accessor :fifo # /tmp/mk-fifo-split

    #
    # Remove the fifo if it exists already, then create it again.
    attr_accessor :force # FALSE

    #
    # Show help and exit.
    attr_accessor :help # TRUE

    #
    # type: int; default: 1000
    # The number of lines to read in each chunk.
    attr_accessor :lines # 1000

    #
    # type: int; default: 0
    # Begin at the Nth line.  If the argument is 0, all lines are printed to the fifo.  If 1, then beginning
    # at the first line, lines are printed (exactly the same as 0).  If 2, the first line is skipped, and the
    # 2nd and subsequent lines are printed to the fifo.
    attr_accessor :offset # (No # value)

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
    # Print out statistics between chunks.  The statistics are the number of chunks, the number of lines,
    # elapsed time, and lines per second overall and during the last chunk.
    attr_accessor :statistics # FALSE

    #
    # Show version and exit.
    attr_accessor :version # FALSE

    #
    # Sets the executable path, otherwise the environment path will be used.
    #
    attr_accessor :path_to_mk_fifo_split

    #
    # Returns a new FifoSplit Object
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

      unless @path_to_mk_fifo_split
        ostring = "mk-fifo-split "
      else
        ostring = @path_to_mk_fifo_split + " "
      end

      self.instance_variables.each do |i|
        tmp_value = self.instance_variable_get "#{i}"
        tmp_string = i.gsub("_", "-").gsub("@", "--")
        unless tmp_string == "--path-to-mk-fifo-split"
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

