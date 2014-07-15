namespace :conduit do
  desc "Execute all Conduit SQL Queries"
  task execute_queries: :environment do
    puts "Started At #{Time.now}"
    threads = []
    Query.all.each do |q|
      puts "Executing #{q.name}"
      threads << Thread.new {
        q.execute()
        q.save()
      }
    end
    threads.each do |t|
      t.join
    end
    puts "End at #{Time.now}"
  end
end
