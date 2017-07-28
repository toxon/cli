# frozen_string_literal: true

module Widgets
  class Chat < VPanel
    class History < Curses::React::Component
    private

      def render
        window.clear

        return if props[:messages].empty?

        offset = 0

        props[:messages].reverse_each do |msg|
          offset += render_message(
            offset,
            msg[:error] || msg[:out] && !msg[:received] && Time.now.utc - msg[:time] > 10,
            msg[:out],
            msg[:time].strftime('%H:%M:%S'),
            msg[:name],
            msg[:text],
          )

          break if offset >= props[:height]
        end
      end

      def render_message(offset, error, out, time, name, text)
        width = props[:width] / 3 * 2
        left  = out ? props[:width] - width : 0

        lines = (text.length / width.to_f).ceil

        elem = render_lines offset, out, text, width, left, lines
        Curses::React::Nodes.klass_for(elem).new(
          elem,
          window,
        ).draw

        elem = render_header error, out, name, time
        width = name.length + time.length + (error ? 3 : 1)
        Curses::React::Nodes.klass_for(elem).new(
          elem,
          window,
          x: out ? props[:width] - width : 0,
          y: props[:height] - offset - lines - 1,
          width: width,
        ).draw

        1 + lines
      end

      def render_header(error, out, name, time)
        create_element :line do
          if out
            if error
              create_element :text, text: 'x', attr: Style.default.message_error_attr
              create_element :text, text: ' '
            end

            create_element :text, text: name, attr: Style.default.message_author_attr
            create_element :text, text: ' '
            create_element :text, text: time, attr: Style.default.message_time_attr
          else
            create_element :text, text: time, attr: Style.default.message_time_attr
            create_element :text, text: ' '
            create_element :text, text: name, attr: Style.default.message_author_attr

            if error
              create_element :text, text: ' '
              create_element :text, text: 'x', attr: Style.default.message_error_attr
            end
          end
        end
      end

      def render_lines(offset, out, text, width, left, lines)
        create_element(
          :lines,
          x: left,
          y: props[:height] - offset - lines,
          width: width,
        ) do
          1.upto lines do |line|
            create_element :line do
              s = text[(width * (line - 1))...(width * line)].strip
              create_element :text, text: out ? s.rjust(width) : s
            end
          end
        end
      end
    end
  end
end
