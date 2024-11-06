****************Merging EHCVM data
clear all
global Inputs_Shapefiles "C:\Users\idiop\OneDrive - CGIAR\020_GithubDesktop\Application-of-Fay-Herriot-Model-for-Burkina-Faso\00.Data\00_Country Shapefiles\Admin3"

global Inputs_EHCVM_MLI "C:\Users\idiop\OneDrive - CGIAR\020_GithubDesktop\Application-of-Fay-Herriot-Model-for-Burkina-Faso\00.Data\EHCVM data\MLI_2021_EHCVM-2_v01_M_STATA14"

global Inputs_EHCVM_NER "C:\Users\idiop\OneDrive - CGIAR\020_GithubDesktop\Application-of-Fay-Herriot-Model-for-Burkina-Faso\00.Data\EHCVM data\NER_2021_EHCVM-2_v01_M_STATA14"

<<<<<<< Updated upstream

global Inputs_EHCVM_BFA "C:\Users\idiop\OneDrive - CGIAR\020_GithubDesktop\Application-of-Fay-Herriot-Model-for-Burkina-Faso\00.Data\EHCVM data\BFA_2021_EHCVM-P_v02_M_Stata"
=======
global Inputs_EHCVM_SEN "C:\Users\ASY\OneDrive - CGIAR\Desktop\GithubDesktop\Application-of-Fay-Herriot-Model-for-Burkina-Faso\00.Data\EHCVM data\SEN_2021_EHCVM-2_v01_M_STATA14"
>>>>>>> Stashed changes

*************** Import HDX data


*use "C:\Users\idiop\OneDrive - CGIAR\020_GithubDesktop\Application-of-Fay-Herriot-Model-for-Burkina-Faso\00.Data\EHCVM data\NER_2021_EHCVM-2_v01_M_STATA14\ehcvm_individu_ner2021.dta" 

***************************************************************** Niger

*EHCVM
clear all
use "${Inputs_EHCVM_NER}\ehcvm_individu_ner2021.dta", clear


*** ADM1 in HDX to EHCVM ADM1
local ADM1 "Agadez Diffa Dosso Maradi Niamey Tahoua Tillabéri Zinder"

foreach x in region {
	local `x'_lab: variable label `x' // #1 from above
	gen strL `x'_vallab = "" // start of #3
	label variable `x'_vallab "``x'_lab' string"
	levelsof `x', local(valrange)
	foreach n of numlist `valrange' { 
		local `x'_vallab_`n': label (`x') `n' // #2 from above
		replace `x'_vallab = "``x'_vallab_`n''" if `x' == `n' // end of #3
	}
}
// we can also decode command
//decode  region, gen (region_vallab)

gen Region=""
replace region_vallab=strlower(region_vallab)
foreach  x  in `ADM1' {
	di strlower("`x'")
	di "`x'"
 	replace Region="`x'" if strrpos(region_vallab, strlower(ustrregexra( ustrnormalize( "`x'", "nfd" ) , "\p{Mark}", "" ) ))>0 |  strrpos(region_vallab, "`x'")>0
}
tab region_vallab if Region==""
replace Region="Agadez" if region==1
replace region_vallab="Agadez" if region==1


*** ADM3 in HDX to EHCVM ADM3
local ADM3 "Aderbissinat Arlit Dannet Gougaram Bilma Dirkou Djado Fachi Iferouane Timia Ingall Agadez Dabaga Tabelot Tchirozerine Bosso Toumour Chetimari Diffa Gueskérou Goudoumaria Foulatari "Maïné Soroa" N'Guelbely N'Gourti Kablewa N'Guigmi "Birni N'Gaouré" Fabidji Fakara Harikanassou Kankandi Kiota Koygolo N'Gonga Dioundiou Karakara Zabori Dan-Kassari Dogondoutchi Dogonkiria Kiéché Matankari Soucoucoutane Dosso Farey Garankédey Gollé Goroubankassam Karguibangou Mokko Sambéra Tessa "Tombokoirey I" "Tombokoirey II" Falmey Guilladjé Bana Bengou Gaya Tanda Tounouga Yélou Falwel Loga Sokorbé Doumega Guéchémé "Koré Maïroua" Tibiri Aguié Tchadoua Bermo Gadabedji Adjekoria Azagor "Bader Goula" "Birni Lallé" Dakoro Dan-Goulbi Korahane Kornaka Maïyara "Roumbou I" "Sabon Machi" Tagriss Gangara Gazaoua Chadakori "Guidan Roumdji" "Guidan Sori" "Saé Saboua" Tibiri Dan-Issa Djiratawa Gabi Madarounfa Safo "Sarkin Yamma" "Maradi I" "Maradi II" "Maradi III" Attantane "El Allassane Maïreyrey" "Guidan Amoumoune" Issawane Kanan-Bakaché Mayahi "Sarkin Haoussa" Tchaké Baoudetta Hawandawaki Koona Korgom Maïjirgui Ourafane Tessaoua Abalak Akoubounou Azeye Tabalak Tamaya Bagaroua Alléla Bazaga "Birni N'Konni" Tsernaoua Allakaye Babankatami Bouza Déoulé Karofane Tabotaki Tama Badaguichiri Illéla Tajaé Garhanga Ibohamane Keita Tamaské Azarori Bangui "Galma Koudawatché" Madaoua Ourno "Sabon Guida" Doguerawa Malbaza Affala Bambeye Barmou Kalfou Takanamat Tebaram Tassara Kao Tchintabaraden Tillia "Tahoua I" "Tahoua II" "Abala" Sanam Ayerou Inatès Tagazar Banibangou Bankilaré Filingué Imanan "Kourfeye Centre" Tondikandia Dargol Gothèye Bitinkodji Diantchandou Hamdallaye Karma Kirtachi Kollo Kouré Liboré N'Dounga Namaro Youri Dingazi Ouallam Simiri Tondikiwindi "Ouro Guéladjo" Say Tamou Diagourou Gorouol Kokorou Méhana Téra Anzourou Bibiyergou Dessa Kourteye Sakoïra Sinder Tillabéri Makalondi Torodi Tarka Albarkaram "Damagaram Takaya" Guidimouni Mazamni Moa Wamé Dogo-Dogo Dungass Gouchi Malawa Alakoss Bouné Gamou Gouré Guidiguir Kellé "Dan Barto" Daouché Doungou Ichirnawa Kantché Kourni Matamey Tsaouni Yaouri Bandé "Dantchiao" Kwaya Magaria Sassoumbroum Wacha Yékoua "Dogo" Droum Gaffati Gouna Hamdara Kolleram Mirriah Zermou Dakoussa Garagoumsa Tirmini Falenko Gangara Olléléwa Tanout Tenhya Tesker "Zinder I" "Zinder II" "Zinder III" "Zinder IV" "Zinder V" "Niamey I" "Niamey II" "Niamey III" "Niamey IV" "Niamey V"" 
foreach char in `ADM3' {
    display "`char'"
}
*tab commune, generate(stubname)

