class PlateauBoundaryWarning
  def self.for_position(position)
    "Rover cannot move to position #{position.to_s} - outside plateau bounds"
  end
end