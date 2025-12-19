// helper to safely get colleague by id
import 'package:audavis_time_management/domain/entities/colleague_entity.dart';

ColleagueEntity? findColleagueById(List<ColleagueEntity> all, String? id) {
  if (id == null) return null;
  try {
    return all.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}
