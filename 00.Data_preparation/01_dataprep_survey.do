**************************************
*This dofile prepares data from BFA EHCVM 2021 for
* small area estimation
*****************************************
clear all

set more off

version 14




// [aw=hhweight_panel]
*===============================================================================
//Specify team paths 
*===============================================================================

global main          "C:\Users\AHema\OneDrive - CGIAR\Desktop\Poverty Mapping\Small area estimation\Burkina Faso\Application of Fay-Herriot Model for Burkina Faso"
global data       	"$main\00.Data"



*===============================================================================
//ehcvm_welfare_2b_bfa2021.dta 
*===============================================================================

use "$data\input\BFA_2021_EHCVM-P_v02_M_Stata\ehcvm_welfare_2b_bfa2021.dta",clear


tabulate  region, gen(region)
tabulate  milieu, gen(milieu)
tabulate  hgender, gen(hgender)
tabulate  hmstat, gen(hmstat)
tabulate  hreligion, gen(hreligion)
tabulate  hnation, gen(hnation)
tabulate  hethnie, gen(hethnie)
rename    halfa2 halfa_2
tabulate  halfa, gen(halfa)
//tabulate  halfa2, gen(halfa2)
tabulate  heduc, gen(heduc)
tabulate  hdiploma, gen(hdiploma)
tabulate  hhandig, gen(hhandig)
tabulate  hactiv7j, gen(hactiv7j)
tabulate  hactiv12m, gen(hactiv12m)
tabulate  hbranch, gen(hbranch)
tabulate  hsectins, gen(hsectins)
tabulate  hcsp, gen(hcsp)


gen adm1_pcode ="."
replace adm1_pcode = "BF46" if region == 1
replace adm1_pcode = "BF47" if region == 2
replace adm1_pcode = "BF13" if region == 3
replace adm1_pcode = "BF48" if region == 4
replace adm1_pcode = "BF49" if region == 5
replace adm1_pcode = "BF50" if region == 6
replace adm1_pcode = "BF51" if region == 7
replace adm1_pcode = "BF52" if region == 8
replace adm1_pcode = "BF53" if region == 9
replace adm1_pcode = "BF54" if region == 10
replace adm1_pcode = "BF55" if region == 11
replace adm1_pcode = "BF56" if region == 12
replace adm1_pcode = "BF57" if region == 13


save "$data\survey_ehcvm_bfa_2021.dta",replace

*===============================================================================
//ehcvm_menage_bfa2021.dta 
*===============================================================================

use "$data\input\BFA_2021_EHCVM-P_v02_M_Stata\ehcvm_menage_bfa2021.dta",clear

tabulate  logem, gen(logem)
tabulate  mur, gen(mur)
tabulate  toit, gen(toit)
tabulate  sol, gen(sol)
tabulate  eauboi_ss, gen(eauboi_ss)
tabulate  eauboi_sp, gen(eauboi_sp)
tabulate  elec_ac, gen(elec_ac)
tabulate  elec_ur, gen(elec_ur)
tabulate  elec_ua, gen(elec_ua)
tabulate  ordure, gen(ordure)
tabulate  toilet, gen(toilet)
tabulate  eva_toi, gen(eva_toi)
tabulate  eva_eau, gen(eva_eau)
tabulate  tv, gen(tv)
tabulate  fer, gen(fer)
tabulate  frigo, gen(frigo)
tabulate  cuisin, gen(cuisin)
tabulate  ordin, gen(ordin)
tabulate  decod, gen(decod)
tabulate  car, gen(car)
tabulate  sh_id_demo, gen(sh_id_demo)
tabulate  sh_co_natu, gen(sh_co_natu)
tabulate  sh_co_eco, gen(sh_co_eco)
tabulate  sh_id_eco, gen(sh_id_eco)
tabulate  sh_co_vio, gen(sh_co_vio)
tabulate  sh_co_oth, gen(sh_co_oth)


merge 1:1 hhid using "$data\survey_ehcvm_bfa_2021.dta"

drop  _merge

save "$data\survey_ehcvm_bfa_2021.dta",replace


*===============================================================================
//ehcvm_individu_bfa2021.dta 
*===============================================================================

use "$data\input\BFA_2021_EHCVM-P_v02_M_Stata\ehcvm_individu_bfa2021.dta",clear

tabulate  resid, gen(resid)
tabulate  sexe, gen(sexe)
tabulate  lien, gen(lien)
tabulate  mstat, gen(mstat)
tabulate  religion, gen(religion)
tabulate  ethnie, gen(ethnie)
tabulate  nation, gen(nation)
tabulate  mal30j, gen(mal30j)
tabulate  aff30j, gen(aff30j)
tabulate  arrmal, gen(arrmal)
tabulate  hos12m, gen(hos12m)
tabulate  couvmal, gen(couvmal)
tabulate  handit, gen(handit)
rename alfa2 alfa_2
tabulate  alfa, gen(alfa)
//tabulate  alfa2, gen(alfa2)
tabulate  educ_scol, gen(educ_scol)
tabulate  educ_hi, gen(educ_hi)
tabulate  diplome, gen(diplome)
tabulate  telpor, gen(telpor)
tabulate  internet, gen(internet)
tabulate  activ7j, gen(activ7j)
tabulate  activ12m, gen(activ12m)
tabulate  branch, gen(branch)
tabulate  sectins, gen(sectins)
tabulate  csp, gen(csp)
tabulate  emploi_sec, gen(emploi_sec)
tabulate  sectins_sec, gen(sectins_sec)
tabulate  csp_sec, gen(csp_sec)
tabulate  bank, gen(bank)
tabulate  serviceconsult, gen(serviceconsult)
tabulate  persconsult, gen(persconsult)


save "$data\ehcvm_individu_bfa2021_with_dummy.dta",replace

use "$data\ehcvm_individu_bfa2021_with_dummy.dta", clear

collapse (first) region* (mean) age resid1	resid2	sexe1	sexe2	lien1	lien2	lien3	lien4	lien5	lien6	lien7	lien8	lien9	lien10	lien11	mstat1	mstat2	mstat3	mstat4	mstat5	mstat6	mstat7	religion1	religion2	religion3	religion4	religion5	ethnie1	ethnie2	ethnie3	ethnie4	ethnie5	ethnie6	ethnie7	ethnie8	ethnie9	ethnie10	ethnie11	ethnie12	nation1	nation2	nation3	nation4	nation5	nation6	nation7	nation8	nation9	nation10	nation11	nation12	nation13	nation14	nation15	nation16	mal30j1	mal30j2	aff30j1	aff30j2	aff30j3	aff30j4	aff30j5	aff30j6	aff30j7	aff30j8	aff30j9	aff30j10	aff30j11	aff30j12	aff30j13	aff30j14	aff30j15	aff30j16	aff30j17	arrmal1	arrmal2	hos12m1	hos12m2	couvmal1	couvmal2	handit1	handit2	alfa1	alfa2	educ_scol1	educ_scol2	educ_scol3	educ_scol4	educ_scol5	educ_scol6	educ_scol7	educ_scol8	educ_hi1	educ_hi2	educ_hi3	educ_hi4	educ_hi5	educ_hi6	educ_hi7	educ_hi8	educ_hi9	diplome1	diplome2	diplome3	diplome4	diplome5	diplome6	diplome7	diplome8	diplome9	diplome10	diplome11	telpor1	telpor2	internet1	internet2	activ7j1	activ7j2	activ7j3	activ7j4	activ7j5	activ7j6	activ12m1	activ12m2	activ12m3	activ12m4	branch1	branch2	branch3	branch4	branch5	branch6	branch7	branch8	branch9	branch10	branch11	sectins1	sectins2	sectins3	sectins4	sectins5	sectins6	csp1	csp2	csp3	csp4	csp5	csp6	csp7	csp8	csp9	csp10	emploi_sec1	emploi_sec2	sectins_sec1	sectins_sec2	sectins_sec3	sectins_sec4	sectins_sec5	sectins_sec6	csp_sec1	csp_sec2	csp_sec3	csp_sec4	csp_sec5	csp_sec6	csp_sec7	csp_sec8	csp_sec9	csp_sec10	bank1	bank2	serviceconsult1	serviceconsult2	serviceconsult3	serviceconsult4	serviceconsult5	persconsult1	persconsult2	persconsult3	persconsult4 [aw=hhweight_panel], by(hhid)


merge 1:1 hhid using "$data\survey_ehcvm_bfa_2021.dta"
drop  _merge

save "$data\survey_ehcvm_bfa_2021.dta",replace

use "$data\input\BFA_2021_EHCVM-P_v02_M_Stata\ehcvm_individu_bfa2021.dta",clear

keep hhid province commune
bys hhid: keep if _n==1

merge 1:1 hhid using "$data\survey_ehcvm_bfa_2021.dta"
drop  _merge


gen adm2_pcode ="."
replace adm2_pcode = "BF4601" if province == 31
replace adm2_pcode = "BF4901" if province == 1
replace adm2_pcode = "BF4602" if province == 32
replace adm2_pcode = "BF5101" if province == 2
replace adm2_pcode = "BF5701" if province == 3
replace adm2_pcode = "BF4801" if province == 4
replace adm2_pcode = "BF5001" if province == 5
replace adm2_pcode = "BF4701" if province == 6
replace adm2_pcode = "BF5501" if province == 7
replace adm2_pcode = "BF5201" if province == 8
replace adm2_pcode = "BF5202" if province == 9
replace adm2_pcode = "BF5301" if province == 10
replace adm2_pcode = "BF5702" if province == 33
replace adm2_pcode = "BF1300" if province == 11
replace adm2_pcode = "BF5302" if province == 12
replace adm2_pcode = "BF5203" if province == 34
//replace adm2_pcode = "BF5204" if province == 
replace adm2_pcode = "BF4603" if province == 13
replace adm2_pcode = "BF4802" if province == 36
replace adm2_pcode = "BF4803" if province == 14
replace adm2_pcode = "BF5502" if province == 37
replace adm2_pcode = "BF4702" if province == 38
replace adm2_pcode = "BF5401" if province == 39
replace adm2_pcode = "BF4604" if province == 15
replace adm2_pcode = "BF5102" if province == 16
replace adm2_pcode = "BF4902" if province == 17
replace adm2_pcode = "BF4605" if province == 40
replace adm2_pcode = "BF5703" if province == 41
replace adm2_pcode = "BF5503" if province == 18
replace adm2_pcode = "BF5601" if province == 19
replace adm2_pcode = "BF5402" if province == 20
replace adm2_pcode = "BF5704" if province == 21
replace adm2_pcode = "BF5002" if province == 22
replace adm2_pcode = "BF4903" if province == 23
replace adm2_pcode = "BF5602" if province == 24
replace adm2_pcode = "BF5003" if province == 25
replace adm2_pcode = "BF5603" if province == 26
replace adm2_pcode = "BF4606" if province == 27
replace adm2_pcode = "BF5205" if province == 28
replace adm2_pcode = "BF5303" if province == 42
replace adm2_pcode = "BF5604" if province == 43
replace adm2_pcode = "BF5403" if province == 29
replace adm2_pcode = "BF5004" if province == 44
replace adm2_pcode = "BF5404" if province == 45


