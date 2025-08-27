class WasteData {
  int recycledItems;
  int compostedItems;
  int plasticsAvoided;

  WasteData({
    this.recycledItems = 0,
    this.compostedItems = 0,
    this.plasticsAvoided = 0,
  });

  void reset() {
    recycledItems = 0;
    compostedItems = 0;
    plasticsAvoided = 0;
  }
}
