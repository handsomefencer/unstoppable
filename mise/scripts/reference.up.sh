#!/bin/bash


cd ${sandbox_dir} 

dcd 

# dc build builder-development
dc build --with-dependencies builder-development
schown 
cd ${roro}
