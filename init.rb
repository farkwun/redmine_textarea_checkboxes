# This is the important line.
# It requires the file in lib/my_plugin/hooks.rb
require_dependency 'redmine_textarea_checkboxes/hooks'
require_dependency 'redmine_textarea_checkboxes/application_helper_patch'

Redmine::Plugin.register :redmine_textarea_checkboxes do
	name 'Redmine Textarea Checkboxes'
	description 'Enables checkboxes in issue description text areas'
	url 'https://github.com/farkwun/redmine_textarea_checkboxes'

	author 'farkwun'
	author_url 'https://github.com/farkwun'

	version '0.0.0'
	requires_redmine :version_or_higher => '2.6.0'
end
