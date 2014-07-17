namespace :conduit do
  desc "Execute all Conduit SQL Queries"
  task execute_queries: :environment do
    puts "Started At #{Time.now}"
    threads = []
    Widget.all.each do |w|
      puts "Executing Widget #{w.id}: #{w.query.name}"
      puts "Variables: #{w.variables}"
      threads << Thread.new {
        w.execute_query()
        w.save()
      }
    end
    threads.each do |t|
      t.join
    end
    puts "End at #{Time.now}"
  end
end