foreach x in commune {
	local `x'_lab: variable label `x' // #1 from above
	gen strL `x'_vallab = "" // start of #3
	label variable `x'_vallab "``x'_lab' string"
	levelsof `x', local(valrange)
	foreach n of numlist `valrange' { 
		local `x'_vallab_`n': label (`x') `n' // #2 from above
		replace `x'_vallab = "``x'_vallab_`n''" if `x' == `n' // end of #3
	}
}


*replace commune_vallab="Abala" if commune_vallab=="Abalak"
*replace commune_vallab="Maïné Soroa" if commune_vallab=="maine soroa"
*replace commune_vallab="Bader Goula" if commune_vallab=="bader goula"
// Corrections: Doguerawa is in Tahoua
replace Region="Tahoua" if commune_vallab=="doguerawa"
replace Region="Maradi" if commune_vallab=="hawandawaki"
replace Region="Tillabéri" if commune_vallab=="abala"
replace Region="Zinder" if commune_vallab=="dogo"
replace Region="Zinder" if commune_vallab=="dantchiao"
replace Region="Maradi" if commune_vallab=="SABON MACHI"

//gen region1=strlower(ustrregexra (ustrnormalize( Region, "nfd" ) , "\p{Mark}", "" ))

replace commune_vallab=ustrregexra(commune_vallab, "ARRONDISSEMENT 1", "I")
replace commune_vallab=ustrregexra(commune_vallab, "ARRONDISSEMENT 2", "II")
replace commune_vallab=ustrregexra(commune_vallab, "ARRONDISSEMENT 3", "III")
replace commune_vallab=ustrregexra(commune_vallab, "ARRONDISSEMENT 4", "IV")
replace commune_vallab=ustrregexra(commune_vallab, "ARRONDISSEMENT 5", "V")
replace commune_vallab=ustrregexra(strlower(ustrregexra (ustrnormalize( commune_vallab, "nfd" ) , "\p{Mark}", "" )), " ", "")




gen Commune=""
foreach  x  in `ADM3' {
*	di strlower("`x'")
*	di "`x'"
    scalar yy=ustrregexra(strlower(ustrregexra (ustrnormalize( "`x'", "nfd" ) , "\p{Mark}", "" )), " ", "")
	disp yy
	replace Commune="`x'" if strrpos(commune_vallab, yy)>0 
}
tab commune_vallab if Commune==""


replace Commune="Abalak" if commune_vallab=="abalak"
replace Commune="Dogo-Dogo" if commune_vallab=="dogo-dogo"

replace Region="Tillabéri" if Commune=="Abala"
replace Region="Zinder" if Commune=="Dogo"

collapse (firstnm) Commune  Region region departement commune, by( hhid grappe menage)
ren commune Commune_Code
save "${Inputs_EHCVM_NER}\NER_HDX_ADM3_EHCVM.dta", replace

import excel "${Inputs_Shapefiles}\ner_admgz_ignn_20230720.xlsx", sheet("ADM3") firstrow clear
keep if ADM3_FR!=""
count
keep ADM3_FR ADM3_PCODE ADM2_FR ADM2_PCODE ADM1_FR ADM1_PCODE ADM0_FR ADM0_PCODE

gen Commune=ADM3_FR 
gen Region=ADM1_FR 

merge 1:m Commune Region using "${Inputs_EHCVM_NER}\NER_HDX_ADM3_EHCVM.dta"

ren  ADM3_FR ADM3_NAME
ren ADM3_PCODE ADM3_CODE

