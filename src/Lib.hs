module Lib
  ( runApp
  ) where
      
import Settings.AppSettings
import Wirings.WiringApp
import Control.Monad.IO.Unlift

unlift :: UnliftIO IO
unlift = UnliftIO (\a -> a)

runApp :: IO ()
runApp = do
  let reader = mkSettingsReader
  cfg <- getCfg reader 
  initApp cfg unlift
