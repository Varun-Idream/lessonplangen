import 'package:lessonplan/util/constants/constants.dart';
import 'package:lessonplan/util/functions.dart';

class Config {
  final bool isEncrypted;
  final String baseURL;
  final String decryptionPass;
  final String initVector;
  final String authorizationToken;
  final String personalAccessTokenVimeo;
  final AppType type;
  final bool showBoardChip;
  final bool showSearch;
  final bool showAITools;
  final String cgfUsername;
  final String cgfPassword;

  const Config({
    this.isEncrypted = true,
    this.baseURL = '',
    this.decryptionPass = '',
    this.initVector = '',
    this.authorizationToken = '',
    this.personalAccessTokenVimeo = '',
    this.type = AppType.standalone,
    this.showBoardChip = false,
    this.showSearch = false,
    this.showAITools = false,
    this.cgfUsername = '',
    this.cgfPassword = '',
  });

  factory Config.fromJSON({required Map<String, dynamic> json}) {
    return Config(
      baseURL: json["base_url"],
      isEncrypted: json["is_encrypted"],
      decryptionPass: json["decpass"],
      initVector: json['initvector'],
      authorizationToken: json['authorizationToken'],
      personalAccessTokenVimeo: json['personalAccessTokenVimeo'],
      type: getAppType(json['type']),
      showBoardChip: json['showBoardChip'],
      showSearch: json['showSearch'],
      showAITools: json['show_aitools'],
      cgfUsername: json['cgf_username'],
      cgfPassword: json['cgf_password'],
    );
  }
}