/*
adm1_pcode	adm2_pcode	adm3_pcode
BF13	BF1300	BF560104

adm1_pcode	adm2_pcode	adm3_pcode
BF55	BF5501	BF570305

adm1_pcode	adm2_pcode	adm3_pcode
BF56	BF5604	BF560205

adm1_pcode	adm2_pcode	adm3_pcode
BF57	BF5703	BF570405
BF57	BF5704	BF540303
*/
gen adm3_pcode ="."
replace adm3_pcode = "BF480301" if commune == "Andemtenga"
replace adm3_pcode = "BF560301" if commune == "Arbinda"
replace adm3_pcode = "BF540201" if commune == "Arbole"
replace adm3_pcode = "BF130004" if commune == "Ardt De Baskuy"
replace adm3_pcode = "BF130004" if commune == "Ardt De Bogodogo"
replace adm3_pcode = "BF130004" if commune == "Ardt De Boulmiougou"
replace adm3_pcode = "BF130004" if commune == "Ardt De Nongremassom"
replace adm3_pcode = "BF130004" if commune == "Ardt De Sig-Noghin"
replace adm3_pcode = "BF130004" if commune == "Arrondissement N 4"
replace adm3_pcode = "BF460101" if commune == "Bagassi"
replace adm3_pcode = "BF480101" if commune == "Bagre"
replace adm3_pcode = "BF460201" if commune == "Balave"
replace adm3_pcode = "BF530101" if commune == "Bama"
replace adm3_pcode = "BF460102" if commune == "Bana"
replace adm3_pcode = "BF480102" if commune == "Bane"
replace adm3_pcode = "BF470101" if commune == "Banfora"
replace adm3_pcode = "BF560201" if commune == "Banh"
replace adm3_pcode = "BF530201" if commune == "Banzon"
replace adm3_pcode = "BF490301" if commune == "Barsalogho"
replace adm3_pcode = "BF480302" if commune == "Baskoure"
replace adm3_pcode = "BF570301" if commune == "Batie"
replace adm3_pcode = "BF480103" if commune == "Beguedo"
replace adm3_pcode = "BF530301" if commune == "Bekuy"
replace adm3_pcode = "BF510301" if commune == "Bere"
replace adm3_pcode = "BF530302" if commune == "Bereba"
replace adm3_pcode = "BF470102" if commune == "Beregadougou"
replace adm3_pcode = "BF500301" if commune == "Bieha"
replace adm3_pcode = "BF520101" if commune == "Bilanga"
replace adm3_pcode = "BF510302" if commune == "Binde"
replace adm3_pcode = "BF500101" if commune == "Bingo"
replace adm3_pcode = "BF480105" if commune == "Bittou"
replace adm3_pcode = "BF490201" if commune == "Boala"
replace adm3_pcode = "BF530102" if commune == "Bobo Dioulasso"
replace adm3_pcode = "BF530102" if commune == "Bobo Dioulasso-Dafra"
replace adm3_pcode = "BF530102" if commune == "Bobo Dioulasso-DÃ´"
replace adm3_pcode = "BF530102" if commune == "Bobo Dioulasso-Dô"
replace adm3_pcode = "BF530102" if commune == "Bobo Dioulasso-Konsa"
replace adm3_pcode = "BF520102" if commune == "Bogande"
replace adm3_pcode = "BF540204" if commune == "Bokin"
replace adm3_pcode = "BF460401" if commune == "Bondokuy"
replace adm3_pcode = "BF530303" if commune == "Bony"
replace adm3_pcode = "BF460103" if commune == "Boromo"
replace adm3_pcode = "BF520501" if commune == "Botou"
replace adm3_pcode = "BF550101" if commune == "Boudry"
replace adm3_pcode = "BF490202" if commune == "Boulsa"
replace adm3_pcode = "BF500302" if commune == "Boura"
replace adm3_pcode = "BF460303" if commune == "Bourasso"
replace adm3_pcode = "BF490203" if commune == "Bouroum"
replace adm3_pcode = "BF570401" if commune == "Bouroum-Bouroum"
replace adm3_pcode = "BF490101" if commune == "Bourzanga"
replace adm3_pcode = "BF550201" if commune == "Bousse"
replace adm3_pcode = "BF570402" if commune == "Boussera"
replace adm3_pcode = "BF540402" if commune == "Boussou"
replace adm3_pcode = "BF480106" if commune == "Boussouma"
replace adm3_pcode = "BF500403" if commune == "Cassou"
replace adm3_pcode = "BF520103" if commune == "Coalla"
replace adm3_pcode = "BF480201" if commune == "Comin-Yanga"
replace adm3_pcode = "BF570201" if commune == "Dano"
replace adm3_pcode = "BF550302" if commune == "Dapelogo"
replace adm3_pcode = "BF490204" if commune == "Dargo"
replace adm3_pcode = "BF460402" if commune == "Dedougou"
replace adm3_pcode = "BF460601" if commune == "Di"
replace adm3_pcode = "BF520201" if commune == "Diabo"
replace adm3_pcode = "BF480303" if commune == "Dialgaye"
replace adm3_pcode = "BF520502" if commune == "Diapaga"
replace adm3_pcode = "BF520202" if commune == "Diapangou"
replace adm3_pcode = "BF500202" if commune == "Didyr"
replace adm3_pcode = "BF570102" if commune == "Diebougou"
replace adm3_pcode = "BF570202" if commune == "Dissin"
replace adm3_pcode = "BF460304" if commune == "Djibasso"
replace adm3_pcode = "BF560304" if commune == "Djibo"
replace adm3_pcode = "BF570103" if commune == "Dolo"
replace adm3_pcode = "BF560202" if commune == "Dori"
replace adm3_pcode = "BF510101" if commune == "Doulougou"
replace adm3_pcode = "BF470202" if commune == "Douna"
replace adm3_pcode = "BF460403" if commune == "Douroula"
replace adm3_pcode = "BF520203" if commune == "Fada N'gourma"
replace adm3_pcode = "BF560203" if commune == "Falagountou"
replace adm3_pcode = "BF460104" if commune == "Fara"
replace adm3_pcode = "BF530104" if commune == "Faramana"
replace adm3_pcode = "BF530105" if commune == "Fo"
replace adm3_pcode = "BF530304" if commune == "Founzan"
replace adm3_pcode = "BF500405" if commune == "Gao"
replace adm3_pcode = "BF570404" if commune == "Gaoua"
replace adm3_pcode = "BF480107" if commune == "Garango"
replace adm3_pcode = "BF460501" if commune == "Gassan"
replace adm3_pcode = "BF520303" if commune == "Gayeri"
replace adm3_pcode = "BF570405" if commune == "Gbomblora"
replace adm3_pcode = "BF500203" if commune == "Godyr"
replace adm3_pcode = "BF510303" if commune == "Gogo"
replace adm3_pcode = "BF510304" if commune == "Gomboussougou"
replace adm3_pcode = "BF560102" if commune == "Gorom-Gorom"
replace adm3_pcode = "BF480304" if commune == "Gounghin"
replace adm3_pcode = "BF540403" if commune == "Gourcy"
replace adm3_pcode = "BF570203" if commune == "Gueguere"
replace adm3_pcode = "BF490102" if commune == "Guiba"
replace adm3_pcode = "BF530305" if commune == "Hounde"
replace adm3_pcode = "BF570104" if commune == "Iolonioro"
replace adm3_pcode = "BF510103" if commune == "Ipelce"
replace adm3_pcode = "BF540302" if commune == "Kalsaka"
replace adm3_pcode = "BF540303" if commune == "Kampti"
replace adm3_pcode = "BF570406" if commune == "Kando"
replace adm3_pcode = "BF480305" if commune == "Kangala"
replace adm3_pcode = "BF530203" if commune == "Kantchari"
replace adm3_pcode = "BF530106" if commune == "Karankasso Sambla"
replace adm3_pcode = "BF530107" if commune == "Karankasso-Vigue"
replace adm3_pcode = "BF490304" if commune == "Kaya"
replace adm3_pcode = "BF530204" if commune == "Kayan"
replace adm3_pcode = "BF510104" if commune == "Kayao"
replace adm3_pcode = "BF500103" if commune == "Kindi"
replace adm3_pcode = "BF540206" if commune == "Kirsi"
replace adm3_pcode = "BF500104" if commune == "Kokoloko"
replace adm3_pcode = "BF510105" if commune == "Kombissiri"
replace adm3_pcode = "BF130001" if commune == "Komki-Ipala"
replace adm3_pcode = "BF130002" if commune == "Komsilga"
replace adm3_pcode = "BF480108" if commune == "Komtoega"
replace adm3_pcode = "BF490103" if commune == "Kongoussi"
replace adm3_pcode = "BF570204" if commune == "Koper"
replace adm3_pcode = "BF490305" if commune == "Korsimoro"
replace adm3_pcode = "BF540304" if commune == "Kossouka"
replace adm3_pcode = "BF530306" if commune == "Koti"
replace adm3_pcode = "BF130003" if commune == "Koubri"
replace adm3_pcode = "BF500105" if commune == "Koudougou"
replace adm3_pcode = "BF460202" if commune == "Kouka"
replace adm3_pcode = "BF530307" if commune == "Koumbia"
replace adm3_pcode = "BF540305" if commune == "Koumbri"
replace adm3_pcode = "BF530108" if commune == "Koundougou"
replace adm3_pcode = "BF480306" if commune == "Koupela"
replace adm3_pcode = "BF530206" if commune == "Kourignon"
replace adm3_pcode = "BF530207" if commune == "Kourouma"
replace adm3_pcode = "BF480203" if commune == "Lalgaye"
replace adm3_pcode = "BF460606" if commune == "Lankoue"
replace adm3_pcode = "BF570304" if commune == "Legmoin"
replace adm3_pcode = "BF500303" if commune == "Leo"
replace adm3_pcode = "BF520104" if commune == "Liptougou"
replace adm3_pcode = "BF520504" if commune == "Logobou"
replace adm3_pcode = "BF570407" if commune == "Loropeni"
replace adm3_pcode = "BF470204" if commune == "Loumana"
replace adm3_pcode = "BF490306" if commune == "Mane"
replace adm3_pcode = "BF510306" if commune == "Manga"
replace adm3_pcode = "BF470103" if commune == "Mangodara"
replace adm3_pcode = "BF520105" if commune == "Mani"
replace adm3_pcode = "BF550103" if commune == "Meguet"
replace adm3_pcode = "BF570305" if commune == "Mogtedo"
replace adm3_pcode = "BF530208" if commune == "Morolaba"
replace adm3_pcode = "BF530209" if commune == "N'dorola"
replace adm3_pcode = "BF550304" if commune == "Nagreongo"
replace adm3_pcode = "BF570409" if commune == "Nako"
replace adm3_pcode = "BF500106" if commune == "Nanoro"
replace adm3_pcode = "BF500305" if commune == "Niabouri"
replace adm3_pcode = "BF470105" if commune == "Niangoloko"
replace adm3_pcode = "BF470205" if commune == "Niankorodougou"
replace adm3_pcode = "BF570205" if commune == "Niego"
replace adm3_pcode = "BF550203" if commune == "Niou"
replace adm3_pcode = "BF510307" if commune == "Nobere"
replace adm3_pcode = "BF460309" if commune == "Nouna"
replace adm3_pcode = "BF530210" if commune == "Orodara"
replace adm3_pcode = "BF540307" if commune == "Ouahigouya"
replace adm3_pcode = "BF480204" if commune == "Ouargaye"
replace adm3_pcode = "BF460405" if commune == "Ouarkoye"
replace adm3_pcode = "BF470206" if commune == "Oueleni"
replace adm3_pcode = "BF570207" if commune == "Ouessa"
replace adm3_pcode = "BF540102" if commune == "Ouindigui"
replace adm3_pcode = "BF540308" if commune == "Oula"
replace adm3_pcode = "BF550305" if commune == "Ourgou-Manega"
replace adm3_pcode = "BF460105" if commune == "Oury"
replace adm3_pcode = "BF560104" if commune == "Pabre"
replace adm3_pcode = "BF530110" if commune == "Padema"
replace adm3_pcode = "BF520506" if commune == "Partiaga"
replace adm3_pcode = "BF530111" if commune == "Peni"
replace adm3_pcode = "BF570410" if commune == "Perigban"
replace adm3_pcode = "BF490309" if commune == "Pibaore"
replace adm3_pcode = "BF520106" if commune == "Piela"
replace adm3_pcode = "BF540208" if commune == "Pilimpikou"
replace adm3_pcode = "BF490310" if commune == "Pissila"
replace adm3_pcode = "BF500109" if commune == "Poa"
replace adm3_pcode = "BF560308" if commune == "Pobe-Mengao"
replace adm3_pcode = "BF500206" if commune == "Pouni"
replace adm3_pcode = "BF460108" if commune == "Poura"
replace adm3_pcode = "BF480307" if commune == "Pouytenga"
replace adm3_pcode = "BF460106" if commune == "PÃ´"
replace adm3_pcode = "BF510202" if commune == "Pô"
replace adm3_pcode = "BF540309" if commune == "Rambo"
replace adm3_pcode = "BF500110" if commune == "Ramongo"
replace adm3_pcode = "BF500207" if commune == "Reo"
replace adm3_pcode = "BF490105" if commune == "Rollo"
replace adm3_pcode = "BF130006" if commune == "Saaba"
replace adm3_pcode = "BF490107" if commune == "Sabce"
replace adm3_pcode = "BF460406" if commune == "Safane"
replace adm3_pcode = "BF550105" if commune == "Salogo"
replace adm3_pcode = "BF530212" if commune == "Samorogouan"
replace adm3_pcode = "BF560205" if commune == "Sampelga"
replace adm3_pcode = "BF460204" if commune == "Sanaba"
replace adm3_pcode = "BF480205" if commune == "Sanga"
replace adm3_pcode = "BF510106" if commune == "Sapone"
replace adm3_pcode = "BF500406" if commune == "Sapouy"
replace adm3_pcode = "BF530112" if commune == "Satiri"
replace adm3_pcode = "BF560403" if commune == "Sebba"
replace adm3_pcode = "BF540310" if commune == "Seguenega"
replace adm3_pcode = "BF560206" if commune == "Seytenga"
replace adm3_pcode = "BF470107" if commune == "Sideradougou"
replace adm3_pcode = "BF500112" if commune == "Sigle"
replace adm3_pcode = "BF500306" if commune == "Silly"
replace adm3_pcode = "BF470207" if commune == "Sindou"
replace adm3_pcode = "BF460205" if commune == "Solenzo"
replace adm3_pcode = "BF470108" if commune == "Soubakaniedougou"
replace adm3_pcode = "BF480206" if commune == "Soudougui"
replace adm3_pcode = "BF500114" if commune == "Sourgou"
replace adm3_pcode = "BF550204" if commune == "Sourgoubila"
replace adm3_pcode = "BF520507" if commune == "Tambaga"
replace adm3_pcode = "BF130007" if commune == "Tanghin Dassouri"
replace adm3_pcode = "BF460206" if commune == "Tansila"
replace adm3_pcode = "BF460407" if commune == "Tcheriba"
replace adm3_pcode = "BF500208" if commune == "Tenado"
replace adm3_pcode = "BF480110" if commune == "Tenkodogo"
replace adm3_pcode = "BF480308" if commune == "Tensobentenga"
replace adm3_pcode = "BF510203" if commune == "Tiebele"
replace adm3_pcode = "BF470109" if commune == "Tiefora"
replace adm3_pcode = "BF490108" if commune == "Tikare"
replace adm3_pcode = "BF560406" if commune == "Titabe"
replace adm3_pcode = "BF540104" if commune == "Titao"
replace adm3_pcode = "BF500307" if commune == "To"
replace adm3_pcode = "BF510107" if commune == "Toece"
replace adm3_pcode = "BF550205" if commune == "Toeghin"
replace adm3_pcode = "BF460504" if commune == "Toma"
replace adm3_pcode = "BF460608" if commune == "Tougan"
replace adm3_pcode = "BF490206" if commune == "Tougouri"
replace adm3_pcode = "BF530113" if commune == "Toussiana"
replace adm3_pcode = "BF540210" if commune == "Yako"
replace adm3_pcode = "BF520206" if commune == "Yamba"
replace adm3_pcode = "BF480207" if commune == "Yargatenga"
replace adm3_pcode = "BF480309" if commune == "Yargo"
replace adm3_pcode = "BF460506" if commune == "Ye"
replace adm3_pcode = "BF480208" if commune == "Yonde"
replace adm3_pcode = "BF480111" if commune == "Zabre"
replace adm3_pcode = "BF550106" if commune == "Zam"
replace adm3_pcode = "BF570208" if commune == "Zambo"
replace adm3_pcode = "BF500209" if commune == "Zamo"
replace adm3_pcode = "BF510204" if commune == "Zecco"
replace adm3_pcode = "BF490311" if commune == "Ziga"
replace adm3_pcode = "BF550306" if commune == "Ziniare"
replace adm3_pcode = "BF510205" if commune == "Ziou"
replace adm3_pcode = "BF550307" if commune == "Zitenga"
replace adm3_pcode = "BF480113" if commune == "Zonse"
replace adm3_pcode = "BF550107" if commune == "Zorgho"
replace adm3_pcode = "BF550108" if commune == "Zoungou"




