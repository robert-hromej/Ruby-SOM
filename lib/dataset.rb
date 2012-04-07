require 'csv'

def Dataset(dataset)
  dataset.is_a?(Dataset) ? dataset : Dataset.new(dataset)
end

class Dataset
  attr_accessor :file_path

  def initialize file_path
    self.file_path = file_path
  end

  def data
    @data ||= file_data[1..-1].map! { |row| row.map { |x| x.to_f } }
  end

  def normalized_data
    @normalized_data ||= self.data.normalize(2)
  end

  def size
    data.size
  end

  def fields
    @fields ||= file_data[0]
  end

  private

  def file_data
    @loaded_data ||= CSV.read file_path
  end
end