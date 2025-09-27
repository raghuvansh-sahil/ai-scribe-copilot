const languages = [
  Language('Francais', 'fr_FR'),
  Language('English', 'en_US'),
  Language('Pусский', 'ru_RU'),
  Language('Italiano', 'it_IT'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}
