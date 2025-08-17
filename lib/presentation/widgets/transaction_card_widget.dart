import 'package:flutter/material.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/presentation/settings/model/wallet_history_response.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Data? transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: transaction?.debit != 0
            ? Colors.red.shade50
            : Colors.green.shade50, // debit transaction
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction?.debit != 0 ? Icons.call_made : Icons.call_received,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction?.debit != 0
                      ? "${locale.debitedToString}\n${transaction?.transactionsType ?? ''}"
                      : "${locale.creditedToString}\n${transaction?.transactionsType ?? ''}",
                  style: theme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  "Transaction id - ${transaction?.transactionId}",
                  style: theme.bodySmall?.copyWith(color: Colors.grey.shade500, fontSize: 14),
                ),
              ],
            ),
          ),

          // Amount + Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${transaction?.transactionAmount?.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                transaction?.transactionDate != null
                    ? DateFormat("dd MMMM").format(DateTime.parse(transaction?.transactionDate))
                    : '', // e.g., 20 June
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
