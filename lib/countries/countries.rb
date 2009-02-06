# -*- encoding: utf-8 -*- 
$KCODE = 'u'
require 'yaml'

class IsoCountry #:nodoc:
  attr_accessor :numeric, :alpha2, :alpha3, :name_en
  attr_accessor :localizations
  @@current_localization = 'en'
  @@table = []
  
  class << self
  
    # Returns a table of all defined countries
    def all; @@table end;
    
    def lookup(code)
      
    end
    
    # Sets the current localization for correct string retrieval. Calling "name"
    # on any IsoCountry will retrieve the relevant country name according to the localization  
    def current_localization=(nlocalization)
      @@current_localization = nlocalization    
    end
  
    # Load a hash of translated country names. The hash has to be keyed by two-letter country
    # code
    def load_translation_table(for_lang_code, hash_of_names_by_code)
      for item in @@table
        item.translate(for_lang_code, hash_of_names_by_code[item.code])
      end
    end

    # Get a has of country names translated into language_code
    def dump_translation_table(language_code)
      language_code = language_code.to_sym if language_code.respond_to?(:to_sym)
      ha = {}
      @@table.each do |item|
        ha[item.code.to_sym] = item.name(language_code)
      end
      ha
    end
    
    def load_from_yaml_file(path = nil)
      yaml_path = (path ? path : File.dirname(__FILE__) + '/iso_countries.yml')
      @@table = YAML::load_file(yaml_path)
    end
    
    def load_from_yaml(data)
      @@table = YAML::load(data)
    end
  end
  
  def initialize(numeric, alpha3, alpha2, *localizationz) #:nodoc:
    @numeric, @alpha3, @alpha2, @localizations = numeric.to_i, alpha3.downcase, alpha2.downcase, {}
    @localizations = {}
    @localizations.merge!(localizationz[0]) if localizationz[0].is_a?(Hash)
    @@table << self
  end
  
  def translate(language_code, name)
    @localizations[language_code.to_sym] = name  
  end

  # Retrieves a name of the country according to the language code as a symbol
  def name(lang_code = nil)
    lang_code = lang_code.to_sym if lang_code.respond_to?(:to_sym)
    lang_code = @@current_localization.to_sym unless lang_code
    @localizations.has_key?(lang_code) ? @localizations[lang_code] : @localizations.dup.shift[1]
  end
  
  alias :code :alpha2  
  alias :id :numeric  

  def to_s #:nodoc:
    "#{code.upcase} - #{name}"
  end


  def ==(other) #:nodoc:
    (other.to_s == @numeric.to_s) or 
      (other.to_s == @alpha2.to_s) or
      (other.to_s == alpha3.to_s) or
      (other.respond_to?(:code) and other.code === code)
  end
end




IsoCountry.load_from_yaml <<EOF
--- 
- !ruby/object:IsoCountry 
  alpha2: au
  alpha3: aus
  localizations: 
    :ru: "Австралия"
    :en: Australia
  numeric: 36
- !ruby/object:IsoCountry 
  alpha2: at
  alpha3: aut
  localizations: 
    :ru: "Австрия"
    :en: Austria
  numeric: 40
- !ruby/object:IsoCountry 
  alpha2: az
  alpha3: aze
  localizations: 
    :ru: "Азербайджан"
    :en: Azerbaijan
  numeric: 31
- !ruby/object:IsoCountry 
  alpha2: ax
  alpha3: ala
  localizations: 
    :ru: "Аландские острова"
    :en: "Аtland Islands"
  numeric: 248
- !ruby/object:IsoCountry 
  alpha2: al
  alpha3: alb
  localizations: 
    :ru: "Албания"
    :en: Albania
  numeric: 8
- !ruby/object:IsoCountry 
  alpha2: dz
  alpha3: dza
  localizations: 
    :ru: "Алжир"
    :en: Algeria
  numeric: 12
- !ruby/object:IsoCountry 
  alpha2: um
  alpha3: umi
  localizations: 
    :ru: "Американские малые внешние острова (???)"
    :en: United States Minor Outlying Islands
  numeric: 581
- !ruby/object:IsoCountry 
  alpha2: vi
  alpha3: vir
  localizations: 
    :ru: "Американские Виргинские острова"
    :en: Virgin Islands (British)
  numeric: 850
- !ruby/object:IsoCountry 
  alpha2: as
  alpha3: asm
  localizations: 
    :ru: "Американское Самоа"
    :en: American Samoa
  numeric: 16
- !ruby/object:IsoCountry 
  alpha2: ai
  alpha3: aia
  localizations: 
    :ru: "Ангилья"
    :en: Anguilla
  numeric: 660
- !ruby/object:IsoCountry 
  alpha2: ao
  alpha3: ago
  localizations: 
    :ru: "Ангола"
    :en: Angola
  numeric: 24
- !ruby/object:IsoCountry 
  alpha2: ad
  alpha3: and
  localizations: 
    :ru: "Андорра"
    :en: Andorra
  numeric: 20
- !ruby/object:IsoCountry 
  alpha2: aq
  alpha3: ata
  localizations: 
    :ru: "Антарктида"
    :en: Antarctica
  numeric: 10
- !ruby/object:IsoCountry 
  alpha2: ag
  alpha3: atg
  localizations: 
    :ru: "Антигуа и Барбуда"
    :en: Antigua And Barbuda
  numeric: 28
- !ruby/object:IsoCountry 
  alpha2: ar
  alpha3: arg
  localizations: 
    :ru: "Аргентина"
    :en: Argentina
  numeric: 32
- !ruby/object:IsoCountry 
  alpha2: am
  alpha3: arm
  localizations: 
    :ru: "Армения"
    :en: Armenia
  numeric: 51
- !ruby/object:IsoCountry 
  alpha2: aw
  alpha3: abw
  localizations: 
    :ru: "Аруба"
    :en: Aruba
  numeric: 533
