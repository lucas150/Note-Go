// import 'package:another_telephony/telephony.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';
// import 'transaction_model.dart';
// import 'transaction_notifier.dart';
// import 'package:hive/hive.dart';

// final telephony = Telephony.instance;

// /// Foreground & background SMS listener setup
// Future<void> setupSmsListeners(WidgetRef ref) async {
//   bool? permissionGranted = await telephony.requestPhoneAndSmsPermissions;

//   if (!(permissionGranted ?? false)) {
//     print("SMS permission not granted.");
//     return;
//   }

//   telephony.listenIncomingSms(
//     onNewMessage: (SmsMessage message) {
//       processIncomingMessage(ref, message);
//     },
//     onBackgroundMessage: backgroundMessageHandler,
//   );
// }

// /// Foreground processing
// void processIncomingMessage(WidgetRef ref, SmsMessage message) {
//   final body = message.body?.toLowerCase() ?? '';

//   if (body.contains('credited')) {
//     _addTransaction(ref, message, TransactionType.income);
//   } else if (body.contains('debited') || body.contains('sent')) {
//     _addTransaction(ref, message, TransactionType.expense);
//   }
// }

// /// Initial inbox scan (when app starts or comes foreground)
// Future<void> scanSmsAndAddTransactions(WidgetRef ref) async {
//   final messages = await telephony.getInboxSms();

//   for (var message in messages) {
//     processIncomingMessage(ref, message);
//   }
// }

// final uuid = Uuid();

// /// Adds transaction via Riverpod
// void _addTransaction(WidgetRef ref, SmsMessage message, TransactionType type) {
//   final amount = _extractAmount(message.body ?? '');
//   if (amount == null) return;

//   final transactionsState = ref.read(transactionsProvider);

//   final transactions = transactionsState.maybeWhen(
//     data: (txList) => txList,
//     orElse: () => [],
//   );

//   final isDuplicate = transactions.any((tx) =>
//       tx.note == message.body &&
//       tx.date.millisecondsSinceEpoch ==
//           (message.date ?? DateTime.now().millisecondsSinceEpoch));

//   if (isDuplicate) return;

//   final tx = TransactionModel(
//     id: uuid.v4(), // Ensure unique ID
//     title: 'Auto SMS Transaction',
//     amount: amount,
//     type: type,
//     category: 'Auto-detected',
//     account: 'Unknown',
//     date: DateTime.fromMillisecondsSinceEpoch(
//       message.date ?? DateTime.now().millisecondsSinceEpoch,
//     ),
//     note: message.body,
//   );

//   ref.read(transactionsProvider.notifier).addTransaction(tx);
// }

// /// Extract amount using Regex
// double? _extractAmount(String body) {
//   final regex = RegExp(r'(?:rs\.?|inr)\s?(\d+(?:,\d{3})*(?:\.\d{1,2})?)',
//       caseSensitive: false);
//   final match = regex.firstMatch(body);
//   if (match != null) {
//     final amountStr = match.group(1)?.replaceAll(',', '');
//     return double.tryParse(amountStr ?? '');
//   }
//   return null;
// }

// /// Background handler (runs even if app is killed)
// @pragma('vm:entry-point')
// void backgroundMessageHandler(SmsMessage message) async {
//   final body = message.body?.toLowerCase() ?? '';

//   // Open Hive box directly since you can't access Riverpod
//   final box = await Hive.openBox<TransactionModel>('transactions');

//   final amount = _extractAmount(message.body ?? '');
//   if (amount == null) return;

//   TransactionType? type;
//   if (body.contains('credited')) {
//     type = TransactionType.income;
//   } else if (body.contains('debited') || body.contains('sent')) {
//     type = TransactionType.expense;
//   }

//   if (type != null) {
//     final tx = TransactionModel(
//       title: 'Auto SMS Transaction',
//       amount: amount,
//       type: type,
//       category: 'Auto-detected',
//       account: 'Unknown',
//       date: DateTime.fromMillisecondsSinceEpoch(
//         message.date ?? DateTime.now().millisecondsSinceEpoch,
//       ),
//       note: message.body,
//       id: '',
//     );

//     await box.add(tx);
//   }
// }

import 'package:another_telephony/telephony.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transaction_model.dart';
import 'transaction_notifier.dart';

final telephony = Telephony.instance;
@pragma('vm:entry-point')
void backgroundMessageHandler(SmsMessage message) {
  print("Background SMS received: ${message.body}");
}

Future<void> scanSmsAndAddTransactions(WidgetRef ref) async {
  bool? permissionGranted = await telephony.requestPhoneAndSmsPermissions;

  if (!(permissionGranted ?? false)) {
    print("SMS permission not granted.");
    return;
  }

  try {
    final messages = await telephony.getInboxSms();
    final lastScannedDate = await getLastScannedDate();

    for (var message in messages) {
      final body = message.body?.toLowerCase() ?? '';
      final messageDate = DateTime.fromMillisecondsSinceEpoch(
        message.date ?? DateTime.now().millisecondsSinceEpoch,
      );

      // Only process messages after last scanned date
      if (messageDate.isAfter(lastScannedDate)) {
        processIncomingMessage(ref, message);
      }
    }

    await updateLastScannedDate(DateTime.now());
  } catch (e) {
    print("SMS Scan Error: $e");
  }
}

void processIncomingMessage(WidgetRef ref, SmsMessage message) {
  final body = message.body?.toLowerCase() ?? '';

  if (body.contains('credited')) {
    _addTransaction(ref, message, TransactionType.income);
  } else if (body.contains('debited') || body.contains('sent')) {
    _addTransaction(ref, message, TransactionType.expense);
  }
}

void _addTransaction(WidgetRef ref, SmsMessage message, TransactionType type) {
  final amount = _extractAmount(message.body ?? '');
  if (amount == null) return;

  final tx = TransactionModel(
    title: 'Auto SMS Transaction',
    amount: amount,
    type: type,
    category: 'Auto-detected',
    account: 'Unknown',
    date: DateTime.fromMillisecondsSinceEpoch(
      message.date ?? DateTime.now().millisecondsSinceEpoch,
    ),
    note: message.body,
    id: '',
  );

  ref.read(transactionsProvider.notifier).addTransaction(tx);
}

double? _extractAmount(String body) {
  final regex = RegExp(r'(?:rs\.?|inr)\s?(\d+(?:,\d{3})*(?:\.\d{1,2})?)',
      caseSensitive: false);
  final match = regex.firstMatch(body);
  if (match != null) {
    final amountStr = match.group(1)?.replaceAll(',', '');
    return double.tryParse(amountStr ?? '');
  }
  return null;
}

Future<DateTime> getLastScannedDate() async {
  final prefs = await SharedPreferences.getInstance();
  final millis = prefs.getInt('lastScannedDate') ?? 0;
  return DateTime.fromMillisecondsSinceEpoch(millis);
}

Future<void> updateLastScannedDate(DateTime date) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('lastScannedDate', date.millisecondsSinceEpoch);
}
