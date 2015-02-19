# Sync Daemon

  Daemon to synchronize database from billing to backoffice(BO) and from BO to billing. To see what data will be synchronized from tracker to billing please see a `sync_user_profile` method in 'lib/daemon.rb'

## Install

  1. Goto your store directory.
  2. Run `git clone http://user@176.9.31.103:7990/scm/bo/sync-daemon.git`
  3. Run `cd sync-daemon`
  4. Set `tracker_dirpath` variable in Gemfile. Details in 'Gemfile'.
  5. Run `bundle install`
  6. Set up things in 'config/config.rb' file in "Settings" section.
  7. Set up a daemon database configurations in 'config/database_cb.yml' and 'config/mongo.yml' files.

>  If you want use a test variant you can connect to existing database or create own:
>
>  1. Run `rake db:create`.
>  2. Run `rake db:migrate`.
>
>  To delete database: `rake db:drop`.

## Run

 To run daemon just type `ruby run.rb`. If there where any problems in starting daemon it will be displayed in console.

# WARNING

 This daemon was tested on faked data and on a small copy of real billing database, so there is a probability that it will fail to start for the first time. If it happens please feel free to contact developers for details.
