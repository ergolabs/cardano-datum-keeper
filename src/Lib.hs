module Lib
    ( runApp
    ) where
      
import Settings.AppSettings
import Wirings.WiringApp

runApp :: IO ()
runApp = do
  let reader = mkSettingsReader
  cfg <- getCfg reader 
  initApp cfg
