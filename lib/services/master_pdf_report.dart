import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

typedef GroupByFunction<T> = String Function(T item);
typedef RowGenerator<T> = List<String> Function(T item);

class GenericPdfGeneratorService {
  /// Generates a filename in the format: reportTitle_22Jun_1203.pdf
  static String _generateFileName(String reportTitle) {
    final now = DateTime.now();
    final dateFormat = DateFormat('ddMMM_HHmm');
    final dateTime = dateFormat.format(now);
    
    // Clean report title by removing special characters and spaces
    final cleanTitle = reportTitle
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special chars except hyphens
        .replaceAll(RegExp(r'\s+'), '_')     // Replace spaces with underscores
        .trim();
    
    return '${cleanTitle}_${dateTime}.pdf';
  }

  static Future<void> generateGroupedPdf<T>({
    required List<T> data,
    required GroupByFunction<T> groupBy,
    required RowGenerator<T> rowBuilder,
    required List<String> headers,
    required String reportTitle,
    String footerText = 'Powered by: Insignia E-Security Pvt Ltd',
    String masterText = 'Master',
    String? fileName, // Made optional - will auto-generate if not provided
  }) async {
    final Map<String, List<T>> groupedData = {};
    
    for (var item in data) {
      final key = groupBy(item).isEmpty ? ' ' : groupBy(item);
      groupedData.putIfAbsent(key, () => []).add(item);
    }

    groupedData.forEach((key, list) {
      list.sort((a, b) => rowBuilder(a).first.compareTo(rowBuilder(b).first));
    });

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(reportTitle),
        footer: (context) => _buildFooter(footerText, context),
        build: (context) {
          final List<pw.Widget> content = [];
          final sortedKeys = groupedData.keys.toList()..sort();

          for (final group in sortedKeys) {
            final list = groupedData[group]!;
            content.add(_buildGroupHeader(group, masterText));
            content.add(_buildTable(headers, list, rowBuilder));
            content.add(pw.SizedBox(height: 20));
          }

          return content;
        },
      ),
    );

    // Use auto-generated filename if not provided
    final finalFileName = fileName ?? _generateFileName(reportTitle);

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: finalFileName,
    );
  }

  static pw.Widget _buildHeader(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          alignment: pw.Alignment.center,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('Report Print Date :'),
            pw.Text(
              ' ${DateFormat('d-MMM-yyyy').format(DateTime.now())}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  static pw.Widget _buildFooter(String text, pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.only(top: 8, bottom: 8),
      margin: const pw.EdgeInsets.only(top: 16),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
      ),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            text,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildGroupHeader(String groupName, String masterText) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey600)),
      child: pw.Row(
        children: [
          pw.Text(masterText, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 10),
          pw.Text(groupName),
        ],
      ),
    );
  }

  static pw.Widget _buildTable<T>(
    List<String> headers,
    List<T> items,
    RowGenerator<T> rowBuilder, [
    double fontSize = 11,
    double headerFontSize = 12,
  ]) {
    final data = items.map((item) => rowBuilder(item)).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey600),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: headerFontSize,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellHeight: 28,
      cellStyle: pw.TextStyle(fontSize: fontSize),
      cellAlignments: {
        for (var i = 0; i < headers.length; i++) i: pw.Alignment.centerLeft
      },
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
    );
  }

  static Future<void> generateSimplePdf<T>({
    required List<T> data,
    required List<String> headers,
    required RowGenerator<T> rowBuilder,
    required String reportTitle,
    String footerText = 'Powered by: Insignia E-Security Pvt Ltd',
    String? fileName, // Made optional - will auto-generate if not provided
  }) async {
    final pdf = pw.Document();

    // 🔹 Decide font size based on number of rows
    final double fontSize = headers.length > 6 ? 6 : 11;
    final double headerFontSize = headers.length > 6 ? 6 : 12;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(reportTitle),
        footer: (context) => _buildFooter(footerText, context),
        build: (context) {
          final List<pw.Widget> content = [];

          content.add(
            _buildTable(headers, data, rowBuilder, fontSize, headerFontSize),
          );
          return content;
        },
      ),
    );

    // Use auto-generated filename if not provided
    final finalFileName = fileName ?? _generateFileName(reportTitle);

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: finalFileName,
    );
  }
}