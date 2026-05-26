module RedmineProjectAccessGuard
  module ApplicationControllerPatch
    def self.included(base)
      base.before_action :guard_project_access
    end

    def guard_project_access
      config             = RedmineProjectAccessGuard.config
      guarded_identifier = config['project_identifier'].to_s.strip
      allowed_group_id   = config['group_id'].to_i

      return if guarded_identifier.empty? || allowed_group_id.zero?

      # params[:project_id] is set by all project-scoped resource controllers.
      # params[:id] is used by ProjectsController itself (show, edit, destroy, …).
      project_identifier = params[:project_id].presence ||
                           (params[:id].presence if controller_name == 'projects')

      return unless project_identifier.to_s == guarded_identifier

      redirect_to home_url unless User.current.groups.exists?(allowed_group_id)
    end
  end
end