gen adm3_pcode_bis =.
replace adm3_pcode_bis = 480301 if adm3_pcode == "BF480301"
replace adm3_pcode_bis = 560301 if adm3_pcode == "BF560301"
replace adm3_pcode_bis = 540201 if adm3_pcode == "BF540201"
replace adm3_pcode_bis = 130004 if adm3_pcode == "BF130004"
replace adm3_pcode_bis = 130004 if adm3_pcode == "BF130004"
replace adm3_pcode_bis = 130004 if adm3_pcode == "BF130004"
replace adm3_pcode_bis = 130004 if adm3_pcode == "BF130004"
replace adm3_pcode_bis = 130004 if adm3_pcode == "BF130004"
replace adm3_pcode_bis = 130004 if adm3_pcode == "BF130004"
replace adm3_pcode_bis = 460101 if adm3_pcode == "BF460101"
replace adm3_pcode_bis = 480101 if adm3_pcode == "BF480101"
replace adm3_pcode_bis = 460201 if adm3_pcode == "BF460201"
replace adm3_pcode_bis = 530101 if adm3_pcode == "BF530101"
replace adm3_pcode_bis = 460102 if adm3_pcode == "BF460102"
replace adm3_pcode_bis = 480102 if adm3_pcode == "BF480102"
replace adm3_pcode_bis = 470101 if adm3_pcode == "BF470101"
replace adm3_pcode_bis = 560201 if adm3_pcode == "BF560201"
replace adm3_pcode_bis = 530201 if adm3_pcode == "BF530201"
replace adm3_pcode_bis = 490301 if adm3_pcode == "BF490301"
replace adm3_pcode_bis = 480302 if adm3_pcode == "BF480302"
replace adm3_pcode_bis = 570301 if adm3_pcode == "BF570301"
replace adm3_pcode_bis = 480103 if adm3_pcode == "BF480103"
replace adm3_pcode_bis = 530301 if adm3_pcode == "BF530301"
replace adm3_pcode_bis = 510301 if adm3_pcode == "BF510301"
replace adm3_pcode_bis = 530302 if adm3_pcode == "BF530302"
replace adm3_pcode_bis = 470102 if adm3_pcode == "BF470102"
replace adm3_pcode_bis = 500301 if adm3_pcode == "BF500301"
replace adm3_pcode_bis = 520101 if adm3_pcode == "BF520101"
replace adm3_pcode_bis = 510302 if adm3_pcode == "BF510302"
replace adm3_pcode_bis = 500101 if adm3_pcode == "BF500101"
replace adm3_pcode_bis = 480105 if adm3_pcode == "BF480105"
replace adm3_pcode_bis = 490201 if adm3_pcode == "BF490201"
replace adm3_pcode_bis = 530102 if adm3_pcode == "BF530102"
replace adm3_pcode_bis = 530102 if adm3_pcode == "BF530102"
replace adm3_pcode_bis = 530102 if adm3_pcode == "BF530102"
replace adm3_pcode_bis = 530102 if adm3_pcode == "BF530102"
replace adm3_pcode_bis = 530102 if adm3_pcode == "BF530102"
replace adm3_pcode_bis = 520102 if adm3_pcode == "BF520102"
replace adm3_pcode_bis = 540204 if adm3_pcode == "BF540204"
replace adm3_pcode_bis = 460401 if adm3_pcode == "BF460401"
replace adm3_pcode_bis = 530303 if adm3_pcode == "BF530303"
replace adm3_pcode_bis = 460103 if adm3_pcode == "BF460103"
replace adm3_pcode_bis = 520501 if adm3_pcode == "BF520501"
replace adm3_pcode_bis = 550101 if adm3_pcode == "BF550101"
replace adm3_pcode_bis = 490202 if adm3_pcode == "BF490202"
replace adm3_pcode_bis = 500302 if adm3_pcode == "BF500302"
replace adm3_pcode_bis = 460303 if adm3_pcode == "BF460303"
replace adm3_pcode_bis = 490203 if adm3_pcode == "BF490203"
replace adm3_pcode_bis = 570401 if adm3_pcode == "BF570401"
replace adm3_pcode_bis = 490101 if adm3_pcode == "BF490101"
replace adm3_pcode_bis = 550201 if adm3_pcode == "BF550201"
replace adm3_pcode_bis = 570402 if adm3_pcode == "BF570402"
replace adm3_pcode_bis = 540402 if adm3_pcode == "BF540402"
replace adm3_pcode_bis = 480106 if adm3_pcode == "BF480106"
replace adm3_pcode_bis = 500403 if adm3_pcode == "BF500403"
replace adm3_pcode_bis = 520103 if adm3_pcode == "BF520103"
replace adm3_pcode_bis = 480201 if adm3_pcode == "BF480201"
replace adm3_pcode_bis = 570201 if adm3_pcode == "BF570201"
replace adm3_pcode_bis = 550302 if adm3_pcode == "BF550302"
replace adm3_pcode_bis = 490204 if adm3_pcode == "BF490204"
replace adm3_pcode_bis = 460402 if adm3_pcode == "BF460402"
replace adm3_pcode_bis = 460601 if adm3_pcode == "BF460601"
replace adm3_pcode_bis = 520201 if adm3_pcode == "BF520201"
replace adm3_pcode_bis = 480303 if adm3_pcode == "BF480303"
replace adm3_pcode_bis = 520502 if adm3_pcode == "BF520502"
replace adm3_pcode_bis = 520202 if adm3_pcode == "BF520202"
replace adm3_pcode_bis = 500202 if adm3_pcode == "BF500202"
replace adm3_pcode_bis = 570102 if adm3_pcode == "BF570102"
replace adm3_pcode_bis = 570202 if adm3_pcode == "BF570202"
replace adm3_pcode_bis = 460304 if adm3_pcode == "BF460304"
replace adm3_pcode_bis = 560304 if adm3_pcode == "BF560304"
replace adm3_pcode_bis = 570103 if adm3_pcode == "BF570103"
replace adm3_pcode_bis = 560202 if adm3_pcode == "BF560202"
replace adm3_pcode_bis = 510101 if adm3_pcode == "BF510101"
replace adm3_pcode_bis = 470202 if adm3_pcode == "BF470202"
replace adm3_pcode_bis = 460403 if adm3_pcode == "BF460403"
replace adm3_pcode_bis = 520203 if adm3_pcode == "BF520203"
replace adm3_pcode_bis = 560203 if adm3_pcode == "BF560203"
replace adm3_pcode_bis = 460104 if adm3_pcode == "BF460104"
replace adm3_pcode_bis = 530104 if adm3_pcode == "BF530104"
replace adm3_pcode_bis = 530105 if adm3_pcode == "BF530105"
replace adm3_pcode_bis = 530304 if adm3_pcode == "BF530304"
replace adm3_pcode_bis = 500405 if adm3_pcode == "BF500405"
replace adm3_pcode_bis = 570404 if adm3_pcode == "BF570404"
replace adm3_pcode_bis = 480107 if adm3_pcode == "BF480107"
replace adm3_pcode_bis = 460501 if adm3_pcode == "BF460501"
replace adm3_pcode_bis = 520303 if adm3_pcode == "BF520303"
replace adm3_pcode_bis = 570405 if adm3_pcode == "BF570405"
replace adm3_pcode_bis = 500203 if adm3_pcode == "BF500203"
replace adm3_pcode_bis = 510303 if adm3_pcode == "BF510303"
replace adm3_pcode_bis = 510304 if adm3_pcode == "BF510304"
replace adm3_pcode_bis = 560102 if adm3_pcode == "BF560102"
replace adm3_pcode_bis = 480304 if adm3_pcode == "BF480304"
replace adm3_pcode_bis = 540403 if adm3_pcode == "BF540403"
replace adm3_pcode_bis = 570203 if adm3_pcode == "BF570203"
replace adm3_pcode_bis = 490102 if adm3_pcode == "BF490102"
replace adm3_pcode_bis = 530305 if adm3_pcode == "BF530305"
replace adm3_pcode_bis = 570104 if adm3_pcode == "BF570104"
replace adm3_pcode_bis = 510103 if adm3_pcode == "BF510103"
replace adm3_pcode_bis = 540302 if adm3_pcode == "BF540302"
replace adm3_pcode_bis = 540303 if adm3_pcode == "BF540303"
replace adm3_pcode_bis = 570406 if adm3_pcode == "BF570406"
replace adm3_pcode_bis = 480305 if adm3_pcode == "BF480305"
replace adm3_pcode_bis = 530203 if adm3_pcode == "BF530203"
replace adm3_pcode_bis = 530106 if adm3_pcode == "BF530106"
replace adm3_pcode_bis = 530107 if adm3_pcode == "BF530107"
replace adm3_pcode_bis = 490304 if adm3_pcode == "BF490304"
replace adm3_pcode_bis = 530204 if adm3_pcode == "BF530204"
replace adm3_pcode_bis = 510104 if adm3_pcode == "BF510104"
replace adm3_pcode_bis = 500103 if adm3_pcode == "BF500103"
replace adm3_pcode_bis = 540206 if adm3_pcode == "BF540206"
replace adm3_pcode_bis = 500104 if adm3_pcode == "BF500104"
replace adm3_pcode_bis = 510105 if adm3_pcode == "BF510105"
replace adm3_pcode_bis = 130001 if adm3_pcode == "BF130001"
replace adm3_pcode_bis = 130002 if adm3_pcode == "BF130002"
replace adm3_pcode_bis = 480108 if adm3_pcode == "BF480108"
replace adm3_pcode_bis = 490103 if adm3_pcode == "BF490103"
replace adm3_pcode_bis = 570204 if adm3_pcode == "BF570204"
replace adm3_pcode_bis = 490305 if adm3_pcode == "BF490305"
replace adm3_pcode_bis = 540304 if adm3_pcode == "BF540304"
replace adm3_pcode_bis = 530306 if adm3_pcode == "BF530306"
replace adm3_pcode_bis = 130003 if adm3_pcode == "BF130003"
replace adm3_pcode_bis = 500105 if adm3_pcode == "BF500105"
replace adm3_pcode_bis = 460202 if adm3_pcode == "BF460202"
replace adm3_pcode_bis = 530307 if adm3_pcode == "BF530307"
replace adm3_pcode_bis = 540305 if adm3_pcode == "BF540305"
replace adm3_pcode_bis = 530108 if adm3_pcode == "BF530108"
replace adm3_pcode_bis = 480306 if adm3_pcode == "BF480306"
replace adm3_pcode_bis = 530206 if adm3_pcode == "BF530206"
replace adm3_pcode_bis = 530207 if adm3_pcode == "BF530207"
replace adm3_pcode_bis = 480203 if adm3_pcode == "BF480203"
replace adm3_pcode_bis = 460606 if adm3_pcode == "BF460606"
replace adm3_pcode_bis = 570304 if adm3_pcode == "BF570304"
replace adm3_pcode_bis = 500303 if adm3_pcode == "BF500303"
replace adm3_pcode_bis = 520104 if adm3_pcode == "BF520104"
replace adm3_pcode_bis = 520504 if adm3_pcode == "BF520504"
replace adm3_pcode_bis = 570407 if adm3_pcode == "BF570407"
replace adm3_pcode_bis = 470204 if adm3_pcode == "BF470204"
replace adm3_pcode_bis = 490306 if adm3_pcode == "BF490306"
replace adm3_pcode_bis = 510306 if adm3_pcode == "BF510306"
replace adm3_pcode_bis = 470103 if adm3_pcode == "BF470103"
replace adm3_pcode_bis = 520105 if adm3_pcode == "BF520105"
replace adm3_pcode_bis = 550103 if adm3_pcode == "BF550103"
replace adm3_pcode_bis = 570305 if adm3_pcode == "BF570305"
replace adm3_pcode_bis = 530208 if adm3_pcode == "BF530208"
replace adm3_pcode_bis = 530209 if adm3_pcode == "BF530209"
replace adm3_pcode_bis = 550304 if adm3_pcode == "BF550304"
replace adm3_pcode_bis = 570409 if adm3_pcode == "BF570409"
replace adm3_pcode_bis = 500106 if adm3_pcode == "BF500106"
replace adm3_pcode_bis = 500305 if adm3_pcode == "BF500305"
replace adm3_pcode_bis = 470105 if adm3_pcode == "BF470105"
replace adm3_pcode_bis = 470205 if adm3_pcode == "BF470205"
replace adm3_pcode_bis = 570205 if adm3_pcode == "BF570205"
replace adm3_pcode_bis = 550203 if adm3_pcode == "BF550203"
replace adm3_pcode_bis = 510307 if adm3_pcode == "BF510307"
replace adm3_pcode_bis = 460309 if adm3_pcode == "BF460309"
replace adm3_pcode_bis = 530210 if adm3_pcode == "BF530210"
replace adm3_pcode_bis = 540307 if adm3_pcode == "BF540307"
replace adm3_pcode_bis = 480204 if adm3_pcode == "BF480204"
replace adm3_pcode_bis = 460405 if adm3_pcode == "BF460405"
replace adm3_pcode_bis = 470206 if adm3_pcode == "BF470206"
replace adm3_pcode_bis = 570207 if adm3_pcode == "BF570207"
replace adm3_pcode_bis = 540102 if adm3_pcode == "BF540102"
replace adm3_pcode_bis = 540308 if adm3_pcode == "BF540308"
replace adm3_pcode_bis = 550305 if adm3_pcode == "BF550305"
replace adm3_pcode_bis = 460105 if adm3_pcode == "BF460105"
replace adm3_pcode_bis = 560104 if adm3_pcode == "BF560104"
replace adm3_pcode_bis = 530110 if adm3_pcode == "BF530110"
replace adm3_pcode_bis = 520506 if adm3_pcode == "BF520506"
replace adm3_pcode_bis = 530111 if adm3_pcode == "BF530111"
replace adm3_pcode_bis = 570410 if adm3_pcode == "BF570410"
replace adm3_pcode_bis = 490309 if adm3_pcode == "BF490309"
replace adm3_pcode_bis = 520106 if adm3_pcode == "BF520106"
replace adm3_pcode_bis = 540208 if adm3_pcode == "BF540208"
replace adm3_pcode_bis = 490310 if adm3_pcode == "BF490310"
replace adm3_pcode_bis = 500109 if adm3_pcode == "BF500109"
replace adm3_pcode_bis = 560308 if adm3_pcode == "BF560308"
replace adm3_pcode_bis = 500206 if adm3_pcode == "BF500206"
replace adm3_pcode_bis = 460108 if adm3_pcode == "BF460108"
replace adm3_pcode_bis = 480307 if adm3_pcode == "BF480307"
replace adm3_pcode_bis = 460106 if adm3_pcode == "BF460106"
replace adm3_pcode_bis = 510202 if adm3_pcode == "BF510202"
replace adm3_pcode_bis = 540309 if adm3_pcode == "BF540309"
replace adm3_pcode_bis = 500110 if adm3_pcode == "BF500110"
replace adm3_pcode_bis = 500207 if adm3_pcode == "BF500207"
replace adm3_pcode_bis = 490105 if adm3_pcode == "BF490105"
replace adm3_pcode_bis = 130006 if adm3_pcode == "BF130006"
replace adm3_pcode_bis = 490107 if adm3_pcode == "BF490107"
replace adm3_pcode_bis = 460406 if adm3_pcode == "BF460406"
replace adm3_pcode_bis = 550105 if adm3_pcode == "BF550105"
replace adm3_pcode_bis = 530212 if adm3_pcode == "BF530212"
replace adm3_pcode_bis = 560205 if adm3_pcode == "BF560205"
replace adm3_pcode_bis = 460204 if adm3_pcode == "BF460204"
replace adm3_pcode_bis = 480205 if adm3_pcode == "BF480205"
replace adm3_pcode_bis = 510106 if adm3_pcode == "BF510106"
replace adm3_pcode_bis = 500406 if adm3_pcode == "BF500406"
replace adm3_pcode_bis = 530112 if adm3_pcode == "BF530112"
replace adm3_pcode_bis = 560403 if adm3_pcode == "BF560403"
replace adm3_pcode_bis = 540310 if adm3_pcode == "BF540310"
replace adm3_pcode_bis = 560206 if adm3_pcode == "BF560206"
replace adm3_pcode_bis = 470107 if adm3_pcode == "BF470107"
replace adm3_pcode_bis = 500112 if adm3_pcode == "BF500112"
replace adm3_pcode_bis = 500306 if adm3_pcode == "BF500306"
replace adm3_pcode_bis = 470207 if adm3_pcode == "BF470207"
replace adm3_pcode_bis = 460205 if adm3_pcode == "BF460205"
replace adm3_pcode_bis = 470108 if adm3_pcode == "BF470108"
replace adm3_pcode_bis = 480206 if adm3_pcode == "BF480206"
replace adm3_pcode_bis = 500114 if adm3_pcode == "BF500114"
replace adm3_pcode_bis = 550204 if adm3_pcode == "BF550204"
replace adm3_pcode_bis = 520507 if adm3_pcode == "BF520507"
replace adm3_pcode_bis = 130007 if adm3_pcode == "BF130007"

