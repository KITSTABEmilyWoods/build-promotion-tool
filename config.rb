require 'yaml'
CONFIG = YAML.load_file("config.yml")

module Config
  def self.tag_types
    CONFIG.fetch('tags')
  end
end
