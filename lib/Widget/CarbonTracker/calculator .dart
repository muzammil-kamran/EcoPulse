class Calculator {
  static double calculateFootprint({
    required double transport,
    required double electricity,
    required double food,
  }) {
    double transportCO2 = transport * 2.3;     // liters of fuel → CO₂
    double electricityCO2 = electricity * 0.82; // kWh → CO₂
    double foodCO2 = food * 1.5;               // meals → CO₂
    return transportCO2 + electricityCO2 + foodCO2;
  }
}
