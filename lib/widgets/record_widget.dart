import 'package:flutter/material.dart';
import 'package:money_mind/models/data_models.dart';
import 'package:money_mind/styles/color.dart';
import 'package:money_mind/widgets/text_style.dart';

class RecordWidget extends StatelessWidget {
  final Transaction transaction;

  RecordWidget({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset(transaction.category.icon),
            ),
            const SizedBox(width: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width - 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextContent(content: transaction.category.name).build(),
                  Text(
                    transaction.note,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis, // Hide overflow with ...
                    maxLines: 1,
                  )
                ],
              ),
            ),
            Spacer(),
            Text(
              transaction.amount.toString(),
              style: TextStyle(
                fontSize: 16,
                color: transaction.budgetType == 'income'
                    ? Colors.green
                    : Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
