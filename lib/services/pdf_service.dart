import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/invoice.dart';
import '../models/dynamic_field.dart';
import '../models/field_type.dart';

class PDFService {
  static Future<void> generateAndShareInvoice(Invoice invoice) async {
    try {
      final pdf = await _generateInvoicePDF(invoice);
      
      // Save to temporary directory
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/invoice_${invoice.id}.pdf');
      await file.writeAsBytes(await pdf.save());
      
      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Invoice: ${invoice.title}',
      );
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  static Future<void> printInvoice(Invoice invoice) async {
    try {
      final pdf = await _generateInvoicePDF(invoice);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      throw Exception('Failed to print PDF: $e');
    }
  }

  static Future<Uint8List> generateInvoicePDF(Invoice invoice) async {
    final pdf = await _generateInvoicePDF(invoice);
    return pdf.save();
  }

  static Future<pw.Document> _generateInvoicePDF(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(invoice),
                
                pw.SizedBox(height: 40),
                
                // Client and Company Info
                _buildClientAndCompanyInfo(invoice),
                
                pw.SizedBox(height: 40),
                
                // Invoice Details
                _buildInvoiceDetails(invoice),
                
                pw.SizedBox(height: 40),
                
                // Dynamic Fields
                _buildDynamicFields(invoice),
                
                pw.SizedBox(height: 40),
                
                // Footer
                _buildFooter(invoice),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(Invoice invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'INVOICE',
              style: pw.TextStyle(
                fontSize: 32,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            if (invoice.invoiceNumber != null) ...[
              pw.SizedBox(height: 8),
              pw.Text(
                'Invoice #: ${invoice.invoiceNumber}',
                style: const pw.TextStyle(fontSize: 14),
              ),
            ],
            pw.SizedBox(height: 8),
            pw.Text(
              'Date: ${_formatDate(invoice.createdAt)}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            if (invoice.dueDate != null) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                'Due Date: ${_formatDate(invoice.dueDate!)}',
                style: const pw.TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            if (invoice.companyName != null) ...[
              pw.Text(
                invoice.companyName!,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
            ],
            if (invoice.companyAddress != null) ...[
              pw.Text(
                invoice.companyAddress!,
                style: const pw.TextStyle(fontSize: 12),
                textAlign: pw.TextAlign.right,
              ),
              pw.SizedBox(height: 4),
            ],
            if (invoice.companyPhone != null) ...[
              pw.Text(
                'Phone: ${invoice.companyPhone}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 4),
            ],
            if (invoice.companyEmail != null) ...[
              pw.Text(
                'Email: ${invoice.companyEmail}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildClientAndCompanyInfo(Invoice invoice) {
    return pw.Row(
      children: [
        // Client Info
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Bill To:',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              if (invoice.clientName != null) ...[
                pw.Text(
                  invoice.clientName!,
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 4),
              ],
              if (invoice.clientEmail != null) ...[
                pw.Text(
                  invoice.clientEmail!,
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 4),
              ],
              if (invoice.clientPhone != null) ...[
                pw.Text(
                  invoice.clientPhone!,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        
        // Status
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: pw.BoxDecoration(
                  color: _getStatusColor(invoice.status!),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  invoice.status!.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildInvoiceDetails(Invoice invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          invoice.title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (invoice.description != null) ...[
          pw.SizedBox(height: 8),
          pw.Text(
            invoice.description!,
            style: const pw.TextStyle(fontSize: 14),
          ),
        ],
        if (invoice.totalAmount != null) ...[
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Total Amount:',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                '${invoice.currency} ${_formatCurrency(invoice.totalAmount!)}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildDynamicFields(Invoice invoice) {
    if (invoice.fields.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Invoice Items',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 16),
        
        // Table header
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Text(
                  'Description',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  'Quantity',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  'Unit Price',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  'Total',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Table rows
        ...invoice.sortedFields.map((field) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    field.name,
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    field.value ?? '',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    field.type == FieldType.currency ? '\$${field.value ?? '0.00'}' : field.value ?? '',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    field.type == FieldType.currency ? '\$${field.value ?? '0.00'}' : field.value ?? '',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildFooter(Invoice invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (invoice.notes != null) ...[
          pw.Text(
            'Notes:',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            invoice.notes!,
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.SizedBox(height: 20),
        ],
        
        pw.Divider(),
        pw.SizedBox(height: 20),
        
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Thank you for your business!',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              'Generated on ${_formatDate(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  static String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }

  static PdfColor _getStatusColor(String status) {
    switch (status) {
      case 'draft':
        return PdfColors.orange;
      case 'sent':
        return PdfColors.blue;
      case 'paid':
        return PdfColors.green;
      case 'overdue':
        return PdfColors.red;
      case 'cancelled':
        return PdfColors.grey;
      default:
        return PdfColors.grey;
    }
  }
}


