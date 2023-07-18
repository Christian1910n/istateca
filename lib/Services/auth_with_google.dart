import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceGoogle {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get user {
    return _auth.currentUser;
  }

  /* Inicia sesión con una cuenta de Google. Obtiene la información de autenticación y crea una credencial. 
  Luego, inicia sesión con la credencial y devuelve el usuario autenticado.*/
  Future<User?> signInGoogle() async {
    try {
      final GoogleSignInAccount googleUser = (await _googleSignIn.signIn())!;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        user.providerData.forEach((userInfo) {
          print(userInfo);
        });
      }
      if (user!.uid == _auth.currentUser!.uid) return user;
    } catch (e) {
      print('Error en el el Metodo: ${e.toString()}');
    }
    return null;
  }

  /* Cierra la sesión de Google y también en el servicio de autenticación de la aplicación. */
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
