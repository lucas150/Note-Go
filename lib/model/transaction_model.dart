import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String? id; // Using String for id to allow UUIDs

  @HiveField(1)
  TransactionType type; // Using enum for type income, expense, or savings

  @HiveField(2)
  DateTime? date; // Using DateTime for date

  @HiveField(3)
  String? title; // Title of the transaction

  @HiveField(4)
  double? amount; // Amount of the transaction

  @HiveField(5)
  String? category; // Category of the transaction, can be null

  @HiveField(6)
  String?
      account; // Account associated with the transaction, can be fetch from Account model (HDFC , Wallet, etc.)

  @HiveField(7)
  String? note; // Optional note for the transaction

  TransactionModel({
    required this.id,
    required this.type,
    required this.date,
    required this.title,
    required this.amount,
    this.account,
    this.category,
    this.note,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: TransactionType.values[map['type']],
      date: DateTime.parse(map['date']),
      title: map['title'],
      amount: map['amount'],
      account: map['account'],
      category: map['category'],
      note: map['note'],
    );
  }

  // Method to convert the model to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'date': date?.toIso8601String(),
      'title': title,
      'account': account,
      'amount': amount,
      'category': category,
      'note': note,
    };
  }

  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    DateTime? date,
    String? title,
    double? amount,
    String? category,
    String? account,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      account: account ?? this.account,
      note: note ?? this.note,
    );
  }
}

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  expense,

  @HiveField(1)
  income,

  @HiveField(2)
  savings,
}

@HiveType(typeId: 2)
enum AccountRole {
  @HiveField(0)
  transaction,

  @HiveField(1)
  saving,

  @HiveField(2)
  both,
}

@HiveType(typeId: 3)
class Account extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double balance;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final AccountRole role;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    required this.role,
  });

  Account copyWith({
    String? id,
    String? name,
    double? balance,
    String? type,
    AccountRole? role,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      role: role ?? this.role,
    );
  }
}
