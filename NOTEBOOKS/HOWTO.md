Guidelines to set up and execute our forecasting tools on any computer.

## 1. Installation and dependecies
<details>
<summary>Click here to drop down the section about installation.</summary>
    
### To get our Sidfex-NextsimF tool:

        git clone https://github.com/datlas-ocean/Sidfex-NextsimF.git

#### `copernicusmarine`
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

#### `wget`
- Can be installed using [homebrew](https://brew.sh):

        brew install wget

#### `sitrack`
- clone [`sitrack`](https://github.com/brodeau/sitrack) into the `<somewhere>` directory on your computer

        cd <somewhere>/
        git clone https://github.com/brodeau/sitrack.git

- make `python` able to locate the sitrack modules, so add the following line to your `.bashrc`, `.profile`, or equivalent:

        export PYTHONPATH=<absolute_path_to_somewhere>/sitrack:${PYTHONPATH}

#### `mojito`
- clone [`mojito`](https://github.com/brodeau/mojito) into the `<somewhere>` directory on your computer

        cd <somewhere>/
        git clone git@github.com:brodeau/mojito.git

- make `python` able to locate the mojito modules, so add the following line to your `.bashrc`, `.profile`, or equivalent:

        export PYTHONPATH=<absolute_path_to_somewhere>/mojito:${PYTHONPATH}

#### `python-basemap` and `climporn` package
Required if you want to use the plotting functionality (usually triggered with `iplot=1` in the various scripts in `sitrack`).

[Climporn](https://github.com/brodeau/climporn) is available here.

</details>

## 2. Setp up
<details>
<summary>Click here to drop down the set up section.</summary>

</details>

## 3. Run the tool
<details>
<summary>Click here to drop down the  section to run the forecasting tool.</summary>

</details>
