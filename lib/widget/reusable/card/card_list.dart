import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenericCardListView<T> extends StatelessWidget {
  final RxList<T> itemList;
  final String Function(T item) primaryLabelBuilder;
  final String Function(T item)? subtitleBuilder;
  final void Function(int index)? onEditPressed;
  final String? headerTitle;
  final void Function(T? item)? onDeleteConfirmed;

  const GenericCardListView({
    super.key,
    required this.itemList,
    required this.primaryLabelBuilder,
    this.subtitleBuilder,
    this.onEditPressed,
    this.headerTitle,
    this.onDeleteConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return headerTitle != null
        ? AppBar(
            title: Text(headerTitle ?? ''),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
          )
        : null;
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: Obx(() => _buildListView(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        try {
          if (index < 0 || index >= itemList.length) {
            developer.log(
              'Invalid index: $index for list with length ${itemList.length}',
              name: 'GenericCardListView',
              error: 'Index out of bounds',
            );
            return const SizedBox.shrink();
          }

          final item = itemList[index];

          if (item == null) {
            developer.log(
              'Null item at index $index',
              name: 'GenericCardListView',
              error: 'Null item detected',
            );
            return const SizedBox.shrink();
          }

          return _buildCardItem(context, item, index);
        } catch (e, stackTrace) {
          developer.log(
            'Error building list item',
            name: 'GenericCardListView',
            error: e,
            stackTrace: stackTrace,
          );
          return _buildErrorItem(e);
        }
      },
    );
  }

  Widget _buildCardItem(BuildContext context, T item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          _safePrimaryLabel(item),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: _buildSubtitle(item),
        trailing: _buildTrailingActions(context, item, index),
      ),
    );
  }

  String _safePrimaryLabel(T item) {
    try {
      return primaryLabelBuilder(item);
    } catch (e) {
      developer.log(
        'Error in primaryLabelBuilder',
        name: 'GenericCardListView',
        error: e,
      );
      return 'Error: Unable to display label';
    }
  }

  Widget? _buildSubtitle(T item) {
    if (subtitleBuilder == null) return null;
    try {
      final subtitle = subtitleBuilder!(item);
      return subtitle.isNotEmpty ? Text(subtitle) : null;
    } catch (e) {
      developer.log(
        'Error in subtitleBuilder',
        name: 'GenericCardListView',
        error: e,
      );
      return const Text('Error: Unable to display subtitle');
    }
  }

  Widget _buildTrailingActions(BuildContext context, T item, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEditPressed != null)
          IconButton(
            icon: const Icon(Icons.edit), // Icon for edit
            onPressed: () => _safeEditAction(index),
          ),
        IconButton(
          icon: const Icon(Icons.delete), // Icon for delete
          onPressed: () => _showDeleteConfirmation(context, item, index),
        ),
      ],
    );
  }

  void _safeEditAction(int index) {
    try {
      onEditPressed?.call(index);
    } catch (e, stackTrace) {
      developer.log(
        'Error in edit action',
        name: 'GenericCardListView',
        error: e,
        stackTrace: stackTrace,
      );
      _showErrorDialog('Error during edit');
    }
  }

  void _showDeleteConfirmation(BuildContext context, T item, int index) async {
    try {
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Confirm Deletion"),
            content: const Text("Are you sure you want to delete this item?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );

      if (confirmDelete == true) {
        _performDeletion(context, item, index);
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error in delete confirmation',
        name: 'GenericCardListView',
        error: e,
        stackTrace: stackTrace,
      );
      _showErrorDialog('Error during deletion');
    }
  }

  void _performDeletion(BuildContext context, T item, int index) {
    try {
      if (index < 0 || index >= itemList.length) {
        throw RangeError('Invalid index for deletion');
      }

      final removedItem = itemList.removeAt(index);
      onDeleteConfirmed?.call(removedItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item successfully deleted'),
          backgroundColor: Colors.green[200],
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e, stackTrace) {
      developer.log(
        'Deletion error',
        name: 'GenericCardListView',
        error: e,
        stackTrace: stackTrace,
      );
      _showErrorDialog('Failed to delete item');
    }
  }

  Widget _buildErrorItem(Object error) {
    return Card(
      color: Colors.red[100],
      child: ListTile(
        title: const Text('Error', style: TextStyle(color: Colors.red)),
        subtitle: Text(error.toString()),
      ),
    );
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
