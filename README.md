# redmine_project_access_guard

A minimal Redmine plugin that silently blocks access to a specific project for users who are not members of a configured group — **including administrators**.

## Features

- Zero UI, zero migrations, zero assets
- Server-side `before_action` on `ApplicationController` — no client-side tricks
- Covers all project routes (issues, wiki, files, settings, API, …)
- Silent redirect to home — no error message shown
- Works on Redmine 5.x / Ruby 3.x

## Installation

```bash
# Copy into your Redmine plugins directory
cp -r redmine_project_access_guard /path/to/redmine/plugins/

# Edit the config with your values (see Configuration below)
nano /path/to/redmine/plugins/redmine_project_access_guard/config.yml

# Restart Redmine
touch /path/to/redmine/tmp/restart.txt
```

No `bundle install` needed — no new gem dependencies.

## Configuration

Edit `config.yml` inside the plugin directory:

```yaml
# Identifier (slug) of the project to protect.
# Found in Administration > Projects > (your project) > Identifier field.
project_identifier: "my_secret_project"

# ID of the Redmine group whose members are allowed access.
# Found in Administration > Groups > (your group) — the number in the URL (/groups/5/edit).
group_id: 5
```

### Finding the values

| Parameter | Where to find it |
|---|---|
| `project_identifier` | *Administration → Projects → (project) → "Identifier" field* |
| `group_id` | *Administration → Groups → (group)* — the number in the URL (`/groups/5/edit`) |

## How it works

`init.rb` hooks into `Rails.application.config.after_initialize` and includes a patch into `ApplicationController`. The patch registers a `before_action` that:

1. Reads `project_identifier` and `group_id` from `config.yml`.
2. Extracts the current project from request params (`params[:project_id]` for resource controllers, `params[:id]` for `ProjectsController`).
3. If the identifier matches the protected project, checks `User.current.groups.exists?(group_id)`.
4. If the user does **not** belong to the group → silent `redirect_to home_url`.

The check is unconditional: `user.admin?` is never consulted.

## Compatibility

| Redmine | Ruby |
|---|---|
| 5.x | 3.x |

## License

MIT
