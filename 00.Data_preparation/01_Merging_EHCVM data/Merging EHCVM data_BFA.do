****************************************** Burkina Faso
****************Merging EHCVM data
clear all
global Inputs_Shapefiles "C:\Users\idiop\OneDrive - CGIAR\020_GithubDesktop\Application-of-Fay-Herriot-Model-for-Burkina-Faso\00.Data\00_Country Shapefiles\Admin3"

global Inputs_EHCVM_BFA "C:\Users\idiop\OneDrive - CGIAR\020_GithubDesktop\Application-of-Fay-Herriot-Model-for-Burkina-Faso\00.Data\EHCVM data\BFA_2021_EHCVM-P_v02_M_Stata"

****************************************** Burkina Faso
use "${Inputs_EHCVM_BFA}\ehcvm_individu_bfa2021.dta", clear

gen x=1
collapse (mean) x , by(country menage region province commune hhid grappe )
*drop x
local ADM2 "Balé	Bam	Banwa	Bazèga	Bougouriba	Boulgou	Boulkiemdé	Comoé	Ganzourgou	Gnagna	Gourma	Houet	Ioba	Kadiogo	Kénédougou	Komandjari	Kompienga	Kossi	Koulpélogo	Kourittenga	Kourwéogo	Léraba	Loroum	Mouhoun	Nahouri	Namentenga	Nayala	Noumbiel	Oubritenga	Oudalan	Passoré	Poni	Sanguié	Sanmatenga	Séno	Sissili	Soum	Sourou	Tapoa	Tuy	Yagha	Yatenga	Ziro	Zondoma	Zoundwéogo"

decode province , gen(province_label)
replace province_label=strlower(province_label)

gen ADM2_NAME=""
foreach  x  in `ADM2' {
*	di strlower("`x'")
*	di "`x'"
 	replace ADM2_NAME="`x'" if strrpos(province_label, strlower(ustrregexra (ustrnormalize( "`x'", "nfd" ) , "\p{Mark}", "" )))>0 
}


