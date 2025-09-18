#!/usr/bin/env bash
#exit on error
set -o errexit
bundle install
bundle exec rake db:migrate
# Ensure seeds are run at deploy time so the demo user and sample data are present!
bundle exec rake db:seed