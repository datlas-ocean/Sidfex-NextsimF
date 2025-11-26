# Forecasting SIDFEX buoys  from NeXtSIM-F sea ice forecast
This repository contains the tools and tutorials  to forecast the  trajectories of the [SIDFEX buoys](https://www.polarprediction.net/key-yopp-activities/sea-ice-prediction-and-verification/sea-ice-drift-forecast-experiment/) from the [sea ice forecast based on the NeXtSIM-F model](https://data.marine.copernicus.eu/product/ARCTIC_ANALYSISFORECAST_PHY_ICE_002_011/description).

### In this repository, you will find:
* a [tutorial](./NOTEBOOKS/HOWTO.md) to set up and make use of the tools,
* the required [scripts and codes](./SRC/) to produce the forecast,
* example notebooks to plot and explore the produced forecasted trajectories.
  
### Our forecatsts for SIDFEX buoys are available here:
* [on the DKRZ SIDFEX webpage (click here).](https://swiftbrowser.dkrz.de/public/dkrz_0262ea1f00e34439850f3f1d71817205/SIDFEx_processed/igedatlas001/)

### Short method description
9-day hourly forecasts are derived from the forecasting system neXtSIM forecast (neXtSIM-F; Williams et al., 2021), based on the stand-alone sea-ice model neXt-generation Sea Ice Model (neXtSIM; Rampal et al., 2016, 2019), and the Lagrangian sea-ice particle tracker, sitrack (https://github.com/brodeau/sitrack) developed by L. Brodeau. 
The Lagranian finite element model, neXtSIM, is run with a nominal triangle side length of 10 km, with an approximate distance of  7.5 km from one point of a triangle to the opposite edge. It operates with the novel brittle Bingham-Maxwell (BBM) sea-ice rheology of Ólason et al. (2022). neXtSIM-F, developed at NERSC in Bergen/Norway (https://nersc.no), is forced by the operational TOPAZ ocean forecasts and ECMWF atmospheric forecasts. It is run operationally every day for the Arctic domain, and distributed via the Copernicus Marine Data Store (https://data.marine.copernicus.eu/product/ARCTIC_ANALYSISFORECAST_PHY_ICE_002_011/description). The initial conditions are adjusted daily using ice charts from the United States National Ice Center, and ice thickness from CS2-SMOS. The forecast sea-ice concentration and sea-ice velocity given by neXtSIM-F are used as inputs for sitrack. Tracking is stopped if a buoy enters a cell with a sea-ice concentration below 15 %. The neXtSIM-F-sitrack trajectory forecasts, produced following the processing chain developed by Grung, Leroux and Rampal and freely accessible on GitHub (https://github.com/datlas-ocean/Sidfex-NextsimF), are initiated at midnight (UTC+1) of the bulletin date. If the last updated buoy position was within one day prior to initialisation, sitrack uses the hindcast provided by neXtSIM-F to advect the buoy to ensure an approximate position at midnight. 

##### Bibliography

Ólason, E.,  Boutin, G.,  Korosov, A.,  Rampal, P.,  Williams, T.,  Kimmritz, M., et al. (2022).  A new brittle rheology and numerical framework for large-scale sea-ice models. Journal of Advances in Modeling Earth Systems,  14, e2021MS002685. https://doi.org/10.1029/2021MS002685

Rampal, P., Bouillon, S., Ólason, E., and Morlighem, M.: neXtSIM: a new Lagrangian sea ice model, The Cryosphere, 10, 1055–1073, https://doi.org/10.5194/tc-10-1055-2016, 2016

Rampal, P., Dansereau, V., Olason, E., Bouillon, S., Williams, T., Korosov, A., and Samaké, A.: On the multi-fractal scaling properties of sea ice deformation, The Cryosphere, 13, 2457–2474, https://doi.org/10.5194/tc-13-2457-2019, 2019.

Williams, T., Korosov, A., Rampal, P., and Ólason, E.: Presentation and evaluation of the Arctic sea ice forecasting system neXtSIM-F, The Cryosphere, 15, 3207–3227, https://doi.org/10.5194/tc-15-3207-2021, 2021.


### Credits:
This work is a collaboration between Datlas and IGE in Grenoble, France, with NERSC, Bergen, Norway and Alfred Wegener Institute, Bremerhaven, Germany.

Main contributors:
* Maren Friele Grung (IGE)
* Stephanie Leroux (Datlas)
* Pierre Rampal (IGE)

with contributions from Laurent Brodeau (Datlas) for the development of the [Mojito](https://github.com/brodeau/mojito) and [Sitrack](https://github.com/brodeau/sitrack) softwares, from Tim Williams for  producing and providing the NeXtSIM-F sea ice forecasts, and from Helge Goessling and  Valentin Ludwig (AWI) for the support regarding the SIDFEX project.