- !ruby/object:IsoCountry 
  alpha2: af
  alpha3: afg
  localizations: 
    :ru: "Афганистан"
    :en: Afghanistan
  numeric: 4
- !ruby/object:IsoCountry 
  alpha2: bs
  alpha3: bhs
  localizations: 
    :ru: "Багамы"
    :en: Bahamas
  numeric: 44
- !ruby/object:IsoCountry 
  alpha2: bd
  alpha3: bgd
  localizations: 
    :ru: "Бангладеш"
    :en: Bangladesh
  numeric: 50
- !ruby/object:IsoCountry 
  alpha2: bb
  alpha3: brb
  localizations: 
    :ru: "Барбадос"
    :en: Barbados
  numeric: 52
- !ruby/object:IsoCountry 
  alpha2: bh
  alpha3: bhr
  localizations: 
    :ru: "Бахрейн"
    :en: Bahrain
  numeric: 48
- !ruby/object:IsoCountry 
  alpha2: bz
  alpha3: blz
  localizations: 
    :ru: "Белиз"
    :en: Belize
  numeric: 84
- !ruby/object:IsoCountry 
  alpha2: by
  alpha3: blr
  localizations: 
    :ru: "Белоруссия"
    :en: Belarus
  numeric: 112
- !ruby/object:IsoCountry 
  alpha2: be
  alpha3: bel
  localizations: 
    :ru: "Бельгия"
    :en: Belgium
  numeric: 56
- !ruby/object:IsoCountry 
  alpha2: bj
  alpha3: ben
  localizations: 
    :ru: "Бенин"
    :en: Benin
  numeric: 204
- !ruby/object:IsoCountry 
  alpha2: bm
  alpha3: bmu
  localizations: 
    :ru: "Бермуды"
    :en: Bermuda
  numeric: 60
- !ruby/object:IsoCountry 
  alpha2: bg
  alpha3: bgr
  localizations: 
    :ru: "Болгария"
    :en: Bulgaria
  numeric: 100
- !ruby/object:IsoCountry 
  alpha2: bo
  alpha3: bol
  localizations: 
    :ru: "Боливия"
    :en: Bolivia
  numeric: 68
- !ruby/object:IsoCountry 
  alpha2: ba
  alpha3: bih
  localizations: 
    :ru: "Босния и Герцеговина"
    :en: Bosnia and Herzegowina
  numeric: 70
- !ruby/object:IsoCountry 
  alpha2: bw
  alpha3: bwa
  localizations: 
    :ru: "Ботсвана"
    :en: Botswana
  numeric: 72
- !ruby/object:IsoCountry 
  alpha2: br
  alpha3: bra
  localizations: 
    :ru: "Бразилия"
    :en: Brazil
  numeric: 76
- !ruby/object:IsoCountry 
  alpha2: io
  alpha3: iot
  localizations: 
    :ru: "Британские территории Индийского океана"
    :en: British Indian Ocean Territory
  numeric: 86
- !ruby/object:IsoCountry 
  alpha2: vg
  alpha3: vgb
  localizations: 
    :ru: "Британские Виргинские острова"
    :en: Virgin Islands (British)
  numeric: 92
- !ruby/object:IsoCountry 
  alpha2: bn
  alpha3: brn
  localizations: 
    :ru: "Бруней"
    :en: Brunei Darussalam
  numeric: 96
- !ruby/object:IsoCountry 
  alpha2: bf
  alpha3: bfa
  localizations: 
    :ru: "Буркина Фасо"
    :en: Burkina Faso
  numeric: 854
- !ruby/object:IsoCountry 
  alpha2: bi
  alpha3: bdi
  localizations: 
    :ru: "Бурунди"
    :en: Burundi
  numeric: 108
- !ruby/object:IsoCountry 
  alpha2: bt
  alpha3: btn
  localizations: 
    :ru: "Бутан"
    :en: Bhutan
  numeric: 64
- !ruby/object:IsoCountry 
  alpha2: vu
  alpha3: vut
  localizations: 
    :ru: "Вануату"
    :en: Vanuatu
  numeric: 548
- !ruby/object:IsoCountry 
  alpha2: va
  alpha3: vat
  localizations: 
    :ru: "Ватикан"
    :en: Vatican City State (Holy See)
  numeric: 336
- !ruby/object:IsoCountry 
  alpha2: gb
  alpha3: gbr
  localizations: 
    :ru: "Великобритания"
    :en: United Kingdom
  numeric: 826
- !ruby/object:IsoCountry 
  alpha2: hu
  alpha3: hun
  localizations: 
    :ru: "Венгрия"
    :en: Hungary
  numeric: 348
- !ruby/object:IsoCountry 
  alpha2: ve
  alpha3: ven
  localizations: 
    :ru: "Венесуэла"
    :en: Venezuela
  numeric: 862
- !ruby/object:IsoCountry 
  alpha2: tl
  alpha3: tls
  localizations: 
    :ru: "Восточный Тимор"
    :en: East Timor
  numeric: 626
- !ruby/object:IsoCountry 
  alpha2: vn
  alpha3: vnm
  localizations: 
    :ru: "Вьетнам"
    :en: Viet Nam
  numeric: 704
- !ruby/object:IsoCountry 
  alpha2: ga
  alpha3: gab
  localizations: 
    :ru: "Габон"
    :en: Gabon
  numeric: 266
- !ruby/object:IsoCountry 
  alpha2: ht
  alpha3: hti
  localizations: 
    :ru: "Гаити"
    :en: Haiti
  numeric: 332
- !ruby/object:IsoCountry 
  alpha2: gy
  alpha3: guy
  localizations: 
    :ru: "Гайана"
    :en: Guyana
  numeric: 328
- !ruby/object:IsoCountry 
  alpha2: gm
  alpha3: gmb
  localizations: 
    :ru: "Гамбия"
    :en: Gambia
  numeric: 270