ren  ADM2_FR ADM2_NAME
ren ADM2_PCODE ADM2_CODE

ren  ADM1_FR ADM1_NAME
ren ADM1_PCODE ADM1_CODE

ren ADM0_PCODE ADM0_CODE
ren ADM0_FR ADM0_NAME
ren region Region_EHCVM
ren  departement Departement_EHCVM
ren Commune_Code Commune_EHCVM
drop _merge Commune Region
save "${Inputs_EHCVM_NER}\NER_HDX_ADM3_EHCVM_Matching.dta", replace

******************************************************************** Mali
clear all
use "${Inputs_EHCVM_MLI}\ehcvm_individu_mli2021.dta", clear

*collapse (mean) x , by(hhid grappe menage region prefecture commune)
*drop x
local ADM2 "Abeibara Anderamboukane Ansongo Bafoulabe Bamako Banamba Bandiagara Bankass Baraouéli Bla Bougouni Bourem Dioila Diré Diéma Djenné Douentza Gao Goundam Gourma-Rharous Inekar Kadiolo Kangaba Kati Kayes Kidal Kita Kolokani Kolondieba Koro Koulikoro Koutiala Kéniéba Macina Mopti Ménaka Nara Niafunké Niono Nioro San Sikasso Ségou Tessalit Tidermene Tin-Essako Tombouctou Tominian Ténenkou Yanfolila Yorosso Youwarou Yélimané"

decode prefecture , gen(prefecture_label)
replace prefecture_label=strlower(prefecture_label)

gen ADM2_NAME=""
foreach  x  in `ADM2' {
*	di strlower("`x'")
*	di "`x'"
 	replace ADM2_NAME="`x'" if strrpos(prefecture_label, strlower(ustrregexra (ustrnormalize( "`x'", "nfd" ) , "\p{Mark}", "" )))>0 
}

replace ADM2_NAME="Gourma-Rharous" if prefecture_label=="gourma-rha"
replace ADM2_NAME="Baraouéli" if prefecture_label=="baroueli"
replace ADM2_NAME="Anderamboukane" if commune=="Anderamboukane" | commune=="Anderanboukane"  | commune=="anderaboukane" | commune=="anderaboukane" | commune=="Andéramboukane"
replace ADM2_NAME="Ansongo" if commune=="" | commune=="Anouzagrene kal talataye" | commune=="Anouzagrene kal talaytette"
replace ADM2_NAME="Kati" if commune=="Baguineda-Camp"
replace ADM2_NAME="Dioila" if commune=="Binko"
replace ADM2_NAME="Douentza" if commune=="Dangol-Bore" 
replace ADM2_NAME="Djenné" if commune=="Derary" 
replace ADM2_NAME="Bafoulabe" if commune=="Diakon" 
replace ADM2_NAME="Kati" if commune=="Dialakorodji" 
replace ADM2_NAME="Diré" if commune=="Diré" 
replace ADM2_NAME="Koro" if commune=="Dougoutene II" 
replace ADM2_NAME="Koutiala" if commune=="Fakolo" 
replace ADM2_NAME="Kolondieba" if commune=="Fakola" 
replace ADM2_NAME="Diéma" if commune=="Fatao"
replace ADM2_NAME="Diré" if commune=="Haïbongo" 
replace ADM2_NAME="Sikasso" if commune=="Kabarasso" 
replace ADM2_NAME="Sikasso" if commune=="Kapolondougou" 
replace ADM2_NAME="Kita" if commune=="Kassaro" 
replace ADM2_NAME="Kolokani" if commune=="Kolokani" 
replace ADM2_NAME="Nioro" if commune=="Koréra Koré" 
/*

                      |                       Prefecture residence
    commune residence | achouratt   alourche    arawane   bouzbeha  foum elba  taoudenit |     Total
----------------------+------------------------------------------------------------------+----------
                10101 |         0          0          0          0          0         61 |        61 
                10102 |         0          0          0          0          0        192 |       192 
                10201 |        73          0          0          0          0          0 |        73 
                10302 |         0         68          0          0          0          0 |        68 
                10303 |         0         60          0          0          0          0 |        60 
                10401 |         0          0         69          0          0          0 |        69 
                10402 |         0          0         54          0          0          0 |        54 
                10501 |         0          0          0         67          0          0 |        67 
                10502 |         0          0          0         69          0          0 |        69 
                10503 |         0          0          0         61          0          0 |        61 
                10601 |         0          0          0          0         59          0 |        59 
----------------------+------------------------------------------------------------------+----------
                Total |        73        128        123        197         59        253 |       833 
These commune are not in the hdx table*/
gen x=1
collapse (mean) x , by(hhid grappe menage region prefecture commune ADM2_NAME)
drop x

 *** ADM3 in HDX to EHCVM ADM3
