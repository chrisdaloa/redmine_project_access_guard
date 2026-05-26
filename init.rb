require 'yaml'

module RedmineProjectAccessGuard
  CONFIG_PATH = File.join(File.dirname(__FILE__), 'config.yml')

  def self.config
    @config ||= YAML.safe_load(File.read(CONFIG_PATH))
  end
end

require_relative 'lib/redmine_project_access_guard/application_controller_patch'

Redmine::Plugin.register :redmine_project_access_guard do
  name        'Redmine Project Access Guard'
  author      'Your Name'
  description 'Silently blocks access to a protected project for non-group members, admins included'
  version     '1.0.0'
  requires_redmine version_or_higher: '5.0'
end

Rails.application.config.after_initialize do
  ApplicationController.include RedmineProjectAccessGuard::ApplicationControllerPatch
end
