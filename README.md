# intecomm-stata

STATA do files

## Getting started


copy the `get_env.do` to ~/path/to/dta/folder:

    cp get_env.do ~/path/to/dta/folder

create an `env.txt`:

    ~/path/to/do/folder
    ~/path/to/dta/folder
    yyyymmdd


where `yyyymmdd` is the timestamp suffix on the dta files.

copy the `env.txt` to ~/path/to/dta/folder

open STATA:

    cd ~/path/to/dta/folder


## Working with exported ``dta`` files

The ``.do`` files are expecting ``.dta`` files generated by the management command ``export_models_to_csv`` in ``edc-pdutils``.

For example, export ``.dta`` files for ``inte_subject`` models into your/dta/folder:

    python manage.py export_models_to_csv -a edc_metadata -p ~/path/to/dta/folder -f stata

In STATA, open an dta file:

    cd ~/path/to/dta/folder
    do "get_env.do"
    do "open_table.do" "intecomm_screening" "patientlog"
    
    
