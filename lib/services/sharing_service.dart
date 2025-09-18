import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../models/invoice.dart';
import 'pdf_service.dart';

class SharingService {
  static Future<File> _writePdfToTemp(Invoice invoice) async {
    final bytes = await PDFService.generateInvoicePDF(invoice);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/invoice_${invoice.id}.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> shareInvoice(Invoice invoice) async {
    final file = await _writePdfToTemp(invoice);
    await Share.shareXFiles([XFile(file.path)], text: 'Invoice: ${invoice.title}');
  }

  static Future<void> shareViaWhatsApp(Invoice invoice) async {
    // Share Plus doesn't force a specific target app across all platforms reliably.
    // We share the file with a helpful message; user picks WhatsApp if available.
    final file = await _writePdfToTemp(invoice);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Invoice: ${invoice.title}\n\nPlease find the attached invoice.',
    );
  }

  static Future<void> shareViaEmail(Invoice invoice) async {
    final file = await _writePdfToTemp(invoice);
    final client = invoice.clientName ?? 'Client';
    final company = invoice.companyName ?? 'Your Company';
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Invoice: ${invoice.title}',
      text: 'Invoice: ${invoice.title}\n\nDear $client,\n\nPlease find attached the invoice.\n\nBest regards,\n$company',
    );
  }

  static Future<void> printInvoice(Invoice invoice) async {
    final bytes = await PDFService.generateInvoicePDF(invoice);
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  static Future<File> saveToDevice(Invoice invoice) async {
    final bytes = await PDFService.generateInvoicePDF(invoice);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/invoice_${invoice.id}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> shareInvoiceData(Invoice invoice) async {
    final data = _formatInvoiceData(invoice);
    await Share.share(data, subject: 'Invoice Data: ${invoice.title}');
  }

  static String _formatInvoiceData(Invoice invoice) {
    final b = StringBuffer();
    b.writeln('INVOICE');
    b.writeln('========');
    b.writeln();
    b.writeln('Title: ${invoice.title}');
    if (invoice.invoiceNumber != null) b.writeln('Invoice #: ${invoice.invoiceNumber}');
    b.writeln('Date: ${invoice.createdAt.toIso8601String()}');
    if (invoice.dueDate != null) b.writeln('Due Date: ${invoice.dueDate!.toIso8601String()}');
    b.writeln('Status: ${invoice.status}');
    b.writeln();
    if (invoice.description != null && invoice.description!.isNotEmpty) {
      b.writeln('Description:');
      b.writeln(invoice.description);
      b.writeln();
    }
    if (invoice.clientName != null) {
      b.writeln('Client: ${invoice.clientName}');
      if (invoice.clientEmail != null) b.writeln('Email: ${invoice.clientEmail}');
      if (invoice.clientPhone != null) b.writeln('Phone: ${invoice.clientPhone}');
      b.writeln();
    }
    if (invoice.companyName != null) {
      b.writeln('Company: ${invoice.companyName}');
      if (invoice.companyAddress != null) b.writeln('Address: ${invoice.companyAddress}');
      if (invoice.companyPhone != null) b.writeln('Phone: ${invoice.companyPhone}');
      if (invoice.companyEmail != null) b.writeln('Email: ${invoice.companyEmail}');
      b.writeln();
    }
    if (invoice.totalAmount != null) {
      b.writeln('Total Amount: ${invoice.currency} ${invoice.totalAmount?.toStringAsFixed(2)}');
      b.writeln();
    }
    if (invoice.fields.isNotEmpty) {
      b.writeln('Fields:');
      for (final f in invoice.sortedFields) {
        b.writeln('- ${f.name}: ${f.value ?? ''}');
      }
      b.writeln();
    }
    if (invoice.notes != null && invoice.notes!.isNotEmpty) {
      b.writeln('Notes:');
      b.writeln(invoice.notes);
      b.writeln();
    }
    b.writeln('Generated: ${DateTime.now().toIso8601String()}');
    return b.toString();
  }
}
