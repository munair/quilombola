#!/bin/bash
#
# setup.bash
#
# written by: munair simpson
# inspired by: dima golub
#
#
# First produce a list of GENERATORS for rails and verify active_admin and bootstrap.
#
# Generate active_admin and bootstrap code for rails.
#
# Then, after specifying the LC_ALL and LANGUAGE variables, login as postgres (the only
# database user that connect to a fresh install of postgresql) to create a superuser
# account for the ubuntu user account. Ideally you should set a password, however since
# you are accessing the database locally (and blocking non-local connections hopefully)
# you needn't specify a password as it would never be invoked on a local connect.
#
# Create _development _test and _production databases for the ubuntu user in accordance
# with the config/database.yml file.
#
# Always migrate after making database changes.
#
# Seed active_admin with the user 'munair@gmail.com'. Don't forget to remove the default.
# Verify seed and then rake up the seed and migrate.
#

rails generate | grep active_admin || ( echo "active_admin not present." ; exit )
rails generate | grep bootstrap || ( echo "bootstrap not present." ; exit )

rails generate active_admin:install
rails generate bootstrap:install

LANGUAGE='ko_KR.UTF-8' ; LC_ALL='C' ; export LANGUAGE LC_ALL ; sudo -u postgres createuser --superuser ubuntu
grep unicode config/database.yml && cat config/database.yml | sed "s/unicode/sql-ascii/" > /tmp/database.yml && mv /tmp/database.yml config/database.yml
sudo -u postgres createdb ubuntu
rake db:create db:migrate

grep munair db/seeds.rb || echo "AdminUser.create email: 'munair@gmail.com', password: 'dimadima', password_confirmation: 'dimadima'" | cat >> db/seeds.rb 
cat db/seeds.rb 
rake db:seed
rake db:migrate
