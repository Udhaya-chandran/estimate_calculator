enum MeasurementType {
  quantityOnly('Quantity Based', 'Count / Bags / Boxes'),
  lengthBased('Length Based', 'Pipes / Rods / Profiles'),
  areaBased('Area Based', 'Tiles / Sheets / Plates'),
  weightBased('Weight Based', 'Angles / Channels / Scrap');

  final String label;
  final String description;

  const MeasurementType(this.label, this.description);
}
