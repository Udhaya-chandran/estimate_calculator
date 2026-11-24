import '../../features/estimates/domain/entities/estimate.dart';
import '../../features/estimates/domain/entities/estimate_item.dart';
import 'products.dart';

final List<Estimate> mockRecentEstimates = [
  Estimate(
    id: 'EST-2026-1048',
    createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
    customerName: 'Kavita Builders & Infra',
    customerPhone: '+91 98765 43210',
    items: [
      EstimateItem(
        id: 'item_rec_1',
        product: mockProducts[0], // TMT Rod
        quantity: 30,
        length: 20,
        rateSnapshot: 55.0,
        calculatedQuantity: 600,
        standardUnit: 'ft',
        totalAmount: 33000.0,
        breakdown: '30 pcs × 20.0 ft (600 ft) × ₹55.00/ft',
      ),
      EstimateItem(
        id: 'item_rec_2',
        product: mockProducts[11], // PPC Cement
        quantity: 50,
        rateSnapshot: 380.0,
        calculatedQuantity: 50,
        standardUnit: 'bags',
        totalAmount: 19000.0,
        breakdown: '50 bags × ₹380.00',
      ),
    ],
    subtotal: 52000.0,
    discount: 0.0,
    finalAmount: 52000.0,
  ),
  Estimate(
    id: 'EST-2026-1047',
    createdAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 40)),
    customerName: 'Sharma Villa Construction',
    customerPhone: '+91 98450 11223',
    items: [
      EstimateItem(
        id: 'item_rec_3',
        product: mockProducts[9], // Floor Tiles
        quantity: 25,
        length: 10,
        width: 12,
        rateSnapshot: 50.0,
        calculatedQuantity: 3000,
        standardUnit: 'sq.ft',
        totalAmount: 150000.0,
        breakdown: '25 rooms/cuts × (10.0 ft × 12.0 ft) = 3000.00 sq.ft × ₹50.00/sq.ft',
      ),
      EstimateItem(
        id: 'item_rec_4',
        product: mockProducts[4], // PVC Pipe
        quantity: 15,
        length: 10,
        rateSnapshot: 25.0,
        calculatedQuantity: 150,
        standardUnit: 'ft',
        totalAmount: 3750.0,
        breakdown: '15 pcs × 10.0 ft (150 ft) × ₹25.00/ft',
      ),
    ],
    subtotal: 153750.0,
    discount: 0.0,
    finalAmount: 153750.0,
  ),
  Estimate(
    id: 'EST-2026-1046',
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    customerName: 'Modern Shed Industrial',
    customerPhone: '+91 97112 88990',
    items: [
      EstimateItem(
        id: 'item_rec_5',
        product: mockProducts[7], // Colour Coated Roofing Sheet
        quantity: 12,
        length: 16,
        width: 3.5,
        rateSnapshot: 85.0,
        calculatedQuantity: 672,
        standardUnit: 'sq.ft',
        totalAmount: 57120.0,
        breakdown: '12 pcs × (16.0 ft × 3.5 ft) = 672.00 sq.ft × ₹85.00/sq.ft',
      ),
    ],
    subtotal: 57120.0,
    discount: 0.0,
    finalAmount: 57120.0,
  ),
];
