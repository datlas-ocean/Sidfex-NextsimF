Guidelines to set up and execute our forecasting tools on any computer.

_!!! NOTE: As of today 2024-05-18 the set up of this repository is still on-going. Do not use before it is ready to be used. !!!._

## 1. Installation and dependecies
<details>
<summary> Click here to drop down the section about installation. </summary>
    
### 1.1 To get our Sidfex-NextsimF tool:

        git clone https://github.com/datlas-ocean/Sidfex-NextsimF.git

#### 1.2 `copernicusmarine`
- If you do not already have a user at `copernicusmarine`, registrer [here](https://data.marine.copernicus.eu/register). This can take a few days.

- Install the [copernicusmarine Toolbox](https://help.marine.copernicus.eu/en/collections/9080063-copernicus-marine-toolbox) via `mamba`, `conda` or `pip`:


    - `pip`:

        python -m pip install copernicusmarine 
        python -m pip install copernicusmarine --upgrade
      
    - `mamba`:
        1. Open the *Miniforge Prompt*  to create a new environment (could be anything, but let's call it `copernicusmarine`) and install the `copernicusmarine` Toolbox from conda-forge:

                mamba create --name copernicusmarine conda-forge::copernicusmarine --yes

        2. Activate the newly created environment (called `copernicusmarine`) to use the Toolbox (either for the CLI or PythonAPI):

                mamba activate copernicusmarine

    - `conda`:
        1.  Install the `copernicusmarine` Toolbox from PyPI:

                    python -m pip install copernicusmarine


  As of today (26. April 2024), the latest version is `copernicusmarine-1.1.1`. You can check which version you have by running `copernicusmarine --version` or `copernicusmarine -V` in your command line interface in  your terminal.

#### 1.3 `wget`
- Can be installed using [homebrew](https://brew.sh):

        brew install wget

#### 1.4 `sitrack`
- clone [`sitrack`](https://github.com/brodeau/sitrack) into the `<somewhere>` directory on your computer

        cd <somewhere>/
        git clone https://github.com/brodeau/sitrack.git

- make `python` able to locate the sitrack modules, so add the following line to your `.bashrc`, `.profile`, or equivalent:

        export PYTHONPATH=<absolute_path_to_somewhere>/sitrack:${PYTHONPATH}

#### 1.5 `mojito`
- clone [`mojito`](https://github.com/brodeau/mojito) into the `<somewhere>` directory on your computer

        cd <somewhere>/
        git clone git@github.com:brodeau/mojito.git

- make `python` able to locate the mojito modules, so add the following line to your `.bashrc`, `.profile`, or equivalent:

        export PYTHONPATH=<absolute_path_to_somewhere>/mojito:${PYTHONPATH}

#### 1.6 `python-basemap` and `climporn` package
Required if you want to use the plotting functionality (usually triggered with `iplot=1` in the various scripts in `sitrack`).

[Climporn](https://github.com/brodeau/climporn) is available here.

</details>

## 2. Setp up
<details>
<summary> Click here to drop down the set up section. </summary>

### 2.1 Edit the environment file `env_sidfex.src`
This is the file  where you set all the paths to the different directories.
```
cd <YOUR-INSTALL-DIR>/Sidfex-NextsimF/SRC/
# make a copy of the initial file for your record
cp env_sidfex.src env_sidfex_SRC.src
# then edit your env file for your needs:
vi env_sidfex.src
```


### 2.2 Edit sitrack
Some of this is needed only until LB has accepted our pull request to sitrack. TO BE UPDATED.

#### Link to our `si3_part_tracker.py`:
* In `sitrack`:
```
cd <YOUR-INSTALL-DIR>/sitrack/
mv si3_part_tracker.py si3_part_tracker_SRC.py
ln -sf <YOUR-INSTALL-DIR>/Sidfex-NextsimF/SRC/scripts4sitrack/si3_part_tracker.py .
```
#### Link to our `generate_sidfex_seeding_vol2.py`:
```
cd <YOUR-INSTALL-DIR>/sitrack/tools/
ln -sf <YOUR-INSTALL-DIR>/Sidfex-NextsimF/SRC/scripts4sitrack/generate_sidfex_seeding_vol2.py .
```

#### `xy_arctic_to_meshmask.py`
* In `sitrack/tools/xy_arctic_to_meshmask.py`: Changed default values of *lat0* and *lon0* to lat0=90., lon0=-45.

#### `util.py`
In `sitrack/sitrack/:
* Function `Geo2CartNPSkm1D`: changed default values of *lat0* and *lon0* to `Geo2CartNPSkm1D( pcoorG, lat0=90., lon0=-45. ):`
* Function `CartNPSkm2Geo1D`: changed default values of *lat0* and *lon0* to `CartNPSkm2Geo1D( pcoorC, lat0=90., lon0=-45. ):`
* Function `ConvertGeo2CartesianNPSkm`: changed default values of *lat0* and *lon0* to `ConvertGeo2CartesianNPSkm( plat, plon, lat0=90., lon0=-45. ):`
* Function `ConvertCartesianNPSkm2Geo`: changed default values of *lat0* and *lon0* to `ConvertCartesianNPSkm2Geo( pY, pX, lat0=90., lon0=-45. ):`

#### `ncio.py`
In `sitrack/sitrack/:
* Line 230: `v_bid  = f_out.createVariable('id_buoy',   'i8',(cd_buoy,))` changed from `i4` to `i8`.
* Line 249: `    v_buoy[:] = np.arange(Nb,dtype='i8')` changed from `i4` to `i8`.
* Line 457 inside function `ModelFileTimeInfo`: `zz = split('-',vn[2])` changed `vn[1]` to `vn[2]` due to naming of concatinated `neXtSIM-F` file.

#### `tracking.py`
In `sitrack/sitrack/:
* Added the function:

        def SidfexSeeding( filepath='./sidfexloc.dat' ):
        ''' Generate seeding lon lat from sidfex buoys read from text file.
        Returns an array with lat lon and another with buoy IDs.
        '''
        print("============= SIDFEX SEEDING")
        #debug example zLatLon = np.array([ [75.,190.] ])
        sidfexdat = ReadFromSidfexDatFile( filepath )
        print('sidfexdat', sidfexdat)
        print('sidfexdat.shape', sidfexdat.shape)
        print('sidfexdat.ndim', sidfexdat.ndim)
        if sidfexdat.ndim > 1:
            zLatLon = sidfexdat[:,[2,1]] # reverse order of columns so that it is now lat lon.
            zIDs = sidfexdat[:,0].astype(int)
        else:
            zLatLonsingle = sidfexdat[[2,1]]
            zLatLon=np.stack((zLatLonsingle,zLatLonsingle))  # here we duplicate the line to avoid problem when read by script generate_seeding
            zIDssingle = sidfexdat[0].astype(int)
            zIDs = np.stack((zIDssingle,zIDssingle)) # here we duplicate the line to avoid problem when read by script generate_seeding
        return zLatLon,zIDs

* Added the function:

        def ReadFromSidfexDatFile( filepath='./sidfexloc.dat' ):
        '''
            Reads from text file sidfex.dat and returns an array with id, lon, lat for all sidfex buoys at a given date.
        '''
        from os.path import exists
        if (exists(filepath)):
            # reads buoys id and locations (lon lat) from text file
            listbuoys = np.genfromtxt(open(filepath))
            # Keep track of how many buoys are read in input file
            NBUOYTOTR=listbuoys.shape[0]
            print("======== Nb of buoys read from sidfex file......"+str(NBUOYTOTR))
        else:
            print("============================================")
            print("=== Error ! 'sidfexloc.dat' file is missing.")
            print("============================================")
            exit(0)
        return listbuoys

* Commented the function `debugSeeding1():`.

</details>

## 3. Run the tool
<details>
<summary>Click here to drop down the  section to run the forecasting tool.</summary>

### Master script:
The master-script is called `MAIN.sh` in `<YOUR-INSTALL-DIR>/Sidfex-NextsimF/SRC/`.  It  can be run in your terminal or in a cronjob. This is the ***only script that needs to be run*** once the initial setup has been done (see above section).

Notice that if you are on a Linux computer and not MacOS, then command giving the date is either `date` or `gdate` respectively. The `MAIN.sh` script and the environment file deals with this by checking on which plateform we are installed and chooses the date command (`$CMD_date`) accordingly.

`MAIN.sh` consists of the following parts:

1. `get_buoy_data-auto_DKRZ.sh`
    * Downloads the position, that is latitude and longitude, closest to midnight of today (can be adjusted for) of the buoy (or other object) from the DKRZ server.

2. `get_nextsim_files.sh`
    * Downloading the hindcast (1 day) and the forecasting files (9 days) of the stand-alone sea-ice model `neXtSIM-F` through `copernicusmarine`. 
    * Concatenates the hindcast and forecast files at which the following variables are stored: *longitude*, *latitude*, *siconc*, *sithick*, *vxsi*, *vysi*.
    * **TO DO:** Pay attention to the message given in the file: For the very first download of data from `copernicusmarine` one needs to manually enter `copernicusmarine` login and password when requested in the terminal. `copernicusmarine` login (`copernicusmarine.login()`) thus needs to be uncommented in `get_nextsim.py` before running for the first time on the computer, and subsequently uncommented again for all following runs. 

3. `generate_arctic_mesh.sh`
    * Converts grid from a C-grid for `si3/NANUK4` to an A-grid for `neXtSIM-F` velocity fields.
    * **TO DO:** Only needs to be ran once. After running you will get an output file called `coordinates_mesh_mask.nc` that you need to store. This directory needs to be given in `propagate_sidfex_seed.sh` in step 6. Once `coordinates_mesh_mask.nc` is generated, the script `generate_arctic_mesh.sh` can be commented in `sidfex_chain.sh` to avoid it running unnecessarily.


4. `hindcast_seeds.sh`
    * Loops over the file, `sidfexloc_${analDate}.dat`, with buoy ID, positions and time that was created in step 1. If last buoy position was given within a day before midnight we use the hindcast of `neXtSIM-F` together with the `sitrack` scripts to advect the buoy's position until midnight. If some buoys are already at midnight they are not included in the hindcast procedure. All positions at midnight are stored into one file, `sidfexloc_out_${analDate}.dat`, at which its positions are given to the symbolic link `sidfexloc.dat` which is used in the next step.

5. `generate_sidfex_seeding.sh`
    * Connects `sidfexloc_out_${analDate}.dat` to the symbolic link `sidfexloc.dat` which is used to seed the buoy positons in our domain from a given start time. 
    * Outputs a seeding file called something like `${yesterdayDate}_${finalForecastDate}_hr-nersc-MODEL-nextsimf-concatenated-ARC-b${analDate}-fv00.0.nc`, where the variables `${yesterdayDate}`, `${finalForecastDate}` and `${analDate}` respectively are the date before analDate, the date of the last forecasted day in this run, and the date of today (unless you decide to forecast for another inital date).

6. `propagate_sidfex_seed.sh`
    * Advects the buoys generated and outputted in a seeding file in step 5. by using the grid created in step 3. and the *siconc*, *vxsi*, *vysi* from step 2. 
    * Outputs a forecast file called something like `data_A-grid_'${yesterdayDate}'_nersc_tracking_sidfex_1h_'${analDate}'h00_'${forecastEndDate}'h00_3km.nc`, where the variable `${forecastEndDate}` is the date after the last forecasted date (i.e. after `${finalForecastDate}`) at midnight. 

7. `to_sidfex.sh`
    * Uses the output forecasting file from step 6. and writes its information to an ASCII-file for each buoy as of the required [`SIDFEx`](https://www.polarprediction.net/fileadmin/user_upload/www.polarprediction.net/Home/YOPP/SIDFEx/SIDFEx_background_and_guidelines_20211207.pdf) format. 
    * Each buoy outputs a file called something like `IGE_Datlas_neXtSIM-F_sitrack_300534062895730_2024-109_001.txt`, where `300534062895730` is the buoy ID, `2024` is the year, `109` is the day of the year, and `001` is the ensemble member number. The files are stored in the directory *./sidfex/workdir/workdir_analDate/sidfex_output*.

</details>