*** ADM3 in HDX to EHCVM ADM3
local ADM3  "Ambsouya	Andemtenga	Arbinda	Arbollé	Bagaré	Bagassi	Bagré	Bahn	Bakata	Balavé	Bama	Bana	Bané	Banfora	Bani	Banzon	Baraboulé	Barani	Barga	Barsalogho	Bartiébougou	Baskouré	Bassi	Batié	Béguédo	Békui	Béré	Béréba	Bérégadougou	Bieha	Bilanga	Bindé	Bingo	Bissiga	Bitou	Boala	Bobo-Dioulasso	Bogandé	Boken	Bomborokui	Bondokui	Boni	Boromo	Botou	Boudri	Bougnounou	Boulsa	Boundoré	Boura	Bourasso	Bouroum	Bouroum-Bouroum	Bourzanga	Boussé	Bousséra	Boussou	Boussou-Koula	Boussouma	Boussouma	Dablo	Dakôrô	Dalô	Dandé	Dano	Dapeolgo	Dargo	Dassa	Dédougou	Déou	Di	Diabo	Dialgaye	Diapaga	Diapangou	Didyr	Diébougou	Diguel	Dissihn	Djibasso	Djibo	Djigouè	Djigouèra	Dokui	Dolo	Dori	Doulougou	Doumbala	Douna	Douroula	Dourtenga	Fada-Ngourma	Falagountou	Fara	Faramana	Fo	Founzan	Foutouri	Gaô	Gaongo	Gaoua	Garango	Gassan	Gayéri	Gbomblora	Gbondjigui	Godyr	Gogo	Gomboro	Gomboussougou	Gomponsom	Gorgadji	Gorom-Gorom	Gossina	Gounguen	Goursi	Guéguéré	Guiaro	Guiba	Guibaré	Houndé	Imasgho	Iôlôniôrô	Ipelsé	Kaïn	Kalsaka	Kampti	Kando	Kangala	Kankalaba	Kantchari	Karangasso-Sambla	Karangasso-Vigué	Kassou	Kassoum	Kaya	Kayan	Kayao	Kelbo	Kiembara	Kindi	Kirsi	Koala	Kogho	Kokologo	Kôlôkô	Kombissiri	Kombori	Komin-Yanga	Komki-Ipala	Kompienga	Komsilga	Komtoèga	Kona	Kongoussi	Koper	Kordié	Korsimoro	Kossouka	Koti	Koubri	Koudougou	Kougny	Kouka	Koumbia	Koumbri	Koundougou	Koupèla	Kourinion	Kourouma	Koutougou	Kpuéré	Kyon	La-Toden	Lalgaye	Lanfièra	Lankoué	Laye	Lèba	Legmoin	Lèna	Léo	Liptougou	Lôgbou	Loropéni	Loumana	Loumbila	Madjoari	Madouba	Malba	Mané	Manga	Mangodara	Mani	Mansila	Markoye	Matiakoali	Mégué	Midebdo	Môgtédo	Morlaba	Moussodougou	Nagbingou	Nagréongo	Nako	Namissiguima	Namissiguima	Namouno	Nandiala	Nanoro	Nasséré	Nassoumbou	Ndôrôla	Nébiélianayou	Niabouri	Niangoloko	Niankôrôdougou	Niaogho	Niégo	Niou	Nobéré	Nouna	Orodara	Oronkua	Ouagadougou	Ouahigouya	Ouargaye	Ouarkoye	Ouéléni	Ouéssa	Ouindigui	Oula	Ouô	Ourgou-Manéga	Ouri	Oursi	Pâ	Pabré	Padéma	Pama	Partiaga	Pella	Péni	Pensa	Périgban	Pibaoré	Piéla	Pilimpikou	Pissila	Po	Poa	Pobé-Mengao	Pompoï	Pouni	Poura	Pouytenga	Rambo	Ramongo	Réo	Rollo	Roukô	Saaba	Sabou	Sabsé	Safané	Samba	Sami	Samôgôgouan	Samôgôyiri	Sampelga	Sanaba	Sangha	Saolgo	Saponé	Sapouy	Satiri	Sebba	Senguènèga	Seytenga	Siby	Sidéradougou	Siglé	Silly	Sindo	Sindou	Soa	Solenzo	Solhan	Sollé	Sônô	Soubakaniédougou	Soudougui	Sourgou	Sourgoubila	Tambaga	Tangaye	Tanguen-Dassouri	Tankougounadié	Tansarga	Tansila	Tchériba	Ténado	Tenkodogo	Tensobentenga	Thion	Thiou	Thiou	Tiankoura	Tibga	Tiébélé	Tiéfora	Tikaré	Tin-Akoff	Titabè	Titao	To	Toécé	Toèguen	Toéni	Toma	Tongomayel	Tougan	Tougo	Tougouri	Toussiana	Wolonkoto	Yaba	Yaho	Yako	Yalgo	Yamba	Yargatenga	Yargo	Yé	Yondé	Zabré	Zam	Zambo	Zamo	Zawara	Zecco	Zéguédéguen	Ziga	Zimtanga	Ziniaré	Ziou	Zitenga	Zoaga	Zogoré	Zonsé	Zôrgho	Zoungou"

gen IF_SPACE=strrpos(commune, " ")>0
tab commune if IF_SPACE==1

gen commune_vallab=commune
replace commune_vallab=ustrregexra(commune_vallab, " ", "")
replace commune_vallab=ustrregexra(strlower(ustrregexra (ustrnormalize( commune_vallab, "nfd" ) , "\p{Mark}", "" )), " ", "")