- !ruby/object:IsoCountry 
  alpha2: gh
  alpha3: gha
  localizations: 
    :ru: "Гана"
    :en: Ghana
  numeric: 288
- !ruby/object:IsoCountry 
  alpha2: gp
  alpha3: glp
  localizations: 
    :ru: "Гваделупа"
    :en: Guadeloupe
  numeric: 312
- !ruby/object:IsoCountry 
  alpha2: gt
  alpha3: gtm
  localizations: 
    :ru: "Гватемала"
    :en: Guatemala
  numeric: 320
- !ruby/object:IsoCountry 
  alpha2: gn
  alpha3: gin
  localizations: 
    :ru: "Гвинея"
    :en: Guinea
  numeric: 324
- !ruby/object:IsoCountry 
  alpha2: gw
  alpha3: gnb
  localizations: 
    :ru: "Гвинея-Бисау"
    :en: Guinea-Bissau
  numeric: 624
- !ruby/object:IsoCountry 
  alpha2: de
  alpha3: deu
  localizations: 
    :ru: "Германия"
    :en: Germany
  numeric: 276
- !ruby/object:IsoCountry 
  alpha2: gi
  alpha3: gib
  localizations: 
    :ru: "Гибралтар"
    :en: Gibraltar
  numeric: 292
- !ruby/object:IsoCountry 
  alpha2: hn
  alpha3: hnd
  localizations: 
    :ru: "Гондурас"
    :en: Honduras
  numeric: 340
- !ruby/object:IsoCountry 
  alpha2: hk
  alpha3: hkg
  localizations: 
    :ru: "Гонконг"
    :en: Hong Kong
  numeric: 344
- !ruby/object:IsoCountry 
  alpha2: gd
  alpha3: grd
  localizations: 
    :ru: "Гренада"
    :en: Grenada
  numeric: 308
- !ruby/object:IsoCountry 
  alpha2: gl
  alpha3: grl
  localizations: 
    :ru: "Гренландия"
    :en: Greenland
  numeric: 304
- !ruby/object:IsoCountry 
  alpha2: gr
  alpha3: grc
  localizations: 
    :ru: "Греция"
    :en: Greece
  numeric: 300
- !ruby/object:IsoCountry 
  alpha2: ge
  alpha3: geo
  localizations: 
    :ru: "Грузия"
    :en: Georgia
  numeric: 268
- !ruby/object:IsoCountry 
  alpha2: gu
  alpha3: gum
  localizations: 
    :ru: "Гуам"
    :en: Guam
  numeric: 316
- !ruby/object:IsoCountry 
  alpha2: dk
  alpha3: dnk
  localizations: 
    :ru: "Дания"
    :en: Denmark
  numeric: 208
- !ruby/object:IsoCountry 
  alpha2: cd
  alpha3: cod
  localizations: 
    :ru: "Демократическая Республика Конго"
    :en: "Congo, the Democratic Republic of the"
  numeric: 180
- !ruby/object:IsoCountry 
  alpha2: dj
  alpha3: dji
  localizations: 
    :ru: "Джибути"
    :en: Djibouti
  numeric: 262
- !ruby/object:IsoCountry 
  alpha2: dm
  alpha3: dma
  localizations: 
    :ru: "Доминика"
    :en: Dominica
  numeric: 212
- !ruby/object:IsoCountry 
  alpha2: do
  alpha3: dom
  localizations: 
    :ru: "Доминиканская республика"
    :en: Dominican Republic
  numeric: 214
- !ruby/object:IsoCountry 
  alpha2: eg
  alpha3: egy
  localizations: 
    :ru: "Египет"
    :en: Egypt
  numeric: 818
- !ruby/object:IsoCountry 
  alpha2: zm
  alpha3: zmb
  localizations: 
    :ru: "Замбия"
    :en: Zambia
  numeric: 894
- !ruby/object:IsoCountry 
  alpha2: eh
  alpha3: esh
  localizations: 
    :ru: "Западная Сахара"
    :en: Western Sahara
  numeric: 732
- !ruby/object:IsoCountry 
  alpha2: zw
  alpha3: zwe
  localizations: 
    :ru: "Зимбабве"
    :en: Zimbabwe
  numeric: 716
- !ruby/object:IsoCountry 
  alpha2: il
  alpha3: isr
  localizations: 
    :ru: "Израиль"
    :en: Israel
  numeric: 376
- !ruby/object:IsoCountry 
  alpha2: in
  alpha3: ind
  localizations: 
    :ru: "Индия"
    :en: India
  numeric: 356
- !ruby/object:IsoCountry 
  alpha2: id
  alpha3: idn
  localizations: 
    :ru: "Индонезия"
    :en: Indonesia
  numeric: 360
- !ruby/object:IsoCountry 
  alpha2: jo
  alpha3: jor
  localizations: 
    :ru: "Иордания"
    :en: Jordan
  numeric: 400
- !ruby/object:IsoCountry 
  alpha2: iq
  alpha3: irq
  localizations: 
    :ru: "Ирак"
    :en: Iraq
  numeric: 368
- !ruby/object:IsoCountry 
  alpha2: ir
  alpha3: irn
  localizations: 
    :ru: "Иран"
    :en: Iran
  numeric: 364
- !ruby/object:IsoCountry 
  alpha2: ie
  alpha3: irl
  localizations: 
    :ru: "Ирландия"
    :en: Ireland
  numeric: 372
- !ruby/object:IsoCountry 
  alpha2: is
  alpha3: isl
  localizations: 
    :ru: "Исландия"
    :en: Iceland
  numeric: 352
- !ruby/object:IsoCountry 
  alpha2: es
  alpha3: esp
  localizations: 
    :ru: "Испания"
    :en: Spain
  numeric: 724