sort adm1_pcode  adm2_pcode  adm3_pcode
order adm1_pcode  adm2_pcode  adm3_pcode adm3_pcode_bis
save "$data\survey_ehcvm_bfa_2021.dta",replace




*===============================================================================
// Covariates in region level
*===============================================================================
use "$data\survey_ehcvm_bfa_2021.dta",clear

collapse  (first) region* (mean)  hage age hhsize hgender1 hgender2 resid1 resid2 sexe1 sexe2 lien1 lien2 lien3 lien4 lien5 lien6 lien7 lien8 lien9 lien10 lien11 mstat1 mstat2 mstat3 mstat4 mstat5 mstat6 mstat7 religion1 religion2 religion3 religion4 religion5 ethnie1 ethnie2 ethnie3 ethnie4 ethnie5 ethnie6 ethnie7 ethnie8 ethnie9 ethnie10 ethnie11 ethnie12 nation1 nation2 nation3 nation4 nation5 nation6 nation7 nation8 nation9 nation10 nation11 nation12 nation13 nation14 nation15 nation16 mal30j1 mal30j2 aff30j1 aff30j2 aff30j3 aff30j4 aff30j5 aff30j6 aff30j7 aff30j8 aff30j9 aff30j10 aff30j11 aff30j12 aff30j13 aff30j14 aff30j15 aff30j16 aff30j17 arrmal1 arrmal2 hos12m1 hos12m2 couvmal1 couvmal2 handit1 handit2 alfa1 alfa2 educ_scol1 educ_scol2 educ_scol3 educ_scol4 educ_scol5 educ_scol6 educ_scol7 educ_scol8 educ_hi1 educ_hi2 educ_hi3 educ_hi4 educ_hi5 educ_hi6 educ_hi7 educ_hi8 educ_hi9 diplome1 diplome2 diplome3 diplome4 diplome5 diplome6 diplome7 diplome8 diplome9 diplome10 diplome11 telpor1 telpor2 internet1 internet2 activ7j1 activ7j2 activ7j3 activ7j4 activ7j5 activ7j6 activ12m1 activ12m2 activ12m3 activ12m4 branch1 branch2 branch3 branch4 branch5 branch6 branch7 branch8 branch9 branch10 branch11 sectins1 sectins2 sectins3 sectins4 sectins5 sectins6 csp1 csp2 csp3 csp4 csp5 csp6 csp7 csp8 csp9 csp10 emploi_sec1 emploi_sec2 sectins_sec1 sectins_sec2 sectins_sec3 sectins_sec4 sectins_sec5 sectins_sec6 csp_sec1 csp_sec2 csp_sec3 csp_sec4 csp_sec5 csp_sec6 csp_sec7 csp_sec8 csp_sec9 csp_sec10 bank1 bank2 serviceconsult1 serviceconsult2 serviceconsult3 serviceconsult4 serviceconsult5 persconsult1 persconsult2 persconsult3 persconsult4 logem1 logem2 logem3 logem4 mur1 mur2 toit1 toit2 sol1 sol2 eauboi_ss1 eauboi_ss2 eauboi_sp1 eauboi_sp2 elec_ac1 elec_ac2 elec_ur1 elec_ur2 elec_ua1 elec_ua2 ordure1 ordure2 toilet1 toilet2 eva_toi1 eva_toi2 eva_eau1 eva_eau2 tv1 tv2 fer1 fer2 frigo1 frigo2 cuisin1 cuisin2 ordin1 ordin2 decod1 decod2 car1 car2 sh_id_demo1 sh_id_demo2 sh_co_natu1 sh_co_natu2 sh_co_eco1 sh_co_eco2 sh_id_eco1 sh_id_eco2 sh_co_vio1 sh_co_vio2 sh_co_oth1 sh_co_oth2 milieu1 milieu2 hmstat1 hmstat2 hmstat3 hmstat4 hmstat5 hmstat6 hmstat7 hreligion1 hreligion2 hreligion3 hreligion4 hreligion5 hnation1 hnation2 hnation3 hnation4 hnation5 hnation6 hnation7 hnation8 hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 hethnie8 hethnie9 hethnie10 hethnie11 hethnie12 halfa1 halfa2 heduc1 heduc2 heduc3 heduc4 heduc5 heduc6 heduc7 heduc8 hdiploma1 hdiploma2 hdiploma3 hdiploma4 hdiploma5 hdiploma6 hdiploma7 hdiploma8 hdiploma9 hdiploma10 hdiploma11 hhandig1 hhandig2 hactiv7j1 hactiv7j2 hactiv7j3 hactiv7j4 hactiv7j5 hactiv12m1 hactiv12m2 hactiv12m3 hbranch1 hbranch2 hbranch3 hbranch4 hbranch5 hbranch6 hbranch7 hbranch8 hbranch9 hbranch10 hbranch11 hsectins1 hsectins2 hsectins3 hsectins4 hsectins5 hsectins6 hcsp1 hcsp2 hcsp3 hcsp4 hcsp5 hcsp6 hcsp7 hcsp8 hcsp9 hcsp10 (sum) pop=hhsize [aw=hhweight_panel], by(adm1_pcode)


