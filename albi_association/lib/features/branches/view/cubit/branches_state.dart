import 'package:qafeel/features/branches/data/models/branch.dart';

abstract class BranchesState {}

class BranchesInitial extends BranchesState {}

class BranchesLoading extends BranchesState {}

class BranchesLoaded extends BranchesState {
  final List<Branch> items;
  BranchesLoaded(this.items);
}

class BranchesError extends BranchesState {
  final String message;
  BranchesError(this.message);
}