- !ruby/object:IsoCountry 
  alpha2: it
  alpha3: ita
  localizations: 
    :ru: "Италия"
    :en: Italy
  numeric: 380
- !ruby/object:IsoCountry 
  alpha2: ye
  alpha3: yem
  localizations: 
    :ru: "Йемен"
    :en: Yemen
  numeric: 887
- !ruby/object:IsoCountry 
  alpha2: kp
  alpha3: prk
  localizations: 
    :ru: "КНДР"
    :en: "Korea, Republic of"
  numeric: 408
- !ruby/object:IsoCountry 
  alpha2: cv
  alpha3: cpv
  localizations: 
    :ru: "Кабо-Верде"
    :en: Cape Verde
  numeric: 132
- !ruby/object:IsoCountry 
  alpha2: kz
  alpha3: kaz
  localizations: 
    :ru: "Казахстан"
    :en: Kazakhstan
  numeric: 398
- !ruby/object:IsoCountry 
  alpha2: ky
  alpha3: cym
  localizations: 
    :ru: "Каймановы острова"
    :en: Cayman Islands
  numeric: 136
- !ruby/object:IsoCountry 
  alpha2: kh
  alpha3: khm
  localizations: 
    :ru: "Камбоджа"
    :en: Cambodia
  numeric: 116
- !ruby/object:IsoCountry 
  alpha2: cm
  alpha3: cmr
  localizations: 
    :ru: "Камерун"
    :en: Cameroon
  numeric: 120
- !ruby/object:IsoCountry 
  alpha2: ca
  alpha3: can
  localizations: 
    :ru: "Канада"
    :en: Canada
  numeric: 124
- !ruby/object:IsoCountry 
  alpha2: qa
  alpha3: qat
  localizations: 
    :ru: "Катар"
    :en: Qatar
  numeric: 634
- !ruby/object:IsoCountry 
  alpha2: ke
  alpha3: ken
  localizations: 
    :ru: "Кения"
    :en: Kenya
  numeric: 404
- !ruby/object:IsoCountry 
  alpha2: cy
  alpha3: cyp
  localizations: 
    :ru: "Кипр"
    :en: Cyprus
  numeric: 196
- !ruby/object:IsoCountry 
  alpha2: kg
  alpha3: kgz
  localizations: 
    :ru: "Киргизстан"
    :en: Kyrgyzstan
  numeric: 417
- !ruby/object:IsoCountry 
  alpha2: ki
  alpha3: kir
  localizations: 
    :ru: "Кирибати"
    :en: Kiribati
  numeric: 296
- !ruby/object:IsoCountry 
  alpha2: cn
  alpha3: chn
  localizations: 
    :ru: "Китайская Народная Республика"
    :en: China
  numeric: 156
- !ruby/object:IsoCountry 
  alpha2: cc
  alpha3: cck
  localizations: 
    :ru: "Кокосовые острова"
    :en: Cocos (Keeling) Islands
  numeric: 166
- !ruby/object:IsoCountry 
  alpha2: co
  alpha3: col
  localizations: 
    :ru: "Колумбия"
    :en: Colombia
  numeric: 170
- !ruby/object:IsoCountry 
  alpha2: km
  alpha3: com
  localizations: 
    :ru: "Коморские острова"
    :en: Comoros
  numeric: 174
- !ruby/object:IsoCountry 
  alpha2: cr
  alpha3: cri
  localizations: 
    :ru: "Коста-Рика"
    :en: Costa Rica
  numeric: 188
- !ruby/object:IsoCountry 
  alpha2: ci
  alpha3: civ
  localizations: 
    :ru: "Кот-д'Ивуар"
    :en: American Samoa
  numeric: 384
- !ruby/object:IsoCountry 
  alpha2: cu
  alpha3: cub
  localizations: 
    :ru: "Куба"
    :en: Cuba
  numeric: 192
- !ruby/object:IsoCountry 
  alpha2: kw
  alpha3: kwt
  localizations: 
    :ru: "Кувейт"
    :en: Kuwait
  numeric: 414
- !ruby/object:IsoCountry 
  alpha2: la
  alpha3: lao
  localizations: 
    :ru: "Лаос"
    :en: "Lao People's Democratic Republic"
  numeric: 418
- !ruby/object:IsoCountry 
  alpha2: lv
  alpha3: lva
  localizations: 
    :ru: "Латвия"
    :en: Latvia
  numeric: 428
- !ruby/object:IsoCountry 
  alpha2: ls
  alpha3: lso
  localizations: 
    :ru: "Лесото"
    :en: Lesotho
  numeric: 426
- !ruby/object:IsoCountry 
  alpha2: lr
  alpha3: lbr
  localizations: 
    :ru: "Либерия"
    :en: Liberia
  numeric: 430
- !ruby/object:IsoCountry 
  alpha2: lb
  alpha3: lbn
  localizations: 
    :ru: "Ливан"
    :en: Lebanon
  numeric: 422
- !ruby/object:IsoCountry 
  alpha2: ly
  alpha3: lby
  localizations: 
    :ru: "Ливия"
    :en: Liberia
  numeric: 434
- !ruby/object:IsoCountry 
  alpha2: lt
  alpha3: ltu
  localizations: 
    :ru: "Литва"
    :en: Lithuania
  numeric: 440
- !ruby/object:IsoCountry 
  alpha2: li
  alpha3: lie
  localizations: 
    :ru: "Лихтенштейн"
    :en: Liechtenstein
  numeric: 438
- !ruby/object:IsoCountry 
  alpha2: lu
  alpha3: lux
  localizations: 
    :ru: "Люксембург"
    :en: Luxembourg
  numeric: 442
- !ruby/object:IsoCountry 
  alpha2: mu
  alpha3: mus
  localizations: 
    :ru: "Маврикий"
    :en: Mauritius
  numeric: 480
- !ruby/object:IsoCountry 
  alpha2: mr
  alpha3: mrt
  localizations: 
    :ru: "Мавритания"
    :en: Mauritania
  numeric: 478
