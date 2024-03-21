//--------------------------------------------------------------------------
// we don't want to expose Firebase User to the UI
// there should be an abstraction layer between firebase logic and
// the UI Logic.
//factory constructor does not require us to create new instance each time
// , we can use it to fetch initialization data from cache, or including
// some logic for initialization that cannot be initialization that cannot
// be included in normal constructor, other than that it is used in use
// cases where we need to fetch emailverfied instance variable data from
// firebase to structure the data received from firebase.
//------------------------------------------------------------------------
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
// we want our auth user to have an user id, to associate that user with specific
// id.
@immutable
class AuthUser{
  final String id;
  final String email;
  final bool isEmailVerified;
  const AuthUser({ required this.id,required this.email,
    required this.isEmailVerified});// required named parameter make it easy to understand what
  // the arguement is.
// copy of firebase user to our own user
  // this is done to not expose the firebase user to our ui logic
factory AuthUser.fromFirebase(User user)=>AuthUser(email:user.email!,
    isEmailVerified: user.emailVerified, id: user.uid );
}
