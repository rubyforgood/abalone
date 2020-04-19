require "rake"

shared_context "rake" do
  let(:rake)      { Rake::Application.new }
  # use the text we pass to `describe` to calculate the task we're going to run
  let(:task_name) { self.class.top_level_description }
  # `task_path` is the path to the file itself, relative to `Rails.root`
  let(:task_path) { "lib/tasks/#{task_name.split(':').first}" }
  subject         { rake[task_name] }

  # exclude the path to the task we're testing so we have the task available.
  # this only matters when you're running more than one test on a rake task
  def loaded_files_excluding_current_rake_file
    $LOADED_FEATURES.reject { |file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

    # load Rails stack from inside the lib folder
    Rake::Task.define_task(:environment)
  end
end
