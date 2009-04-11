namespace :uscg do
  desc "download vessel data from http://www.st.nmfs.noaa.gov/st1/CoastGuard/VesselByName.html"
  task(:crawl => :environment) do
    vowels = ['a', 'e', 'i', 'o', 'u']
    # Check to see if it exists
    filename = "#{RAILS_ROOT}/tmp/memo.txt"
    
    if File.exists?(filename)
      file = File.new(filename, "r")
      memo = file.read.chomp
      file.close
    else
      memo = 'a'
    end

    YachtBot.crawl([memo])

    file = File.new(filename, "w")
    if memo == 'u' or ! vowels.include?(memo)
      file.puts('a')
    else
      file.puts(vowels[vowels.index(memo) + 1])
    end
    file.close
  end

  task(:find => :environment) do
    puts YachtBot.find(ENV['USCG_ID']).inspect
  end
end
