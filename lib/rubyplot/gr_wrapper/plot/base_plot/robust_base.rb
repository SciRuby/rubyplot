module Rubyplot
  module GRWrapper
    module Plot
      module BasePlot
        class RobustBase
          include Rubyplot::GRWrapper::Tasks
          
          attr_reader :plot_type
          
          def initialize
            @tasks = []
            @plot_type = :robust
          end

          # FIXME: writer to canvas is also part of this class, similar to Magick backend.
          #  In the future both should be abstracted to another rendering class.
          def write file_name
            puts "file: #{file_name}"
            BeginPrint.new(file_name).call
            
            # FIXME: remove @identity varible.
            @identity = [@axes.figure.nrows, @axes.figure.ncols, @axes.position+1]
            
            r = (@identity[2].to_f / @identity[1].to_f).ceil
            c = (@identity[2] % @identity[1]).zero? ? @identity[1] : @identity[2] % @identity[1]
            @ymax = 1 - (1.to_f / @identity[0]) * (r - 1) - 0.095 / @identity[0]
            @ymin = 1 - (1.to_f / @identity[0]) * r + 0.095 / @identity[0]
            @xmin = (1.to_f / @identity[1]) * (c - 1) + 0.095 / @identity[1]
            @xmax = (1.to_f / @identity[1]) * c - 0.095 / @identity[1]

            @axes.x_axis_padding = Math.log((@axes.x_range[1] - @axes.x_range[0]), 10).round
            @axes.y_axis_padding = Math.log((@axes.y_range[1] - @axes.y_range[0]), 10).round

            @axes.origin[0] = @axes.x_range[0] - @axes.x_axis_padding if
              @axes.origin[0] == :default
            @axes.origin[1] = @axes.y_range[0] - @axes.y_axis_padding if
              @axes.origin[1] == :default

            SetViewPort.new(@xmin, @xmax, @ymin, @ymax).call
            SetWindow.new(@axes.x_range[0] - @axes.x_axis_padding,
                          @axes.x_range[1] + @axes.x_axis_padding,
                          @axes.y_range[0] - @axes.y_axis_padding,
                          @axes.y_range[1] + @axes.y_axis_padding).call
            # Make sure that window is set bigger than range figure out how to manage it
            SetTextAlign.new(2, 0).call
            @axes.text_font = :times_roman if @axes.text_font == :default
            SetTextFontPrecision.new(GR_FONTS[@axes.text_font],
                                     GR_FONT_PRECISION[:text_precision_string]).call
            SetCharHeight.new(0.012).call
            @axes.y_tick_count = 10 if @axes.y_tick_count == :default
            @axes.x_tick_count = 10 if @axes.x_tick_count == :default # 10 ticks by default
            SetLineColorIndex.new(hex_color_to_gr_color_index(
                                    Rubyplot::Color::COLOR_INDEX[:black])).call
            SetLineWidth.new(1).call
            SetLineType.new(GR_LINE_TYPES[:solid]).call
            Grid.new((@axes.x_range[1] - @axes.x_range[0]).to_f / @axes.x_tick_count,
                     (@axes.y_range[1] - @axes.y_range[0]).to_f / @axes.y_tick_count,
                     0, 0, 1, 1).call
            Tasks::Axes.new((@axes.x_range[1] - @axes.x_range[0]).to_f / @axes.x_tick_count,
                     (@axes.y_range[1] - @axes.y_range[0]).to_f / @axes.y_tick_count,
                     @axes.origin[0], @axes.origin[1], 1, 1, 0.01).call
            Tasks::AxesTitles.new(@axes.x_title, @axes.y_title, '').call

            call
            # @tasks.each do |task|
            #   task.call()
            #   task.call(self) if task.plot_type == :lazy
            # end

            EndPrint.new.call
          end
        end
      end
    end # module Plot
  end # module GRWrapper
end # module Rubyplot
