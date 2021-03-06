Conduit
============
## Setup

Prior to running the application, set up a Postgres database:

```createdb -p 5432 -h localhost -e conduit_db```

## Auto-Execute Queries

To enable the whenever gem to automatically execute all of your queries every 15 minutes, you need to manually have it update your crontab with the following command:

```whenever --update-crontab```

You can disable this behavior with this command:

```whenever --clear-crontab```

## Run Cucumber and Rspec Tests

To run cucumber tests , go to the conduit directory and run the
following command:

```bundle exec cucumber```

To run the rspec tests , go to the conduit directory and run the
following command:

```bundle exec rspec```
