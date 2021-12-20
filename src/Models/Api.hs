{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE Strict #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Models.Api where

import           Data.Aeson                            (ToJSON, FromJSON, toJSON, ToJSONKey)
import           Plutus.V1.Ledger.Address              (Address (..))
import qualified PlutusTx.AssocMap                     as Map
import           Plutus.V1.Ledger.Value
import           Plutus.V1.Ledger.Scripts              (ValidatorHash(..), DatumHash(..))
import           Plutus.V1.Ledger.Crypto               (PubKeyHash(..))
import           Plutus.V1.Ledger.Credential           (StakingCredential(..), Credential(..))
import qualified PlutusTx.Builtins                     as Builtins
import           Ledger.Scripts                        (Datum (..))
import           Plutus.V1.Ledger.TxId                 (TxId(..))
import           Data.Swagger
import           Database.PostgreSQL.Simple.FromField  (FromField (..))
import           Database.PostgreSQL.Simple.FromRow    (FromRow (..), field)
import           GHC.Base                              (mzero)
import           GHC.Generics
import           Servant
import           Servant.Swagger
import qualified PlutusTx

instance ToSchema Datum

instance ToSchema PlutusTx.BuiltinData where
    declareNamedSchema _ = return $ NamedSchema (Just "plutus.BuiltinData") byteSchema

instance ToSchema DatumHash where
    declareNamedSchema _ = return $ NamedSchema (Just "DatumHash") byteSchema
