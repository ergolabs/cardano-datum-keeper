{-# LANGUAGE OverloadedStrings #-}

module Repositories.AssetsRepository where

import Models.Api

data AssetsRepository = AssetsRepository { getAssetByName :: AssetName -> Maybe AssetInfo }

--mkAssetsRepository :: 