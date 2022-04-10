# cardano-datum-keeper

## How to dockerize
- Copy executable binary to ./temp-build/ in project's root
- Specify configuration in ./configs/config.dhall or mount on startup with ``` -v "${pwd}/config.dhall:/etc/datum-keeper/config.dhall"```
- run docker build command.
- pull docker image on a machine and run 