gen ADM3_NAME=""
gen len=strlen(commune_vallab)
foreach  x  in `ADM3' {
*	di strlower("`x'")
*	di "`x'"
    scalar y=ustrregexra(strlower(ustrregexra (ustrnormalize( "`x'", "nfd" ) , "\p{Mark}", "" )), " ", "")
	disp y
 	replace ADM3_NAME="`x'" if strrpos(commune_vallab, y)>0 & len==strlen(y)
}
replace ADM3_NAME="Bahn" if commune=="Banh"
replace ADM3_NAME="Békui" if commune=="Bekuy"
replace ADM3_NAME="Boken" if commune=="Bokin"
replace ADM3_NAME="Bondokui" if commune=="Bondokuy"
replace ADM3_NAME="Boni" if commune=="Bony"
replace ADM3_NAME="Boudri" if commune=="Boudry"
replace ADM3_NAME="Kassou" if commune=="Cassou"
replace ADM3_NAME="Koala" if commune=="Coalla"
replace ADM3_NAME="Komin-Yanga" if commune=="Comin-Yanga"
replace ADM3_NAME="Dapeolgo" if commune=="Dapelogo"
replace ADM3_NAME="Fada-Ngourma" if commune=="Fada N'gourma"
replace ADM3_NAME="Gounguen" if commune=="Gounghin"
replace ADM3_NAME="Goursi" if commune=="Gourcy"
replace ADM3_NAME="Ipelsé" if commune=="Ipelce"
replace ADM3_NAME="Karangasso-Sambla" if commune=="Karankasso Sambla"
replace ADM3_NAME="Karangasso-Vigué" if commune=="Karankasso-Vigue"
replace ADM3_NAME="Lôgbou" if commune=="Logobou"
replace ADM3_NAME="Morlaba	" if commune=="Morolaba"
replace ADM3_NAME="Ndôrôla" if commune=="N'dorola"
replace ADM3_NAME="Ouri" if commune=="Oury"
replace ADM3_NAME="Sabsé" if commune=="Sabce"
replace ADM3_NAME="Saolgo" if commune=="Salogo"
replace ADM3_NAME="Samôgôgouan" if commune=="Samorogouan"
replace ADM3_NAME="Sangha" if commune=="Sanga"
replace ADM3_NAME="Senguènèga" if commune=="Seguenega"
replace ADM3_NAME="Arbollé" if commune=="Arbole"
replace ADM3_NAME="Ouagadougou" if commune=="Ardt De Baskuy"
replace ADM3_NAME="Ouagadougou" if commune=="Ardt De Bogodogo"
replace ADM3_NAME="Ouagadougou" if commune=="Ardt De Boulmiougou"
replace ADM3_NAME="Ouagadougou" if commune=="Ardt De Nongremassom"
replace ADM3_NAME="Ouagadougou" if commune=="Ardt De Sig-Noghin"
replace ADM3_NAME="Bitou" if commune=="Bittou"
replace ADM3_NAME="Bobo-Dioulasso" if commune=="Bobo Dioulasso"
replace ADM3_NAME="Bobo-Dioulasso" if commune=="Bobo Dioulasso-Dafra"
replace ADM3_NAME="Bobo-Dioulasso" if commune=="Bobo Dioulasso-DÃ´"
replace ADM3_NAME="Bobo-Dioulasso" if commune=="Bobo Dioulasso-Dô"
replace ADM3_NAME="Bobo-Dioulasso" if commune=="Bobo Dioulasso-Konsa"
replace ADM3_NAME="Dissihn" if commune=="Dissin"
replace ADM3_NAME="Kokologo" if commune=="Kokoloko"
replace ADM3_NAME="Kourinion" if commune=="Kourignon"
replace ADM3_NAME="Mégué" if commune=="Meguet"
replace ADM3_NAME="Pâ" if commune=="PÃ´"
replace ADM3_NAME="Tanguen-Dassouri" if commune=="Tanghin Dassouri"
replace ADM3_NAME="Toèguen" if commune=="Toeghin"
replace ADM3_NAME="Bobo Dioulasso" if commune=="Arrondissement N 4"


collapse (firstnm) region province_label commune_vallab ADM2_NAME ADM3_NAME, by(hhid grappe menage )

save "${Inputs_EHCVM_BFA}\BFA_HDX_ADM3_EHCVM.dta", replace


***Import HDX data
import excel "${Inputs_Shapefiles}\bfa_adminboundaries_tabulardata.xlsx", sheet("ADM3") firstrow clear
count
keep admin3Name_fr admin3Pcode  admin2Name_fr admin2Pcode admin1Name_fr admin1Pcode admin0Name_fr admin0Pcode