local ADM3  "Tomora Sidibela Niambia Kontéla Diallan Diakon Bafoulabe Sitakily Sagalo Guenegoré Baye Kita Niantanso Sobra Makano Bossofala Mountougoula N'gouraba "Tiémala Banimonitié" Tougouni Dinandougou Boidié Nyamina Tamani "Gadougou I" Djougoun Bougarybaya Badia Fégui Kayes Tafacirga "Séro Siamanou" Ségala Sahel Sadiola Logo Koussané "Hawa Dembaya" Falémé Djélébou Diamou N'tjiba Kotouba Daban Kassaro Bougouni Souba Somo Sido Nongo-Souala Kouoro "Bourem Inaly" Colimbiné Gouméra "Madiga Sacko" Lakamané Diéoura Diema "Diangounté Camara" Béma Fatao Toya Tringa Kremis Konsiga "Kirané Kaniaga" Guidime Fanga "Diafounou Gory" "Nioro" Yéréré Simbi Sandaré "Koréra Koré" Guétéma Gogui Gavinané Diarra Diabigué Baniéré Koré Toukoroba Sebete "Madina Sacko" Kiban Duguwolowula "Ben Kadi" Banamba Toubacoro Karan Nouga Narena "Balan Bakama" Benkadi Kati Siby Ouélessébougou Konodimini Kéléya Danou Kabarasso Niantjila Nioumakana Kalifabougou Doubabougou "Dio Gare" Diébougou Bougoula Moribabougou Tioribougou Ouolodo Nossombougou Nonkon Massantola Kolokani Koulikoro Yinindougou Ségou "Sanankoro Djitoumou" "Wassoulou Balle" Zangasso "Diouradougou Kafo" Banco Zan Coulibaly N'golobougou Kerela Dégnékoro Binko Ouagadou "Niamana Nara" Koronga Guiré Guéneibe Gouanan Tiélé Kémékafo "Sere Moussa Ani Samo de Siékorolé" Koumankou Dièbè Jékafo Nangola Fallou Dogofry Dilly Dabo Allahina Boron Bladié-Tièmala Faragouaran Monimpébougou Macina Kolongo "Kokry Centre" Folomana "Boky Were" Tominian Djenné Pondori "Néma Badenyakafo" Madiama Derrary Douentza Tedie Mondoro Korarou Kéréna Hombori Hairé Gandamia Djaptodji Dianwély Débéré "Dangol Boré" Mopti Sasalbe Zantiébougou Kolélé Mandé Yoro Madougou Koro "Koporokendie Na" "Koporo Pen" Kassa "Dougouténé II" "Dougouténé I" Diougani Dinangourou Diankabou Bondo Ouonkoro Sokoura Tori Baye Diallassagou "Koulogon Habé" Ségué Soubala Bankass "Dimbal Habé" "Kani Bozon" Bandiagara Timiri Soroly Sangha "Pignari Bana" Pignari "Lowol Guéou" Kendié Dourou "Dogani Béré" "Bara Sara" "Ségué Iré" Youwarou N'dodjiga Farimaké Dongo "Bimbéré Tama" Ténenkou Toguére-Coumbe Togoro Kotia Sougoulbe Diondiori Diaka Dianké Fittouga Koumaïra Léré Souboundou Soumpi Ber Défina Dangha Haibongo Kirchamba Kondi Sareyamou Diré Tilemsi Bintagoungou Douékire Essakane Kaneye M'bouna Razelma Dombia "Souransan Tomoto" Séféto Nord Koussan "Kita Nord" Koniakary Marintoumania "Maréna Diombougou" Khouloum Karakoro Kouroulamini Farédiélé Dougoufié "Sama Foulala" Benkadi Gory Gopéla Sansankidé Guédébiné Grouméra Gomitradougou Fassoudebé Lambidou Soumpou Marekaffo Gory "Diafounou Diongaga" Youri Troungoumbé "Nioro Tougouné Rangaba" "Kadiaba Kadiel" Diaye Coura Sangarébougou Farako Alafia Dialakorodji Diago Dombila Sébougou Diganibougou N'golonianasso Fagui Tella Wacoro Diouman Kilidougou N'golodiana "Syen Toula" Tagandougou Sinkolo Dolendougou Benkadi "Fakolo" "Gouadji Kao" "Karagouana Mallé" Koningué Logouana Nafanga Nampé N'goutjina Sincina "Songo Doubacoro" Sorobasso Tao Zanina Bougoula Zanférébougou Tiankadi "Sokourani Missirikoro" Sanzana Pimperna Dialakoro Yallankoro-Soloba "Menamba I" Tesserla Yeredon Saniona Toridaga Ko Diakourouna Djéguena Karaba Niamana N'torosso Sourountouna Téné Waki Kassorola Kaniégue Diéli Koulandougou Samabogo Tiemena Sakoiba Pelengana N'gara Markala "Farakou Massa" Dougabougou Diouna Dioro Diédougou Tongué Matomo Benena Fangasso Koula Mafouné Ouan Mandiakuy Lanfiala Ouroun Diou Kai Garalo Domba Sankarani Kaniogo Maramandougou Minidian Diedougou Nimbougou Zégoua "Gouadié Sougouna" "Kafo Faboli" Kapala Kolonigué Kouniana Miena M'pessoba N'tossoni Songoua Yognogo Zanfigué Fakola Konina Diédougou Zebala Kébila Ména Natien N'tjikouna Missirikoro Miria Kourouma Kolokoba Kofan Kléla Dindanko Madina Faraba "Tiakadougou Dialakoro" Baya Séléfougou N'dlondougou Dogoni Dembela Kignan Kapolondougou Kapala Gongasso Farakala Doumanaba Blendio Finkolo Bolo-Fouta Djallon-Foula Boura Karangana "Kiffosso I" Koumbia Koury Guémoukouraba Dianguirdé "Dioumara Koussata" Sagabala Didiéni "Djiguiya De Koloni" Mahou Ourikela Yorosso Konobougou Kalake Baraouéli Pogo Kava Yiridougou "Sébécoro I" Guihoyo Beguene Bla Diaramana Dougouolo Kazangasso Kemeni Niala Somasso Yangasso Togou Soignébougou Sibila Sansanding N'koumandougou Massala Kourouba Bancoumana Niagadina Kamiandougou Boussin Bellen Baguindabougou Souleye Sana Saloba "Ouro Ali" "Dandougou Fakala" Pétaka "Koubéwel Koundia" Dallah Kounari Konna Fatoma Dialloube Borondougou Bassirou Kola Sanankoroba Youdiou "Pel Maoude" Barapireli Bamba "Lessagou Habé" Wadouba Pélou Ondougou Métoumou Kendé Doucoumbo Dandoli Borko "Ouro Guire" "Ouro Ardo" Diafarabé Kalabancoro Dogodouman "Commune IV" Salam Arham "Bourem Sidi Amar" Garbakoira Tinguereguif Adarmalane Doukouria Issa Béry Télé Tin Aicha Goundam "Bambara Maoudé" Banikane Gouandiaka "Commune III" "Commune II" "Commune VI" Rharous Sérere Gossi Tombouctou Ansongo Bourem Ménaka Andéramboukane Anchawadi Gao Anefif Kidal Abéïbara Tessalit Tin Essako Guégnéka Talataye Lafia Tonka Tindirma Binga "Banikane Narhawa" Tiongui Loulouni Fourou Kaladougou Diamnati N'gorkou Ouroube Doude Dirma Déboye Nampalari Dialafara Gounfan Kassama "Finkolo Ganadougou" Lobougoula Nangalasso Fion Niansanari Soye Femaye Koundian Mahina Kéniéba Zaniena Miniko Tousseguela Kolosso Faléa Dabia Faraba Kobri Diokeli Bamafélé Koumantou Débélin Kolondiéba San Kokofata Koulou Kouroukoto Djidian Sébékoro Wola Massigui Waténi "Gadougou II" "Benkadi Founia" Senko Sirakoro Tambaga "Dinlin Oualia" Toukoto Séféto Ouest Kourounikoto Saboula "Namala Guimba" "Commune I" Tarkint Téméra Inékar Tessit N'tillit Bourra Tin Hama Tidermène Bara "Sony Aliber" Gabéro Tilemsi Gounzoureye Essouk Sanso Bendougouba Boudofo "Kita Ouest" Koutiala Kareri Sokolo Diabaly Doumba Yélékedougou Farako N'garadougou "Baguinéda Camp" Tienfala Gouendo Falo Sanando N'gassola Diena Mariko Niono Kéwa Niantaga Koromo Moribila Danderesso Fama Kafouziela Sikasso Kaboila Sirakorola Sony Kadiana Dialakoroba Touna Katiéna Korodougou Fani Fatine Sibirila Kadiolo Misséni "Kéméné Tambo" "Commune V" Alzounoub Hamzakoma Inadiatafane Ouinerden Ouattagouna Bamba Taboye Boghassa Tinzawatène Adjelhoc Timtaghene Ténindougou Haribomo Tienkour Korombana Dogofry Kambila N'gabacoro Droit Méguétan Saminé "Sirifila Boundy" "Kala Siguida" Siribala Togué Mourari "Ouro Modi" Koubaye Socoura Tourakolomba Diomaténé Zangaradougou Koula "Guidimakan Keri Kaff" Cinzana N'goa Siadougou Dioumaténé Somankidy "Samé Diomgoma" Bangassi "Liberté Dembaya" Niasso Sy Ouolon Teneni Baramandougou Sio Fakala Somo Dah Yasso Sanékuy Diora Timissa Konséguéla Gargando Niéna Safo Méridiéla Dogo"


