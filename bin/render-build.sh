#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

export RAILS_ENV=production
: "${DATABASE_URL:?Set DATABASE_URL to the Render internal PostgreSQL URL}"
: "${RAILS_MASTER_KEY:?Set RAILS_MASTER_KEY in Render, never in this script}"

bundle install
bundle exec ruby script/validate_credentials.rb
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Free web services have no pre-deploy command. Keep migrations here as in
# Render's Rails 8 guide. Use additive migrations while the old release is live.
bundle exec rails db:migrate
