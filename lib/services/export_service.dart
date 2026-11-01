import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/intervention.dart';
class ExportService {
 static Future<String> save(List<Intervention> all,DateTime start,DateTime end,String company) async {
  final a=DateTime(start.year,start.month,start.day), b=DateTime(end.year,end.month,end.day,23,59,59);
  final rows=all.where((x){final d=DateTime.tryParse(x.createdAt);return d!=null&&!d.isBefore(a)&&!d.isAfter(b);}).toList();
  if(rows.isEmpty)throw Exception('Aucune intervention sur cette période.');
  final book=Excel.createExcel();final sheet=book['Interventions'];
  sheet.appendRow(['DATE_HEURE','REFERENCE_CLIENT_PDL','DETECTEUR_CO_1','DETECTEUR_CO_2','LATITUDE','LONGITUDE','ENTREPRISE'].map((e)=>TextCellValue(e)).toList());
  for(final x in rows){sheet.appendRow([TextCellValue(x.createdAt),TextCellValue(x.pdl),TextCellValue(x.detector1),TextCellValue(x.detector2),TextCellValue(x.latitude.toString()),TextCellValue(x.longitude.toString()),TextCellValue(company)]);}
  final bytes=book.encode();if(bytes==null)throw Exception('Création Excel impossible');
  final dir=await getExternalStorageDirectory()??await getApplicationDocumentsDirectory();final f=File('${dir.path}/CO_TRACK_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.xlsx');await f.writeAsBytes(bytes,flush:true);return f.path;
 }
}
