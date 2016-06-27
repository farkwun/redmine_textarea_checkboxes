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
      input_type = 'enabled'
      unless @issue.nil?
        input_type = @issue.safe_attribute?('description') ? 'enabled' : 'disabled'
      end
      # checkboxes in table
      text.gsub!(/<td>\[ \](.*)<\/td>/,"<td><input #{input_type} type='checkbox' onclick='toggle(this)' data='\\1'>\\1</td>")
      text.gsub!(/<td>\[[xX*]\](.*)<\/td>/,"<td><input #{input_type} checked type='checkbox' onclick='toggle(this)'data='\\1'><font color='gray'><strike>\\1</strike></td></font>")

      # checkboxes as part of a list
      text.gsub!(/\[ \](.*)<\/li>\n/,"<input #{input_type} type='checkbox' onclick='toggle(this)' data='\\1'>\\1\n")
      text.gsub!(/\[[xX*]\](.*)<\/li>\n/,"<input #{input_type} checked type='checkbox' onclick='toggle(this)'data='\\1'><font color='gray'><strike>\\1</strike></font>\n")
      # checkboxes on standalone lines
      text.gsub!(/<p>\[ \](.*)<\/p>/,"<input #{input_type} type='checkbox' onclick='toggle(this)' data='\\1'>\\1")
      text.gsub!(/<p>\[[xX*]\](.*)<\/p>/,"<input #{input_type} checked type='checkbox' onclick='toggle(this)'data='\\1'><font color='gray'><strike>\\1</strike></font>")

      text
    end

  end
end

ApplicationHelper.send :include, ApplicationHelperPatch

