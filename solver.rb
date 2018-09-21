class Grid

  def initialize(grid)
    @grid = grid
    @possibilities = {}
    self.sections
  end

  attr_accessor :grid

  def boxes
    @boxes = []
    @grid.each_slice(3) do |rows_slice|
      rows_slice.transpose.each_slice(3) do |box|
        @boxes << box
      end
    end
    @boxes
  end

  def get_box(name)
    char, num = name[0], name[1].to_i
    index = (num-1)/3
    ["ABC", "DEF", "GHI"].each {|string| @box_name = string.downcase[index] if string.include?(char)}
    return @sections["boxes"][@box_name]
  end


  def sections
    @sections = {
      "rows" => {
      },
      "columns" => {
      },
      "boxes" => {
      }
    }
    (0..8).each do |i|
      @sections["rows"]["ABCDEFGHI"[i]] = @grid[i]
      @sections["columns"]["123456789"[i]] = @grid.transpose[i]
      @sections["boxes"]["abcdefghi"[i]] = self.boxes[i].flatten
    end
    @sections
  end

  def remove_possibilities
    while @grid.flatten.include?(0) do
      @grid.each_with_index do |row, row_index|
        row.each_with_index do |item, column_index|
          if item == 0
            item_name = "ABCDEFGHI"[row_index] + "123456789"[column_index]
            item_row = sections["rows"][item_name[0]]
            item_col = sections["columns"][item_name[1]]
            item_box = get_box(item_name)
            @possibilities[item_name] = (1..9).to_a
            (item_row | item_col | item_box).each { |number| @possibilities[item_name].delete(number) if number != 0 }
            if @possibilities[item_name].length == 1
              @grid[row_index][column_index] = @possibilities[item_name][0]
            end
          end
        end
      end
    end
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
grid.remove_possibilities
puts
puts
grid.grid.each {|row| p row}
