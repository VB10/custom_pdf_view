class ProjectConstat {
  static ProjectConstat? _instace;
  static ProjectConstat get instance {
    _instace ??= ProjectConstat._init();
    return _instace!;
  }

  ProjectConstat._init();

  final baseUrl = 'https://hwatutorial-857aa-default-rtdb.firebaseio.com/';

  final String key = 'image';
}
