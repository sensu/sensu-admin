YAML::ENGINE.yamler = 'syck'
APP_CONFIG = YAML.load_file(Rails.root.join('config', 'config.yml'))[Rails.env]
