module Http.Server where

import Http.V1.Routes
import Http.V1.DatumRoutes
import Http.V1.SwaggerRoutes
import Control.Monad.IO.Unlift
import Control.Monad.IO.Class    (MonadIO)
import Servant
import Servant.Swagger
import Servant.Swagger.UI
import Settings.AppSettings
import Network.Wai.Handler.Warp  as Warp
import Services.DatumService

f2Handler :: (MonadIO f) => UnliftIO f -> f a -> Servant.Handler a
f2Handler UnliftIO{..} = liftIO . unliftIO

mkApiServer :: (MonadIO f) => DatumService f -> ServerT API f
mkApiServer datumS = swaggerSchemaUIServerT v1Swagger :<|> mkDatumApiServer datumS

httpApp :: (MonadIO f) => DatumService f -> UnliftIO f -> Application
httpApp datumService un = serve apiV1Proxy $ hoistServer apiV1Proxy (f2Handler un) (mkApiServer datumService)

runHttpServer :: (MonadIO f) => HttpSettings -> DatumService f -> UnliftIO f -> f ()
runHttpServer HttpSettings{..} datumService uIO =
  liftIO $ (Warp.run (fromIntegral getPort) (httpApp datumService uIO))