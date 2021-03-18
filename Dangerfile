# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 800

# MR is a work in progress and shouldn't be merged yet
warn "MR is classed as Work in Progress" if gitlab.mr_title.include? "[WIP]"

# If these are all empty something has gone wrong, better to raise it in a comment
if git.modified_files.empty? && git.added_files.empty? && git.deleted_files.empty?
  fail "This MR has no changes at all, this is likely an issue during development."
end

# Info.plist file shouldn't change often. Leave warning if it changes.
plist_updated = !git.modified_files.grep(/Info.plist/).empty?
if plist_updated
  warn "Plist changed, don't forget to localize your plist values"
end

# Leave warning, if Podfile changes
podfile_updated = !git.modified_files.grep(/Podfile/).empty?
if podfile_updated
  warn "The `Podfile` was updated"
end

# Turn on Flutter linter
flutter_lint.only_modified_files = true
flutter_lint.report_path = "flutter_analyze_report.txt"
flutter_lint.lint