lib = File.expand_path(__dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "digital_signage/version"
require "digital_signage/board"
require "digital_signage/iiif_board"

module DigitalSignage
  def self.call
    boards.each do |board|
      begin
        board.call
      rescue => e
        puts e
      end
    end
  end

  def self.boards
    ObjectSpace.each_object(Class).select { |klass| klass < DigitalSignage::Board }
  end
end
