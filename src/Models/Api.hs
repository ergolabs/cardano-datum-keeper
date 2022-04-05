{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE Strict #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Models.Api where

import           GHC.Generics            (Generic)
import           Data.ByteString         (ByteString)
import qualified Data.ByteString.Lazy    as B
import qualified Data.ByteString.Base16  as Hex
import qualified Data.Text.Encoding      as T
import qualified Data.Either.Combinators as Either
import           Data.Aeson
import           Data.Swagger

import           Ledger.Scripts  (Datum (..))
import           Codec.Serialise (deserialiseOrFail)

newtype SerializedDatum = SerializedDatum { getDatumBytes :: ByteString }
  deriving stock (Eq, Show, Generic)

deserialiseDatum :: SerializedDatum -> Maybe Datum
deserialiseDatum = Either.rightToMaybe . deserialiseOrFail . B.fromStrict . getDatumBytes

instance FromJSON SerializedDatum where
  parseJSON (String s) = either fail (pure . SerializedDatum) (Hex.decode . T.encodeUtf8 $ s)
  parseJSON _          = fail "Expected a string"

instance ToSchema SerializedDatum where
  declareNamedSchema _ = return $ NamedSchema (Just "SerializedDatum") byteSchema