save "$data\region_survey_ehcvm_bfa_2021.dta",replace
*===============================================================================
// Covariates in province level
*===============================================================================


use "$data\survey_ehcvm_bfa_2021.dta",clear

collapse  (first) region* (mean)  hhsize hage age  hgender1 hgender2 resid1 resid2 sexe1 sexe2 lien1 lien2 lien3 lien4 lien5 lien6 lien7 lien8 lien9 lien10 lien11 mstat1 mstat2 mstat3 mstat4 mstat5 mstat6 mstat7 religion1 religion2 religion3 religion4 religion5 ethnie1 ethnie2 ethnie3 ethnie4 ethnie5 ethnie6 ethnie7 ethnie8 ethnie9 ethnie10 ethnie11 ethnie12 nation1 nation2 nation3 nation4 nation5 nation6 nation7 nation8 nation9 nation10 nation11 nation12 nation13 nation14 nation15 nation16 mal30j1 mal30j2 aff30j1 aff30j2 aff30j3 aff30j4 aff30j5 aff30j6 aff30j7 aff30j8 aff30j9 aff30j10 aff30j11 aff30j12 aff30j13 aff30j14 aff30j15 aff30j16 aff30j17 arrmal1 arrmal2 hos12m1 hos12m2 couvmal1 couvmal2 handit1 handit2 alfa1 alfa2 educ_scol1 educ_scol2 educ_scol3 educ_scol4 educ_scol5 educ_scol6 educ_scol7 educ_scol8 educ_hi1 educ_hi2 educ_hi3 educ_hi4 educ_hi5 educ_hi6 educ_hi7 educ_hi8 educ_hi9 diplome1 diplome2 diplome3 diplome4 diplome5 diplome6 diplome7 diplome8 diplome9 diplome10 diplome11 telpor1 telpor2 internet1 internet2 activ7j1 activ7j2 activ7j3 activ7j4 activ7j5 activ7j6 activ12m1 activ12m2 activ12m3 activ12m4 branch1 branch2 branch3 branch4 branch5 branch6 branch7 branch8 branch9 branch10 branch11 sectins1 sectins2 sectins3 sectins4 sectins5 sectins6 csp1 csp2 csp3 csp4 csp5 csp6 csp7 csp8 csp9 csp10 emploi_sec1 emploi_sec2 sectins_sec1 sectins_sec2 sectins_sec3 sectins_sec4 sectins_sec5 sectins_sec6 csp_sec1 csp_sec2 csp_sec3 csp_sec4 csp_sec5 csp_sec6 csp_sec7 csp_sec8 csp_sec9 csp_sec10 bank1 bank2 serviceconsult1 serviceconsult2 serviceconsult3 serviceconsult4 serviceconsult5 persconsult1 persconsult2 persconsult3 persconsult4 logem1 logem2 logem3 logem4 mur1 mur2 toit1 toit2 sol1 sol2 eauboi_ss1 eauboi_ss2 eauboi_sp1 eauboi_sp2 elec_ac1 elec_ac2 elec_ur1 elec_ur2 elec_ua1 elec_ua2 ordure1 ordure2 toilet1 toilet2 eva_toi1 eva_toi2 eva_eau1 eva_eau2 tv1 tv2 fer1 fer2 frigo1 frigo2 cuisin1 cuisin2 ordin1 ordin2 decod1 decod2 car1 car2 sh_id_demo1 sh_id_demo2 sh_co_natu1 sh_co_natu2 sh_co_eco1 sh_co_eco2 sh_id_eco1 sh_id_eco2 sh_co_vio1 sh_co_vio2 sh_co_oth1 sh_co_oth2 milieu1 milieu2 hmstat1 hmstat2 hmstat3 hmstat4 hmstat5 hmstat6 hmstat7 hreligion1 hreligion2 hreligion3 hreligion4 hreligion5 hnation1 hnation2 hnation3 hnation4 hnation5 hnation6 hnation7 hnation8 hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 hethnie8 hethnie9 hethnie10 hethnie11 hethnie12 halfa1 halfa2 heduc1 heduc2 heduc3 heduc4 heduc5 heduc6 heduc7 heduc8 hdiploma1 hdiploma2 hdiploma3 hdiploma4 hdiploma5 hdiploma6 hdiploma7 hdiploma8 hdiploma9 hdiploma10 hdiploma11 hhandig1 hhandig2 hactiv7j1 hactiv7j2 hactiv7j3 hactiv7j4 hactiv7j5 hactiv12m1 hactiv12m2 hactiv12m3 hbranch1 hbranch2 hbranch3 hbranch4 hbranch5 hbranch6 hbranch7 hbranch8 hbranch9 hbranch10 hbranch11 hsectins1 hsectins2 hsectins3 hsectins4 hsectins5 hsectins6 hcsp1 hcsp2 hcsp3 hcsp4 hcsp5 hcsp6 hcsp7 hcsp8 hcsp9 hcsp10 (sum) pop=hhsize [aw=hhweight_panel], by(adm1_pcode adm2_pcode)


