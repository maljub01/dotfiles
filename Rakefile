IGNORED = ["Rakefile", "README", "~$"]

desc "Create symlinks for the dotfiles, keeping backups of the old files."
task :install do
  start_time = Time.now

  puts "Getting the latest updates."
  `git pull && git submodule init && git submodule update`
  puts "Rakefile changed by update. Restarting..." && `rake install` && exit if File.mtime("Rakefile") > start_time

  Dir["*"].reject { |f| IGNORED.any? { |m| f.match(m) } }.each do |file|
    target = File.join(Dir.pwd, file)
    link   = File.expand_path("~/.#{file}")

    File.delete(link) if File.symlink?(link)
    backup_count = Dir["#{link}.backup*"].length
    File.rename(link, "#{link}.backup#{backup_count}") && puts("Moving '#{link}' to '#{link}.backup#{backup_count}'") if File.exist?(link)

    puts "Creating the symlink: #{link} -> #{target}"
    File.symlink(target, link)
  end
end
