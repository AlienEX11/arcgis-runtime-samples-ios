// Copyright 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ArcGIS

class ReadGeopackageViewController: UIViewController {
    
    @IBOutlet weak var mapView:AGSMapView!
    
    private var geoPackage:AGSGeoPackage?
    private var allLayers:[AGSLayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate and display a map using a basemap, location, and zoom level.
        mapView.map = AGSMap(basemapType: .streets, latitude: 39.7294, longitude: -104.8319, levelOfDetail: 11)
        
        // Create a geopackage from a named bundle resource.
        geoPackage = AGSGeoPackage(name: "AuroraCO")
        
        // Load the geopackage.
        geoPackage?.load { [weak self] error in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: "Error opening Geopackage: \(error!.localizedDescription)", maskType: .gradient)
                return
            }

            // Create feature layers for each feature table in the geopackage.
            let featureLayers = self?.geoPackage?.geoPackageFeatureTables.map({ featureTable -> AGSLayer in
                return AGSFeatureLayer(featureTable: featureTable)
            }) ?? []
            
            // Create raster layers for each raster in the geopackage.
            let rasterLayers = self?.geoPackage?.geoPackageRasters.map({ raster -> AGSLayer in
                return AGSRasterLayer(raster: raster)
            }) ?? []

            // Keep an array of all the feature layers and raster layers in this geopackage.
            self?.allLayers.append(contentsOf: featureLayers)
            self?.allLayers.append(contentsOf: rasterLayers)
        }
        
        //add the source code button item to the right of navigation bar
        (self.navigationItem.rightBarButtonItem as! SourceCodeBarButtonItem).filenames = ["ReadGeopackageViewController", "GPKGLayersViewController","GPKGLayerTableCell"]
    }
    
    //MARK: - Segue to and from the Layer Control viewcontroller.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LayersSegue",
            let navigationController = segue.destination as? UINavigationController,
            let controller = navigationController.viewControllers.first as? GPKGLayersViewController {
            // Provide the map and all layers to the layer controller UI.
            controller.map = mapView.map
            controller.allLayers = allLayers
        }
    }
    
    @IBAction func showReadGeopackageMapView(segue: UIStoryboardSegue) {
        // An unwind segue placehold for the Layer
    }
    
}