- !ruby/object:IsoCountry 
  alpha2: mg
  alpha3: mdg
  localizations: 
    :ru: "Мадагаскар"
    :en: Madagascar
  numeric: 450
- !ruby/object:IsoCountry 
  alpha2: yt
  alpha3: myt
  localizations: 
    :ru: "Майот"
    :en: Mayotte
  numeric: 175
- !ruby/object:IsoCountry 
  alpha2: mo
  alpha3: mac
  localizations: 
    :ru: "Макао"
    :en: Macau
  numeric: 446
- !ruby/object:IsoCountry 
  alpha2: mk
  alpha3: mkd
  localizations: 
    :ru: "Македония"
    :en: Macedonia
  numeric: 807
- !ruby/object:IsoCountry 
  alpha2: mw
  alpha3: mwi
  localizations: 
    :ru: "Малави"
    :en: Malawi
  numeric: 454
- !ruby/object:IsoCountry 
  alpha2: my
  alpha3: mys
  localizations: 
    :ru: "Малайзия"
    :en: Malaysia
  numeric: 458
- !ruby/object:IsoCountry 
  alpha2: ml
  alpha3: mli
  localizations: 
    :ru: "Мали"
    :en: Mali
  numeric: 466
- !ruby/object:IsoCountry 
  alpha2: mv
  alpha3: mdv
  localizations: 
    :ru: "Мальдивы"
    :en: Maldives
  numeric: 462
- !ruby/object:IsoCountry 
  alpha2: mt
  alpha3: mlt
  localizations: 
    :ru: "Мальта"
    :en: Malta
  numeric: 470
- !ruby/object:IsoCountry 
  alpha2: ma
  alpha3: mar
  localizations: 
    :ru: "Марокко"
    :en: Morocco
  numeric: 504
- !ruby/object:IsoCountry 
  alpha2: mq
  alpha3: mtq
  localizations: 
    :ru: "Мартиника"
    :en: Martinique
  numeric: 474
- !ruby/object:IsoCountry 
  alpha2: mh
  alpha3: mhl
  localizations: 
    :ru: "Маршалловы острова"
    :en: Marshall Islands
  numeric: 584
- !ruby/object:IsoCountry 
  alpha2: mx
  alpha3: mex
  localizations: 
    :ru: "Мексика"
    :en: Mexico
  numeric: 484
- !ruby/object:IsoCountry 
  alpha2: mz
  alpha3: moz
  localizations: 
    :ru: "Мозамбик"
    :en: Mozambique
  numeric: 508
- !ruby/object:IsoCountry 
  alpha2: md
  alpha3: mda
  localizations: 
    :ru: "Молдавия"
    :en: "Moldova, Republic of"
  numeric: 498
- !ruby/object:IsoCountry 
  alpha2: mc
  alpha3: mco
  localizations: 
    :ru: "Монако"
    :en: Monaco
  numeric: 492
- !ruby/object:IsoCountry 
  alpha2: mn
  alpha3: mng
  localizations: 
    :ru: "Монголия"
    :en: Mongolia
  numeric: 496
- !ruby/object:IsoCountry 
  alpha2: ms
  alpha3: msr
  localizations: 
    :ru: "Монсеррат"
    :en: Montserrat
  numeric: 500
- !ruby/object:IsoCountry 
  alpha2: mm
  alpha3: mmr
  localizations: 
    :ru: "Мьянма"
    :en: Myanmar
  numeric: 104
- !ruby/object:IsoCountry 
  alpha2: na
  alpha3: nam
  localizations: 
    :ru: "Намибия"
    :en: Namibia
  numeric: 516
- !ruby/object:IsoCountry 
  alpha2: nr
  alpha3: nru
  localizations: 
    :ru: "Науру"
    :en: Nauru
  numeric: 520
- !ruby/object:IsoCountry 
  alpha2: np
  alpha3: npl
  localizations: 
    :ru: "Непал"
    :en: Nepal
  numeric: 524
- !ruby/object:IsoCountry 
  alpha2: ne
  alpha3: ner
  localizations: 
    :ru: "Нигер"
    :en: Niger
  numeric: 562
- !ruby/object:IsoCountry 
  alpha2: ng
  alpha3: nga
  localizations: 
    :ru: "Нигерия"
    :en: Nigeria
  numeric: 566
- !ruby/object:IsoCountry 
  alpha2: an
  alpha3: ant
  localizations: 
    :ru: "Нидерландские Антильские острова"
    :en: Netherlands Antilles
  numeric: 530
- !ruby/object:IsoCountry 
  alpha2: nl
  alpha3: nld
  localizations: 
    :ru: "Нидерланды"
    :en: Netherlands
  numeric: 528
- !ruby/object:IsoCountry 
  alpha2: ni
  alpha3: nic
  localizations: 
    :ru: "Никарагуа"
    :en: Nicaragua
  numeric: 558
- !ruby/object:IsoCountry 
  alpha2: nu
  alpha3: niu
  localizations: 
    :ru: "Ниуэ"
    :en: Niue
  numeric: 570
- !ruby/object:IsoCountry 
  alpha2: nc
  alpha3: ncl
  localizations: 
    :ru: "Новая Каледония"
    :en: New Caledonia
  numeric: 540
- !ruby/object:IsoCountry 
  alpha2: nz
  alpha3: nzl
  localizations: 
    :ru: "Новая Зеландия"
    :en: New Zealand
  numeric: 554
- !ruby/object:IsoCountry 
  alpha2: "no"
  alpha3: nor
  localizations: 
    :ru: "Норвегия"
    :en: Norway
  numeric: 578
- !ruby/object:IsoCountry 
  alpha2: ae
  alpha3: are
  localizations: 
    :ru: "Объединённые Арабские Эмираты"
    :en: United Arab Emirates
  numeric: 784
