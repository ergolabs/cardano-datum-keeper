module Lib
  ( runApp
  ) where
      
import Settings.AppSettings
import Wirings.WiringApp
import Control.Monad.IO.Unlift

runApp :: IO ()
runApp = do
  let reader = mkSettingsReader
  cfg <- getCfg reader 
  initApp cfg (UnliftIO id)
