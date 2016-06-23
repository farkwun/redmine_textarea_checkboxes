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
      suppress(NoMethodError) do
        text = grab_checkboxes(text)
      end
      text.html_safe
    end

    def grab_checkboxes(text)
      unless @issue.nil?
        input_type = @issue.safe_attribute?('description') ? 'enabled' : 'disabled'
      end
      # checkboxes as part of a list
      text.gsub!(/\[ \](.*)<\/li>\n/,"<input #{input_type} type='checkbox' onclick='toggle(this)' data='\\1'>\\1\n")
      text.gsub!(/\[[xX*]\](.*)<\/li>\n/,"<input #{input_type} checked type='checkbox' onclick='toggle(this)'data='\\1'>\\1\n")
      # checkboxes on standalone lines
      text.gsub!(/\n<p>\[ \](.*)<\/p>\n/,"<input #{input_type} type='checkbox' onclick='toggle(this)' data='\\1'>\\1\n")
      text.gsub!(/\n<p>\[[xX*]\](.*)<\/p>\n/,"<input #{input_type} checked type='checkbox' onclick='toggle(this)'data='\\1'>\\1\n")

      text
    end

  end
end

ApplicationHelper.send :include, ApplicationHelperPatch

