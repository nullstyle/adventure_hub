module AdventureHub
  class Reporter
    
    include Celluloid

    def initialize(io=$stdout)
      @io = io
      @io.sync = true
    end

    def log(message)
      reset_to_beginning_of_line
      clear_screen
      @io.puts message
      @io.flush
      
    end
    
    def progress(label, current, total)
      return unless @io.tty?
      reset_to_beginning_of_line
      @io.print progress_line(label, current, total)
    end

    private
    def get_screen_width
      TermInfo.screen_size.last
    end

    def progress_line(label, current, total)
      line = "#{label} "
      progress_bar_length = get_screen_width - line.length
      progress_bar_body_length = progress_bar_length - 2 # [] removed from bar size


      percentage_complete = current / total.to_f
      chars_filled  = (progress_bar_body_length * percentage_complete).round
      progress_body = "=" * chars_filled

      line += "[#{progress_body.ljust(progress_bar_body_length)}]"
      line
    end
    
    def clear_screen
      return unless @io.tty?
      @io.printf "\033[0J"
    end

    def reset_to_beginning_of_line
      return unless @io.tty?
      @io.printf "\033[1G"
    end


  end
end