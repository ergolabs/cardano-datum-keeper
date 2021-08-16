module Lib
    ( someFunc
    ) where
      
import Settings.AppSettings

someFunc :: IO ()
someFunc = do
  let reader = mkSettingsReader
  cfg <- getCfg reader 
  print cfg 
