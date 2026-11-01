import 'package:mobile_scanner/mobile_scanner.dart';
class ScannerService {
 static String? pdlFrom(String raw){final matches=RegExp(r'(?<!\d)27\d{6,20}(?!\d)').allMatches(raw).map((m)=>m.group(0)!).toSet();return matches.length==1?matches.first:null;}
 static String? first(BarcodeCapture c){for(final b in c.barcodes){final s=b.rawValue?.trim();if(s!=null&&s.isNotEmpty)return s;}return null;}
}