- !ruby/object:IsoCountry 
  alpha2: om
  alpha3: omn
  localizations: 
    :ru: "Оман"
    :en: Oman
  numeric: 512
- !ruby/object:IsoCountry 
  alpha2: cx
  alpha3: cxr
  localizations: 
    :ru: "Остров Рождества"
    :en: Christmas Island
  numeric: 162
- !ruby/object:IsoCountry 
  alpha2: ck
  alpha3: cok
  localizations: 
    :ru: "Острова Кука"
    :en: Cook Islands
  numeric: 184
- !ruby/object:IsoCountry 
  alpha2: hm
  alpha3: hmd
  localizations: 
    :ru: "Острова Хирд и Макдональд"
    :en: Heard and Mc Donald Islands
  numeric: 334
- !ruby/object:IsoCountry 
  alpha2: pk
  alpha3: pak
  localizations: 
    :ru: "Пакистан"
    :en: Pakistan
  numeric: 586
- !ruby/object:IsoCountry 
  alpha2: pw
  alpha3: plw
  localizations: 
    :ru: "Палау"
    :en: Palau
  numeric: 585
- !ruby/object:IsoCountry 
  alpha2: ps
  alpha3: pse
  localizations: 
    :ru: "Палестинская автономия"
    :en: Nepal
  numeric: 275
- !ruby/object:IsoCountry 
  alpha2: pa
  alpha3: pan
  localizations: 
    :ru: "Панама"
    :en: Panama
  numeric: 591
- !ruby/object:IsoCountry 
  alpha2: pg
  alpha3: png
  localizations: 
    :ru: "Папуа-Новая Гвинея"
    :en: Papua New Guinea
  numeric: 598
- !ruby/object:IsoCountry 
  alpha2: py
  alpha3: pry
  localizations: 
    :ru: "Парагвай"
    :en: Paraguay
  numeric: 600
- !ruby/object:IsoCountry 
  alpha2: pe
  alpha3: per
  localizations: 
    :ru: "Перу"
    :en: Peru
  numeric: 604
- !ruby/object:IsoCountry 
  alpha2: pn
  alpha3: pcn
  localizations: 
    :ru: "Питкэрн"
    :en: Pitcairn
  numeric: 612
- !ruby/object:IsoCountry 
  alpha2: pl
  alpha3: pol
  localizations: 
    :ru: "Польша"
    :en: Poland
  numeric: 616
- !ruby/object:IsoCountry 
  alpha2: pt
  alpha3: prt
  localizations: 
    :ru: "Португалия"
    :en: Portugal
  numeric: 620
- !ruby/object:IsoCountry 
  alpha2: pr
  alpha3: pri
  localizations: 
    :ru: "Пуэрто-Рико"
    :en: Puerto Rico
  numeric: 630
- !ruby/object:IsoCountry 
  alpha2: cg
  alpha3: cog
  localizations: 
    :ru: "Республика Конго"
    :en: Congo
  numeric: 178
- !ruby/object:IsoCountry 
  alpha2: re
  alpha3: reu
  localizations: 
    :ru: "Реюньон"
    :en: Algeria
  numeric: 638
- !ruby/object:IsoCountry 
  alpha2: ru
  alpha3: rus
  localizations: 
    :ru: "Россия"
    :en: Russia
  numeric: 643
- !ruby/object:IsoCountry 
  alpha2: rw
  alpha3: rwa
  localizations: 
    :ru: "Руанда"
    :en: Rwanda
  numeric: 646
- !ruby/object:IsoCountry 
  alpha2: ro
  alpha3: rou
  localizations: 
    :ru: "Румыния"
    :en: Romania
  numeric: 642
- !ruby/object:IsoCountry 
  alpha2: us
  alpha3: usa
  localizations: 
    :ru: "США"
    :en: United States
  numeric: 840
- !ruby/object:IsoCountry 
  alpha2: sv
  alpha3: slv
  localizations: 
    :ru: "Сальвадор"
    :en: El Salvador
  numeric: 222
- !ruby/object:IsoCountry 
  alpha2: ws
  alpha3: wsm
  localizations: 
    :ru: "Самоа"
    :en: American Samoa
  numeric: 882
- !ruby/object:IsoCountry 
  alpha2: sm
  alpha3: smr
  localizations: 
    :ru: "Сан-Марино"
    :en: San Marino
  numeric: 674
- !ruby/object:IsoCountry 
  alpha2: st
  alpha3: stp
  localizations: 
    :ru: "Сан-Томе и Принсипи"
    :en: Sao Tome and Principe
  numeric: 678
- !ruby/object:IsoCountry 
  alpha2: sa
  alpha3: sau
  localizations: 
    :ru: "Саудовская Аравия"
    :en: Saudi Arabia
  numeric: 682
- !ruby/object:IsoCountry 
  alpha2: sz
  alpha3: swz
  localizations: 
    :ru: "Свазиленд"
    :en: Swaziland
  numeric: 748
- !ruby/object:IsoCountry 
  alpha2: sj
  alpha3: sjm
  localizations: 
    :ru: "Свальбард и Ян Майен"
    :en: Svalbard and Jan Mayen Islands
  numeric: 744
- !ruby/object:IsoCountry 
  alpha2: mp
  alpha3: mnp
  localizations: 
    :ru: "Северные Марианские острова"
    :en: Northern Mariana Islands
  numeric: 580
- !ruby/object:IsoCountry 
  alpha2: sc
  alpha3: syc
  localizations: 
    :ru: "Сейшелы"
    :en: Seychelles
  numeric: 690
- !ruby/object:IsoCountry 
  alpha2: sn
  alpha3: sen
  localizations: 
    :ru: "Сенегал"
    :en: Senegal
  numeric: 686
