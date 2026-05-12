import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../config/theme_config.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (order.status) {
      case 'pending':
        return ThemeConfig.warningColor;
      case 'confirmed':
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return ThemeConfig.successColor;
      case 'cancelled':
        return ThemeConfig.errorColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.orderNumber,
                    style: ThemeConfig.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.statusText,
                      style: ThemeConfig.bodySmall.copyWith(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (order.customerName != null)
                Text(
                  order.customerName!,
                  style: ThemeConfig.bodySmall,
                ),
              const SizedBox(height: 4),
              Text(
                DateFormatter.format(order.createdAt),
                style: ThemeConfig.bodySmall,
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: ThemeConfig.bodyMedium,
                  ),
                  Text(
                    CurrencyFormatter.format(order.totalAmount + order.shippingCost),
                    style: ThemeConfig.bodyMedium.copyWith(
                      color: ThemeConfig.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
