class Provider < ActiveRecord::Base
  # TODO: replace with scope
  def self.all_providers(brand)
    output = self.all.where(brand_id: brand)
    output.map { |provider| provider.name }.to_s[1..-2].tr('"', "'")
  end
end
