module ApplicationHelperPatch
  def self.included(base) # :nodoc:
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      def grab_checkboxes(text)
        @input_type = enable_checkboxes? ? 'enabled' : 'disabled'
        # checkboxes in table
        text.gsub!(/<td>\[ \]\s(.*)<\/td>/,"<td>#{un_checked_box}</td>")
        text.gsub!(/<td>\[[xX*]\]\s(.*)<\/td>/,"<td>#{checked_box}</td>")

        # checkboxes as part of a list
        text.gsub!(/\[ \]\s(.*)<\/li>\n/,"#{un_checked_box}\n")
        text.gsub!(/\[[xX*]\]\s(.*)<\/li>\n/,"#{checked_box}\n")
        # checkboxes on standalone lines
        text.gsub!(/<p>\[ \]\s(.*)<\/p>/,"#{un_checked_box}")
        text.gsub!(/<p>\[[xX*]\]\s(.*)<\/p>/,"#{checked_box}")

        text
      end

      def un_checked_box
        "<label><input #{@input_type} type='checkbox' onclick='toggle(this)' data='\s\\1'>\\1</input></label>"
      end

      def checked_box
        "<label><input #{@input_type} checked type='checkbox' onclick='toggle(this)'data='\s\\1'><font color='gray'><strike>\\1</strike></font></input></label>"
      end

      def enable_checkboxes?
        @issue && allow_edits? && @issue.safe_attribute?('description')
      end

      def edit_args_passed?(args)
        symbols_in_args(args).include?(:description)
      end

      def symbols_in_args(args)
        symbols = []
        args.each do |arg|
          symbols << arg if is_a_symbol?(arg)
        end
        symbols
      end

      def is_a_symbol?(input)
        input.respond_to?(:is_a?) && input.is_a?(Symbol)
      end

      def allow_edits
        @editable = true
      end

      def allow_edits?
        @editable
      end

      def textilizable_with_checkboxes(*args)
        text = textilizable_without_checkboxes(*args).to_s
        allow_edits if edit_args_passed?(args)
        text = grab_checkboxes(text)
        text.html_safe
      end

      alias_method_chain :textilizable, :checkboxes
    end
  end
end

ApplicationHelper.send :include, ApplicationHelperPatch
