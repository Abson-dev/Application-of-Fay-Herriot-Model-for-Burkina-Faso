var G5_Sahel_adm2 = ee.FeatureCollection("projects/ee-aboubacarhema94/assets/ACLED/G5_Sahel_adm2N"),
    bfa_admin_1 = ee.FeatureCollection("projects/ee-aboubacarhema94/assets/Small_Area_Estimation/bfa_admin_1"),
    bfa_admin_2 = ee.FeatureCollection("projects/ee-aboubacarhema94/assets/Small_Area_Estimation/bfa_admin_2"),
    bfa_admin_3 = ee.FeatureCollection("projects/ee-aboubacarhema94/assets/Small_Area_Estimation/bfa_admin_3");



    // spectral indices formulas here: 
var spectral = require("users/dmlmont/spectral:spectral");

//print(spectral.indices);

// Specify admin level 
var admin_level = bfa_admin_3;
var admin_label = 'admin_3';

// Getting images for all 2022
var start = '2022-01-01';
var end = '2022-12-31';

//Landsat 8
 var l8 = ee.ImageCollection("LANDSAT/LC08/C02/T1_L2") 
      .filterDate(start, end) 
      .filterMetadata('CLOUD_COVER', 'less_than', 80); 


var dataset = "LANDSAT/LC08/C02/T1_L2";

//print(l8)
var image = l8.mean();

var image_l = spectral.scale(image,dataset);



var parameters = {
    "A": image_l.select('SR_B1'),
    "B": image_l.select('SR_B2'),
    "G": image_l.select('SR_B3'),
    "R": image_l.select("SR_B4"),
    "N": image_l.select("SR_B5"),
    "S1": image_l.select("SR_B6"),
    "S2": image_l.select("SR_B7"),
   // "T1": image_l.select("SR_B10"),
  //  "T2": image_l.select("SR_B11"),    
    "L": 0.5, // for IBI
    "g": 2.5, // for EVI,
    "gamma": 1, // for ARVI
    "C1": 6, //for EVI
    "C2": 7.5 // for EVI
    
};


var list_indices = ["MNDWI","BRBA","NBAI","NDSI","VARI","SAVI","OSAVI","NDMI","NBAI","EVI","NDVI","SR","ARVI","UI"];
                                          
//"MNDWI","BRBA","NBAI","NDSI","VARI","SAVI","OSAVI","NDMI","NBAI","EVI","NDVI","SR","ARVI","UI" 
//"IBI", "MNDWI", "NBAI", "NDMI","EVI", "NDVI", "NDBI", "SR","ARVI", "UI", "MNDWI",  //"NBUI","BRBA", "NBAI","NDSI", "VARI","SAVI", "OSAVI", "NDMI"
var l8_1 = spectral.computeIndex(image_l,list_indices,parameters);

var l8_1 = l8_1.clip(admin_level);

Map.addLayer(l8_1.select('MNDWI'));

//var imagecol =  imagecol.clip(country);
//var l8_1 = l8_1.select(list_indices);
var calculateFeatureSum = function(feature) {
    var events = l8_1.reduceRegion({
    reducer: ee.Reducer.mean(),
    geometry: feature.geometry(),
    scale: 10000,
    maxPixels: 1e30
    });
    var adm_level = feature.get('ADM3_PCODE');//ADM1_PCODE,ADM2_PCODE,ADM3_PCODE
    return ee.Feature(
      feature.geometry(),
      events.set('ADM3_PCODE', adm_level)); //ADM1_PCODE,ADM2_PCODE,ADM3_PCODE
};
 
//Map Function to Create
var Feature_byADM2 = admin_level.map(calculateFeatureSum);
//print(Feature_byADM2);
Export.table.toDrive({
    collection: Feature_byADM2,
    fileNamePrefix: 'geo_indices_' + admin_label,
    description: 'geo_indices_' + admin_label,
    //folder: "", //set based on user preference
    fileFormat: 'CSV',
    selectors: ['ADM3_PCODE',"MNDWI","BRBA","NBAI","NDSI","VARI","SAVI","OSAVI","NDMI","NBAI","EVI","NDVI","SR","ARVI","UI"]
    });
//ADM1_PCODE,ADM2_PCODE,ADM3_PCODE