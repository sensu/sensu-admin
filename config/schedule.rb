# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

every 5.minutes do
  runner "Downtime.process_downtimes"
end

every 20.minutes do
  runner "Stash.clear_expired_stashes"
end

# Learn more: http://github.com/javan/whenever
