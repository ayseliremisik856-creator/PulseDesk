# PulseDesk

[![CI](https://github.com/ayseliremisik856-creator/PulseDesk/actions/workflows/ci.yml/badge.svg)](https://github.com/ayseliremisik856-creator/PulseDesk/actions/workflows/ci.yml)

Repository: https://github.com/ayseliremisik856-creator/PulseDesk

Rails 8.1.4 support workflow: brands, agents, tickets, replies and a 60-minute first-response SLA. Status flow is `new → open → solved`; a late reply never erases the SLA breach.

## Local development (Windows)

Ruby 4.0.7 with RubyInstaller/MSYS2, Bundler 4.0.20 and Git. Development and test use SQLite; a local PostgreSQL server is not required.

```powershell
bundle install
ruby bin/rails db:prepare
ruby bin/rails server -b 127.0.0.1 -p 3000
```

Open http://127.0.0.1:3000. Add a brand and agent on the dashboard, then create a ticket.

```powershell
$env:RAILS_ENV = 'test'
ruby bin/rails db:migrate
ruby bin/rails test
Remove-Item Env:RAILS_ENV
```

The existing suite contains 22 tests. Time travel covers the exact 60-minute boundary (on time) and one second beyond it (breached), plus late replies and the full HTTP workflow. These are model and HTTP integration tests, not browser automation.

## GitHub preparation

No remote repository, push or Render service is created by these files. When ready, create an empty GitHub repository and replace the badge placeholders. From this directory, initialize Git if needed:

```powershell
git init -b main
git check-ignore config/master.key .env storage/development.sqlite3
git add .
git diff --cached --name-only
# Review the staged file list before committing; private keys and local data must be absent.
git commit -m "Prepare PulseDesk for Render"
git remote add origin https://github.com/ayseliremisik856-creator/PulseDesk.git
git push -u origin main
```

Commit `Gemfile.lock`, `.ruby-version`, `render.yaml` and encrypted `config/credentials.yml.enc`. Never commit `config/master.key`, credentials `.key` files, `.env` files or local SQLite files. `.gitignore` cannot remove secrets already tracked in Git history; rotate any exposed secret.

`.gitattributes` keeps Rails binstubs, shell scripts and YAML in LF format. Render/CI invoke scripts via `bash`, `bundle exec rails` or `bundle exec puma`, so Windows Git's executable-bit handling does not block deployment.

## Render free preview

Configuration follows [Render's Rails 8 guide](https://render.com/docs/deploy-rails-8). Use the native Ruby runtime and the repository-root `render.yaml` Blueprint. Both the web service and PostgreSQL explicitly use `plan: free` and the Frankfurt region. No services have been provisioned yet.

1. Push the reviewed repository when ready and wait for GitHub Actions to pass.
2. In Render, select **New → Blueprint** and connect that repository/branch.
3. Review the two free resources. Set `RAILS_MASTER_KEY` privately to the contents of your local `config/master.key`; do not paste it into source code, chat or logs.
4. Approve creation. Render injects the internal `DATABASE_URL` from `pulsedesk-db` and runs `bash bin/render-build.sh`.
5. The script installs locked gems, precompiles/cleans assets and runs migrations. Free services do not support a pre-deploy command, so migrations run in the build. Use additive/backward-compatible migrations while an older release may still serve traffic.
6. Verify the generated HTTPS URL, `/up`, and the create → assign → open → reply → solve workflow. Start with synthetic data.

| Setting | Source / purpose |
| --- | --- |
| Ruby | `.ruby-version` and `Gemfile.lock` pin 4.0.7; Bundler is locked to 4.0.20. The first Linux build must confirm availability on Render. |
| `RAILS_ENV` | `production` |
| `DATABASE_URL` | Render internal PostgreSQL URL, injected by Blueprint; required in production. Never use a local SQLite fallback. |
| `RAILS_MASTER_KEY` | Private manual entry (`sync: false`); production requires the key. Existing encrypted credentials supply `secret_key_base`. |
| `PORT` | Provided by Render; Puma binds `0.0.0.0:$PORT` (fallback 10000 in start command). Do not hard-code a different port. |
| `BUNDLE_WITHOUT` | `development:test`, excludes SQLite and Solid tooling from production. |
| `BUNDLE_DEPLOYMENT` | `true`, requires a matching committed lockfile. |
| `RAILS_SERVE_STATIC_FILES` | `true`; Puma serves compiled assets. |
| `RAILS_LOG_TO_STDOUT` | `true`; Rails already logs to stdout in production. |
| `WEB_CONCURRENCY` | `0` means Puma single mode, one process, to limit memory and match the async Cable adapter. |
| `RAILS_MAX_THREADS` | `3`, matched by PostgreSQL's connection pool. |

HTTPS is assumed behind Render's TLS proxy; `force_ssl` is retained and `/up` is excluded from redirects. `SECRET_KEY_BASE` need not be entered separately when the correct encrypted credentials/master key are present. SMTP and external file storage are not used by the current workflow.

### Solid components

The generated Rails setup expected separate `cache`, `queue` and `cable` databases. The components can share PostgreSQL with their own tables, but require explicit schema/worker setup. For this synchronous preview they are disabled in production:

- Cache: bounded 16 MB `memory_store`, disposable across restarts.
- Jobs: `inline`, executes immediately; no persistent queue, worker or scheduled jobs. Add a durable queue before introducing slow/background work.
- Cable: `async`, in one Puma process only. Add a shared adapter before scaling.

Solid gems/generated schema files remain available for local tooling but are excluded from the production bundle. Production has one PostgreSQL connection only. The existing ticket/SLA logic needs no scheduler: deadlines are calculated when read.

### Free-tier and application limits

[Free Render PostgreSQL expires after 30 days](https://render.com/docs/free); free web services sleep after inactivity and use an ephemeral filesystem. This is a preview, not durable commercial production hosting. Upgrade PostgreSQL before expiry and arrange backups. Do not store SQLite data or uploads on the web service filesystem. Before adding attachments, configure external object storage; the generated Active Storage local setting is not durable on Render.

The current app has no login, authorization or tenant isolation. Anyone who can reach it can manage the support data. Use synthetic data for the public demo; add these controls before using real customer information.

## CI and platform verification

`.github/workflows/ci.yml` runs on pushes, pull requests and manual dispatch with read-only repository permissions:

- Ubuntu 24.04 / Ruby 4.0.7: migrate SQLite and run the full 22-test suite plus Zeitwerk validation.
- Separate production job with PostgreSQL 16: install production gems only, generate disposable CI credentials, run the actual Render build script, exercise the PostgreSQL workflow inside a rolled-back transaction, start Puma and check `/`, `/up` and the compiled CSS URL.

CI credentials replace the encrypted file only inside the disposable runner checkout; they never use the real master key and are not uploaded. The workflow does not need repository secrets. The Blueprint waits for passing GitHub checks before automatic deploys (initial creation still requires manual approval).

The lockfile includes Windows `x64-mingw-ucrt` and Linux `x86_64-linux` platforms, including PostgreSQL native gems. After dependency updates, preserve both:

```powershell
bundle lock --add-platform x86_64-linux
bundle install
```

Passing local Windows tests or asset compilation does not prove a Linux/Render deploy succeeded. GitHub-hosted jobs have not run until the repository is pushed; inspect their actual results before deployment. No GitHub Actions or Render success is implied by the badge template.