- !ruby/object:IsoCountry 
  alpha2: vc
  alpha3: vct
  localizations: 
    :ru: "Сент-Винсент и Гренадины"
    :en: Saint Vincent and the Grenadines
  numeric: 670
- !ruby/object:IsoCountry 
  alpha2: kn
  alpha3: kna
  localizations: 
    :ru: "Сент-Китс и Невис"
    :en: Saint Kitts and Nevis
  numeric: 659
- !ruby/object:IsoCountry 
  alpha2: lc
  alpha3: lca
  localizations: 
    :ru: "Сент-Люсия"
    :en: Saint Lucia
  numeric: 662
- !ruby/object:IsoCountry 
  alpha2: pm
  alpha3: spm
  localizations: 
    :ru: "Сент-Пьер и Микелон"
    :en: Saint Kitts and Nevis
  numeric: 666
- !ruby/object:IsoCountry 
  alpha2: cs
  alpha3: scg
  localizations: 
    :ru: "Сербия и Черногория"
    :en: Serbia and Montenegro
  numeric: 891
- !ruby/object:IsoCountry 
  alpha2: sg
  alpha3: sgp
  localizations: 
    :ru: "Сингапур"
    :en: Singapore
  numeric: 702
- !ruby/object:IsoCountry 
  alpha2: sy
  alpha3: syr
  localizations: 
    :ru: "Сирия"
    :en: Syria
  numeric: 760
- !ruby/object:IsoCountry 
  alpha2: sk
  alpha3: svk
  localizations: 
    :ru: "Словакия"
    :en: Slovakia
  numeric: 703
- !ruby/object:IsoCountry 
  alpha2: si
  alpha3: svn
  localizations: 
    :ru: "Словения"
    :en: Slovenia
  numeric: 705
- !ruby/object:IsoCountry 
  alpha2: sb
  alpha3: slb
  localizations: 
    :ru: "Соломоновы острова"
    :en: Solomon Islands
  numeric: 90
- !ruby/object:IsoCountry 
  alpha2: so
  alpha3: som
  localizations: 
    :ru: "Сомали"
    :en: Somalia
  numeric: 706
- !ruby/object:IsoCountry 
  alpha2: sd
  alpha3: sdn
  localizations: 
    :ru: "Судан"
    :en: Suriname
  numeric: 736
- !ruby/object:IsoCountry 
  alpha2: sr
  alpha3: sur
  localizations: 
    :ru: "Суринам"
    :en: Suriname
  numeric: 740
- !ruby/object:IsoCountry 
  alpha2: sl
  alpha3: sle
  localizations: 
    :ru: "Сьерра-Леоне"
    :en: Sierra Leone
  numeric: 694
- !ruby/object:IsoCountry 
  alpha2: tj
  alpha3: tjk
  localizations: 
    :ru: "Таджикистан"
    :en: Tajikistan
  numeric: 762
- !ruby/object:IsoCountry 
  alpha2: th
  alpha3: tha
  localizations: 
    :ru: "Таиланд"
    :en: Thailand
  numeric: 764
- !ruby/object:IsoCountry 
  alpha2: tw
  alpha3: twn
  localizations: 
    :ru: "Тайвань"
    :en: Taiwan
  numeric: 158
- !ruby/object:IsoCountry 
  alpha2: tz
  alpha3: tza
  localizations: 
    :ru: "Танзания"
    :en: Tanzania
  numeric: 834
- !ruby/object:IsoCountry 
  alpha2: tg
  alpha3: tgo
  localizations: 
    :ru: "Того"
    :en: Togo
  numeric: 768
- !ruby/object:IsoCountry 
  alpha2: tk
  alpha3: tkl
  localizations: 
    :ru: "Токелау"
    :en: Tokelau
  numeric: 772
- !ruby/object:IsoCountry 
  alpha2: to
  alpha3: ton
  localizations: 
    :ru: "Тонга"
    :en: Tonga
  numeric: 776
- !ruby/object:IsoCountry 
  alpha2: tt
  alpha3: tto
  localizations: 
    :ru: "Тринидад и Тобаго"
    :en: Trinidad and Tobago
  numeric: 780
- !ruby/object:IsoCountry 
  alpha2: tv
  alpha3: tuv
  localizations: 
    :ru: "Тувалу"
    :en: Tuvalu
  numeric: 798
- !ruby/object:IsoCountry 
  alpha2: tn
  alpha3: tun
  localizations: 
    :ru: "Тунис"
    :en: Tunisia
  numeric: 788
- !ruby/object:IsoCountry 
  alpha2: tm
  alpha3: tkm
  localizations: 
    :ru: "Туркменистан"
    :en: Turkmenistan
  numeric: 795
- !ruby/object:IsoCountry 
  alpha2: tr
  alpha3: tur
  localizations: 
    :ru: "Турция"
    :en: Turkey
  numeric: 792
- !ruby/object:IsoCountry 
  alpha2: ug
  alpha3: uga
  localizations: 
    :ru: "Уганда"
    :en: Uganda
  numeric: 800
- !ruby/object:IsoCountry 
  alpha2: uz
  alpha3: uzb
  localizations: 
    :ru: "Узбекистан"
    :en: Uzbekistan
  numeric: 860
- !ruby/object:IsoCountry 
  alpha2: ua
  alpha3: ukr
  localizations: 
    :ru: "Украина"
    :en: Ukraine
  numeric: 804
- !ruby/object:IsoCountry 
  alpha2: uy
  alpha3: ury
  localizations: 
    :ru: "Уругвай"
    :en: Uruguay
  numeric: 858
- !ruby/object:IsoCountry 
  alpha2: fo
  alpha3: fro
  localizations: 
    :ru: "Фарерские острова"
    :en: Faroe Islands
  numeric: 234
- !ruby/object:IsoCountry 
  alpha2: fm
  alpha3: fsm
  localizations: 
    :ru: "Федеративные Штаты Микронезии"
    :en: "Micronesia, Federated States of"
  numeric: 583
