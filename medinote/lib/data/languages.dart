const languages = [
  Language('English', 'en_US'),
  Language('Francais', 'fr_FR'),
  Language('Pусский', 'ru_RU'),
  Language('Italiano', 'it_IT'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}