save "$data\province_survey_ehcvm_bfa_2021.dta",replace
*===============================================================================
// Covariates in commune level
*===============================================================================
use "$data\survey_ehcvm_bfa_2021.dta",clear




collapse  (first) region* (mean)  hhsize hage age  hgender1 hgender2 resid1 resid2 sexe1 sexe2 lien1 lien2 lien3 lien4 lien5 lien6 lien7 lien8 lien9 lien10 lien11 mstat1 mstat2 mstat3 mstat4 mstat5 mstat6 mstat7 religion1 religion2 religion3 religion4 religion5 ethnie1 ethnie2 ethnie3 ethnie4 ethnie5 ethnie6 ethnie7 ethnie8 ethnie9 ethnie10 ethnie11 ethnie12 nation1 nation2 nation3 nation4 nation5 nation6 nation7 nation8 nation9 nation10 nation11 nation12 nation13 nation14 nation15 nation16 mal30j1 mal30j2 aff30j1 aff30j2 aff30j3 aff30j4 aff30j5 aff30j6 aff30j7 aff30j8 aff30j9 aff30j10 aff30j11 aff30j12 aff30j13 aff30j14 aff30j15 aff30j16 aff30j17 arrmal1 arrmal2 hos12m1 hos12m2 couvmal1 couvmal2 handit1 handit2 alfa1 alfa2 educ_scol1 educ_scol2 educ_scol3 educ_scol4 educ_scol5 educ_scol6 educ_scol7 educ_scol8 educ_hi1 educ_hi2 educ_hi3 educ_hi4 educ_hi5 educ_hi6 educ_hi7 educ_hi8 educ_hi9 diplome1 diplome2 diplome3 diplome4 diplome5 diplome6 diplome7 diplome8 diplome9 diplome10 diplome11 telpor1 telpor2 internet1 internet2 activ7j1 activ7j2 activ7j3 activ7j4 activ7j5 activ7j6 activ12m1 activ12m2 activ12m3 activ12m4 branch1 branch2 branch3 branch4 branch5 branch6 branch7 branch8 branch9 branch10 branch11 sectins1 sectins2 sectins3 sectins4 sectins5 sectins6 csp1 csp2 csp3 csp4 csp5 csp6 csp7 csp8 csp9 csp10 emploi_sec1 emploi_sec2 sectins_sec1 sectins_sec2 sectins_sec3 sectins_sec4 sectins_sec5 sectins_sec6 csp_sec1 csp_sec2 csp_sec3 csp_sec4 csp_sec5 csp_sec6 csp_sec7 csp_sec8 csp_sec9 csp_sec10 bank1 bank2 serviceconsult1 serviceconsult2 serviceconsult3 serviceconsult4 serviceconsult5 persconsult1 persconsult2 persconsult3 persconsult4 logem1 logem2 logem3 logem4 mur1 mur2 toit1 toit2 sol1 sol2 eauboi_ss1 eauboi_ss2 eauboi_sp1 eauboi_sp2 elec_ac1 elec_ac2 elec_ur1 elec_ur2 elec_ua1 elec_ua2 ordure1 ordure2 toilet1 toilet2 eva_toi1 eva_toi2 eva_eau1 eva_eau2 tv1 tv2 fer1 fer2 frigo1 frigo2 cuisin1 cuisin2 ordin1 ordin2 decod1 decod2 car1 car2 sh_id_demo1 sh_id_demo2 sh_co_natu1 sh_co_natu2 sh_co_eco1 sh_co_eco2 sh_id_eco1 sh_id_eco2 sh_co_vio1 sh_co_vio2 sh_co_oth1 sh_co_oth2 milieu1 milieu2 hmstat1 hmstat2 hmstat3 hmstat4 hmstat5 hmstat6 hmstat7 hreligion1 hreligion2 hreligion3 hreligion4 hreligion5 hnation1 hnation2 hnation3 hnation4 hnation5 hnation6 hnation7 hnation8 hethnie1 hethnie2 hethnie3 hethnie4 hethnie5 hethnie6 hethnie7 hethnie8 hethnie9 hethnie10 hethnie11 hethnie12 halfa1 halfa2 heduc1 heduc2 heduc3 heduc4 heduc5 heduc6 heduc7 heduc8 hdiploma1 hdiploma2 hdiploma3 hdiploma4 hdiploma5 hdiploma6 hdiploma7 hdiploma8 hdiploma9 hdiploma10 hdiploma11 hhandig1 hhandig2 hactiv7j1 hactiv7j2 hactiv7j3 hactiv7j4 hactiv7j5 hactiv12m1 hactiv12m2 hactiv12m3 hbranch1 hbranch2 hbranch3 hbranch4 hbranch5 hbranch6 hbranch7 hbranch8 hbranch9 hbranch10 hbranch11 hsectins1 hsectins2 hsectins3 hsectins4 hsectins5 hsectins6 hcsp1 hcsp2 hcsp3 hcsp4 hcsp5 hcsp6 hcsp7 hcsp8 hcsp9 hcsp10 (sum) pop=hhsize [aw=hhweight_panel], by(adm1_pcode adm2_pcode adm3_pcode)