- !ruby/object:IsoCountry 
  alpha2: fj
  alpha3: fji
  localizations: 
    :ru: "Фиджи"
    :en: Fiji
  numeric: 242
- !ruby/object:IsoCountry 
  alpha2: ph
  alpha3: phl
  localizations: 
    :ru: "Филиппины"
    :en: Philippines
  numeric: 608
- !ruby/object:IsoCountry 
  alpha2: fi
  alpha3: fin
  localizations: 
    :ru: "Финляндия"
    :en: Finland
  numeric: 246
- !ruby/object:IsoCountry 
  alpha2: fk
  alpha3: flk
  localizations: 
    :ru: "Фолклендские острова"
    :en: Falkland Islands
  numeric: 238
- !ruby/object:IsoCountry 
  alpha2: fr
  alpha3: fra
  localizations: 
    :ru: "Франция"
    :en: France
  numeric: 250
- !ruby/object:IsoCountry 
  alpha2: gf
  alpha3: guf
  localizations: 
    :ru: "Французская Гвиана"
    :en: French Guiana
  numeric: 254
- !ruby/object:IsoCountry 
  alpha2: pf
  alpha3: pyf
  localizations: 
    :ru: "Французская Полинезия"
    :en: French Polynesia
  numeric: 258
- !ruby/object:IsoCountry 
  alpha2: tf
  alpha3: atf
  localizations: 
    :ru: "Французские Южные территории"
    :en: French Southern Territories
  numeric: 260
- !ruby/object:IsoCountry 
  alpha2: hr
  alpha3: hrv
  localizations: 
    :ru: "Хорватия"
    :en: Croatia
  numeric: 191
- !ruby/object:IsoCountry 
  alpha2: cf
  alpha3: caf
  localizations: 
    :ru: "Центрально-Африканская Республика"
    :en: Central African Republic
  numeric: 140
- !ruby/object:IsoCountry 
  alpha2: td
  alpha3: tcd
  localizations: 
    :ru: "Чад"
    :en: Chad
  numeric: 148
- !ruby/object:IsoCountry 
  alpha2: cz
  alpha3: cze
  localizations: 
    :ru: "Чехия"
    :en: Czech Republic
  numeric: 203
- !ruby/object:IsoCountry 
  alpha2: cl
  alpha3: chl
  localizations: 
    :ru: "Чили"
    :en: Chile
  numeric: 152
- !ruby/object:IsoCountry 
  alpha2: ch
  alpha3: che
  localizations: 
    :ru: "Швейцария"
    :en: Switzerland
  numeric: 756
- !ruby/object:IsoCountry 
  alpha2: se
  alpha3: swe
  localizations: 
    :ru: "Швеция"
    :en: Sweden
  numeric: 752
- !ruby/object:IsoCountry 
  alpha2: lk
  alpha3: lka
  localizations: 
    :ru: "Шри-Ланка"
    :en: Sri Lanka
  numeric: 144
- !ruby/object:IsoCountry 
  alpha2: ec
  alpha3: ecu
  localizations: 
    :ru: "Эквадор"
    :en: Ecuador
  numeric: 218
- !ruby/object:IsoCountry 
  alpha2: gq
  alpha3: gnq
  localizations: 
    :ru: "Экваториальная Гвинея"
    :en: Equatorial Guinea
  numeric: 226
- !ruby/object:IsoCountry 
  alpha2: er
  alpha3: eri
  localizations: 
    :ru: "Эритрея"
    :en: Eritrea
  numeric: 232
- !ruby/object:IsoCountry 
  alpha2: ee
  alpha3: est
  localizations: 
    :ru: "Эстония"
    :en: Estonia
  numeric: 233
- !ruby/object:IsoCountry 
  alpha2: et
  alpha3: eth
  localizations: 
    :ru: "Эфиопия"
    :en: Ethiopia
  numeric: 231
- !ruby/object:IsoCountry 
  alpha2: za
  alpha3: zaf
  localizations: 
    :ru: "ЮАР"
    :en: South Africa
  numeric: 710
- !ruby/object:IsoCountry 
  alpha2: kr
  alpha3: kor
  localizations: 
    :ru: "Южная Корея"
    :en: "Korea, Republic of"
  numeric: 410
- !ruby/object:IsoCountry 
  alpha2: gs
  alpha3: sgs
  localizations: 
    :ru: "Южная Георгия и Южные Сандвичевы острова"
    :en: South Georgia and the South Sandwich Islands
  numeric: 239
- !ruby/object:IsoCountry 
  alpha2: jm
  alpha3: jam
  localizations: 
    :ru: "Ямайка"
    :en: Jamaica
  numeric: 388
- !ruby/object:IsoCountry 
  alpha2: jp
  alpha3: jpn
  localizations: 
    :ru: "Япония"
    :en: Japan
  numeric: 392
- !ruby/object:IsoCountry 
  alpha2: bv
  alpha3: bvt
  localizations: 
    :ru: "остров Буве"
    :en: Bouvet Island
  numeric: 74
- !ruby/object:IsoCountry 
  alpha2: nf
  alpha3: nfk
  localizations: 
    :ru: "остров Норфолк"
    :en: Norfolk Island
  numeric: 574
- !ruby/object:IsoCountry 
  alpha2: sh
  alpha3: shn
  localizations: 
    :ru: "остров Святой Елены"
    :en: Saint Kitts and Nevis
  numeric: 654
- !ruby/object:IsoCountry 
  alpha2: tc
  alpha3: tca
  localizations: 
    :ru: "острова Тёркс и Кайкос"
    :en: Turks and Caicos Islands
  numeric: 796
- !ruby/object:IsoCountry 
  alpha2: wf
  alpha3: wlf
  localizations: 
    :ru: "острова Уоллис и Футура"
    :en: Wallis and Futuna Islands
  numeric: 876
EOF