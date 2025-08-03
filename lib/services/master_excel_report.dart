import 'dart:io' show File, Platform, Directory;
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

/// A generic Excel generator utility for any model
typedef RowBuilder<T> = List<dynamic> Function(T item);

class GenericExcelGeneratorService {
  static bool _isDownloading = false; // Flag to prevent duplicate downloads

  /// Generates a filename in the format: reportTitle_22Jun_1203.xlsx
  static String _generateFileName(String reportTitle) {
    final now = DateTime.now();
    final dateFormat = DateFormat('ddMMM_HHmm');
    final dateTime = dateFormat.format(now);
    
    // Clean report title by removing special characters and spaces
    final cleanTitle = reportTitle
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special chars except hyphens
        .replaceAll(RegExp(r'\s+'), '_')     // Replace spaces with underscores
        .trim();
    
    return '${cleanTitle}_${dateTime}.xlsx';
  }

  static Future<void> generateGroupedExcel<T>({
    required List<T> data,
    required String reportTitle,
    required List<String> headers,
    required RowBuilder<T> rowBuilder,
    String? masterText,
    String Function(T item)? groupBy,
    String? fileName, // Optional custom filename
  }) async {
    // Prevent duplicate downloads
    if (_isDownloading) {
      print('Download already in progress, skipping...');
      return;
    }

    try {
      _isDownloading = true;
      
      final excel = Excel.createExcel();
      final Sheet sheet = excel['Sheet'];

      if (excel.sheets.containsKey('Sheet1')) {
        excel.delete('Sheet1');
      }

      int currentRow = 0;

      // Report Title
      final titleCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow));
      titleCell.value = TextCellValue(reportTitle);
      titleCell.cellStyle = CellStyle(
        fontSize: 16,
        bold: true,
        horizontalAlign: HorizontalAlign.Center,
      );
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow),
        CellIndex.indexByColumnRow(columnIndex: headers.length - 1, rowIndex: currentRow),
      );
      currentRow++;

      // Print Date
      final dateCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow));
      final dateStr = DateFormat('d-MMM-yyyy').format(DateTime.now());
      dateCell.value = TextCellValue('Report Print Date: $dateStr');
      dateCell.cellStyle = CellStyle(fontSize: 10);
      currentRow += 2;

      // Grouping logic
      final groupedData = <String, List<T>>{};
      if (groupBy != null) {
        for (var item in data) {
          final key = groupBy(item);
          groupedData.putIfAbsent(key, () => []).add(item);
        }
      } else {
        groupedData['All Data'] = data;
      }

      for (final entry in groupedData.entries) {
        if (groupBy != null && masterText != null) {
          // Insert group header row
          final groupCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow));
          groupCell.value = TextCellValue('$masterText ${entry.key}');
          groupCell.cellStyle = CellStyle(bold: true, fontSize: 12);
          currentRow++;
        }

        // Insert column headers
        for (int i = 0; i < headers.length; i++) {
          final headerCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: currentRow));
          headerCell
            ..value = TextCellValue(headers[i])
            ..cellStyle = CellStyle(bold: true);
        }
        currentRow++;

        // Insert rows with proper data types
        for (final item in entry.value) {
          final row = rowBuilder(item);
          for (int i = 0; i < row.length; i++) {
            final cellValue = _getCellValue(row[i]);
            sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: currentRow)).value = cellValue;
          }
          currentRow++;
        }

        currentRow++; // Space after each group
      }

      // Use consistent filename format with PDF generator
      final finalFileName = fileName ?? _generateFileName(reportTitle);
      
      if (kIsWeb) {
        // For web, get bytes and use custom download to control the filename
        final fileBytes = excel.save();
        if (fileBytes == null) {
          throw Exception("Excel file bytes are null");
        }
        await _downloadFileWeb(fileBytes, finalFileName);
      } else {
        // For mobile/desktop, save to file system
        final fileBytes = excel.save();
        if (fileBytes == null) {
          throw Exception("Excel file bytes are null");
        }
        
        Directory dir = Platform.isAndroid
            ? (await getExternalStorageDirectory())!
            : await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/$finalFileName';
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);
        print('Excel saved to $filePath');
      }
    } catch (e) {
      throw Exception('Failed to generate Excel: $e');
    } finally {
      // Reset the flag after a delay to ensure download completes
      Future.delayed(Duration(seconds: 2), () {
        _isDownloading = false;
      });
    }
  }

  // Helper method to determine the correct CellValue type
  static CellValue _getCellValue(dynamic value) {
    if (value == null) {
      return TextCellValue('N/A');
    }
    
    if (value is int) {
      return IntCellValue(value);
    }
    
    if (value is double) {
      return DoubleCellValue(value);
    }
    
    if (value is num) {
      return value is int ? IntCellValue(value.toInt()) : DoubleCellValue(value.toDouble());
    }
    
    // For strings, check if they represent numbers
    if (value is String) {
      if (value.isEmpty) {
        return TextCellValue('N/A');
      }
      
      // Try to parse as int first
      final intValue = int.tryParse(value);
      if (intValue != null) {
        return IntCellValue(intValue);
      }
      
      // Try to parse as double
      final doubleValue = double.tryParse(value);
      if (doubleValue != null) {
        return DoubleCellValue(doubleValue);
      }
      
      // If not a number, return as text
      return TextCellValue(value);
    }
    
    // Default to string representation
    return TextCellValue(value.toString());
  }

  static Future<void> generateExcel<T>({
    required List<T> data,
    required String reportTitle,
    required List<String> headers,
    required RowBuilder<T> rowBuilder,
    String? fileName, // Added optional filename parameter
  }) async {
    // It simply calls the more complex method without the grouping parameters
    return generateGroupedExcel(
      data: data,
      reportTitle: reportTitle,
      headers: headers,
      rowBuilder: rowBuilder,
      fileName: fileName,
      // groupBy and masterText are omitted, so they are null by default
    );
  }

  static Future<void> _downloadFileWeb(List<int> fileBytes, String fileName) async {
    try {
      final content = Uint8List.fromList(fileBytes);
      final blob = html.Blob([content], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Create a temporary anchor element
      final anchor = html.AnchorElement();
      anchor.href = url;
      anchor.download = fileName;
      anchor.style.display = 'none';
      
      // Add to DOM, click, and immediately remove
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      
      // Clean up the blob URL
      html.Url.revokeObjectUrl(url);
      
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  // Method to reset download flag manually if needed
  static void resetDownloadFlag() {
    _isDownloading = false;
  }
}