import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatefulWidget {
  final Function(DateTimeRange?) onRangeSelected;
  final DateTimeRange? initialRange;

  const DateRangeSelector({
    super.key,
    required this.onRangeSelected,
    this.initialRange,
  });

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  late DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    selectedRange = widget.initialRange;
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: selectedRange ?? DateTimeRange(start: now, end: now),
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });
      widget.onRangeSelected(picked);
    }
  }

  void _applyQuickSelect(String value) {
    final now = DateTime.now();
    late DateTime start, end;

    switch (value) {
      case 'This Week':
        start = now.subtract(Duration(days: now.weekday - 1));
        end = now;
        break;
      case 'This Month':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0);
        break;
      case 'Last 7 Days':
        start = now.subtract(const Duration(days: 6));
        end = now;
        break;
      case 'Custom':
        _pickDateRange();
        return;
      default:
        return;
    }

    final range = DateTimeRange(start: start, end: end);
    setState(() {
      selectedRange = range;
    });
    widget.onRangeSelected(range);
  }

  @override
  Widget build(BuildContext context) {
    String label = 'Select Date Range';
    if (selectedRange != null) {
      label =
          '${DateFormat.yMMMd().format(selectedRange!.start)} - ${DateFormat.yMMMd().format(selectedRange!.end)}';
    }

    return Row(
      children: [
        PopupMenuButton<String>(
          onSelected: _applyQuickSelect,
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'This Week', child: Text('This Week')),
            const PopupMenuItem(value: 'This Month', child: Text('This Month')),
            const PopupMenuItem(
                value: 'Last 7 Days', child: Text('Last 7 Days')),
            const PopupMenuItem(value: 'Custom', child: Text('Custom Range')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (selectedRange != null)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                selectedRange = null;
              });
              widget.onRangeSelected(null);
            },
          ),
      ],
    );
  }
}
