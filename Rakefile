require 'erb'

IGNORED = ["Rakefile", "README", "~$"]

desc "Create symlinks for the dotfiles, keeping backups of the old files."
task :update do
  puts "Getting the latest updates."
  `git pull && git submodule init && git submodule update`
end

task :install do
  def backup(file)
    return unless File.exists?(file)
    backup_count = Dir["#{file}.backup*"].length
    File.rename(file, "#{file}.backup#{backup_count}") && puts("Moving '#{file}' to '#{file}.backup#{backup_count}'")
  end

  Dir["*"].reject { |f| IGNORED.any? { |m| f.match(m) } }.each do |file|
    repoFile = File.join(Dir.pwd, file)

    if file.match('\.erb$')
      dotfile = file.gsub(/\.erb$/, '')
      homeFile = File.expand_path("~/.#{dotfile}")
      generatedFile = ERB.new(File.read(repoFile)).result
      if !File.exists?(homeFile) or generatedFile != File.read(homeFile)
        backup(homeFile)
        puts "Writing generated #{file} to ~/.#{dotfile}"
        File.open(homeFile, 'w') { |f| f.write(generatedFile) }
      else
        puts "~/.#{dotfile} is identical to generated #{file}"
      end
    else
      homeFile = File.expand_path("~/.#{file}")
      if File.symlink?(homeFile) and File.readlink(homeFile) == repoFile
        puts "symlink for .#{file} already exists"
      else
        backup(homeFile)

        puts "Creating the symlink: ~/.#{file} -> #{repoFile}"
        File.symlink(repoFile, homeFile)
      end
    end
  end
end
