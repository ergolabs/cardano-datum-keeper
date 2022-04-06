module Lib
  ( runApp
  ) where
      
import RIO.List

import Settings.AppSettings
import Wirings.WiringApp ( initApp )
import Control.Monad.IO.Unlift ( UnliftIO(UnliftIO) )

runApp :: [String] -> IO ()
runApp args = do
  settings <- loadSetting $ headMaybe args
  initApp settings (UnliftIO id)
