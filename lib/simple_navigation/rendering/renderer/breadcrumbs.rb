module SimpleNavigation
  module Renderer

    # Renders an ItemContainer as a list of items, either by default a
    # <div> element and its containing items as <a> elements, or a raw
    # Array of items (if :raw=>true).  It only renders 'selected'
    # elements.
    #
    # By default, the renderer sets the item's key as dom_id for the rendered <a> element unless the config option <tt>autogenerate_item_ids</tt> is set to false.
    # The id can also be explicitely specified by setting the id in the html-options of the 'item' method in the config/navigation.rb file.
    # The ItemContainer's dom_class and dom_id are applied to the surrounding <div> element.
    #
    class Breadcrumbs < SimpleNavigation::Renderer::Base

      def render(item_container)
        data = selected_items(item_container)
        if options[:raw]
          data
        else
          content_tag(:div, a_tags(data).join(join_with), :id => item_container.dom_id, :class => item_container.dom_class)
        end
      end

      protected

      def a_tags(items)
        items.collect { |i| link_to(i.name, i.url, {:method => i.method}.merge(i.html_options.except(:class,:id))) }
      end

      def selected_items(item_container)
        item_container.items.inject([]) do |list, item|
          if item.selected?
            list << item
            if include_sub_navigation?(item)
              list.concat selected_items(item.sub_navigation)
            end
          end
          list
        end
      end

      def join_with
        @join_with ||= options[:join_with] || " "
      end
    end

  end
end
