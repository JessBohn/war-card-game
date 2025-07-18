# Setup

I happen to be using `ruby 3.3.8`, so that is the version set within the Gemfile. Run
```
bundle install
```

If there is an issue with the bundler version, try:
```
bundle update --bundler && bundle install
```

If you don't have an applicable ruby version installed simply install it using one of the following (or possibly with another manager)    
**rvm**
```
rvm install 3.3.8
```

**rbenv**
```
rbenv install 3.3.8
```
If you just installed the ruby version, also run
```
bundle update --ruby
```

# Run
After finishing setup, you can simply run
```
ruby lib/game_runner.rb
```
This will create a randomized instance of the game, choosing either 2 or 4 players, play until there is a winner and print out the winner with how many rounds it took.

# Development
Tests are built and run with [`rspec`](https://github.com/rspec/rspec). You can run all, per file, or a specific block by adding the starting line number
```
$ rspec
```
