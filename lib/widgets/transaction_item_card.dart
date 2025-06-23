import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mind/models/data_models.dart';

class TransactionItemCard extends StatelessWidget {
  final Transaction transaction;
  final bool isLast;

  const TransactionItemCard({
    super.key,
    required this.transaction,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.budgetType == 'income';
    final color = isIncome ? Colors.green : Colors.red;

    return Container(
      margin: EdgeInsets.only(
        left: 32,
        right: 16,
        bottom: isLast ? 16 : 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: color.withOpacity(0.5),
            width: 2,
          ),
        ),
      ),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(left: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Date Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d').format(transaction.dateRecord),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(transaction.dateRecord),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.note.isNotEmpty
                          ? transaction.note
                          : 'No description',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a').format(transaction.dateRecord),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount
              Text(
                '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
