#!/bin/bash

source /etc/profile.d/rbenv.sh

export DATABASE_URL="postgresql://postgres:@$DB_PORT_5432_TCP_ADDR:$DB_PORT_5432_TCP_PORT/app_database"

# mkdir -p /var/www
# cd /var/www
# git clone git@github.com:tadyjp/SampleRails422.git

rm -rf /var/www/app
git clone $GIT_REPOSITORY /var/www/app

cd /var/www/app

git checkout -b ${GIT_BRANCH:-master}

gem install pg -- --with-pg-config=/usr/pgsql-9.4/bin/pg_config

bundle install --without test development

bundle exec rake db:create RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production

# while true; do sleep 3 && echo "sleep!" ; done
bundle exec rails server -p 3000 -b 0.0.0.0

