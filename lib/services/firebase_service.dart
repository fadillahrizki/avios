import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final data = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = data.user;

    final userData = (await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get());

    if (!userData.exists) {
      await createUserData(user.uid, user.displayName, user.photoURL);
    }

    return data;
  }

  static createUserData(uid, name, [photo]) async {
    final storageRef = FirebaseStorage.instance.ref();
    final placeholderImageRef = storageRef.child('profile/placeholder.png');

    final placeholderPhoto = await placeholderImageRef.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'name': name, 'photo': photo ?? placeholderPhoto});
  }

  static Future<TaskSnapshot> uploadImageProfile(file, uid) async {
    final storageRef = FirebaseStorage.instance.ref();
    final profileRef = storageRef.child('profile/$uid.png');
    return await profileRef.putFile(file);
  }

  static logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
