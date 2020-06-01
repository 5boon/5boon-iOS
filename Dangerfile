# Warn when there is a big PR
warn("Big PR, try to keep changes smaller if you can :cry:") if git.lines_of_code > 1000

# Notify important file changes
important_files = %w(Podfile.lock Gemfile.lock Cartfile.resolved project.yml)

git.modified_files.map do |file|
  if important_files.include?(file)
    message "#{file} has changed. If you agree, ignore this comment."
  end
end

# Swiftlint
github.dismiss_out_of_range_messages
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode: true
