
require 'rubocop/rake_task'
require 'foodcritic'

task default: [:rubocop, :foodcritic]

FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    cookbook_paths: '.',
    search_gems: true
  }
end

RuboCop::RakeTask.new
