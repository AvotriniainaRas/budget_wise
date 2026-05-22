import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/entities.dart';
import '../../domain/usecases/transaction/get_monthly_summary.dart';
import '../extensions/date_extensions.dart';

/// Service d'export des données en CSV et PDF.
///
/// Retourne le chemin du fichier généré.
class ExportService {
  const ExportService();

  // ── Export CSV ───────────────────────────────────────

  /// Exporte une liste de transactions en fichier CSV.
  Future<String> exportToCsv(
    List<Transaction> transactions,
    List<Category>    categories,
  ) async {
    final formatter = NumberFormat('#,###', 'fr_FR');

    // En-têtes
    final rows = <List<dynamic>>[
      ['Date', 'Type', 'Catégorie', 'Description', 'Montant (Ar)', 'Note'],
    ];

    // Données
    for (final t in transactions) {
      final category = categories.firstWhere(
        (c) => c.id == t.categoryId,
        orElse: () => const Category(
          id:    '',
          name:  'Autre',
          icon:  IconData(0xe000, fontFamily: 'MaterialIcons'),
          color: Color(0xFF78909C),
        ),
      );

      rows.add([
        t.date.toReadable(),
        t.isIncome ? 'Revenu' : 'Dépense',
        category.name,
        t.title,
        t.isIncome
            ? '+${formatter.format(t.amount)}'
            : '-${formatter.format(t.amount)}',
        t.note ?? '',
      ]);
    }

    final csv  = const ListToCsvConverter().convert(rows);
    final dir  = await getApplicationSupportDirectory();
    final path =
        '${dir.path}/budgetwise_export_${DateTime.now().toFileName()}.csv';
    final file = File(path);
    await file.writeAsString(csv, encoding: utf8);

    return path;
  }

  // ── Export PDF ───────────────────────────────────────

  /// Exporte une liste de transactions en fichier PDF.
  Future<String> exportToPdf(
    List<Transaction> transactions,
    List<Category>    categories,
    MonthlySummary?   summary,
  ) async {
    final pdf       = pw.Document();
    final formatter = NumberFormat('#,###', 'fr_FR');
    final now       = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin:     const pw.EdgeInsets.all(32),
        header:     (context) => _buildHeader(context, now),
        footer:     (context) => _buildFooter(context),
        build:      (context) => [

          // Résumé financier
          if (summary != null) ...[
            pw.Text(
              'Résumé du mois',
              style: pw.TextStyle(
                fontSize:   16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            _buildSummaryTable(summary, formatter),
            pw.SizedBox(height: 24),
          ],

          // Liste des transactions
          pw.Text(
            'Transactions (${transactions.length})',
            style: pw.TextStyle(
              fontSize:   16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          _buildTransactionsTable(transactions, categories, formatter),
        ],
      ),
    );

    final dir  = await getApplicationSupportDirectory();
    final path =
        '${dir.path}/budgetwise_export_${now.toFileName()}.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    return path;
  }

  // ── Widgets PDF privés ───────────────────────────────

  pw.Widget _buildHeader(pw.Context context, DateTime date) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'BudgetWise',
          style: pw.TextStyle(
            fontSize:   20,
            fontWeight: pw.FontWeight.bold,
            color:      PdfColor.fromHex('#5C6BC0'),
          ),
        ),
        pw.Text(
          'Export du ${date.toReadable()}',
          style: pw.TextStyle(
            fontSize: 10,
            color:    PdfColors.grey600,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(
          'Page ${context.pageNumber} / ${context.pagesCount}',
          style: pw.TextStyle(
            fontSize: 10,
            color:    PdfColors.grey600,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSummaryTable(
    MonthlySummary summary,
    NumberFormat   formatter,
  ) {
    return pw.Table(
      border:       pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: [
        _pdfRow(
          'Revenus',
          '+${formatter.format(summary.totalIncome)} Ar',
          isHeader: true,
        ),
        _pdfRow('Dépenses', '-${formatter.format(summary.totalExpense)} Ar'),
        _pdfRow('Solde',    '${formatter.format(summary.balance)} Ar'),
        _pdfRow(
          'Taux d\'épargne',
          '${summary.savingsRate.toStringAsFixed(1)}%',
        ),
      ],
    );
  }

  pw.Widget _buildTransactionsTable(
    List<Transaction> transactions,
    List<Category>    categories,
    NumberFormat      formatter,
  ) {
    return pw.Table(
      border:       pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(3),
        3: const pw.FlexColumnWidth(2),
      },
      children: [
        // En-tête
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _pdfCell('Date',        isHeader: true),
            _pdfCell('Catégorie',   isHeader: true),
            _pdfCell('Description', isHeader: true),
            _pdfCell('Montant',     isHeader: true),
          ],
        ),
        // Lignes
        ...transactions.map((t) {
          final category = categories.firstWhere(
            (c) => c.id == t.categoryId,
            orElse: () => const Category(
              id:    '',
              name:  'Autre',
              icon:  IconData(0xe000, fontFamily: 'MaterialIcons'),
              color: Color(0xFF78909C),
            ),
          );
          return pw.TableRow(
            children: [
              _pdfCell(t.date.toReadable()),
              _pdfCell(category.name),
              _pdfCell(t.title),
              _pdfCell(
                '${t.isIncome ? '+' : '-'}'
                '${formatter.format(t.amount)} Ar',
              ),
            ],
          );
        }),
      ],
    );
  }

  pw.TableRow _pdfRow(
    String label,
    String value, {
    bool isHeader = false,
  }) {
    return pw.TableRow(
      decoration: isHeader
          ? const pw.BoxDecoration(color: PdfColors.grey200)
          : null,
      children: [
        _pdfCell(label, isHeader: isHeader),
        _pdfCell(value),
      ],
    );
  }

  pw.Widget _pdfCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize:   10,
          fontWeight: isHeader
              ? pw.FontWeight.bold
              : pw.FontWeight.normal,
        ),
      ),
    );
  }
}