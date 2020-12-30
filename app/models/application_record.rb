class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.sample
    find_by('id >= ?', rand(first.id..last.id))
  end
end