// Identify commune name with space
gen IF_SPACE=strrpos(commune, " ")>0
tab commune if IF_SPACE==1

gen commune_vallab=commune
replace commune_vallab=ustrregexra(commune_vallab, "Tenenkou Central", "Tenenkou")
replace commune_vallab=ustrregexra(commune_vallab, "commune de Menaka", "Menaka")
replace commune_vallab=ustrregexra(commune_vallab, "commune de menaka", "menaka")
replace commune_vallab=ustrregexra(commune_vallab, "Niamana de Nara", "Niamana Nara")
replace commune_vallab=ustrregexra(commune_vallab, "Koula de Tominian", "Tominian")
replace commune_vallab=ustrregexra(commune_vallab, "Anouzagrene kal talataye", "talataye")
replace commune_vallab=ustrregexra(commune_vallab, "Anouzagrene kal talaytette", "talataye")
replace commune_vallab=ustrregexra(commune_vallab, "Kiffosso 1", "Kiffosso I")
replace commune_vallab=ustrregexra(commune_vallab, "Gadougou 2", "Gadougou I")
replace commune_vallab=ustrregexra(commune_vallab, "anouzagrene", "talataye")
replace commune_vallab=ustrregexra(commune_vallab, "Anouzagrene", "talataye")

replace commune_vallab=ustrregexra(commune_vallab, "Anderamboukane", "Andéramboukane")
replace commune_vallab=ustrregexra(commune_vallab, "Anderanboukane", "Andéramboukane")
replace commune_vallab=ustrregexra(commune_vallab, "Anderamboukane", "Andéramboukane")
replace commune_vallab=ustrregexra(commune_vallab, "anderaboukane", "Andéramboukane")
replace commune_vallab=ustrregexra(commune_vallab, "Baguineda-Camp", "Baguinéda Camp")
replace commune_vallab=ustrregexra(commune_vallab, "Dangol-Bore" , "Dangol Boré")
replace commune_vallab=ustrregexra(commune_vallab, "Derary", "Derrary")
replace commune_vallab=ustrregexra(commune_vallab, "Haïbongo", "Haibongo")

