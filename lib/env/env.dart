import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {

  // FIREBASE
  @EnviedField(varName: 'serverKey', obfuscate: true)
  static final String serverKey = _Env.serverKey;

}
