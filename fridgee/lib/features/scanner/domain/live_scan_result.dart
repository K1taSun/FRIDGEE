// Wynik skanowania na żywo przekazywany do formularza produktu.

class LiveScanResult {
  const LiveScanResult({
    this.barcode,
    this.expiryDate,
    this.productName,
  });

  final String? barcode;
  final DateTime? expiryDate;
  final String? productName;

  Map<String, dynamic> toMap() => {
        'barcode': barcode,
        'expiryDate': expiryDate,
        'productName': productName,
      };

  factory LiveScanResult.fromMap(Map<String, dynamic> map) => LiveScanResult(
        barcode: map['barcode'] as String?,
        expiryDate: map['expiryDate'] as DateTime?,
        productName: map['productName'] as String?,
      );
}