replace commune_vallab=ustrregexra(commune_vallab, "Niafunké", "Léré")
replace commune_vallab=ustrregexra(commune_vallab, "Oualia", "Dinlin Oualia")
replace commune_vallab=ustrregexra(commune_vallab, "Ouattagoun", "Ouattagouna")
replace commune_vallab=ustrregexra(commune_vallab, "Koulogon H", "Koulogon Habé")
replace commune_vallab=ustrregexra(commune_vallab, "Sere Moussa Ani Samo", "Sere Moussa Ani Samo de Siékorolé")
replace commune_vallab=ustrregexra(commune_vallab, "Sitakilly", "Sitakily")
replace commune_vallab=ustrregexra(commune_vallab, "soboundou", "Souboundou")
replace commune_vallab=ustrregexra(commune_vallab, "sonyaliber", "Sony Aliber")
replace commune_vallab=ustrregexra(commune_vallab, "tallouma2", "Ménaka")
replace commune_vallab=ustrregexra(commune_vallab, "wassoulou-balle", "Wassoulou Ballé")
replace commune_vallab=ustrregexra(commune_vallab, "Tinessako", "Tin Essako")

replace commune_vallab=ustrregexra(commune_vallab, "Marekafo", "Marekaffo")

/*
replace commune_vallab=ustrregexra(commune_vallab, "Sitakilly", "Sitakily")
replace commune_vallab=ustrregexra(commune_vallab, "soboundou", "Souboundou")
replace commune_vallab=ustrregexra(commune_vallab, "sonyaliber", "Sony Aliber")

*/
replace commune_vallab=ustrregexra(commune_vallab, " ", "")
replace commune_vallab=ustrregexra(strlower(ustrregexra (ustrnormalize( commune_vallab, "nfd" ) , "\p{Mark}", "" )), " ", "")


gen ADM3_NAME=""
foreach  x  in `ADM3' {
*	di strlower("`x'")
*	di "`x'"
    scalar y=ustrregexra(strlower(ustrregexra (ustrnormalize( "`x'", "nfd" ) , "\p{Mark}", "" )), " ", "")
	disp y
 	replace ADM3_NAME="`x'" if strrpos(commune_vallab, y)>0 
}

replace ADM3_NAME="Baraouéli" if  commune_vallab=="baroueli" 
replace ADM3_NAME="Rharous" if  commune_vallab=="gourma-ras" 
replace ADM3_NAME="Rharous" if  commune_vallab=="gourmararousse" 
replace ADM3_NAME="Tin Essako" if  commune_vallab=="intadjedite" 
replace ADM3_NAME="Tin Essako" if  commune_vallab=="intedjedite" 
replace ADM3_NAME="Nara" if  commune_vallab=="nara" 
replace ADM3_NAME="Néma Badenyakafo" if  commune_vallab=="nema-badenyakafo" 
replace ADM3_NAME="Souboundou" if  commune_vallab=="soboundou" 
replace ADM3_NAME="Ménaka" if  commune_vallab=="tallouma2" 
replace ADM3_NAME="Wassoulou Balle" if  commune_vallab=="wassoulou-balle" 
replace ADM3_NAME="Yélékedougou" if  commune_vallab=="yelekebougou" 
replace ADM2_NAME="Anderamboukane" if commune_vallab=="anderamboukane" 
replace ADM2_NAME="Dioila" if commune_vallab=="Binko"
replace ADM2_NAME="Bafoulabe" if commune_vallab=="diakon"
replace ADM2_NAME="Kati" if commune_vallab=="dialakorodji"
replace ADM2_NAME="Ségou" if commune_vallab=="Diouna" 
replace ADM2_NAME="Koro" if commune_vallab=="dougouteneii"
replace ADM2_NAME="Kolondieba" if commune_vallab=="fakola"
replace ADM2_NAME="Koutiala" if commune_vallab=="fakolo"
replace ADM2_NAME="Diéma" if commune_vallab=="fatao" 
replace ADM2_NAME="Tin-Essako" if commune_vallab=="intadjedite"
replace ADM2_NAME="Tin-Essako" if commune_vallab=="intadjedite"
replace ADM2_NAME="Sikasso" if commune_vallab=="kabarasso"
replace ADM2_NAME="Sikasso" if commune_vallab=="kapolondougou"
replace ADM2_NAME="Kita" if commune_vallab=="kassaro"
replace ADM2_NAME="Kolokani" if commune_vallab=="kolokani" 
replace ADM2_NAME="Nioro" if commune_vallab=="korerakore"
replace ADM2_NAME="Koro" if commune_vallab=="koro"
replace ADM2_NAME="Kita" if commune_vallab=="kotouba"
replace ADM2_NAME="Bla" if commune_vallab=="koulandougou"
replace ADM2_NAME="Bankass" if commune_vallab=="koulogonh"
replace ADM2_NAME="Kita" if commune_vallab=="kourouninkoto"
replace ADM2_NAME="Koutiala" if commune_vallab=="logouana"
replace ADM2_NAME="Yélimané" if commune_vallab=="marekafo"
replace ADM2_NAME="Kati" if commune_vallab=="n'gabacoro"
replace ADM2_NAME="Nara" if commune_vallab=="nara"
replace ADM2_NAME="Djenné" if commune_vallab=="nema-badenyakafo"
replace ADM2_NAME="Kolokani" if commune_vallab=="Nonkon"
replace ADM2_NAME="Kati" if commune_vallab=="sangarebougou"
replace ADM2_NAME="Macina" if commune_vallab=="sana"
replace ADM2_NAME="Sikasso" if commune_vallab=="sikasso"
replace ADM2_NAME="Kéniéba" if commune_vallab=="sitakily"
replace ADM2_NAME="Ansongo" if commune_vallab=="talataye"
replace ADM2_NAME="Ténenkou" if commune_vallab=="tenenkou"
replace ADM2_NAME="Diré" if commune_vallab=="Tindirma"
replace ADM2_NAME="Yanfolila" if commune_vallab=="yallankoro-soloba"
replace ADM2_NAME="Kati" if commune_vallab=="yelekebougou"
replace ADM2_NAME="Baraouéli" if commune_vallab=="baroueli"

