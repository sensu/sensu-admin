YAML::ENGINE.yamler = 'syck' if defined?(YAML::ENGINE)
APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]
