class Grid

  def initialize(grid)
    @grid = grid
    @possibilities = {}
    self.sections
  end

  attr_accessor :grid

  def boxes
    # returns an array of 3*3 boxes
    @boxes = []
    @grid.each_slice(3) do |rows_slice|
      rows_slice.transpose.each_slice(3) do |box|
        @boxes << box
      end
    end
    @boxes
  end

  def sections
    # generates hash to organise the different rows, columns and boxes of the sudoku
    @sections = { "rows" => {}, "columns" => {}, "boxes" => {} }
    (0..8).each do |i|
      @sections["rows"]["ABCDEFGHI"[i]] = @grid[i]
      @sections["columns"]["123456789"[i]] = @grid.transpose[i]
      @sections["boxes"]["abcdefghi"[i]] = self.boxes[i].flatten
    end
    @sections
  end

  def get_box(name)
    char, num = name[0], name[1].to_i
    index = (num-1)/3 # turns the numerical identifier for an item's row (1-9) into an identifier for which column of boxes it belongs to (1-3)
    ["ABC", "DEF", "GHI"].each {|string| @box_name = string.downcase[index] if string.include?(char)} # gets box name (named as above) from the above
    return @sections["boxes"][@box_name]
  end


  def reduce_possibilities(item_name)
    # creates array of possibilities and eliminates any that are present in the item's row, column or box
    item_sections = sections["rows"][item_name[0]] | sections["columns"][item_name[1]] | get_box(item_name)
    @possibilities[item_name] = (1..9).to_a.select { |number| !(item_sections.include? number) }

    # @possibilities[item_name] = (1..9).to_a
    # (item_row | item_col | item_box).each { |number| @possibilities[item_name].delete(number) if number != 0 }
  end

  def update(item_name, row_index, column_index)
    # updates empty square in grid if there is only one logical possibility
    if @possibilities[item_name].length == 1
      @grid[row_index][column_index] = @possibilities[item_name][0]
    end
  end

  def fill
    @grid.each_with_index do |row, row_index|
      row.each_with_index do |item, column_index|
        if item == 0
          item_name = "ABCDEFGHI"[row_index] + "123456789"[column_index]
          reduce_possibilities(item_name)
          update(item_name, row_index, column_index)
        end
      end
    end
  end

  def solve
    # keeps filling out sudoku by reducing possibilities until all squares are full.
    iterations = 0
    while @grid.flatten.include?(0) do
      # Gives up after 100 iterations, to prevent hanging on unsolveable sudokus
      iterations += 1
      if iterations > 100
        puts "Unable to solve after 100 iterations: returning current grid"
        return @grid
      end
      fill
    end

    return @grid
  end
end

grid = Grid.new([
  [5,3,0,0,7,0,0,0,0],
  [6,0,0,1,9,5,0,0,0],
  [0,9,8,0,0,0,0,6,0],
  [8,0,0,0,6,0,0,0,3],
  [4,0,0,8,0,3,0,0,1],
  [7,0,0,0,2,0,0,0,6],
  [0,6,0,0,0,0,2,8,0],
  [0,0,0,4,1,9,0,0,5],
  [0,0,0,0,8,0,0,7,9]])

grid.grid.each {|row| p row}
puts
grid.solve.each {|row| p row}