gen adm3_pcode_bis =.
replace adm3_pcode_bis = 130001 if adm3_pcode == "BF130001"
replace adm3_pcode_bis = 130002 if adm3_pcode == "BF130002"
replace adm3_pcode_bis = 130003 if adm3_pcode == "BF130003"
replace adm3_pcode_bis = 130004 if adm3_pcode == "BF130004"
replace adm3_pcode_bis = 130006 if adm3_pcode == "BF130006"
replace adm3_pcode_bis = 130007 if adm3_pcode == "BF130007"
replace adm3_pcode_bis = 460101 if adm3_pcode == "BF460101"
replace adm3_pcode_bis = 460102 if adm3_pcode == "BF460102"
replace adm3_pcode_bis = 460103 if adm3_pcode == "BF460103"
replace adm3_pcode_bis = 460104 if adm3_pcode == "BF460104"
replace adm3_pcode_bis = 460105 if adm3_pcode == "BF460105"
replace adm3_pcode_bis = 460106 if adm3_pcode == "BF460106"
replace adm3_pcode_bis = 460108 if adm3_pcode == "BF460108"
replace adm3_pcode_bis = 460201 if adm3_pcode == "BF460201"
replace adm3_pcode_bis = 460202 if adm3_pcode == "BF460202"
replace adm3_pcode_bis = 460204 if adm3_pcode == "BF460204"
replace adm3_pcode_bis = 460205 if adm3_pcode == "BF460205"
replace adm3_pcode_bis = 460206 if adm3_pcode == "BF460206"
replace adm3_pcode_bis = 460303 if adm3_pcode == "BF460303"
replace adm3_pcode_bis = 460304 if adm3_pcode == "BF460304"
replace adm3_pcode_bis = 460309 if adm3_pcode == "BF460309"
replace adm3_pcode_bis = 460401 if adm3_pcode == "BF460401"
replace adm3_pcode_bis = 460402 if adm3_pcode == "BF460402"
replace adm3_pcode_bis = 460403 if adm3_pcode == "BF460403"
replace adm3_pcode_bis = 460405 if adm3_pcode == "BF460405"
replace adm3_pcode_bis = 460406 if adm3_pcode == "BF460406"
replace adm3_pcode_bis = 460407 if adm3_pcode == "BF460407"
replace adm3_pcode_bis = 460501 if adm3_pcode == "BF460501"
replace adm3_pcode_bis = 460504 if adm3_pcode == "BF460504"
replace adm3_pcode_bis = 460506 if adm3_pcode == "BF460506"
replace adm3_pcode_bis = 460601 if adm3_pcode == "BF460601"
replace adm3_pcode_bis = 460606 if adm3_pcode == "BF460606"
replace adm3_pcode_bis = 460608 if adm3_pcode == "BF460608"
replace adm3_pcode_bis = 470101 if adm3_pcode == "BF470101"
replace adm3_pcode_bis = 470102 if adm3_pcode == "BF470102"
replace adm3_pcode_bis = 470103 if adm3_pcode == "BF470103"
replace adm3_pcode_bis = 470105 if adm3_pcode == "BF470105"
replace adm3_pcode_bis = 470107 if adm3_pcode == "BF470107"
replace adm3_pcode_bis = 470108 if adm3_pcode == "BF470108"
replace adm3_pcode_bis = 470109 if adm3_pcode == "BF470109"
replace adm3_pcode_bis = 470202 if adm3_pcode == "BF470202"
replace adm3_pcode_bis = 470204 if adm3_pcode == "BF470204"
replace adm3_pcode_bis = 470205 if adm3_pcode == "BF470205"
replace adm3_pcode_bis = 470206 if adm3_pcode == "BF470206"
replace adm3_pcode_bis = 470207 if adm3_pcode == "BF470207"
replace adm3_pcode_bis = 480101 if adm3_pcode == "BF480101"
replace adm3_pcode_bis = 480102 if adm3_pcode == "BF480102"
replace adm3_pcode_bis = 480103 if adm3_pcode == "BF480103"
replace adm3_pcode_bis = 480105 if adm3_pcode == "BF480105"
replace adm3_pcode_bis = 480106 if adm3_pcode == "BF480106"
replace adm3_pcode_bis = 480107 if adm3_pcode == "BF480107"
replace adm3_pcode_bis = 480108 if adm3_pcode == "BF480108"
replace adm3_pcode_bis = 480110 if adm3_pcode == "BF480110"
replace adm3_pcode_bis = 480111 if adm3_pcode == "BF480111"
replace adm3_pcode_bis = 480113 if adm3_pcode == "BF480113"
replace adm3_pcode_bis = 480201 if adm3_pcode == "BF480201"
replace adm3_pcode_bis = 480203 if adm3_pcode == "BF480203"
replace adm3_pcode_bis = 480204 if adm3_pcode == "BF480204"
replace adm3_pcode_bis = 480205 if adm3_pcode == "BF480205"
replace adm3_pcode_bis = 480206 if adm3_pcode == "BF480206"
replace adm3_pcode_bis = 480207 if adm3_pcode == "BF480207"
replace adm3_pcode_bis = 480208 if adm3_pcode == "BF480208"
replace adm3_pcode_bis = 480301 if adm3_pcode == "BF480301"
replace adm3_pcode_bis = 480302 if adm3_pcode == "BF480302"
replace adm3_pcode_bis = 480303 if adm3_pcode == "BF480303"
replace adm3_pcode_bis = 480304 if adm3_pcode == "BF480304"
replace adm3_pcode_bis = 480305 if adm3_pcode == "BF480305"
replace adm3_pcode_bis = 480306 if adm3_pcode == "BF480306"
replace adm3_pcode_bis = 480307 if adm3_pcode == "BF480307"
replace adm3_pcode_bis = 480308 if adm3_pcode == "BF480308"
replace adm3_pcode_bis = 480309 if adm3_pcode == "BF480309"
replace adm3_pcode_bis = 490101 if adm3_pcode == "BF490101"
replace adm3_pcode_bis = 490102 if adm3_pcode == "BF490102"
replace adm3_pcode_bis = 490103 if adm3_pcode == "BF490103"
replace adm3_pcode_bis = 490105 if adm3_pcode == "BF490105"
replace adm3_pcode_bis = 490107 if adm3_pcode == "BF490107"
replace adm3_pcode_bis = 490108 if adm3_pcode == "BF490108"
replace adm3_pcode_bis = 490201 if adm3_pcode == "BF490201"
replace adm3_pcode_bis = 490202 if adm3_pcode == "BF490202"
replace adm3_pcode_bis = 490203 if adm3_pcode == "BF490203"
replace adm3_pcode_bis = 490204 if adm3_pcode == "BF490204"
replace adm3_pcode_bis = 490206 if adm3_pcode == "BF490206"
replace adm3_pcode_bis = 490301 if adm3_pcode == "BF490301"
replace adm3_pcode_bis = 490304 if adm3_pcode == "BF490304"
replace adm3_pcode_bis = 490305 if adm3_pcode == "BF490305"
replace adm3_pcode_bis = 490306 if adm3_pcode == "BF490306"
replace adm3_pcode_bis = 490309 if adm3_pcode == "BF490309"
replace adm3_pcode_bis = 490310 if adm3_pcode == "BF490310"
replace adm3_pcode_bis = 490311 if adm3_pcode == "BF490311"
replace adm3_pcode_bis = 500101 if adm3_pcode == "BF500101"
replace adm3_pcode_bis = 500103 if adm3_pcode == "BF500103"
replace adm3_pcode_bis = 500104 if adm3_pcode == "BF500104"
replace adm3_pcode_bis = 500105 if adm3_pcode == "BF500105"
replace adm3_pcode_bis = 500106 if adm3_pcode == "BF500106"
replace adm3_pcode_bis = 500109 if adm3_pcode == "BF500109"
replace adm3_pcode_bis = 500110 if adm3_pcode == "BF500110"
replace adm3_pcode_bis = 500112 if adm3_pcode == "BF500112"
replace adm3_pcode_bis = 500114 if adm3_pcode == "BF500114"
replace adm3_pcode_bis = 500202 if adm3_pcode == "BF500202"
replace adm3_pcode_bis = 500203 if adm3_pcode == "BF500203"
replace adm3_pcode_bis = 500206 if adm3_pcode == "BF500206"
replace adm3_pcode_bis = 500207 if adm3_pcode == "BF500207"
replace adm3_pcode_bis = 500208 if adm3_pcode == "BF500208"
replace adm3_pcode_bis = 500209 if adm3_pcode == "BF500209"
replace adm3_pcode_bis = 500301 if adm3_pcode == "BF500301"
replace adm3_pcode_bis = 500302 if adm3_pcode == "BF500302"
replace adm3_pcode_bis = 500303 if adm3_pcode == "BF500303"
replace adm3_pcode_bis = 500305 if adm3_pcode == "BF500305"
replace adm3_pcode_bis = 500306 if adm3_pcode == "BF500306"
replace adm3_pcode_bis = 500307 if adm3_pcode == "BF500307"
replace adm3_pcode_bis = 500403 if adm3_pcode == "BF500403"
replace adm3_pcode_bis = 500405 if adm3_pcode == "BF500405"
replace adm3_pcode_bis = 500406 if adm3_pcode == "BF500406"
replace adm3_pcode_bis = 510101 if adm3_pcode == "BF510101"
replace adm3_pcode_bis = 510103 if adm3_pcode == "BF510103"
replace adm3_pcode_bis = 510104 if adm3_pcode == "BF510104"
replace adm3_pcode_bis = 510105 if adm3_pcode == "BF510105"
replace adm3_pcode_bis = 510106 if adm3_pcode == "BF510106"
replace adm3_pcode_bis = 510107 if adm3_pcode == "BF510107"
replace adm3_pcode_bis = 510202 if adm3_pcode == "BF510202"
replace adm3_pcode_bis = 510203 if adm3_pcode == "BF510203"
replace adm3_pcode_bis = 510204 if adm3_pcode == "BF510204"
replace adm3_pcode_bis = 510205 if adm3_pcode == "BF510205"
replace adm3_pcode_bis = 510301 if adm3_pcode == "BF510301"
replace adm3_pcode_bis = 510302 if adm3_pcode == "BF510302"
replace adm3_pcode_bis = 510303 if adm3_pcode == "BF510303"
replace adm3_pcode_bis = 510304 if adm3_pcode == "BF510304"
replace adm3_pcode_bis = 510306 if adm3_pcode == "BF510306"
replace adm3_pcode_bis = 510307 if adm3_pcode == "BF510307"
replace adm3_pcode_bis = 520101 if adm3_pcode == "BF520101"
replace adm3_pcode_bis = 520102 if adm3_pcode == "BF520102"
replace adm3_pcode_bis = 520103 if adm3_pcode == "BF520103"
replace adm3_pcode_bis = 520104 if adm3_pcode == "BF520104"
replace adm3_pcode_bis = 520105 if adm3_pcode == "BF520105"
replace adm3_pcode_bis = 520106 if adm3_pcode == "BF520106"
replace adm3_pcode_bis = 520201 if adm3_pcode == "BF520201"
replace adm3_pcode_bis = 520202 if adm3_pcode == "BF520202"
replace adm3_pcode_bis = 520203 if adm3_pcode == "BF520203"
replace adm3_pcode_bis = 520206 if adm3_pcode == "BF520206"
replace adm3_pcode_bis = 520303 if adm3_pcode == "BF520303"
replace adm3_pcode_bis = 520501 if adm3_pcode == "BF520501"
replace adm3_pcode_bis = 520502 if adm3_pcode == "BF520502"
replace adm3_pcode_bis = 520504 if adm3_pcode == "BF520504"
replace adm3_pcode_bis = 520506 if adm3_pcode == "BF520506"
replace adm3_pcode_bis = 520507 if adm3_pcode == "BF520507"
replace adm3_pcode_bis = 530101 if adm3_pcode == "BF530101"
replace adm3_pcode_bis = 530102 if adm3_pcode == "BF530102"
replace adm3_pcode_bis = 530104 if adm3_pcode == "BF530104"
replace adm3_pcode_bis = 530105 if adm3_pcode == "BF530105"
replace adm3_pcode_bis = 530106 if adm3_pcode == "BF530106"
replace adm3_pcode_bis = 530107 if adm3_pcode == "BF530107"
replace adm3_pcode_bis = 530108 if adm3_pcode == "BF530108"
replace adm3_pcode_bis = 530110 if adm3_pcode == "BF530110"
replace adm3_pcode_bis = 530111 if adm3_pcode == "BF530111"
replace adm3_pcode_bis = 530112 if adm3_pcode == "BF530112"
replace adm3_pcode_bis = 530113 if adm3_pcode == "BF530113"
replace adm3_pcode_bis = 530201 if adm3_pcode == "BF530201"
replace adm3_pcode_bis = 530203 if adm3_pcode == "BF530203"
replace adm3_pcode_bis = 530204 if adm3_pcode == "BF530204"
replace adm3_pcode_bis = 530206 if adm3_pcode == "BF530206"
replace adm3_pcode_bis = 530207 if adm3_pcode == "BF530207"
replace adm3_pcode_bis = 530208 if adm3_pcode == "BF530208"
replace adm3_pcode_bis = 530209 if adm3_pcode == "BF530209"
replace adm3_pcode_bis = 530210 if adm3_pcode == "BF530210"
replace adm3_pcode_bis = 530212 if adm3_pcode == "BF530212"
replace adm3_pcode_bis = 530301 if adm3_pcode == "BF530301"
replace adm3_pcode_bis = 530302 if adm3_pcode == "BF530302"
replace adm3_pcode_bis = 530303 if adm3_pcode == "BF530303"
replace adm3_pcode_bis = 530304 if adm3_pcode == "BF530304"
replace adm3_pcode_bis = 530305 if adm3_pcode == "BF530305"
replace adm3_pcode_bis = 530306 if adm3_pcode == "BF530306"
replace adm3_pcode_bis = 530307 if adm3_pcode == "BF530307"
replace adm3_pcode_bis = 540102 if adm3_pcode == "BF540102"
replace adm3_pcode_bis = 540104 if adm3_pcode == "BF540104"
replace adm3_pcode_bis = 540201 if adm3_pcode == "BF540201"
replace adm3_pcode_bis = 540204 if adm3_pcode == "BF540204"
replace adm3_pcode_bis = 540206 if adm3_pcode == "BF540206"
replace adm3_pcode_bis = 540208 if adm3_pcode == "BF540208"
replace adm3_pcode_bis = 540210 if adm3_pcode == "BF540210"
replace adm3_pcode_bis = 540302 if adm3_pcode == "BF540302"
replace adm3_pcode_bis = 540303 if adm3_pcode == "BF540303"
replace adm3_pcode_bis = 540304 if adm3_pcode == "BF540304"
replace adm3_pcode_bis = 540305 if adm3_pcode == "BF540305"
replace adm3_pcode_bis = 540307 if adm3_pcode == "BF540307"
replace adm3_pcode_bis = 540308 if adm3_pcode == "BF540308"
replace adm3_pcode_bis = 540309 if adm3_pcode == "BF540309"
replace adm3_pcode_bis = 540310 if adm3_pcode == "BF540310"
replace adm3_pcode_bis = 540402 if adm3_pcode == "BF540402"
replace adm3_pcode_bis = 540403 if adm3_pcode == "BF540403"
replace adm3_pcode_bis = 550101 if adm3_pcode == "BF550101"
replace adm3_pcode_bis = 550103 if adm3_pcode == "BF550103"
replace adm3_pcode_bis = 550105 if adm3_pcode == "BF550105"
replace adm3_pcode_bis = 550106 if adm3_pcode == "BF550106"
replace adm3_pcode_bis = 550107 if adm3_pcode == "BF550107"
replace adm3_pcode_bis = 550108 if adm3_pcode == "BF550108"
replace adm3_pcode_bis = 550201 if adm3_pcode == "BF550201"
replace adm3_pcode_bis = 550203 if adm3_pcode == "BF550203"
replace adm3_pcode_bis = 550204 if adm3_pcode == "BF550204"
replace adm3_pcode_bis = 550205 if adm3_pcode == "BF550205"
replace adm3_pcode_bis = 550302 if adm3_pcode == "BF550302"
replace adm3_pcode_bis = 550304 if adm3_pcode == "BF550304"
replace adm3_pcode_bis = 550305 if adm3_pcode == "BF550305"
replace adm3_pcode_bis = 550306 if adm3_pcode == "BF550306"
replace adm3_pcode_bis = 550307 if adm3_pcode == "BF550307"
replace adm3_pcode_bis = 560102 if adm3_pcode == "BF560102"
replace adm3_pcode_bis = 560104 if adm3_pcode == "BF560104"
replace adm3_pcode_bis = 560201 if adm3_pcode == "BF560201"
replace adm3_pcode_bis = 560202 if adm3_pcode == "BF560202"
replace adm3_pcode_bis = 560203 if adm3_pcode == "BF560203"
replace adm3_pcode_bis = 560205 if adm3_pcode == "BF560205"
replace adm3_pcode_bis = 560206 if adm3_pcode == "BF560206"
replace adm3_pcode_bis = 560301 if adm3_pcode == "BF560301"
replace adm3_pcode_bis = 560304 if adm3_pcode == "BF560304"
replace adm3_pcode_bis = 560308 if adm3_pcode == "BF560308"
replace adm3_pcode_bis = 560403 if adm3_pcode == "BF560403"
replace adm3_pcode_bis = 560406 if adm3_pcode == "BF560406"
replace adm3_pcode_bis = 570102 if adm3_pcode == "BF570102"
replace adm3_pcode_bis = 570103 if adm3_pcode == "BF570103"
replace adm3_pcode_bis = 570104 if adm3_pcode == "BF570104"
replace adm3_pcode_bis = 570201 if adm3_pcode == "BF570201"
replace adm3_pcode_bis = 570202 if adm3_pcode == "BF570202"
replace adm3_pcode_bis = 570203 if adm3_pcode == "BF570203"
replace adm3_pcode_bis = 570204 if adm3_pcode == "BF570204"
replace adm3_pcode_bis = 570205 if adm3_pcode == "BF570205"
replace adm3_pcode_bis = 570207 if adm3_pcode == "BF570207"
replace adm3_pcode_bis = 570208 if adm3_pcode == "BF570208"
replace adm3_pcode_bis = 570301 if adm3_pcode == "BF570301"
replace adm3_pcode_bis = 570304 if adm3_pcode == "BF570304"
replace adm3_pcode_bis = 570305 if adm3_pcode == "BF570305"
replace adm3_pcode_bis = 570401 if adm3_pcode == "BF570401"
replace adm3_pcode_bis = 570402 if adm3_pcode == "BF570402"
replace adm3_pcode_bis = 570404 if adm3_pcode == "BF570404"
replace adm3_pcode_bis = 570405 if adm3_pcode == "BF570405"
replace adm3_pcode_bis = 570406 if adm3_pcode == "BF570406"
replace adm3_pcode_bis = 570407 if adm3_pcode == "BF570407"
replace adm3_pcode_bis = 570409 if adm3_pcode == "BF570409"
replace adm3_pcode_bis = 570410 if adm3_pcode == "BF570410"



sort adm1_pcode adm1_pcode  adm2_pcode  adm3_pcode

drop adm1_pcode adm2_pcode

gen adm0_pcode = substr(adm3_pcode, 1, 2)
gen adm1_pcode = substr(adm3_pcode, 1, 4)
gen adm2_pcode = substr(adm3_pcode, 1, 6)
order adm0_pcode adm1_pcode  adm2_pcode  adm3_pcode adm3_pcode_bis
drop adm3_pcode_bis
tabulate adm1_pcode, gen(adm1_pcode)
tabulate adm2_pcode, gen(adm2_pcode)
save "$data\commune_survey_ehcvm_bfa_2021.dta",replace