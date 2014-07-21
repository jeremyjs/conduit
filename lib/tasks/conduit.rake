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
  desc "Update list of providers"
  task update_providers: :environment do
    puts "Started At #{Time.now}"
    puts "Fetching list of providers..."
    providers = Query.execute("SELECT DISTINCT source_type_cd FROM customer_sources")
    providers.each do |p|
      Provider.find_or_create_by(name: p['source_type_cd'])
    end
    puts "End at #{Time.now}"
  end
end
