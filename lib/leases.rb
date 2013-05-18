require 'leases/railtie'
require 'leases/version'
require 'leases/model'
require 'leases/controller'

module Leases

  class << self

    cattr_accessor :leasers
    self.leasers = []

    def leasing(object)
      self.leasers << object.name
      self.leasers.uniq!

      Apartment.excluded_models ||= []
      Apartment.excluded_models += [object.name]
      Apartment.excluded_models.uniq!

      Apartment.database_names ||= Proc.new do
        Leases.leaser_names
      end
    end

    def leaser_names
      leasers.map do |l|
        model = l.constantize
        model.all.collect(&:leaser_name)
      end.flatten
    end

  end

end
