class Intervention {
  final int? id;
  final String pdl, detector1, detector2, enterprise, createdAt;
  final double latitude, longitude;
  const Intervention({this.id, required this.pdl, required this.detector1, required this.detector2, required this.latitude, required this.longitude, required this.enterprise, required this.createdAt});
  Map<String,Object?> toMap()=>{'pdl':pdl,'detector1':detector1,'detector2':detector2,'latitude':latitude,'longitude':longitude,'enterprise':enterprise,'created_at':createdAt};
  factory Intervention.fromMap(Map<String,Object?> m)=>Intervention(id:m['id'] as int?,pdl:'${m['pdl']??''}',detector1:'${m['detector1']??''}',detector2:'${m['detector2']??''}',latitude:(m['latitude'] as num?)?.toDouble()??0,longitude:(m['longitude'] as num?)?.toDouble()??0,enterprise:'${m['enterprise']??''}',createdAt:'${m['created_at']??''}');
}
