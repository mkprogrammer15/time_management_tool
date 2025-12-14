// Dummy colleagues
import 'package:audavis_time_management/data/models/colleague_model.dart';
import 'package:audavis_time_management/data/models/holiday_model.dart';
import 'package:audavis_time_management/date_helpers.dart';
import 'package:audavis_time_management/domain/entities/leave_entity.dart';

final List<ColleagueModel> allColleagues = [
  const ColleagueModel(id: '1', name: "Michael Karp", team: "Frontend"),
  const ColleagueModel(
    id: '2',
    name: "Moritz Fuchshofer",
    team: "Data Engineering",
  ),
  const ColleagueModel(id: '3', name: "Mathias Hosang", team: "Infrastructure"),
  const ColleagueModel(id: '4', name: "Philipp Roebruck", team: "Sales"),
  const ColleagueModel(id: '5', name: "Otrek Wilke", team: "Backend"),
];

List<LeaveEntry> leaves = [
  LeaveEntry(
    id: '1',
    colleagueName: "Moritz Fuchshofer",
    start: DateTime(DateTime.now().year, DateTime.now().month, 3),
    end: DateTime(DateTime.now().year, DateTime.now().month, 6),
    type: LeaveType.vacation,
    status: LeaveStatus.approved,
  ),
  LeaveEntry(
    id: '2',
    colleagueName: "Michael Karp",
    start: DateTime(DateTime.now().year, DateTime.now().month, 10),
    end: DateTime(DateTime.now().year, DateTime.now().month, 10),
    type: LeaveType.vacation,
    status: LeaveStatus.approved,
  ),
  LeaveEntry(
    id: '3',
    colleagueName: "Mathias Hosang",
    start: DateTime(DateTime.now().year, DateTime.now().month, 18),
    end: DateTime(DateTime.now().year, DateTime.now().month, 19),
    type: LeaveType.sick,
    status: LeaveStatus.requested,
  ),
  LeaveEntry(
    id: '4',
    colleagueName: "Philipp Roebruck",
    start: DateTime(DateTime.now().year, DateTime.now().month, 15),
    end: DateTime(DateTime.now().year, DateTime.now().month, 15),
    type: LeaveType.sick,
    status: LeaveStatus.requested,
  ),
  LeaveEntry(
    id: '5',
    colleagueName: "Otrek Wilke",
    start: DateTime(DateTime.now().year, DateTime.now().month, 23),
    end: DateTime(DateTime.now().year, DateTime.now().month, 24),
    type: LeaveType.sick,
    status: LeaveStatus.requested,
  ),
];

List<HolidayModel> holidaysFromAdmin = [
  HolidayModel(
    id: 'h1',
    date: DateTime(month.year, month.month, 1),
    title: 'Feiertag 1',
  ),
  HolidayModel(
    id: 'h2',
    date: DateTime(month.year, month.month, 25),
    title: 'Feiertag 2',
  ),
];
