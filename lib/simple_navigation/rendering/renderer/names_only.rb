module SimpleNavigation
  module Renderer

    # Renders an ItemContainer as a list of strings joined by the
    # specfied string.  It only renders 'selected' elements.
    class NamesOnly < SimpleNavigation::Renderer::Base

      def render(item_container)
        list = raw_items(item_container)
        options[:reverse] && list.reverse!
        list[options[:start] || 0, options[:depth] || list.length].join(join_with)
      end

      protected

      def raw_items(item_container)
        item_container.items.inject([]) do |list, item|
          if item.selected?
            list << item.name
            if include_sub_navigation?(item)
              list.concat raw_items(item.sub_navigation)
            end
          end
          list
        end
      end

      def join_with
        @join_with ||= options[:join_with] || " - "
      end
    end

  end
end
