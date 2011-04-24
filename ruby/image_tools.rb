require 'rubygems'
require 'RMagick'

def intensity_matrix(args = {})
  
  return nil if args[:file_path] == nil
  
  img = Magick::Image.read(args[:file_path]).first

  pixelmatrix = Array.new

  for row in 0..(img.rows - 1) do
    pixelmatrix[row] = Array.new
    px_array = img.get_pixels(0, row, img.columns, 1)
    count = 0
    for pixel in px_array do
      pixelmatrix[row][count] = pixel.to_hsla[2]
      pixelmatrix[row][count] = (255.0 - pixelmatrix[row][count]).abs if args[:invert] == true
      pixelmatrix[row][count] = (pixelmatrix[row][count] / 255.0) * 100.0 if args[:percentage] == true
      count += 1
    end
  end
  
  pixelmatrix
end

def process_image_directory(args = {})
  
  return nil if args[:directory_path] == nil
  
  bitmap_hash = Hash.new
  Dir["#{args[:directory_path]}/*.bmp"].each do |file|
    path = "#{file}"
    tmp_args = args
    tmp_args[:file_path] = file
    bitmap_hash[File.basename(file)] = intensity_matrix(tmp_args)
  end
  
  bitmap_hash
end