#!/usr/bin/env bash
#exit on error
set -o errexit
# Allow bundler to update the lockfile during build (Render runs in frozen mode by default)
# This lets new gems (like `pg`) be resolved and installed during deploy.
bundle config set --local frozen false || true
bundle install --jobs 4 --retry 3
bundle exec rake db:migrate
# Ensure seeds are run at deploy time so the demo user and sample data are present!
bundle exec rake db:seed