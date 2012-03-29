require "bundler/setup"
require 'benchmark'

require 'tk'
#require 'tkextlib/tktable'
require 'tkextlib/tile'

Dir["./lib/**/*.rb"].each { |file| require file }

require 'csv'

Dir.glob('./lib/**/*.rb').each { |lib| require lib }

folders = ['output', 'dump']
folders.each { |folder| Dir.mkdir folder unless Dir.exist? folder }

class Application
  include Tk::Tile

  attr_accessor :root, :settings, :content, :attributes_frame, :dataset_frame, :control_frame,
                :rows, :cols, :type, :neighborhood_radius, :learning_rate, :epochs,
                :items_label, :properties_label, :fields_label,
                :start_button, :stop_button, :prev_button, :next_button,
                :learning_progressbar, :pictures_progressbar,
                :dataset,
                :polygons
  attr_writer :som, :drawer, :canvas #, :polygons

  def initialize
    self.root = TkRoot.new { title "RubySOM" }

    self.settings = Frame.new(root) { borderwidth 2; relief "groove"; height 500; width 250 }
    self.settings.grid :column => 0, :row => 0
    init_settings

    self.content = Frame.new(root) { borderwidth 2; relief "groove"; height 800; width 800 }
    self.content.grid :column => 1, :row => 0
    init_content

    default!
  end

  def som
    @som ||= SOM.new({grid: {}})
  end

  def drawer
    @drawer ||= Drawer.new
  end

  def init_settings
    self.attributes_frame = Frame.new(settings) { borderwidth 2; relief "groove"; height 200; width 250 }
    self.attributes_frame.grid :row => 0
    init_attributes_frame

    self.dataset_frame = Frame.new(settings) { borderwidth 2; relief "groove"; height 100; width 250 }
    self.dataset_frame.grid :row => 1
    init_dataset_frame

    self.control_frame = Frame.new(settings) { borderwidth 2; relief "groove"; height 200; width 250 }
    self.control_frame.grid :row => 2
    init_control_frame
  end

  def init_content
    #   ...
  end

  def canvas
    @canvas ||= TkCanvas.new(content) { borderwidth 2; relief "groove"; height 800; width 800 }.pack
  end

  def image_label
    return @image_label if @image_label

    @image_label = Label.new canvas
    @image_label.place(x: 0, y: 0)
  end

  def pictures
    @pictures ||= {}
  end

  def clean_canvas
    self.image_label.destroy
    self.canvas.destroy
    self.pictures.each { |_, picture| picture.destroy }

    @canvas = nil
    @image_label = nil
    @pictures = nil
  end

  def init_attributes_frame
    rows_label = Label.new(attributes_frame) { text "rows:"; padding '5' }
    rows_label.grid :column => 0, :row => 0, :sticky => 'nw'

    self.rows = Combobox.new(attributes_frame) { values (1..30).to_a; width 10 }
    self.rows.grid :column => 1, :row => 0

    cols_label = Label.new(attributes_frame) { text "cols:"; padding '5' }
    cols_label.grid :column => 0, :row => 1, :sticky => 'nw'

    self.cols = Combobox.new(attributes_frame) { values (1..30).to_a; width 10 }
    self.cols.grid :column => 1, :row => 1

    type_label = Label.new(attributes_frame) { text "type:"; padding '5' }
    type_label.grid :column => 0, :row => 2, :sticky => 'new'

    self.type = Combobox.new(attributes_frame) { values ['square', 'hexagonal']; width 10 }
    self.type.grid :column => 1, :row => 2

    radius_label = Label.new(attributes_frame) { text "radius:"; padding '5' }
    radius_label.grid :column => 0, :row => 3, :sticky => 'new'

    self.neighborhood_radius = Combobox.new(attributes_frame) { values (1..30).to_a; width 10 }
    self.neighborhood_radius.grid :column => 1, :row => 3

    rate_label = Label.new(attributes_frame) { text "rate:"; padding '5' }
    rate_label.grid :column => 0, :row => 4, :sticky => 'new'

    self.learning_rate = Combobox.new(attributes_frame) { values (1..50).map { |x| x.to_f/10 }; width 10 }
    self.learning_rate.grid :column => 1, :row => 4

    epochs_label = Label.new(attributes_frame) { text "epochs:"; padding '5' }
    epochs_label.grid :column => 0, :row => 5, :sticky => 'new'

    self.epochs = Combobox.new(attributes_frame) { values (50..1000).to_a; width 10 }
    self.epochs.grid :column => 1, :row => 5
  end

  def init_dataset_frame
    title_label = Label.new(dataset_frame) { text "DATASET"; padding '5' }
    title_label.grid :column => 0, :row => 0, :columnspan => 2, :sticky => 'new'

    items_label = Label.new(dataset_frame) { text "items:"; padding '5' }
    items_label.grid :column => 0, :row => 1, :sticky => 'new'

    self.items_label = Label.new(dataset_frame) { padding '5' }
    self.items_label.grid :column => 1, :row => 1, :sticky => 'new'

    properties_label = Label.new(dataset_frame) { text "properties:"; padding '5' }
    properties_label.grid :column => 0, :row => 2, :sticky => 'new'

    self.properties_label = Label.new(dataset_frame) { padding '5' }
    self.properties_label.grid :column => 1, :row => 2, :sticky => 'new'

    fields_label = Label.new(dataset_frame) { text "fields:"; padding '5' }
    fields_label.grid :column => 0, :row => 3, :sticky => 'new'

    self.fields_label = Label.new(dataset_frame) { padding '5' }
    self.fields_label.grid :column => 1, :row => 3, :sticky => 'new'

    open_dataset_command = -> { open_dataset }
    button = Button.new(dataset_frame) { text "Open"; command open_dataset_command }
    button.grid :column => 0, :row => 4, :columnspan => 2, :sticky => 'new'
  end

  def init_control_frame
    learning_label = Label.new(control_frame) { text "learning"; padding '5' }
    learning_label.grid :column => 0, :row => 0, :sticky => 'new'

    self.learning_progressbar = Progressbar.new(control_frame) { orient 'horizontal'; length 200; mode 'determinate' }
    self.learning_progressbar.grid :column => 1, :row => 0

    pictures_label = Label.new(control_frame) { text "pictures"; padding '5' }
    pictures_label.grid :column => 0, :row => 1, :sticky => 'new'

    self.pictures_progressbar = Progressbar.new(control_frame) { orient 'horizontal'; length 200; mode 'determinate' }
    self.pictures_progressbar.grid :column => 1, :row => 1

    self.start_button = Button.new(control_frame) { text "Run Train" }
    self.start_button.grid :column => 0, :row => 2
    start_button.command = -> { train(:start) }

    self.stop_button = Button.new(control_frame) { text "Stop Train"; state 'disabled' }
    self.stop_button.grid :column => 1, :row => 2
    stop_button.command = -> { train(:stop) }

    scale = Tk::Tile::Scale.new(control_frame) { orient 'horizontal'; length 200; from 0; to 999 }
    scale.grid :column => 0, :row => 3, :columnspan => 2

    scale.command = proc {
      epoch = som.epochs*(scale.value/999)
      show_picture epoch.to_i
    }
  end

  private

  def train flag
    Thread.abort_on_exception = true

    if flag == :start
      self.start_button.state('disabled')
      self.stop_button.state('!disabled')
      @train_thread = Thread.new {
        begin
          clean_canvas

          update_som_attributes
          som.run_train

          generate_pictures

          show_picture 0

          self.stop_button.state('disabled')
          self.start_button.state('!disabled')

          self.pictures_progressbar.value = 0
          self.learning_progressbar.value = 0
        rescue => ex
          puts ex.message
          puts ex.backtrace
        end
      }
    else
      self.stop_button.state('disabled')
      self.start_button.state('!disabled')
      self.som.progressbar.value = 0
      self.pictures_progressbar.value = 0
      @som = nil
      @train_thread.kill
    end
  end

  def show_picture epoch
    image_label.image = get_picture epoch
  end

  def get_picture epoch
    epoch = 0 if epoch < 0
    epoch = (som.epochs-1) if epoch >= som.epochs

    file_path = "output/#{som.file_name}/iteration_#{epoch.to_i}.gif"

    if pictures[file_path].nil?
      pictures[file_path] = TkPhotoImage.new
      original = TkPhotoImage.new(file: file_path)

      x_scale = original.width/canvas.width.to_f
      y_scale = original.height/canvas.height.to_f

      scale = [x_scale, y_scale].max.ceil

      if scale > 1
        pictures[file_path].copy(original, subsample: [scale, scale])
      else
        pictures[file_path] = original
      end

    end

    self.pictures[file_path]
  end

  def init_canvas
    self.som.canvas = self.canvas
    som.grid.ceil_size = 15

    create_polygons
  end

  def create_polygons
    som.size.times do |index|
      col, row = som.grid.convert_to_coordinate index
      polygon = som.grid.polygon_points(col, row)
      self.polygons << TkcPolygon.new(canvas, *polygon, state: 'hidden')
    end
  end

  def fill_polygons epoch = nil
    epoch ||= som.epochs

    som.history[epoch]

    som.neurons.each_with_index { |n, i| n.weights = weights[i] }

    colors = Drawer.new(som: som, type: :canvas).colors

    colors.each_with_index do |color, index|
      polygons[index].addtag color
    end

    colors.uniq.each do |color|
      canvas.itemconfigure(color, fill: color, state: 'normal', tags: nil)
    end
  end

  #def create_polygons
  #  drawer = Drawer.new(som: som)
  #  polygons = drawer.polygons
  #
  #  polygons.each do |polygon|
  #    id = polygon.pop
  #    TkcPolygon.new(canvas, *polygon, :tags => "polygon_#{id}")
  #    #TkcPolygon.new(canvas, *polygon, :tags => "polygon_#{id}", :fill => 'white')
  #  end
  #
  #  colors = drawer.colors
  #
  #  puts Benchmark.realtime {
  #    colors.each do |color, ids|
  #      ids.each do |id|
  #        canvas.itemconfigure "polygon_#{id}", :fill => color
  #      end
  #      #
  #      #keys = ids.map{|id| "polygon_#{id}" }
  #      #
  #      #canvas.itemconfigure keys.join(" "), :fill => color
  #      #p [color, ids]
  #    end
  #  }
  #  #colors.each do
  #
  #end

  def generate_pictures


    #drawer.type = :rasem
    #drawer.type = :chunky
    drawer.type = :rmagick

    som.grid.ceil_size = 15

    p "Start generate images...please wait"
    puts Benchmark.realtime {
      som.history.each_with_index do |weights, iteration|
        self.pictures_progressbar.value = (iteration / som.epochs.to_f) * 100
        step = 1
        if iteration == som.epochs-1 or iteration%step == 0
          som.neurons.each_with_index { |n, i| n.weights = weights[i] }
          som.current_iteration = iteration
          Drawer.new(som: som, type: :rmagick).draw
          #drawer.som = som
          #drawer.draw
        end
      end
    }
  end

  def update_som_attributes
    som.grid.rows = rows.value.to_i
    som.grid.cols = cols.value.to_i
    som.grid.type = type.value
    som.learning_rate = learning_rate.value.to_f
    som.neighborhood_radius = neighborhood_radius.value.to_i
    som.epochs = epochs.value.to_i
    som.dataset = dataset
    som.progressbar = learning_progressbar
  end

  def default!
    rows.value = 30
    cols.value = 30
    type.value = "hexagonal"
    learning_rate.value = 0.8
    neighborhood_radius.value = 10
    epochs.value = 100
  end

  def reset
    init_form
    init_buttons
  end

  def open_dataset
    dataset_file = Tk.getOpenFile

    if File.exist? dataset_file
      self.dataset = dataset_file
      som.dataset = dataset
      items_label.text = som.dataset.size
      properties_label.text = som.dataset.fields.size
      fields_label.text = som.dataset.fields.join(',')
    end
  end
end

Application.new
Tk.mainloop
