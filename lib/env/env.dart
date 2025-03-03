import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'MAP_API_KEY', obfuscate: true)
  static String key = _Env.key;
}
