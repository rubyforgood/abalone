# ReportsKit.configure do |config|
#   config.properties_method = lambda do |controller|
#     path = Rails.root.join('config', 'reports_kit', 'reports', "#{report_key}.yml")
#     properties = YAML.safe_load(File.read(path))
#     properties['filters'] = [
#       { key: 'organization', criteria: { value: current_user&.organization&.id } }
#     ]
#     properties
#   end
# end
