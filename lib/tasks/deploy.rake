namespace :deploy do
  desc 'Deploy to staging'
  task :staging do
    remote = "git@heroku.com:myflix-staging.git"
    app = "myflix-staging"

    system "heroku maintenance:on --app #{app}"
    system 'git checkout staging'
    system 'git rebase master'
    system "git push -f #{remote} staging:master"
    system 'git push origin staging'
    system "heroku run rake db:migrate --app #{app}"
    system "heroku restart --app #{app}"
    system "heroku maintenance:off --app #{app}"
    system 'git checkout master'
  end

  desc 'Deploy to production'
  task :production do
    remote = "git@heroku.com:blooming-meadow-2769.git"
    app = "blooming-meadow-2769"

    system "heroku maintenance:on --app #{app}"
    system 'git checkout production'
    system 'git rebase staging'
    system "git push -f #{remote} production:master"
    system 'git push origin production'
    system "heroku run rake db:migrate --app #{app}"
    system "heroku restart --app #{app}"
    system "heroku maintenance:off --app #{app}"
    system 'git checkout master'
  end
end