// import 'package:sms_advanced/sms_advanced.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../model/transaction_model.dart';
// import '../model/transaction_notifier.dart';
// import 'package:uuid/uuid.dart';

// final smsScanProvider = Provider(SmsScanService.new);

// class SmsScanService {
//   final Ref ref;
//   SmsScanService(this.ref);

//   Future<void> scanMessages() async {
//     SmsQuery query = SmsQuery();
//     List<SmsMessage> messages = await query.getAllSms;

//     for (var message in messages) {
//       if (message.body == null) continue;

//       final body = message.body!.toLowerCase();

//       // Basic Income/Expense detection example
//       if (body.contains('credited') || body.contains('received')) {
//         await _addTransaction(message, TransactionType.income);
//       } else if (body.contains('debited') || body.contains('spent')) {
//         await _addTransaction(message, TransactionType.expense);
//       }
//     }
//   }

//   Future<void> _addTransaction(SmsMessage message, TransactionType type) async {
//     final tx = TransactionModel(
//       id: const Uuid().v4(),
//       title: 'Auto SMS ${type == TransactionType.income ? 'Income' : 'Expense'}',
//       amount: _extractAmount(message.body ?? ''),
//       date: message.date ?? DateTime.now(),
//       type: type,
//       account: 'SMS',
//       category: 'Auto',
//       note: 'Added from SMS',
//     );

//     if (tx.amount != null && tx.amount! > 0) {
//       await ref.read(transactionsProvider.notifier).addTransaction(tx);
//     }
//   }

//   double? _extractAmount(String body) {
//     final regex = RegExp(r'([₹$]?[\d,]+(\.\d{1,2})?)');
//     final match = regex.firstMatch(body);
//     if (match != null) {
//       final amountStr = match.group(1)!.replaceAll(RegExp(r'[₹$,]'), '');
//       return double.tryParse(amountStr);
//     }
//     return null;
//   }
// }