replace ADM3_NAME="Sere Moussa Ani Samo de Siékorolé" if commune_vallab=="seremoussaanisamodesiekorole"
replace ADM3_NAME="Binko" if commune_vallab=="binko"
replace ADM3_NAME="Sony Aliber" if commune_vallab=="sonyaliber"
replace ADM3_NAME="Diakon" if commune_vallab=="diakon"
replace ADM3_NAME="Dialakorodji" if commune_vallab=="dialakorodji"
replace ADM3_NAME="Diouna" if commune_vallab=="diouna"
replace ADM3_NAME="Dougouténé II" if commune_vallab=="dougouteneii"
replace ADM3_NAME="Fakola" if commune_vallab=="fakola"
replace ADM3_NAME="Fakolo" if commune_vallab=="fakolo"
replace ADM3_NAME="Fatao" if commune_vallab=="fatao"
replace ADM3_NAME="Kabarasso" if commune_vallab=="kabarasso"
replace ADM3_NAME="Kapolondougou" if commune_vallab=="kapolondougou"
replace ADM3_NAME="Kassaro" if commune_vallab=="kassaro"
replace ADM3_NAME="Kolokani" if commune_vallab=="kolokani"
replace ADM3_NAME="Koréra Koré" if commune_vallab=="korerakore"
replace ADM3_NAME="Koro" if commune_vallab=="koro"
replace ADM3_NAME="Kotouba" if commune_vallab=="kotouba"
replace ADM3_NAME="Koulandougou" if commune_vallab=="koulandougou"
replace ADM3_NAME="Koulogon Habé" if commune_vallab=="koulogonhabe"
replace ADM3_NAME="Kourounikoto" if commune_vallab=="kourouninkoto"
replace ADM3_NAME="Logouana" if commune_vallab=="logouana"
replace ADM3_NAME="N'gabacoro Droit" if commune_vallab=="n'gabacoro"
replace ADM2_NAME="Kati" if commune_vallab=="n'gabacoro"

replace ADM3_NAME="Nonkon" if commune_vallab=="nonkon"
replace ADM3_NAME="Sana" if commune_vallab=="sana"
replace ADM3_NAME="Sangarébougou" if commune_vallab=="sangarebougou"
replace ADM3_NAME="Ténenkou" if commune_vallab=="tenenkou"
replace ADM3_NAME="Tiemena" if commune_vallab=="tiemena"
replace ADM3_NAME="Tindirma" if commune_vallab=="tindirma"
replace ADM3_NAME="Tin Essako" if commune_vallab=="tinessako"
replace ADM3_NAME="Yallankoro-Soloba" if commune_vallab=="yallankoro-soloba"

replace ADM3_NAME="Talataye" if commune_vallab=="commune"

collapse (firstnm) region prefecture commune_vallab ADM2_NAME ADM3_NAME, by(hhid grappe menage )

save "${Inputs_EHCVM_MLI}\MLI_HDX_ADM3_EHCVM.dta", replace


***Import HDX data
import excel "${Inputs_Shapefiles}\mli_adminboundaries_tabulardata.xlsx", sheet("Admin3") firstrow clear
keep if OBJECTID!=.
count
keep admin3Name_fr admin3Pcode  admin2Name_fr admin2Pcode admin1Name_fr admin1Pcode admin0Name_fr admin0Pcode

ren admin3Name_fr  ADM3_NAME
ren admin2Name_fr ADM2_NAME

merge 1:m ADM2_NAME ADM3_NAME using "${Inputs_EHCVM_MLI}\MLI_HDX_ADM3_EHCVM.dta"

