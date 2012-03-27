require 'csv'
require 'normalizer'

class Dataset
  attr_accessor :file_path
  attr_writer :data

  def initialize file_path
    self.file_path = file_path
  end

  def data
    @data ||= file_data[1..-1].map! { |row| row.map { |x| x.to_f } }
  end

  def normalized_data
    return @normalized_data if @normalized_data

    min, max = Normalizer.find_min_and_max self.data
    normalizer = Normalizer.new(min: min, max: max)
    @normalized_data = self.data.map { |n| normalizer.normalize(n) }
  end

  def size
    self.data.size
  end

  def fields
    @fields ||= file_data[0]
  end

  private

  def file_data
    @loaded_data ||= CSV.read file_path
  end
end