import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/models/profile.dart';
import 'package:fluttercommerce/resources/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  ProfileBloc({@required this.repository}) : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is UpdateProfile) {
      yield ProfileLoading();

      try {
        final Profile profile =
            await repository.fetchProfileData(event.token, event.userId);
        yield ProfileLodaded(profile: profile);
      } on HttpException {
        yield ProfileFaluire(
          error: ('No Service'),
        );
      } on FormatException {
        yield ProfileFaluire(
          error: ('No Formate Exception'),
        );
      } catch (e) {
        print(e);
        yield ProfileFaluire(error: e.toString());
      }
    }
  }
}
