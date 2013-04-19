namespace :deploy do
  desc 'Deploy to staging'
  task :staging do
    reomte = "git@heroku.com:kkk.git"
    app = "myflix"

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
    reomte = "git@heroku.com:kkk.git"
    app = "myflix"

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