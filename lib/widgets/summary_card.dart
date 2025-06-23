import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mind/models/data_models.dart';
import 'package:money_mind/widgets/transaction_item_card.dart';

class SummaryCard extends StatefulWidget {
  final Category category;
  final List<Transaction> transactions;

  const SummaryCard({
    super.key,
    required this.category,
    required this.transactions,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    print('transactions-summary-card: ${widget.transactions.length}');
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.category.type == CategoryType.income;
    final color = isIncome ? Colors.green : Colors.red;
    final totalAmount = widget.transactions
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    return Column(
      children: [
        // Category Header Card
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Category Icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconForCategory(widget.category.icon),
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Category Name
                      Expanded(
                        child: Text(
                          widget.category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Total Amount
                      Text(
                        '${isIncome ? '+' : '-'}\$${totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      // Expand Icon
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey,
                      ),
                    ],
                  ),

                  // Additional Info when expanded
                  if (_expanded) ...[
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.transactions.length} ${widget.transactions.length == 1 ? 'transaction' : 'transactions'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _getDateRange(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Transaction List (only shown when expanded)
        if (_expanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.transactions.length,
            itemBuilder: (context, index) {
              print('Rendering transaction: ${widget.transactions[index].id}');
              return TransactionItemCard(
                transaction: widget.transactions[index],
                isLast: index == widget.transactions.length - 1,
              );
            },
          ),
      ],
    );
  }

  String _getDateRange() {
    if (widget.transactions.isEmpty) return '';
    final dates = widget.transactions.map((t) => t.dateRecord).toList();
    dates.sort();
    final start = DateFormat('MMM d').format(dates.first);
    final end = DateFormat('MMM d').format(dates.last);
    return '$start - $end';
  }

  IconData _getIconForCategory(String iconName) {
    switch (iconName.trim().toLowerCase()) {
      case 'house':
        return Icons.house;
      case 'travel':
        return Icons.luggage;
      case 'education':
        return Icons.school;
      case 'beauty & health':
        return Icons.health_and_safety;
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'salary':
        return Icons.work;
      case 'shopping':
        return Icons.shopping_bag;
      case 'award':
        return Icons.emoji_events;
      case 'grant':
        return Icons.monetization_on;
      case 'refund':
        return Icons.money_off;
      case 'family':
        return Icons.family_restroom;
      case 'gift':
        return Icons.card_giftcard;
      default:
        return Icons.category;
    }
  }
}
