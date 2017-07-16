module UsdaNutrientDatabase
  class Importer
    attr_reader :directory, :version

    def initialize(directory = 'tmp/usda', version = UsdaNutrientDatabase.usda_version)
      @directory = directory
      @version = version
    end

    def import(download: true)
      downloader.download_and_unzip if download
      importer_names.each { |importer_name| importer_for(importer_name).import }
    ensure
      downloader.cleanup
    end

    private

    def importer_names
      # FoodGroups, SourceCodes, Nutrients, Foods, FoodsNutrients, Weights, Footnotes
      [
        'FoodGroups',
        'Nutrients',
        'Foods',
        'FoodsNutrients',
        'Weights'
      ]
    end

    def importer_for(importer_name)
      "UsdaNutrientDatabase::Import::#{importer_name}".constantize.
        new("#{directory}/#{version}")
    end

    def downloader
      UsdaNutrientDatabase::Import::Downloader.new(directory, version)
    end
  end
end
