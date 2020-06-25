```zsh
cp config/database.yml.sample config/database.yml

bundle install --without production

rake db:migrate
rake default:system_user
rails s

```

### rename
```
rails g rename:into New-Name
```