ren admin3Pcode ADM3_CODE 
ren admin2Pcode ADM2_CODE
ren admin1Name_fr ADM1_NAME
ren admin1Pcode ADM1_CODE

ren admin0Name_fr ADM0_NAME
ren admin0Pcode ADM0_CODE
ren region Region_EHCVM 
ren prefecture Departement_EHCVM
ren commune_vallab Commune_EHCVM
keep  ADM3_NAME ADM3_CODE ADM2_NAME ADM2_CODE ADM1_NAME ADM1_CODE ADM0_NAME ADM0_CODE hhid grappe menage Region_EHCVM Departement_EHCVM Commune_EHCVM
save "${Inputs_EHCVM_MLI}\MLI_HDX_ADM3_EHCVM_Matching.dta", replace


<<<<<<< Updated upstream




=======
******************************************************************** Senegal
*EHCVM
clear all
use "${Inputs_EHCVM_SEN}\ehcvm_individu_sen2021.dta", clear

*** ADM1 in HDX to EHCVM ADM1
local ADM1 "Dakar Diourbel Fatick Kaffrine Kaolack Kédougou Kolda Louga Matam Saint-Louis Sédhiou Tambacounda Thiès Ziguinchor"

foreach x in region {
	local `x'_lab: variable label `x' // #1 from above
	gen strL `x'_vallab = "" // start of #3
	label variable `x'_vallab "``x'_lab' string"
	levelsof `x', local(valrange)
	foreach n of numlist `valrange' { 
		local `x'_vallab_`n': label (`x') `n' // #2 from above
		replace `x'_vallab = "``x'_vallab_`n''" if `x' == `n' // end of #3
	}
}

// we can also decode command
//decode  region, gen (region_vallab)

gen Region=""
replace region_vallab=strlower(region_vallab)
foreach  x  in `ADM1' {
	di strlower("`x'")
	di "`x'"
 	replace Region="`x'" if strrpos(region_vallab, strlower(ustrregexra( ustrnormalize( "`x'", "nfd" ) , "\p{Mark}", "" ) ))>0 |  strrpos(region_vallab, "`x'")>0
}
tab region_vallab if Region==""



*** ADM3 in HDX to EHCVM ADM3
local ADM3 "Almadies "Grand Dakar"	"Parcelles Assainies"	"Dakar Plateau"	Guédiawaye	Thiaroye "Pikine Dagoudane"	Sangalkam	Rufisque-Est	Diamniadio	Jaxaay	Malika	Yeumbeul	Lambaye	Ngoye	Baba Garage	Ndoulo	Ndindy	Ndame	Taïf	Kaèl	Ndiob	Fimla	Tataguine	Niakhar	Djilor	Toubakouta	Niodior	Colobane	Ouadiour	Mabo	Keur Mboucki	Gnibi	Katakel	Missira Wadène	Ida Mouride	Lour Escale	Darou Minam 2	Sagna	Mbadakhoune	Nguélou	Ngothie	Koumbal	Ndiédiéng	Paoscoto	Wak Ngouna	Médina Sabakh	Bandafassi	Fongolembi	Dar Salam	Dakatéli	Sabodala	Bembou	Mampatim	Saré Bidji	Dioulacolon	Ndorna	Niaming	Fafacourou	Bonconto	Pakour	Saré Coly Sallé	Ndande	Darou Mousty	Sagata Geth	Yang-Yang	Sagata Diolof	Barkédji	Dodji	Keur Momar Sarr	Koki	Mbédiène	Sakal	Ouro Sidi	Orkadiéré	Ogo	Agnam Civol	Vélingara	Ndiaye Ngènt	Mbane	Gamadji Sarré	Thillé Boubakar	Saldé	Cas Cas	Rao	Bona	Bogal	Diaroumé	Simbandi Brassou	Djibanar	Karantaba	Diendé	Djibabouya	Djirédji	Kéniéba	Moudéri	Bellé	Dianké Makan	Koular	Bala	Bouinguel Bamba	Koutiaba Wolof	Bamba Tialène	Missira	Makacoutibantang	Koussanar	Séssène	Sindia	Fissel	Keur Moussa	Thiénaba	Noto	Niakhène	Pambal	Méouane	Mérina Dakhar	Kataba 1	Tanghori	Tendouck	Sindian	Loudia Wolof	Cabrousse	Niaguis	Niassia"


foreach char in `ADM3' {
    display "`char'"
}
*tab commune, generate(stubname)

foreach x in commune {
	local `x'_lab: variable label `x' // #1 from above
	gen strL `x'_vallab = "" // start of #3
	label variable `x'_vallab "``x'_lab' string"
	levelsof `x', local(valrange)
	foreach n of numlist `valrange' { 
		local `x'_vallab_`n': label (`x') `n' // #2 from above
		replace `x'_vallab = "``x'_vallab_`n''" if `x' == `n' // end of #3
	}
}


gen Commune=""
foreach  x  in `ADM3' {
*	di strlower("`x'")
*	di "`x'"
    scalar yy=ustrregexra(strlower(ustrregexra (ustrnormalize( "`x'", "nfd" ) , "\p{Mark}", "" )), " ", "")
	disp yy
	replace Commune="`x'" if strrpos(commune_vallab, yy)>0 
}
tab commune_vallab if Commune==""
>>>>>>> Stashed changes
