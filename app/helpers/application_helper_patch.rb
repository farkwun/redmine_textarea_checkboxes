module ApplicationHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      alias_method_chain :textilizable, :checkboxes
    end
  end

  module InstanceMethods
    def textilizable_with_checkboxes(*args)
      text = textilizable_without_checkboxes(*args).to_s
      # TODO: nomethoderror being thrown when grab_checkboxes is called
      # on the home screen - not sure why, since the method has been
      # included in the application helper -- need to figure out why!
      suppress(NoMethodError) do
        text = grab_checkboxes(text)
      end

      text.html_safe
    end

    def grab_checkboxes(text)
      $input_type = 'enabled'
      unless @issue.nil?
        $input_type = @issue.safe_attribute?('description') ? 'enabled' : 'disabled'
      end
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
      "<input #{$input_type} type='checkbox' onclick='toggle(this)' data='\s\\1'>\\1</input>"
    end

    def checked_box
        "<input #{$input_type} checked type='checkbox' onclick='toggle(this)'data='\s\\1'><font color='gray'><strike>\\1</strike></font></input>"
    end

  end
end

ApplicationHelper.send :include, ApplicationHelperPatch

