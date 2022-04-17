module Http.Server where

import Http.V1.Routes
import Http.V1.DatumRoutes
import Http.V1.SwaggerRoutes
import Network.Wai.Middleware.Cors
import Control.Monad.IO.Unlift
import Servant
import Servant.Swagger.UI
import Settings.AppSettings
import Network.Wai.Handler.Warp  as Warp
import Services.DatumService
import Control.Monad.Except (ExceptT, mapExceptT)

f2Handler :: UnliftIO f -> ExceptT ServerError f a -> Servant.Handler a
f2Handler UnliftIO{..} = Handler . mapExceptT unliftIO

mkApiServer :: (MonadIO f) => DatumService f -> ServerT API (ExceptT ServerError f)
mkApiServer datumS = swaggerSchemaUIServerT v1Swagger :<|> mkDatumApiServer datumS

httpApp :: (MonadIO f) => DatumService f -> UnliftIO f -> Application
httpApp datumService un =
    cors (const $ Just policy)
      $ serve apiV1Proxy $ hoistServer apiV1Proxy (f2Handler un) (mkApiServer datumService)
  where
    policy = simpleCorsResourcePolicy
      { corsRequestHeaders = ["Content-Type"] }

runHttpServer :: (MonadIO f) => HttpSettings -> DatumService f -> UnliftIO f -> f ()
runHttpServer HttpSettings{..} datumService uIO =
  liftIO (Warp.run (fromIntegral getPort) (httpApp datumService uIO))
